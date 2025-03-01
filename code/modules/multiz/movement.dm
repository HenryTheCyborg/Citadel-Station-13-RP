/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Downwards" //cit change - dumb name, "Move Down" -> "Move Downwards"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(src, "<span class='notice'>You move down.</span>")

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)

	if(istype(loc,/obj/mecha))
		var/obj/mecha/mech = loc
		return mech.relaymove(src,direction)

	if(!can_ztravel())
		to_chat(src, "<span class='warning'>You lack means of travel in that direction.</span>")
		return

	var/turf/start = loc
	if(!istype(start))
		to_chat(src, "<span class='notice'>You are unable to move from here.</span>")
		return 0

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(!destination)
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return 0

	if(is_incorporeal())
		forceMove(destination)
		return 1

	if(!start.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [start] is in the way.</span>")
		return 0

	if(!destination.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [destination] blocks your way.</span>")
		return 0

	if(direction == UP && has_gravity() && !can_overcome_gravity())
		var/obj/structure/lattice/lattice = locate() in destination.contents
		if(lattice)
			var/pull_up_time = max(5 SECONDS + (movement_delay() * 10), 1)
			to_chat(src, "<span class='notice'>You grab \the [lattice] and start pulling yourself upward...</span>")
			destination.audible_message("<span class='notice'>You hear something climbing up \the [lattice].</span>")
			if(do_after(src, pull_up_time))
				to_chat(src, "<span class='notice'>You pull yourself up.</span>")
			else
				to_chat(src, "<span class='warning'>You gave up on pulling yourself up.</span>")
				return 0
		else if(ismob(src)) // Are they a mob, and are they currently flying??
			var/mob/living/H = src
			if(H.flying)
				if(H.incapacitated(INCAPACITATION_ALL))
					to_chat(src, "<span class='notice'>You can't fly in your current state.</span>")
					H.stop_flying() //Should already be done, but just in case.
					return 0
				var/fly_time = max(7 SECONDS + (H.movement_delay() * 10), 1) //So it's not too useful for combat. Could make this variable somehow, but that's down the road.
				to_chat(src, "<span class='notice'>You begin to fly upwards...</span>")
				destination.audible_message("<span class='notice'>You hear the of air moving.</span>")
				H.audible_message("<span class='notice'>[H] begins to soar upwards!</span>")
				if(do_after(H, fly_time) && H.flying)
					to_chat(src, "<span class='notice'>You fly upwards.</span>")
				else
					to_chat(src, "<span class='warning'>You stopped flying upwards.</span>")
					return 0
			else
				to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
				return 0
		else
			to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
			return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start, 1.5, 0))
			to_chat(src, "<span class='warning'>\The [A] blocks you.</span>")
			return 0
	if(!Move(destination))
		return 0
	return 1

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/can_overcome_gravity()
	return hovering

/mob/living/carbon/human/can_overcome_gravity()
	. = ..()
	if(!.)
		return species && species.can_overcome_gravity(src)

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/proc/can_ztravel()
	return 0

/mob/living/zMove(direction)
	//Sort of a lame hack to allow ztravel through zpipes. Should be improved.
	if(is_ventcrawling && istype(loc,/obj/machinery/atmospherics/pipe/zpipe))
		var/obj/machinery/atmospherics/pipe/zpipe/currentpipe = loc
		if(istype(currentpipe.node1,/obj/machinery/atmospherics/pipe/zpipe))
			currentpipe.ventcrawl_to(src, currentpipe.node1, direction)
		else if(istype(currentpipe.node2,/obj/machinery/atmospherics/pipe/zpipe))
			currentpipe.ventcrawl_to(src, currentpipe.node2, direction)
	return ..()

/mob/observer/can_ztravel()
	return TRUE

