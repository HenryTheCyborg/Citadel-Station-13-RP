/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_TORSO
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_HUGE
	body_part = UPPER_TORSO
	vital = TRUE
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = TRUE
	cannot_amputate = TRUE
	parent_organ = null
	encased = "ribcage"
	organ_rel_size = 70
	base_miss_chance = 10

/obj/item/organ/external/chest/robotize()
	if(..() && robotic != ORGAN_NANOFORM)
		// Give them fancy new organs.
		owner.internal_organs_by_name[O_CELL] = new /obj/item/organ/internal/cell(owner,1)
		owner.internal_organs_by_name[O_VOICE] = new /obj/item/organ/internal/voicebox/robot(owner, 1)
		owner.internal_organs_by_name[O_PUMP] = new /obj/item/organ/internal/heart/machine(owner,1)
		owner.internal_organs_by_name[O_CYCLER] = new /obj/item/organ/internal/stomach/machine(owner,1)
		owner.internal_organs_by_name[O_HEATSINK] = new /obj/item/organ/internal/robotic/heatsink(owner,1)
		owner.internal_organs_by_name[O_DIAGNOSTIC] = new /obj/item/organ/internal/robotic/diagnostic(owner,1)

/obj/item/organ/external/chest/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for CHEST
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_LARGE
	body_part = LOWER_TORSO
	vital = TRUE
	parent_organ = BP_TORSO
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = TRUE
	cannot_amputate = TRUE
	organ_rel_size = 30

/obj/item/organ/external/groin/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for GROIN
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)

/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 80
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_TORSO
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = TRUE
	force = 7
	throw_force = 10

/obj/item/organ/external/arm/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for ARM
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			if(organ_tag == BP_L_ARM) //Specific level 2 'feature
				owner.drop_held_item_of_index(1)
			else if(organ_tag == BP_R_ARM)
				owner.drop_held_item_of_index(2)

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 80
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = TRUE
	force = 10
	throw_force = 12

/obj/item/organ/external/leg/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for LEG
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.Weaken(5)

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = TRUE
	force = 3
	throw_force = 6

/obj/item/organ/external/foot/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for FOOT
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.Weaken(5)

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = TRUE
	organ_rel_size = 10
	base_miss_chance = 50
	force = 3
	throw_force = 5

/obj/item/organ/external/hand/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for HAND
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			if(organ_tag == BP_L_HAND) //Specific level 2 'feature
				owner.drop_left_held_item()
			else if(organ_tag == BP_R_HAND)
				owner.drop_right_held_item()

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEMSIZE_NORMAL
	body_part = HEAD
	vital = TRUE
	parent_organ = BP_TORSO
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = TRUE
	cannot_gib = TRUE
	encased = "skull"
	base_miss_chance = 40
	force = 3
	throw_force = 7

	var/can_intake_reagents = TRUE
	var/eyes_over_markings = FALSE
	var/eye_icon = "eyes_s"
	var/eye_icon_location = 'icons/mob/human_face.dmi'

/obj/item/organ/external/head/Initialize(mapload)
	if(config_legacy.allow_headgibs)
		cannot_gib = FALSE
	return ..()

/obj/item/organ/external/head/robotize(company, skip_prosthetics, keep_organs)
	return ..(company, skip_prosthetics, 1)

/obj/item/organ/external/head/removed()
	if(owner)
		if(iscarbon(owner))
			name = "[owner.real_name]'s head"
			spawn(1)
				owner.update_hair()
	get_icon()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), permutation = 0)
	. = ..()
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for HEAD
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.eye_blurry += 20 //Specific level 2 'feature

/obj/item/organ/external/head/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/toy/plushie) || istype(I, /obj/item/organ/external/head))
		user.visible_message("<span class='notice'>[user] makes \the [I] kiss \the [src]!.</span>", \
		"<span class='notice'>You make \the [I] kiss \the [src]!.</span>")
	return ..()

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"
