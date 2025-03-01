
///Higher == N2 slows reaction more
#define NITROGEN_SLOWING_FACTOR 0.15
///Higher == more heat released during reaction
#define THERMAL_RELEASE_MODIFIER 10000
///Higher == less phoron released by reaction
#define PHORON_RELEASE_MODIFIER 1500
///Higher == less oxygen released at high temperature/power
#define OXYGEN_RELEASE_MODIFIER 15000
///Higher == more overall power
#define REACTION_POWER_MODIFIER 1.1
/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
#define POWER_FACTOR 1.0
///Affects how fast the supermatter power decays
#define DECAY_FACTOR 700
///K
#define CRITICAL_TEMPERATURE 5000
#define CHARGING_FACTOR 0.05
///damage rate cap at power = 300, scales linearly with power
#define DAMAGE_RATE_LIMIT 3
/// max damage per tick, 1000 div 50 = 20 * 2 = 80 seconds
#define DAMAGE_HARD_LIMIT 50
// Base variants are applied to everyone on the same Z level
// Range variants are applied on per-range basis: numbers here are on point blank, it scales with the map size (assumes square shaped Z levels)
#define DETONATION_RADS 20
#define DETONATION_HALLUCINATION_BASE 300
#define DETONATION_HALLUCINATION_RANGE 300
#define DETONATION_HALLUCINATION 600


///seconds between warnings.
#define WARNING_DELAY 20
// Keeps Accent sounds from layering, increase or decrease as preferred.
#define SUPERMATTER_ACCENT_SOUND_COOLDOWN 2 SECONDS


/obj/machinery/power/supermatter
	name = "Supermatter"
	desc = "A strangely translucent and iridescent crystal. <font color='red'>You get headaches just from looking at it.</font>"
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"
	density = 1
	anchored = 0
	light_range = 4

	var/gasefficency = 0.25

	base_icon_state = "darkmatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 500
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#8A8A00"
	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/grav_pulling = 0
	var/pull_radius = 14
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 100
	var/explosion_power = 8

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundand explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/debug = 0

	/// Cooldown tracker for accent sounds,
	var/last_accent_sound = 0

	var/datum/looping_sound/supermatter/soundloop

/obj/machinery/power/supermatter/Initialize(mapload)
	. = ..()
	uid = gl_uid++
	soundloop = new(list(src), TRUE)

/obj/machinery/power/supermatter/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > CRITICAL_TEMPERATURE))
		return SUPERMATTER_WARNING

	if(air.temperature > (CRITICAL_TEMPERATURE * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)



/obj/machinery/power/supermatter/proc/explode()
	message_admins("Supermatter exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("SUPERMATTER([x],[y],[z]) Exploded. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
	anchored = 1
	grav_pulling = 1
	exploded = 1
	var/turf/TS = get_turf(src)		// The turf supermatter is on. SM being in a locker, mecha, or other container shouldn't block it's effects that way.
	if(!TS)
		return
	for(var/z in GetConnectedZlevels(TS.z))
		SSradiation.z_radiate(locate(1, 1, z), DETONATION_RADS, 1)
	for(var/mob/living/mob in living_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (loc.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				//Hilariously enough, running into a closet should make you get hit the hardest.
				var/mob/living/carbon/human/H = mob
				if(H.isSynthetic())
					continue
				H.hallucination += max(50, min(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1)) ) )
	spawn(pull_time)
		explosion(get_turf(src), explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)
		sleep(5) //to allow the explosion to finish
		new /obj/item/broken_sm(TS)
		qdel(src)
		return

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(var/lum, var/clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"
	var/message_sound = 'sound/ambience/matteralarm.ogg'

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		GLOB.global_announcer.autosay(alert_msg, "Supermatter Monitor", "Engineering")
		log_game("SUPERMATTER([x],[y],[z]) Emergency engineering announcement. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			GLOB.global_announcer.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT!", "Supermatter Monitor")
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player) && !isdeaf(M))
					SEND_SOUND(M, message_sound)
			admin_chat_message(message = "SUPERMATTER DELAMINATING!", color = "#FF2222")
			public_alert = 1
			log_game("SUPERMATTER([x],[y],[z]) Emergency PUBLIC announcement. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
		else if((damage > emergency_point) && public_alert)
			GLOB.global_announcer.autosay("DANGER: SUPERMATTER CRYSTAL DEGRADATION IN PROGRESS! INTEGRITY AT [integrity]%", "Supermatter Monitor")
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player) && !isdeaf(M))
					SEND_SOUND(M, sound('sound/ambience/engine_alert2.ogg'))
		else if(safe_warned && public_alert)
			GLOB.global_announcer.autosay(alert_msg, "Supermatter Monitor")
			public_alert = 0


/obj/machinery/power/supermatter/get_transit_zlevel()
	//don't send it back to the station -- most of the time
	if(prob(99))
		var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
		for(var/zlevel in GLOB.using_map.station_levels)
			candidates.Remove("[zlevel]")
		candidates.Remove("[src.z]")

		if(candidates.len)
			return text2num(pickweight(candidates))

	return ..()