/mob/living/can_ztravel()
	if(incapacitated())
		return FALSE
	return (hovering || is_incorporeal())

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return FALSE

	if(hovering || is_incorporeal())
		return TRUE

	if(flying) // Allows movement up/down with wings.
		return 1
	if(Process_Spacemove())
		return TRUE

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return TRUE

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return FALSE

	if(hovering)
		return TRUE

	if(Process_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return TRUE

// TODO - Leshana Experimental

//Execution by grand piano!
/atom/movable/proc/get_fall_damage()
	return 42

//If atom stands under open space, it can prevent fall, or not
/atom/proc/can_prevent_fall(var/atom/movable/mover, var/turf/coming_from)
	return (!CanPass(mover, coming_from))

////////////////////////////



//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall()
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	if(istype(below, /turf/space))
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	if(!has_gravity())
		return

	if(throwing)
		return

	if(ismob(src))
		var/mob/H = src // Flight on mobs.
		if(H.flying) //Some other checks are done in the wings_toggle proc
			if(H.nutrition > 2)
				H.nutrition -= 0.5 //You use up 0.5 nutrition per TILE and tick of flying above open spaces. If people wanna flap their wings in the hallways, shouldn't penalize them for it. Lowered to make winged people less sad.
			if(H.incapacitated(INCAPACITATION_ALL))
				H.stop_flying()
				//Just here to see if the person is KO'd, stunned, etc. If so, it'll move onto can_fall.
			else if (H.nutrition > 1000) //Eat too much while flying? Get fat and fall.
				to_chat(H, "<span class='danger'>You're too heavy! Your wings give out and you plummit to the ground!</span>")
				H.stop_flying() //womp womp.
			else if(H.nutrition < 300 && H.nutrition > 289) //290 would be risky, as metabolism could mess it up. Let's do 289.
				to_chat(H, "<span class='danger'>You are starting to get fatigued... You probably have a good minute left in the air, if that. Even less if you continue to fly around! You should get to the ground soon!</span>") //Ticks are, on average, 3 seconds. So this would most likely be 90 seconds, but lets just say 60.
				H.nutrition -= 0.5 //Fixed the evilness to have 10 nutrition drained per tick and tile below 300 nutrition too
				return
			else if(H.nutrition < 100 && H.nutrition > 89)
				to_chat(H, "<span class='danger'>You're seriously fatigued! You need to get to the ground immediately and eat before you fall!</span>")
				return
			else if(H.nutrition < 10) //Should have listened to the warnings!
				to_chat(H, "<span class='danger'>You lack the strength to keep yourself up in the air...</span>")
				H.stop_flying()
			else
				return
		else if(ishuman(H)) //Needed to prevent 2 people from grabbing eachother in the air.
			var/mob/living/carbon/human/F = H
			if(F.grabbed_by.len) //If you're grabbed (presumably by someone flying) let's not have you fall. This also allows people to grab onto you while you jump over a railing to prevent you from falling!
				var/obj/item/grab/G = F.get_active_held_item()
				var/obj/item/grab/J = F.get_inactive_held_item()
				if(istype(G) || istype(J))
					//fall
				else
					return

	if(can_fall())
		// We spawn here to let the current move operation complete before we start falling. fall() is normally called from
		// Entered() which is part of Move(), by spawn()ing we let that complete.  But we want to preserve if we were in client movement
		// or normal movement so other move behavior can continue.
		var/mob/M = src
		var/is_client_moving = (ismob(M) && M.client && M.client.moving)
		var/curr = loc
		spawn(0)
			if(loc != curr)
				return
			if(is_client_moving) M.client.moving = 1
			handle_fall(below)
			if(is_client_moving) M.client.moving = 0
		// TODO - handle fall on damage!

//For children to override
/atom/movable/proc/can_fall()
	if(anchored)
		return FALSE
	// if(throwing)
		// return FALSE
	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/debris/cleanable/can_fall()
	return TRUE

// These didn't fall anyways but better to nip this now just incase.
/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Mechas are anchored, so we need to override.
/obj/mecha/can_fall()
	return TRUE

/obj/item/pipe/can_fall()
	. = ..()

	if(anchored)
		return FALSE

	var/turf/below = GetBelow(src)
	if((locate(/obj/structure/disposalpipe/up) in below) || (locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below))
		return FALSE

/mob/can_fall()
	if(buckled)
		return FALSE	// buckled falls instead
	return ..()

/mob/living/can_fall()
	if(is_incorporeal())
		return FALSE
	if(hovering)
		return FALSE
	return ..()

/mob/living/carbon/human/can_fall()
	if(..())
		return species.can_fall(src)

// Check if this atom prevents things standing on it from falling. Return TRUE to allow the fall.
/obj/proc/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	return TRUE

// Things that prevent objects standing on them from falling into turf below
/obj/structure/catwalk/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	return FALSE

// So you'll slam when falling onto a catwalk
/obj/structure/catwalk/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/obj/structure/lattice/CanFallThru(atom/movable/mover as mob|obj, turf/target as turf)
	return check_standard_flag_pass(mover)

// So you'll slam when falling onto a grille
/obj/structure/lattice/CheckFall(var/atom/movable/falling_atom)
	if(check_standard_flag_pass(falling_atom))
		return FALSE
	return falling_atom.fall_impact(src)

// Actually process the falling movement and impacts.
/atom/movable/proc/handle_fall(turf/landing)
	var/turf/oldloc = loc

	// Check if there is anything in our turf we are standing on to prevent falling.
	for(var/obj/O in loc)
		if(!O.CanFallThru(src, landing))
			return FALSE
	// See if something in turf below prevents us from falling into it.
	for(var/atom/A in landing)
		if(!A.CanPass(src, src.loc, 1, 0))
			return FALSE
	// TODO - Stairs should operate thru a different mechanism, not falling, to allow side-bumping.

	// this is shitcode lmao
	var/obj/structure/stairs = locate() in landing
	if(!stairs)
		// Now lets move there!
		if(!Move(landing))
			return 1

		var/atom/A = find_fall_target(oldloc, landing)
		if(special_fall_handle(A) || !A || !A.check_impact(src))
			return
		fall_impact(A)
	else
		locationTransitForceMove(landing)

/atom/movable/proc/special_fall_handle(var/atom/A)
	return FALSE

/mob/living/carbon/human/special_fall_handle(var/atom/A)
	if(species)
		return species.fall_impact_special(src, A)
	return FALSE

/atom/movable/proc/find_fall_target(var/turf/oldloc, var/turf/landing)
	if(isopenturf(oldloc))
		oldloc.visible_message("\The [src] falls down through \the [oldloc]!", "You hear something falling through the air.")

	// If the turf has density, we give it first dibs
	if (landing.density && landing.CheckFall(src))
		return landing

	// First hit objects in the turf!
	for(var/atom/movable/A in landing)
		if(A != src && A.CheckFall(src))
			return A

	// If none of them stopped us, then hit the turf itself
	if(landing.CheckFall(src))
		return landing

/mob/living/carbon/human/find_fall_target(var/turf/landing)
	if(species)
		var/atom/A = species.find_fall_target_special(src, landing)
		if(A)
			return A
	return ..()

//CheckFall landing.fall_impact(src)

// ## THE FALLING PROCS ###

// Called on everything that falling_atom might hit. Return TRUE if you're handling it so find_fall_target() will stop checking.
/atom/proc/CheckFall(var/atom/movable/falling_atom)
	if(density && !(flags & ON_BORDER))
		return TRUE

// If you are hit: how is it handled.
// Return TRUE if the generic fall_impact should be called
// Return FALSE if you handled it yourself or if there's no effect from hitting you
/atom/proc/check_impact(var/atom/movable/falling_atom)
	if(density && !(flags & ON_BORDER))
		return TRUE

// By default all turfs are gonna let you hit them regardless of density.
/turf/CheckFall(var/atom/movable/falling_atom)
	return TRUE

/turf/check_impact(var/atom/movable/falling_atom)
	return TRUE

// Obviously you can't really hit open space.
/turf/simulated/open/CheckFall(var/atom/movable/falling_atom)
	return FALSE

/turf/simulated/open/check_impact(var/atom/movable/falling_atom)
	return FALSE

// Or actual space.
/turf/space/CheckFall(var/atom/movable/falling_atom)
	return FALSE

/turf/space/check_impact(var/atom/movable/falling_atom)
	return FALSE

// We return 1 without calling fall_impact in order to provide a soft landing. So nice.
// Note this really should never even get this far
/obj/structure/stairs/CheckFall(var/atom/movable/falling_atom)
	return TRUE

/obj/structure/stairs/check_impact(var/atom/movable/falling_atom)
	return FALSE

// Can't fall onto ghosts
/mob/observer/dead/CheckFall()
	return FALSE

/mob/observer/dead/check_impact()
	return FALSE


// Called by CheckFall when we actually hit something. Various Vars will be described below
// hit_atom is the thing we fall on
// damage_min is the smallest amount of damage a thing (currently only mobs and mechs) will take from falling
// damage_max is the largest amount of damage a thing (currently only mobs and mechs) will take from falling.
// If silent is True, the proc won't play sound or give a message.
// If planetary is True, it's harder to stop the fall damage

/atom/movable/proc/fall_impact(var/atom/hit_atom, var/damage_min = 0, var/damage_max = 10, var/silent = FALSE, var/planetary = FALSE)
	if(!silent)
		visible_message("\The [src] falls from above and slams into \the [hit_atom]!", "You hear something slam into \the [hit_atom].")
	for(var/atom/movable/A in src.contents)
		A.fall_impact(hit_atom, damage_min, damage_max, silent = TRUE)
	for(var/mob/M in buckled_mobs)
		M.fall_impact(hit_atom, damage_min, damage_max, silent, planetary)

// Take damage from falling and hitting the ground
/mob/living/fall_impact(var/atom/hit_atom, var/damage_min = 0, var/damage_max = 5, var/silent = FALSE, var/planetary = FALSE)
	var/turf/landing = get_turf(hit_atom)
	if(planetary && src.CanParachute())
		if(!silent)
			visible_message("<span class='warning'>\The [src] glides in from above and lands on \the [landing]!</span>", \
				"<span class='danger'>You land on \the [landing]!</span>", \
				"You hear something land \the [landing].")
		return
	else if(!planetary && src.softfall) // Falling one floor and falling one atmosphere are very different things
		if(!silent)
			visible_message("<span class='warning'>\The [src] falls from above and lands on \the [landing]!</span>", \
				"<span class='danger'>You land on \the [landing]!</span>", \
				"You hear something land \the [landing].")
		return
	else
		if(!silent)
			if(planetary)
				visible_message("<span class='danger'><font size='3'>\A [src] falls out of the sky and crashes into \the [landing]!</font></span>", \
					"<span class='danger'><font size='3'> You fall out of the sky and crash into \the [landing]!</font></span>", \
					"You hear something slam into \the [landing].")
				var/turf/T = get_turf(landing)
				explosion(T, 0, 1, 2)
			else
				visible_message("<span class='warning'>\The [src] falls from above and slams into \the [landing]!</span>", \
					"<span class='danger'>You fall off and hit \the [landing]!</span>", \
					"You hear something slam into \the [landing].")
			playsound(loc, "punch", 25, 1, -1)

		// Because wounds heal rather quickly, 10 (the default for this proc) should be enough to discourage jumping off but not be enough to ruin you, at least for the first time.
		// Hits 10 times, because apparently targeting individual limbs lets certain species survive the fall from atmosphere
		for(var/i = 1 to 10)
			adjustBruteLoss(rand(damage_min, damage_max))
		Weaken(4)
		updatehealth()

/mob/living/carbon/human/fall_impact(atom/hit_atom, damage_min, damage_max, silent, planetary)
	if(!species?.handle_falling(src, hit_atom, damage_min, damage_max, silent, planetary))
		..()

//Using /atom/movable instead of /obj/item because I'm not sure what all humans can pick up or wear
/atom/movable
	var/parachute = FALSE	// Is this thing a parachute itself?
	var/hovering = FALSE	// Is the thing floating or flying in some way? If so, don't fall normally.	//Not implemented yet, idea is to let mobs/mechs ignore terrain slowdown and falling down floors
	var/softfall = FALSE	// Is the thing able to lessen their impact upon falling?
	var/parachuting = FALSE	// Is the thing able to jump out of planes and survive? Don't check this directly outside of CanParachute().

/atom/movable/proc/isParachute()
	return parachute

//This is what makes the parachute items know they've been used.
//I made it /atom/movable so it can be retooled for other things (mobs, mechs, etc), though it's only currently called in human/CanParachute().
/atom/movable/proc/handleParachute()
	return

//Checks if the thing is allowed to survive a fall from space
/atom/movable/proc/CanParachute()
	return parachuting

//For humans, this needs to be a wee bit more complicated
/mob/living/carbon/human/CanParachute()
	//Certain slots don't really need to be checked for parachute ability, i.e. pockets, ears, etc. If this changes, just add them to the loop, I guess?
	//This is done in Priority Order, so items lower down the list don't call handleParachute() unless they're actually used.
	if(back && back.isParachute())
		back.handleParachute()
		return TRUE
	if(s_store && s_store.isParachute())
		s_store.handleParachute()
		return TRUE
	if(belt && belt.isParachute())
		belt.handleParachute()
		return TRUE
	if(wear_suit && wear_suit.isParachute())
		wear_suit.handleParachute()
		return TRUE
	if(w_uniform && w_uniform.isParachute())
		w_uniform.handleParachute()
		return TRUE
	else
		return parachuting

//Mech Code
/obj/mecha/handle_fall(var/turf/landing)
	// First things first, break any lattice
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, loc)
	if(lattice)
		// Lattices seem a bit too flimsy to hold up a massive exosuit.
		lattice.visible_message("<span class='danger'>\The [lattice] collapses under the weight of \the [src]!</span>")
		qdel(lattice)

	// Then call parent to have us actually fall
	return ..()

