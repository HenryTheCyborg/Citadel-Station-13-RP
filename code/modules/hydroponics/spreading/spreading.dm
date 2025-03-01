#define DEFAULT_SEED "glowshroom"
#define VINE_GROWTH_STAGES 5

/proc/spacevine_infestation(var/potency_min=40, var/potency_max=80, var/maturation_min=5, var/maturation_max=15)
	spawn() //to stop the secrets panel hanging
		var/list/turf/simulated/floor/turfs = get_area_turfs(typesof(/area/hallway)) //list of all the empty floor turfs in the hallway areas
		for(var/i in turfs)
			var/turf/T = i
			if(!(T.z in GLOB.using_map.station_levels))
				turfs -= T

		if(turfs.len) //Pick a turf to spawn at if we can
			var/turf/simulated/floor/T = pick(turfs)
			var/datum/seed/seed = SSplants.create_random_seed(1)
			seed.set_trait(TRAIT_SPREAD,2)             // So it will function properly as vines.
			seed.set_trait(TRAIT_POTENCY,rand(potency_min, potency_max))
			seed.set_trait(TRAIT_MATURATION,rand(maturation_min, maturation_max))
			seed.set_trait(TRAIT_CARNIVOROUS,rand(0, 20)) // VINES WERE A BIT TOO MURDERHAPPY AT 80~100!!
			seed.display_name = "strange plants" //more thematic for the vine infestation event

			//make vine zero start off fully matured
			var/obj/effect/plant/vine = new(T,seed)
			vine.health = vine.max_health
			vine.mature_time = 0
			vine.process()

			message_admins("<span class='notice'>Event: Spacevines spawned at [T.loc] ([T.x],[T.y],[T.z])</span>")
			return
		message_admins("<span class='notice'>Event: Spacevines failed to find a viable turf.</span>")

/obj/effect/dead_plant
	anchored = 1
	opacity = 0
	density = 0
	color = DEAD_PLANT_COLOUR

/obj/effect/dead_plant/attack_hand()
	qdel(src)

/obj/effect/dead_plant/attackby()
	..()
	for(var/obj/effect/plant/neighbor in range(1))
		neighbor.update_neighbors()
	qdel(src)

/obj/effect/plant
	name = "plant"
	anchored = TRUE
	buckle_allowed = TRUE
	opacity = 0
	density = 0
	icon = 'icons/obj/hydroponics_growing.dmi'
	icon_state = "bush4-1"
	pass_flags = ATOM_PASS_TABLE
	mouse_opacity = 2

	var/health = 15
	var/max_health = 95 - TRAIT_POTENCY
	var/growth_threshold = 0
	var/growth_type = 1
	var/max_growth = 0
	var/list/neighbors = list()
	var/obj/effect/plant/parent
	var/datum/seed/seed
	var/sampled = 0
	var/floor = 0
	var/spread_chance = 40
	var/spread_distance = 3
	var/evolve_chance = 2
	var/mature_time		//minimum maturation time
	var/last_tick = 0
	var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant

/obj/effect/plant/Destroy()
	if(SSplants)
		SSplants.remove_plant(src)
	for(var/obj/effect/plant/neighbor in range(1,src))
		SSplants.add_plant(neighbor)
	return ..()

/obj/effect/plant/single
	spread_chance = 0

/obj/effect/plant/Initialize(mapload, datum/seed/newseed, obj/effect/plant/newparent)
	. = ..()
	if(!newparent)
		parent = src
	else
		parent = newparent

	if(!istype(newseed))
		newseed = SSplants.seeds[DEFAULT_SEED]
	seed = newseed
	if(!seed)
		qdel(src)
		return

	name = seed.display_name
	max_health = round(seed.get_trait(TRAIT_ENDURANCE)/2)
	if(seed.get_trait(TRAIT_SPREAD)==2)
		max_growth = VINE_GROWTH_STAGES
		growth_threshold = max_health/VINE_GROWTH_STAGES
		icon = 'icons/obj/hydroponics_vines.dmi'
	else
		max_growth = seed.growth_stages
		growth_threshold = max_health/seed.growth_stages

	if(max_growth > 2 && prob(50))
		max_growth-- //Ensure some variation in final sprite, makes the carpet of crap look less wonky.

	mature_time = world.time + seed.get_trait(TRAIT_MATURATION) + 25 //prevent vines from maturing until at least a few seconds after they've been created.
	spread_chance = seed.get_trait(TRAIT_POTENCY)
	spread_distance = ((growth_type>0) ? round(spread_chance*0.77) : round(spread_chance*0.6))
	update_icon()

// Plants will sometimes be spawned in the turf adjacent to the one they need to end up in, for the sake of correct dir/etc being set.
/obj/effect/plant/proc/finish_spreading()
	setDir(calc_dir())
	update_icon()
	SSplants.add_plant(src)
	//Some plants eat through plating.
	if(islist(seed.chems) && !isnull(seed.chems["pacid"]))
		var/turf/T = get_turf(src)
		T.ex_act(prob(80) ? 3 : 2)

