/datum/species/auril
	name = SPECIES_AURIL
	name_plural = "Auril"
	default_language = LANGUAGE_ENOCHIAN
	language = LANGUAGE_GALCOM
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)

	blurb = "Auril lore is still a work in progress. They are not actual supernatural creatures. They are aliens. \
	They are not obsessed human genemodders. They're just a race of aliens that look like angels. It's a big galaxy."
	catalogue_data = list(/datum/category_item/catalogue/fauna/auril)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR

	blood_color = "#856A16"
	flesh_color = "#DED2AD"
	base_color = "#C5C0B8"

	min_age = 18

	//Angels glow in the dark.
	has_glowing_eyes = 1

	//Physical resistances and Weaknesses.
	//item_slowdown_mod = 0.5		//The Hardy debate is not settled yet.
	flash_mod = 0.5
	burn_mod = 1.25
	radiation_mod = 1.25
	toxins_mod = 0.85

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color)

/datum/species/dremachir
	name = SPECIES_DREMACHIR
	name_plural = "Dremachir"
	default_language = LANGUAGE_DAEMON
	language = LANGUAGE_GALCOM
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)

	blurb = "Dremachir lore is still a work in progress. They are not actual supernatural creatures. They are aliens. \
	They are not obsessed human genemodders. They're just a race of aliens that look like demonss. It's a big galaxy."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dremachir)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR

	blood_color = "#27173D"
	flesh_color = "#6A091B"
	base_color = "#2C030A"

	min_age = 18

	//Demons glow in the dark.
	has_glowing_eyes = 1
	darksight = 7

	//Physical resistances and Weaknesses.
	flash_mod = 3.0
	burn_mod = 0.85
	brute_mod = 0.85
	heat_discomfort_level = T0C+19
	siemens_coefficient = 1.5

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal)
