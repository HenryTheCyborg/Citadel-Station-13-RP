/datum/controller/subsystem/characters
	//! Species
	/**
	 * yeah so funny right
	 *
	 * we have a lot of fake-people around (minor races/human reskins)
	 * i can't remove them because that'd ruffle feathers
	 *              ( literally, looking at you harpies )
	 * so **everyone** gets to be a /datum/character_species
	 * that way we get the name, desc, and species id of what
	 * actual species we should be any are able to do roundstart tweaks.
	 */
	var/list/character_species_lookup
	/**
	 * species ui cache
	 * so we don't rebuild this every time someone makes an ui
	 * list of categories associated to lists
	 * second layer of list contains:
	 * {name: str, desc: str, whitelisted: 1 or 0, id: str}
	 */
	var/list/character_species_cache

/datum/controller/subsystem/characters/proc/rebuild_character_species()
	// make species lookup
	character_species_lookup = list()
	for(var/path in GLOB.species_meta)
		var/datum/species/S = GLOB.species_meta[path]
		if(!(S.spawn_flags & SPECIES_CAN_JOIN))		// don't bother lmao
			continue
		if(character_species_lookup[S.uid])
			stack_trace("species uid collision on [S.uid] from [S.type].")
			continue
		character_species_lookup[S.uid] = S.construct_character_species()
	for(var/path in subtypesof(/datum/character_species))
		var/datum/character_species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(character_species_lookup[S.uid])
			stack_trace("ignoring custom character species path [path] - collides on uid [S.uid]")
			continue
		character_species_lookup[S.uid] = S

	// make species data cache
	character_species_cache = list()
	for(var/id in character_species_lookup)
		var/datum/character_species/S = character_species_lookup[id]
		LAZYINITLIST(character_species_cache[S.category])
		character_species_cache[S.category] += list(list(
			"id" = S.uid,
			"whitelisted" = S.whitelisted,
			"name" = S.name,
			"desc" = S.desc
		))

/datum/controller/subsystem/characters/proc/resolve_character_species(uid)
	RETURN_TYPE(/datum/character_species)
	return character_species_lookup[uid]

/datum/controller/subsystem/characters/proc/construct_character_species(uid)
	RETURN_TYPE(/datum/species)
	var/datum/character_species/faux = resolve_character_species(uid)
	var/datum/species/built = new faux.real_species_type
	if(faux.is_real)
		// let's assume they aren't an idiot and didn't hardcode a real species as a character species
		return built
	faux.tweak(built)
	return built