/obj/machinery/power/supermatter/process(delta_time)

	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && (world.timeofday - lastwarning) >= WARNING_DELAY * 10)
			announce_warning()
	else
		shift_light(4,initial(light_color))
	if(grav_pulling)
		supermatter_pull(src)
	// Vary volume by power produced.
	if(power)
		// Volume will be 1 at no power, ~12.5 at ENERGY_NITROGEN, and 20+ at ENERGY_PHORON.
		// Capped to 20 volume since higher volumes get annoying and it sounds worse.
		// Formula previously was min(round(power/10)+1, 20)
		soundloop.volume = clamp((50 + (power / 50)), 50, 100)

	// Swap loops between calm and delamming.
	if(damage >= 300)
		soundloop.mid_sounds = list('sound/machines/sm/loops/delamming.ogg' = 1)
	else
		soundloop.mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)

	// Play Delam/Neutral sounds at rate determined by power and damage.
	if(last_accent_sound < world.time && prob(20))
		var/aggression = min(((damage / 800) * (power / 2500)), 1.0) * 100
		if(damage >= 300)
			playsound(src, "smdelam", max(50, aggression), FALSE, 10)
		else
			playsound(src, "smcalm", max(50, aggression), FALSE, 10)
		var/next_sound = round((100 - aggression) * 5)
		last_accent_sound = world.time + max(SUPERMATTER_ACCENT_SOUND_COOLDOWN, next_sound)
	//Ok, get the air from the turf
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We dont want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = min((power/300)*(explosion_point/1000)*DAMAGE_RATE_LIMIT, DAMAGE_HARD_LIMIT)

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage += max((power - 15*POWER_FACTOR)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage = max( damage + min( ( (removed.temperature - CRITICAL_TEMPERATURE) / 150 ), damage_inc_limit ) , 0 )
		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = max(min((removed.gas[/datum/gas/oxygen] - (removed.gas[/datum/gas/nitrogen] * NITROGEN_SLOWING_FACTOR)) / removed.total_moles, 1), 0)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/DECAY_FACTOR)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		//We've generated power, now let's transfer it to the collectors for storing/usage
		//transfer_energy()

		var/device_energy = power * REACTION_POWER_MODIFIER

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi(/datum/gas/phoron, max(device_energy / PHORON_RELEASE_MODIFIER, 0), \
		                     /datum/gas/oxygen, max((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0))

		var/thermal_power = THERMAL_RELEASE_MODIFIER * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		removed.adjust_thermal_energy(thermal_power)
		removed.temperature = clamp( removed.temperature, 0,  10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/l in view(src, min(7, round(sqrt(power/6))))) // If they can see it without mesons on.  Bad on them.
		if(l.isSynthetic() || (PLANE_MESONS in l.planes_visible))
			continue
		if(!istype(l.glasses, /obj/item/clothing/glasses/meson)) // Only mesons can protect you!
			l.hallucination = max(0, min(200, l.hallucination + power * config_hallucination_power * sqrt( 1 / max(1,get_dist(l, src)) ) ) )

	SSradiation.radiate(src, max(power * 1.5, 50) ) //Better close those shutters!

	power -= (power/DECAY_FACTOR)**3		//energy losses due to radiation

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.

	var/added_energy
	var/added_damage
	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		added_energy = proj_damage * config_bullet_energy	* CHARGING_FACTOR / POWER_FACTOR
		power += added_energy
	else
		added_damage = proj_damage * config_bullet_energy
		damage += added_damage
	if(added_energy || added_damage)
		log_game("SUPERMATTER([x],[y],[z]) Hit by \"[Proj.name]\". +[added_energy] Energy, +[added_damage] Damage.")
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as mob)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src], inducing a resonance... [TU.his] body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")

	Consume(user)

/obj/machinery/power/supermatter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiSupermatter", name)
		ui.open()

// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter/ui_data(mob/user)
	var/list/data = list()

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(!istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling

	return data

/*
// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(!istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
*/

/obj/machinery/power/supermatter/attackby(obj/item/W as obj, mob/living/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	Consume(W)
	user.apply_effect(150, IRRADIATE)


/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /obj/effect))
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/datum/gender/T = GLOB.gender_datums[M.get_visible_gender()]
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... [T.his] body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	Consume(AM)

/obj/machinery/power/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

		//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(10))
		if(l in view())
			l.show_message("<span class=\"warning\">As \the [src] slowly stops resonating, you find your skin covered in new radiation burns.</span>", 1,\
				"<span class=\"warning\">The unearthly ringing subsides and you notice you have new radiation burns.</span>", 2)
		else
			l.show_message("<span class=\"warning\">You hear an uneartly ringing and notice your skin is covered in fresh radiation burns.</span>", 2)
	var/rads = 500
	SSradiation.radiate(src, rads)

/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/proc/supermatter_pull(T, radius = 20)
	T = get_turf(T)
	if(!T)
		return
	for(var/atom/movable/AM in range(T, radius))
		if(AM.anchored)		// TODO: move_resist, move_force
			continue
		step_towards(AM, T)
		// TODO: atom damage for structures

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <font color='red'>You get headaches just from looking at it.</font>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_radius = 5
	pull_time = 45
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return

/obj/item/broken_sm
	name = "shattered supermatter plinth"
	desc = "The shattered remains of a supermatter shard plinth. It doesn't look safe to be around."
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter_broken"

/obj/item/broken_sm/Initialize(mapload)
	. = ..()
	message_admins("Broken SM shard created at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	START_PROCESSING(SSobj, src)

/obj/item/broken_sm/process(delta_time)
	SSradiation.radiate(src, 50)

/obj/item/broken_sm/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
