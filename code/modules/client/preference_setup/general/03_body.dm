var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["species"]			>> pref.species
	S["hair_red"]			>> pref.r_hair
	S["hair_green"]			>> pref.g_hair
	S["hair_blue"]			>> pref.b_hair
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["facial_red"]			>> pref.r_facial
	S["facial_green"]		>> pref.g_facial
	S["facial_blue"]		>> pref.b_facial
	S["skin_tone"]			>> pref.s_tone
	S["skin_red"]			>> pref.r_skin
	S["skin_green"]			>> pref.g_skin
	S["skin_blue"]			>> pref.b_skin
	S["hair_style_name"]	>> pref.h_style
	S["facial_style_name"]	>> pref.f_style
	S["grad_style_name"]	>> pref.grad_style
	S["grad_wingstyle_name"]>> pref.grad_wingstyle
	S["eyes_red"]			>> pref.r_eyes
	S["eyes_green"]			>> pref.g_eyes
	S["eyes_blue"]			>> pref.b_eyes
	S["b_type"]				>> pref.b_type
	S["disabilities"]		>> pref.disabilities
	S["mirror"]				>> pref.mirror
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data
	S["body_markings"]		>> pref.body_markings
	S["synth_color"]		>> pref.synth_color
	S["synth_red"]			>> pref.r_synth
	S["synth_green"]		>> pref.g_synth
	S["synth_blue"]			>> pref.b_synth
	S["synth_markings"]		>> pref.synth_markings
	pref.regen_limbs = 1
	S["bgstate"]			>> pref.bgstate
	S["body_descriptors"]	>> pref.body_descriptors
	S["s_base"]				>> pref.s_base

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["species"]			<< pref.species
	S["hair_red"]			<< pref.r_hair
	S["hair_green"]			<< pref.g_hair
	S["hair_blue"]			<< pref.b_hair
	S["grad_red"]			<< pref.r_grad
	S["grad_green"]			<< pref.g_grad
	S["grad_blue"]			<< pref.b_grad
	S["facial_red"]			<< pref.r_facial
	S["facial_green"]		<< pref.g_facial
	S["facial_blue"]		<< pref.b_facial
	S["skin_tone"]			<< pref.s_tone
	S["skin_red"]			<< pref.r_skin
	S["skin_green"]			<< pref.g_skin
	S["skin_blue"]			<< pref.b_skin
	S["hair_style_name"]	<< pref.h_style
	S["facial_style_name"]	<< pref.f_style
	S["grad_style_name"]	<< pref.grad_style
	S["grad_wingstyle_name"]<< pref.grad_wingstyle
	S["eyes_red"]			<< pref.r_eyes
	S["eyes_green"]			<< pref.g_eyes
	S["eyes_blue"]			<< pref.b_eyes
	S["b_type"]				<< pref.b_type
	S["disabilities"]		<< pref.disabilities
	S["mirror"]				<< pref.mirror
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data
	S["body_markings"]		<< pref.body_markings
	S["synth_color"]		<< pref.synth_color
	S["synth_red"]			<< pref.r_synth
	S["synth_green"]		<< pref.g_synth
	S["synth_blue"]			<< pref.b_synth
	S["synth_markings"]		<< pref.synth_markings
	S["bgstate"]			<< pref.bgstate
	S["body_descriptors"]	<< pref.body_descriptors
	S["s_base"]				<< pref.s_base

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	if(!pref.species || !(pref.species in GLOB.playable_species))
		pref.species = SPECIES_HUMAN
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_grad			= sanitize_integer(pref.r_grad, 0, 255, initial(pref.r_grad))
	pref.g_grad			= sanitize_integer(pref.g_grad, 0, 255, initial(pref.g_grad))
	pref.b_grad			= sanitize_integer(pref.b_grad, 0, 255, initial(pref.b_grad))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style		= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.grad_wingstyle	= sanitize_inlist(pref.grad_wingstyle, GLOB.hair_gradients, initial(pref.grad_wingstyle))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))
	if(pref.mirror == null)
		pref.mirror = TRUE

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= body_marking_styles_list
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.r_eyes			= pref.r_eyes
	character.g_eyes			= pref.g_eyes
	character.b_eyes			= pref.b_eyes
	character.r_hair			= pref.r_hair
	character.g_hair			= pref.g_hair
	character.b_hair			= pref.b_hair
	character.r_grad			= pref.r_grad
	character.g_grad			= pref.g_grad
	character.b_grad			= pref.b_grad
	character.r_gradwing		= pref.r_gradwing
	character.g_gradwing		= pref.g_gradwing
	character.b_gradwing		= pref.b_gradwing
	character.r_facial			= pref.r_facial
	character.g_facial			= pref.g_facial
	character.b_facial			= pref.b_facial
	character.r_skin			= pref.r_skin
	character.g_skin			= pref.g_skin
	character.b_skin			= pref.b_skin
	character.s_tone			= pref.s_tone
	character.h_style			= pref.h_style
	character.f_style			= pref.f_style
	character.grad_style		= pref.grad_style
	character.grad_wingstyle	= pref.grad_wingstyle
	character.b_type			= pref.b_type
	character.synth_color 		= pref.synth_color
	character.r_synth			= pref.r_synth
	character.g_synth			= pref.g_synth
	character.b_synth			= pref.b_synth
	character.synth_markings 	= pref.synth_markings
	character.s_base			= pref.s_base

	// Destroy/cyborgize organs and limbs.
	character.synthetic = null
	for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					O.robotize(pref.rlimb_data[name])
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()


	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		if(!istype(O))
			continue
		O.markings.Cut()

	for(var/M in pref.body_markings)
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]
		var/mark_color = "[pref.body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	var/datum/species/mob_species = pref.character_static_species_meta()
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = clamp(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))

	return

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	. = list()

	var/datum/species/mob_species = pref.character_static_species_meta()
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Species: <a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	if(has_flag(mob_species, HAS_BASE_SKIN_COLOR))
		. += "Base Colour: <a href='?src=\ref[src];base_skin=1'>[pref.s_base]</a><br>"
	. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[DISABILITY_NEARSIGHTED]'><b>[pref.disabilities & DISABILITY_NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
	. += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"
	. += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"
	. += "Respawn Method: <a href='?src=\ref[src];mirror=1'><b>[pref.mirror ? "Mirror" : "Off-Site Cloning"]</b></a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null

		switch(name)
			if(BP_TORSO)
				organ_name = "torso"
			if(BP_GROIN)
				organ_name = "groin"
			if(BP_HEAD)
				organ_name = "head"
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(O_HEART)
				organ_name = "heart"
			if(O_EYES)
				organ_name = "eyes"
			if(O_VOICE)
				organ_name = "larynx"
			if(O_BRAIN)
				organ_name = "brain"
			if(O_LUNGS)
				organ_name = "lungs"
			if(O_LIVER)
				organ_name = "liver"
			if(O_KIDNEYS)
				organ_name = "kidneys"
			if(O_SPLEEN)
				organ_name = "spleen"
			if(O_STOMACH)
				organ_name = "stomach"
			if(O_INTESTINE)
				organ_name = "intestines"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				. += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && GLOB.all_robolimbs[pref.rlimb_data[name]])
				R = GLOB.all_robolimbs[pref.rlimb_data[name]]
			else
				R = GLOB.basic_robolimb
			. += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if ("brain")
					. += "\tPositronic [organ_name]"
				else
					. += "\tSynthetic [organ_name]"
		else if(status == "digital")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tDigital [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if("heart")
					. += "\tPacemaker-assisted [organ_name]"
				if("lungs")
					. += "\tAssisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tSurgically altered [organ_name]"
				if("eyes")
					. += "\tRetinal overlayed [organ_name]"
				if("brain")
					. += "\tAssisted-interface [organ_name]"
				else
					. += "\tMechanically assisted [organ_name]"
	if(!ind)
		. += "\[...\]<br><br>"
	else
		. += "<br><br>"

	if(LAZYLEN(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=\ref[src];change_descriptor=[entry]'>Change</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> [color_square(pref.r_hair, pref.g_hair, pref.b_hair)] "
	. += " Style: <a href='?src=\ref[src];hair_style_left=[pref.h_style]'><</a> <a href='?src=\ref[src];hair_style_right=[pref.h_style]''>></a> <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>" //The <</a> & ></a> in this line is correct-- those extra characters are the arrows you click to switch between styles.

	. += "<b>Gradient</b><br>"
	. += "<a href='?src=\ref[src];grad_color=1'>Change Color</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
	. += " Style: <a href='?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> [color_square(pref.r_facial, pref.g_facial, pref.b_facial)] "
	. += " Style: <a href='?src=\ref[src];facial_style_left=[pref.f_style]'><</a> <a href='?src=\ref[src];facial_style_right=[pref.f_style]''>></a> <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>" //Same as above with the extra > & < characters

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> [color_square(pref.r_eyes, pref.g_eyes, pref.b_eyes)]<br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> [color_square(pref.r_skin, pref.g_skin, pref.b_skin)]<br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	. += "<table>"
	for(var/M in pref.body_markings)
		. += "<tr><td>[M]</td><td>[pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>[color_square(hex = pref.body_markings[M])]</td></tr>"

	. += "</table>"
	. += "<br>"
	. += "<b>Allow Synth markings:</b> <a href='?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Yes" : "No"]</b></a><br>"
	. += "<b>Allow Synth color:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Change Color</a> [color_square(pref.r_synth, pref.g_synth, pref.b_synth)]"

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.species_appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = pref.character_static_species_meta()

	if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = input("Please select a descriptor.", "Descriptor") as null|anything in descriptor.chargen_value_descriptors
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TOPIC_REFRESH

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
		var/choice = input("Which species would you like to look at?") as null|anything in GLOB.playable_species
		if(!choice) return
		pref.species_preview = choice
		SetSpecies(preference_mob())
		pref.alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?
		return TOPIC_HANDLED

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in all_species_names()))
			return TOPIC_NOACTION

		var/datum/species/setting_species

		if(name_static_species_meta(href_list["set_species"]))
			setting_species = name_static_species_meta(href_list["set_species"])
		else
			return TOPIC_NOACTION

		if(((!(setting_species.spawn_flags & SPECIES_CAN_JOIN)) || (!is_alien_whitelisted(preference_mob(),setting_species))) && !check_rights(R_ADMIN, 0) && !(setting_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE))
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])
			pref.custom_species = null // This is cleared on species changes

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = pref.get_valid_hairstyles()

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				pref.h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.age = max(min(pref.age, max_age), min_age)

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = pref.get_valid_hairstyles()

		var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference", pref.h_style)  as null|anything in valid_hairstyles
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_left"])
		var/H = href_list["hair_style_left"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.h_style = valid_hairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.h_style = valid_hairstyles[valid_hairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_right"])
		var/H = href_list["hair_style_right"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != valid_hairstyles.len) //If we're not the end of the list, become the next element.
			pref.h_style = valid_hairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.h_style = valid_hairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		var/new_grad_style = input(user, "Choose a color pattern for your hair:", "Character Preference", pref.grad_style)  as null|anything in valid_gradients
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style_left"])
		var/G = href_list["grad_style_left"]
		var/list/valid_gradients = GLOB.hair_gradients
		var/start = valid_gradients.Find(G)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.grad_style = valid_gradients[start-1]
		else //But if we ARE, become the final element.
			pref.grad_style = valid_gradients[valid_gradients.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style_right"])
		var/G = href_list["grad_style_right"]
		var/list/valid_gradients = GLOB.hair_gradients
		var/start = valid_gradients.Find(G)

		if(start != valid_gradients.len) //If we're not the end of the list, become the next element.
			pref.grad_style = valid_gradients[start+1]
		else //But if we ARE, become the first element.
			pref.grad_style = valid_gradients[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["base_skin"])
		if(!has_flag(mob_species, HAS_BASE_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_s_base = input(user, "Choose your character's base colour:", "Character preference") as null|anything in mob_species.base_skin_colours
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

		var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference", pref.f_style)  as null|anything in valid_facialhairstyles
		if(new_f_style && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_left"])
		var/F = href_list["facial_style_left"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.f_style = valid_facialhairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.f_style = valid_facialhairstyles[valid_facialhairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_right"])
		var/F = href_list["facial_style_right"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != valid_facialhairstyles.len) //If we're not the end of the list, become the next element.
			pref.f_style = valid_facialhairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.f_style = valid_facialhairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings.Copy() ^ body_marking_styles_list.Copy()
		var/new_marking = input(user, "Choose a body marking:", "Character Preference")  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_markings.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			move_element(pref.body_markings, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			move_element(pref.body_markings, start, pref.body_markings.len+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_markings.Find(M)
		if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
			move_element(pref.body_markings, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			move_element(pref.body_markings, start, 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_move"])
		var/M = href_list["marking_move"]
		var/start = pref.body_markings.Find(M)
		var/list/move_locs = pref.body_markings - M
		if(start != 1)
			move_locs -= pref.body_markings[start-1]

		var/inject_after = input(user, "Move [M] ahead of...", "Character Preference") as null|anything in move_locs //Move ahead of any marking that isn't the current or previous one.
		var/newpos = pref.body_markings.Find(inject_after)
		if(newpos)
			move_element(pref.body_markings, start, newpos+1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = pref.character_static_species_meta()
		if(!current_species.has_organ["brain"])
			limb_selection_list -= "Full Body"
		else if(pref.organ_data[BP_TORSO] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = input(user, "Which limb do you want to change?") as null|anything in limb_selection_list

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")
		switch(organ_tag)
			if("Left Leg")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Right Foot")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Left Hand")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Right Hand")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_TORSO
				second_limb = BP_HEAD
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in choice_options
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		pref.regen_limbs = 1

		switch(new_state)
			if("Normal")
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal in O_ALL_STANDARD)
							pref.organ_data[internal] = null
							pref.rlimb_data[internal] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null

			if("Amputated")
				if(limb == BP_TORSO)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in GLOB.chargen_robolimbs)
					var/datum/robolimb/M = GLOB.chargen_robolimbs[company]
					if(!(limb in M.parts))
						continue
					if(tmp_species in M.species_cannot_use)
						continue
					// Cyberlimb whitelisting.
					if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this limb?") as null|anything in usable_manufacturers
				if(!choice)
					return

				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"

				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						if(pref.organ_data[other_limb])
							continue
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[O_BRAIN])
						pref.organ_data[O_BRAIN] = "assisted"
					for(var/internal_organ in list(O_HEART,O_EYES))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])

		var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes","Larynx", "Lungs", "Liver", "Kidneys", "Spleen", "Intestines", "Stomach", "Brain")
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Heart")
				organ = O_HEART
			if("Eyes")
				organ = O_EYES
			if("Larynx")
				organ = O_VOICE
			if("Lungs")
				organ = O_LUNGS
			if("Liver")
				organ = O_LIVER
			if("Kidneys")
				organ = O_KIDNEYS
			if("Spleen")
				organ = O_SPLEEN
			if("Intestines")
				organ = O_INTESTINE
			if("Stomach")
				organ = O_STOMACH
			if("Brain")
				if(pref.organ_data[BP_HEAD] != "cyborg")
					to_chat(user, "<span class='warning'>You may only select a cybernetic or synthetic brain if you have a full prosthetic body.</span>")
					return
				organ = "brain"

		var/list/organ_choices = list("Normal")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Normal"
			if(organ_name == "Brain")
				organ_choices += "Cybernetic"
				organ_choices += "Positronic"
				organ_choices += "Drone"
			else
				organ_choices += "Assisted"
				organ_choices += "Mechanical"
		else
			organ_choices += "Assisted"
			organ_choices += "Mechanical"

		var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in organ_choices
		if(!new_state) return

		pref.regen_limbs = 1

		switch(new_state)
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Cybernetic")
				pref.organ_data[organ] = "assisted"
			if ("Mechanical")
				pref.organ_data[organ] = "mechanical"
			if("Drone")
				pref.organ_data[organ] = "digital"
			if("Positronic")
				pref.organ_data[organ] = "mechanical"

		return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["mirror"])
		if(pref.mirror)
			pref.mirror = FALSE
			to_chat(usr, "Off-Site Cloning means you cannot rejoin a round as the same character if you are killed and cannot be recovered.")
		else
			pref.mirror = TRUE
			to_chat(usr, "A mirror is an implant that, if recovered, will allow you to be resleeved.")
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		var/new_color = input(user, "Choose your character's synth colour: ", "Character Preference", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		if(new_color && CanUseTopic(user))
			pref.r_synth = hex2num(copytext(new_color, 2, 4))
			pref.g_synth = hex2num(copytext(new_color, 4, 6))
			pref.b_synth = hex2num(copytext(new_color, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_markings"])
		pref.synth_markings = !pref.synth_markings
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_list_item(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/body/proc/reset_limbs()

	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null

	pref.regen_limbs = 1

	// Sanitize the name so that there aren't any numbers sticking around.
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	if(!pref.species_preview || !(pref.species_preview in all_species_names()))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = name_static_species_meta(pref.species_preview)
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	if(current_species.wikilink)
		dat += "<td width = 400>[current_species.blurb]<br><br>See <a href=[current_species.wikilink]>the wiki</a> for more details.</td>"
	else
		dat += "<td width = 400>[current_species.blurb]</td>"
	dat += "<td width = 200 align='center'>"
	if(current_species.preview_icon)
		usr << browse_rsc(icon(icon = current_species.preview_icon, icon_state = ""), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Often present on human stations.</b>"
			if(3 to 4)
				dat += "</br><b>Rarely present on human stations.</b>"
			if(5)
				dat += "</br><b>Unheard of on human stations.</b>"
			else
				dat += "</br><b>May be present on human stations.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Does not have a circulatory system.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Does not have a respiratory system.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.species_appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.species_appearance_flags & HAS_BASE_SKIN_COLOR)
		dat += "</br><b>Has a small number of base skin colors.</b>"
	if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.species_appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0

	if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
		restricted = 2
	else if(!is_alien_whitelisted(preference_mob(),current_species))
		restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN, 0) || current_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE)	//selectability
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")
