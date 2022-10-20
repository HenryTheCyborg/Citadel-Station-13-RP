GLOBAL_REAL(gas_data, /datum/gas_data)

/**
 * master datum holding all atmospherics gas data
 * all lists should be accessed directly for speed
 * all lists are keyed by id
 */
/datum/gas_data
	//! gas data
	//? intrinsics
	/// ids; associative list to the instantiated datum
	var/list/gases = list()
	/// names
	var/list/names = list()
	/// flags
	var/list/flags = list()
	/// groups
	var/list/groups = list()
	//? physics
	/// specific heat
	var/list/specific_heats = list()
	/// molar masses
	var/list/molar_masses = list()
	//? reagents
	/// reagents: id = (reagentid, base amount, minimum moles, mole factor, max amount)
	/// this is a sparse lookup, not all gases are in here.
	var/list/reagents = list()
	//? visuals
	/// visuals: id = (state, threshold, factor, color)
	var/list/visuals = list()
	//? reactions
	var/list/rarities = list()

	//! gas cache lists
	/// list of lists of gas ids by flag
	var/list/gas_by_flag = list()
	/// list of lists of gas ids by group
	var/list/gas_by_group = list()

	//! global data
	/// next random gas id
	var/static/next_procedural_gas_id = 0

/datum/gas_data/New()
	build_hardcoded()

/datum/gas_data/proc/rebuild_caches()
	names = list()
	flags = list()
	groups = list()
	specific_heats = list()
	molar_masses = list()
	reagents = list()
	visuals = list()
	rarities = list()
	gas_by_flag = list()
	gas_by_group = list()
	if(!islist(gases))
		gases = list()
	for(var/i in 1 to length(gases))
		var/id = gases[i]
		var/datum/gas/G = gases[id]
		if(!G)
			gases -= id
			continue
		if(id != G.id)
			gases[i] = G.id
			gases[G.id] = G
		_register_gas(G)

/datum/gas_data/proc/build_hardcoded()
	for(var/path in subtypesof(/datum/gas))
		var/datum/gas/G = new path
		register_gas(G)

/datum/gas_data/proc/register_gas(datum/gas/G)
	ASSERT(G.id)
	ASSERT(!gases[G.id])
	_register_gas(G)

/datum/gas_data/proc/_register_gas(datum/gas/G)
	//? intrinsics
	gases[G.id] = G
	names[G.id] = G.name
	if(flags[G.id])
		var/old_flags = flags[G.id]
		for(var/bit in bitfield2list(old_flags))
			LAZYREMOVE(gas_by_flag["[bit]"], G.id)
	flags[G.id] = G.gas_flags
	if(groups[G.id])
		var/old_group = groups[G.id]
		LAZYREMOVE(gas_by_group[old_group], G.id)
	groups[G.id] = G.gas_group
	//? physics
	specific_heats[G.id] = G.specific_heat
	molar_masses[G.id] = G.molar_mass
	//? reagents
	if(G.gas_reagent_id)
		reagents[G.id] = list(
			G.gas_reagent_id,
			G.gas_reagent_amount,
			G.gas_reagent_threshold,
			G.gas_reagent_factor,
			G.gas_reagent_max
		)
	else
		reagents -= G.id
	//? visuals
	#warn visuals
	//? reactions
	rarities[G.id] = G.rarity
	//? rebuild cheap cache lists
	//* gas groups
	LAZYINITLIST(gas_by_group[G.gas_group])
	LAZYOR(gas_by_group[G.gas_group], G.id)
	//* gas flags
	for(var/bit in bitfield2list(G.gas_flags))
		LAZYINITLIST(gas_by_flag["[bit]"])
		LAZYOR(gas_by_flag["[bit]"], G.id)

/datum/gas_data/proc/construct_overlay(id)
	RETURN_TYPE(/image)
	var/list/data = visuals[id]
	if(!data)
		return
	var/image/I = image('icons/modules/atmospherics/gas.dmi', icon_state = data[GAS_VISUAL_INDEX_STATE], layer = FLOAT_LAYER + 1)
	I.plane = FLOAT_PLANE
	#warn needs to be better at caching by far; maybe a minimum + shift system?