/obj/effect/plant/update_icon()
	//TODO: should really be caching this.
	refresh_icon()
	if(growth_type == 0 && !floor)
		src.transform = null
		var/matrix/M = matrix()
		// should make the plant flush against the wall it's meant to be growing from.
		M.Translate(0,-(rand(12,14)))
		switch(dir)
			if(WEST)
				M.Turn(90)
			if(NORTH)
				M.Turn(180)
			if(EAST)
				M.Turn(270)
		src.transform = M
	var/icon_colour = seed.get_trait(TRAIT_PLANT_COLOUR)
	if(icon_colour)
		color = icon_colour
	// Apply colour and light from seed datum.
	if(seed.get_trait(TRAIT_BIOLUM))
		var/clr
		if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
			clr = seed.get_trait(TRAIT_BIOLUM_COLOUR)
		set_light(1+round(seed.get_trait(TRAIT_POTENCY)/20), l_color = clr)
		return
	else
		set_light(0)

/obj/effect/plant/proc/refresh_icon()
	var/growth = min(max_growth,round(health/growth_threshold))
	var/at_fringe = get_dist(src,parent)
	if(spread_distance > 5)
		if(at_fringe >= (spread_distance-3))
			max_growth--
		if(at_fringe >= (spread_distance-2))
			max_growth--
	max_growth = max(1,max_growth)
	if(growth_type > 0)
		if(max_health > 40)
			icon_state = "vines-[growth]"
		else if(max_health <= 40 > 30)
			icon_state = "mass-[growth]"
		else if(max_health <= 30 > 20)
			icon_state = "worms"
		else
			icon_state = "mold-[growth]"
	else
		icon_state = "[seed.get_trait(TRAIT_PLANT_ICON)]-[growth]"

	if(growth>2 && growth == max_growth)
		plane = ABOVE_PLANE
		set_opacity(1)
		if(!isnull(seed.chems["woodpulp"]))
			density = 1
	else
		plane = initial(plane)
		set_base_layer(initial(layer))
		density = 0

/obj/effect/plant/proc/calc_dir()
	set background = 1
	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/direction = 16

	for(var/wallDir in GLOB.cardinal)
		var/turf/newTurf = get_step(T,wallDir)
		if(newTurf.density)
			direction |= wallDir

	for(var/obj/effect/plant/shroom in T.contents)
		if(shroom == src)
			continue
		if(shroom.floor) //special
			direction &= ~16
		else
			direction &= ~shroom.dir

	var/list/dirList = list()

	for(var/i=1,i<=16,i <<= 1)
		if(direction & i)
			dirList += i

	if(dirList.len)
		var/newDir = pick(dirList)
		if(newDir == 16)
			floor = 1
			newDir = 1
		return newDir

	floor = 1
	return 1

/obj/effect/plant/attackby(var/obj/item/W, var/mob/user)

	user.setClickCooldown(user.get_attack_speed(W))
	SSplants.add_plant(src)

	if(W.is_wirecutter() || istype(W, /obj/item/surgical/scalpel))
		if(sampled)
			to_chat(user, "<span class='warning'>\The [src] has already been sampled recently.</span>")
			return
		if(!is_mature())
			to_chat(user, "<span class='warning'>\The [src] is not mature enough to yield a sample yet.</span>")
			return
		if(!seed)
			to_chat(user, "<span class='warning'>There is nothing to take a sample from.</span>")
			return
		if(sampled)
			to_chat(user, "<span class='danger'>You cannot take another sample from \the [src].</span>")
			return
		if(prob(70))
			sampled = 1
		seed.harvest(user,0,1)
		health -= (rand(3,5)*5)
		sampled = 1
	else
		..()
		if(W.force)
			health -= W.force
	check_health()

//handles being overrun by vines - note that attacker_parent may be null in some cases
/obj/effect/plant/proc/vine_overrun(datum/seed/attacker_seed, obj/effect/plant/attacker_parent)
	var/aggression = 0
	aggression += (attacker_seed.get_trait(TRAIT_CARNIVOROUS) - seed.get_trait(TRAIT_CARNIVOROUS))
	aggression += (attacker_seed.get_trait(TRAIT_SPREAD) - seed.get_trait(TRAIT_SPREAD))

	var/resiliance
	if(is_mature())
		resiliance = 0
		switch(seed.get_trait(TRAIT_ENDURANCE))
			if(30 to 70)
				resiliance = 1
			if(70 to 95)
				resiliance = 2
			if(95 to INFINITY)
				resiliance = 3
	else
		resiliance = -2
		if(seed.get_trait(TRAIT_ENDURANCE) >= 50)
			resiliance = -1
	aggression -= resiliance

	if(aggression > 0)
		health -= aggression*5
		check_health()

/obj/effect/plant/ex_act(severity)
	switch(severity)
		if(1.0)
			die_off()
			return
		if(2.0)
			if (prob(50))
				die_off()
				return
		if(3.0)
			if (prob(5))
				die_off()
				return
		else
	return

/obj/effect/plant/proc/check_health()
	if(health <= 0)
		die_off()

/obj/effect/plant/proc/is_mature()
	return (health >= (max_health/3) && world.time > mature_time)