/obj/mecha/fall_impact(var/atom/hit_atom, var/damage_min = 15, var/damage_max = 30, var/silent = FALSE, var/planetary = FALSE)
	// Anything on the same tile as the landing tile is gonna have a bad day.
	for(var/mob/living/L in hit_atom.contents)
		L.visible_message("<span class='danger'>\The [src] crushes \the [L] as it lands on them!</span>")
		L.adjustBruteLoss(rand(70, 100))
		L.Weaken(8)

	var/turf/landing = get_turf(hit_atom)

	if(planetary && src.CanParachute())
		if(!silent)
			visible_message("<span class='warning'>\The [src] glides in from above and lands on \the [landing]!</span>", \
				"<span class='danger'>You land on \the [landing]!</span>", \
				"You hear something land \the [landing].")
		return
	else if(!planetary && src.softfall) // Falling one floor and falling one atmosphere are very different things
		if(!silent)
			visible_message("<span class='warning'>\The [src] falls from above and lands on \the [landing]!</span>", \
				"<span class='danger'>You land on \the [landing]!</span>", \
				"You hear something land \the [landing].")
		return
	else
		if(!silent)
			if(planetary)
				visible_message("<span class='danger'><font size='3'>\A [src] falls out of the sky and crashes into \the [landing]!</font></span>", \
					"<span class='danger'><font size='3'> You fall out of the skiy and crash into \the [landing]!</font></span>", \
					"You hear something slam into \the [landing].")
				var/turf/T = get_turf(landing)
				explosion(T, 0, 1, 2)
			else
				visible_message("<span class='warning'>\The [src] falls from above and slams into \the [landing]!</span>", \
					"<span class='danger'>You fall off and hit \the [landing]!</span>", \
					"You hear something slam into \the [landing].")
			playsound(loc, "punch", 25, 1, -1)

	// And now to hurt the mech.
	if(!planetary)
		take_damage(rand(damage_min, damage_max))
	else
		for(var/atom/movable/A in src.contents)
			A.fall_impact(hit_atom, damage_min, damage_max, silent = TRUE)
		qdel(src)

	// And hurt the floor.
	if(istype(hit_atom, /turf/simulated/floor))
		var/turf/simulated/floor/ground = hit_atom
		ground.break_tile()
