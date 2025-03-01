//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_range = 2
	light_color = "#b5ff5b"
	desc = "Some blob creature thingy"
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 2

	var/maxHealth = 30
	var/health
	var/brute_resist = 4
	var/fire_resist = 1
	var/expandType = /obj/effect/blob

/obj/effect/blob/Initialize(mapload)
	. = ..()
	health = maxHealth
	update_icon()

/obj/effect/blob/CanAllowThrough(atom/movable/mover, turf/target)
	return FALSE

/obj/effect/blob/ex_act(severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) / brute_resist)
		if(2)
			take_damage(rand(60, 100) / brute_resist)
		if(3)
			take_damage(rand(20, 60) / brute_resist)

/obj/effect/blob/update_icon()
	if(health > maxHealth / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/take_damage(damage)
	health -= damage
	if(health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/effect/blob/proc/regen()
	health = min(health + 1, maxHealth)
	update_icon()

/obj/effect/blob/proc/expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
		return
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(80)
		return
	var/obj/structure/girder/G = locate() in T
	if(G)
		if(prob(40))
			G.dismantle()
		return
	var/obj/structure/window/W = locate() in T
	if(W)
		W.shatter()
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return
	for(var/obj/structure/reagent_dispensers/fueltank/Fuel in T)
		Fuel.ex_act(2)
		return
	for(var/obj/machinery/door/D in T) // There can be several - and some of them can be open, locate() is not suitable
		if(D.density)
			D.ex_act(2)
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle_old/V = locate() in T
	if(V)
		V.ex_act(2)
		return
	var/obj/mecha/M = locate() in T
	if(M)
		M.visible_message("<span class='danger'>The blob attacks \the [M]!</span>")
		M.take_damage(40)
		return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		L.visible_message("<span class='danger'>The blob attacks \the [L]!</span>", "<span class='danger'>The blob attacks you!</span>")
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		L.take_organ_damage(rand(30, 40))
		return
	new expandType(T, min(health, 30))

/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	regen()
	animate(src, color = "#FF0000", time=1)
	animate(color = "#FFFFFF", time=4, easing=ELASTIC_EASING)
	sleep(5)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(health))
			expand(T)
		return
	B.pulse(forceLeft - 1, dirs)

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.get_final_damage(src))
		if(BURN)
			take_damage(Proj.get_final_damage(src))
	return 0

/obj/effect/blob/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / fire_resist)
			if(istype(W, /obj/item/weldingtool))
				playsound(src, W.tool_sound, 100, 1)
		if("brute")
			damage = (W.force / brute_resist)

	take_damage(damage)
	return

/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"
	light_range = 3
	light_color = "#ffc880"
	maxHealth = 200
	brute_resist = 2
	fire_resist = 2

	expandType = /obj/effect/blob/shield

/obj/effect/blob/core/update_icon()
	return

/obj/effect/blob/core/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/blob/core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/blob/core/process(delta_time)
	pulse(20, list(NORTH, EAST))
	pulse(20, list(NORTH, WEST))
	pulse(20, list(SOUTH, EAST))
	pulse(20, list(SOUTH, WEST))

/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	light_range = 3
	desc = "Some blob creature thingy"
	maxHealth = 60
	brute_resist = 1
	fire_resist = 2

/obj/effect/blob/shield/Initialize(mapload)
	. = ..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	density = 0
	update_nearby_tiles()
	..()

/obj/effect/blob/shield/update_icon()
	if(health > maxHealth * 2 / 3)
		icon_state = "blob_idle"
	else if(health > maxHealth / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanAllowThrough(var/atom/movable/mover, var/turf/target)
	. = ..()
	return !density
