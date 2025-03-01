/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 15)//Reduces bleeding rate, and allowes the patient to breath even when in shock
		M.add_chemical_effect(CE_PAINKILLER, 10)
/*
/datum/reagent/inaprovaline/topical//Main way to obtain is destiller
	name = "Inaprovalaze"
	id = "inaprovalaze"
	description = "Inaprovalaze is a topical variant of Inaprovaline."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	touch_met = REM * 0.75
	can_overdose_touch = TRUE

/datum/reagent/inaprovaline/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		..()
		M.adjustToxLoss(2 * removed)

/datum/reagent/inaprovaline/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 20)
		M.add_chemical_effect(CE_PAINKILLER, 12)
*/
/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = REAGENT_LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(4 * removed * chem_effective, 0) //The first Parameter of the function is brute, the second burn damage

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/wound_heal = 1.5 * removed//Overdose enhances the healing effects
	M.eye_blurry = min(M.eye_blurry + wound_heal, 250)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)//for-loop that covers all injured external organs
			for(var/datum/wound/W in O.wounds)//for-loop that covers all wounds in the organ we are currently looking at.
				if(W.bleeding() || W.internal)//Checks if the wound is bleeding or internal
					W.damage = max(W.damage - wound_heal, 0)//reduces the damage, and sets it to 0 if its lower than 0
					if(W.damage <= 0)//If the wound is healed,
						O.wounds -= W//remove the wound
/*
/datum/reagent/bicaridine/topical//Main way to obtain is destiller
	name = "Bicaridaze"
	id = "bicaridaze"
	description = "Bicaridaze is a topical variant of the chemical Bicaridine."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = REAGENT_LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE * 0.75
	scannable = 1
	touch_met = REM * 0.75
	can_overdose_touch = TRUE

/datum/reagent/bicaridine/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		..(M, alien, removed * chem_effective)//heals the patient like Bicardine would
		M.adjustToxLoss(2 * removed)//deals toxic damage like the other topical gels

/datum/reagent/bicaridine/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 * removed * chem_effective, 0)
*/
/datum/reagent/vermicetol//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Vermicetol"
	id = "vermicetol"
	description = "A potent chemical that treats physical damage at an exceptional rate."
	taste_description = "heavy metals"
	taste_mult = 3
	reagent_state = REAGENT_SOLID
	color = "#964e06"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/vermicetol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(8 * removed * chem_effective, 0)

/datum/reagent/calciumcarbonate
	name = "calcium carbonate"
	id = "calciumcarbonate"
	description = "Calcium carbonate is a calcium salt commonly used as an antacid."
	taste_description = "chalk"
	reagent_state = REAGENT_SOLID
	color = "#eae6e3"
	overdose = REAGENTS_OVERDOSE * 0.8
	metabolism = REM * 0.4
	scannable = 1

/datum/reagent/calciumcarbonate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) // Why would you inject this.
	if(alien != IS_DIONA)
		M.adjustToxLoss(3 * removed)

/datum/reagent/calciumcarbonate/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_ANTACID, 3)//Antipuke effect

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.5
		M.adjustBruteLoss(2 * removed) //Mends burns, but has negative effects with a Promethean's skeletal structure.
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 4 * removed * chem_effective)
/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = REAGENT_LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 8 * removed * chem_effective)/*
/datum/reagent/dermaline/topical//Main way to obtain is destiller
	name = "Dermalaze"
	id = "dermalaze"
	description = "Dermalaze is a topical variant of the chemical Dermaline."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = REAGENT_LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.4
	scannable = 1
	touch_met = REM * 0.75
	can_overdose_touch = TRUE

/datum/reagent/dermaline/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		..(M, alien, removed * chem_effective)
		M.adjustToxLoss(2 * removed)

/datum/reagent/dermaline/topical/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 12 * removed * chem_effective)
*/
/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = REAGENT_LIQUID
	color = "#00A000"
	scannable = 1

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.66
		if(dose >= 15)
			M.druggy = max(M.druggy, 5)
	if(alien != IS_DIONA)
		M.drowsyness = max(0, M.drowsyness - 6 * removed * chem_effective)//reduces drowsyness to zero
		M.hallucination = max(0, M.hallucination - 9 * removed * chem_effective)//reduces hallucination to 0
		M.adjustToxLoss(-4 * removed * chem_effective)//Removes toxin damage
		if(prob(10))
			M.remove_a_modifier_of_type(/datum/modifier/poisoned)//Removes the poisoned effect, which is super rare of its own

/datum/reagent/carthatoline
	name = "Carthatoline"
	id = "carthatoline"
	description = "Carthatoline is strong evacuant used to treat severe poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#225722"
	scannable = 1

/datum/reagent/carthatoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.getToxLoss() && prob(10))//if the patient has toxin damage 10% chance to cause vomiting
		M.vomit(1)
	M.adjustToxLoss(-8 * removed)
	if(prob(30))
		M.remove_a_modifier_of_type(/datum/modifier/poisoned)//better chance to remove the poisoned effect
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
		if(istype(L))
			if(L.robotic >= ORGAN_ROBOT)
				return
			if(L.damage > 0)
				L.heal_damage_i(2 * removed, can_revive = TRUE)
		if(alien == IS_SLIME)
			H.druggy = max(M.druggy, 5)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM * 0.25
/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 24) //Vox breath phoron, oxygen is rather deadly to them
	if(alien == IS_ALRAUNE)
		M.adjustToxLoss(removed * 10) //cit change: oxygen is waste for plants
	else if(alien == IS_SLIME && dose >= 15)
		M.add_chemical_effect(CE_PAINKILLER, 15)
		if(prob(15))
			to_chat(M, "<span class='notice'>You have a moment of clarity as you collapse.</span>")
			M.adjustBrainLoss(-20 * removed) //Deals braindamage to promethians
			M.Weaken(6)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-60 * removed) //Heals alot of oxyloss damage/but
		//keep in mind that Dexaline has a metabolism rate of 0.25*REM meaning only 0.25 units are removed every tick(if your metabolism takes usuall 1u per tick)

	holder.remove_reagent("lexorin", 8 * removed)
/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)//Again, vox dont like O2
	if(alien == IS_ALRAUNE)
		M.adjustToxLoss(removed * 5) //cit change: oxygen is waste for plants
	else if(alien == IS_SLIME && dose >= 10)
		M.add_chemical_effect(CE_PAINKILLER, 25)
		if(prob(25))
			to_chat(M, "<span class='notice'>You have a moment of clarity, as you feel your tubes lose pressure rapidly.</span>")
			M.adjustBrainLoss(-8 * removed)//deals less braindamage than Dex
			M.Weaken(3)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-150 * removed)//Heals more oxyloss than Dex and has no metabolism reduction

	holder.remove_reagent("lexorin", 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#8040FF"
	scannable = 1

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)//Heals everyone besides diona on all 4 base damage types.
		var/chem_effective = 1
		if(alien == IS_SLIME)
			chem_effective = 0.5
		M.adjustOxyLoss(-3 * removed * chem_effective)
		M.heal_organ_damage(1.5 * removed, 1.5 * removed * chem_effective)
		M.adjustToxLoss(-1.5 * removed * chem_effective)

/datum/reagent/tricordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		affect_blood(M, alien, removed * 0.4)
/*
/datum/reagent/tricorlidaze//Main way to obtain is destiller
	name = "Tricorlidaze"
	id = "tricorlidaze"
	description = "Tricorlidaze is a topical gel produced with tricordrazine and sterilizine."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#B060FF"
	scannable = 1
	can_overdose_touch = TRUE

/datum/reagent/tricorlidaze/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			chem_effective = 0.5
		M.adjustOxyLoss(-0.5 * removed * chem_effective)//Oxyloss is hard to treat with some gel you smear over you skin
		M.heal_organ_damage(2 * removed, 2 * removed * chem_effective)//alittle more potent on brute and burns than Tricordrazine
		M.adjustToxLoss(-0.5 * removed * chem_effective)//Same as Oxyloss

/datum/reagent/tricorlidaze/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(3 * removed)

/datum/reagent/tricorlidaze/touch_obj(var/obj/O)
	if(istype(O, /obj/item/stack/medical/bruise_pack) && round(volume) >= 5)
		var/obj/item/stack/medical/bruise_pack/C = O
		var/packname = C.name
		var/to_produce = min(C.amount, round(volume / 5))

		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce)//Upgrades bruise packs into advanced trauma kits

		if(M && M.amount)
			holder.my_atom.visible_message("<span class='notice'>\The [packname] bubbles.</span>")
			remove_self(to_produce * 5)
*/
//Cryo chems
/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "overripe bananas"
	reagent_state = REAGENT_LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			chem_effective = 0.25
			to_chat(M, "<span class='danger'>It's cold. Something causes your cellular mass to harden occasionally, resulting in vibration.</span>")
			M.Weaken(10)
			M.silent = max(M.silent, 10)
			M.make_jittery(4)
		M.adjustCloneLoss(-10 * removed * chem_effective)//Clone damage, either occured during cloning or from xenobiology slimes.
		M.adjustOxyLoss(-10 * removed * chem_effective)//Also heals the standard damages
		M.heal_organ_damage(10 * removed, 10 * removed * chem_effective)
		M.adjustToxLoss(-10 * removed * chem_effective)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "rotten bananas"
	reagent_state = REAGENT_LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			M.Weaken(20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		M.adjustCloneLoss(-30 * removed * chem_effective)//Better version of cryox, but they can work at the same time
		M.adjustOxyLoss(-30 * removed * chem_effective)
		M.heal_organ_damage(30 * removed, 30 * removed * chem_effective)
		M.adjustToxLoss(-30 * removed * chem_effective)

/datum/reagent/necroxadone
	name = "Necroxadone"
	id = "necroxadone"
	description = "A liquid compound based upon that which is used in the cloning process. Utilized primarily in severe cases of toxic shock."
	taste_description = "meat"
	reagent_state = REAGENT_LIQUID
	color = "#94B21C"
	metabolism = REM * 0.5
	mrate_static = TRUE
	scannable = 1

/datum/reagent/necroxadone/on_mob_life(var/mob/living/carbon/M, var/alien, var/datum/reagents/metabolism/location)
	if(M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse))
		affects_dead = TRUE
	else
		affects_dead = FALSE

	. = ..(M, alien, location)

/datum/reagent/necroxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170 || (M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse)))
		var/chem_effective = 1
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			M.Weaken(20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		if(M.stat != DEAD)
			M.adjustCloneLoss(-5 * removed * chem_effective)
		M.adjustOxyLoss(-20 * removed * chem_effective)//dehusking for cool people
		M.adjustToxLoss(-40 * removed * chem_effective)

/* Painkillers */
/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	M.add_chemical_effect(CE_PAINKILLER, 25 * chem_effective)//kinda weak painkilling, for non life threatening injuries

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(alien == IS_SLIME)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#CB68FC"
	overdose = 30
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.8
		M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.add_chemical_effect(CE_PAINKILLER, 80 * chem_effective)//more potent painkilling, for close to fatal injuries

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#800080"
	overdose = 20
	scannable = 1
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
		M.stuttering = min(50, max(0, M.stuttering + 5)) //If you can't feel yourself, and your main mode of speech is resonation, there's a problem.
	M.add_chemical_effect(CE_PAINKILLER, 200 * chem_effective)//Bad boy painkiller, for you and the fact that she left you
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.eye_blurry = min(M.eye_blurry + 10, 250 * chem_effective)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 3)

/datum/reagent/numbing_enzyme//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Numbing Enzyme"//Obtained from vore bellies, and numbing bite trait custom species
	id = "numbenzyme"
	description = "Some sort of organic painkiller."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#800080"
	metabolism = 0.1 //Lasts up to 200 seconds if you give 20u which is OD.
	mrate_static = TRUE
	overdose = 20 //High OD. This is to make numbing bites have somewhat of a downside if you get bit too much. Have to go to medical for dialysis.
	scannable = 0 //Let's not have medical mechs able to make an extremely strong organic painkiller

/datum/reagent/numbing_enzyme/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)//Similar to Oxycodone
	if(prob(0.01)) //1 in 10000 chance per tick. Extremely rare.
		to_chat(M,"<span class='warning'>Your body feels numb as a light, tingly sensation spreads throughout it, like some odd warmth.</span>")
	//Not noted here, but a movement debuff of 1.5 is handed out in human_movement.dm when numbing_enzyme is in a person's bloodstream!

/datum/reagent/numbing_enzyme/overdose(var/mob/living/carbon/M, var/alien)
	//..() //Add this if you want it to do toxin damage. Personally, let's allow them to have the horrid effects below without toxin damage.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(1))
			to_chat(H,"<span class='warning'>Your entire body feels numb and the sensation of pins and needles continually assaults you. You blink and the next thing you know, your legs give out momentarily!</span>")
			H.AdjustWeakened(5) //Fall onto the floor for a few moments.
			H.Confuse(15) //Be unable to walk correctly for a bit longer.
		if(prob(1))
			if(H.losebreath <= 1 && H.oxyloss <= 20) //Let's not suffocate them to the point that they pass out.
				to_chat(H,"<span class='warning'>You feel a sharp stabbing pain in your chest and quickly realize that your lungs have stopped functioning!</span>") //Let's scare them a bit.
				H.losebreath = 10
				H.adjustOxyLoss(5)
		if(prob(2))
			to_chat(H,"<span class='warning'>You feel a dull pain behind your eyes and at thee back of your head...</span>")
			H.hallucination += 20 //It messes with your mind for some reason.
			H.eye_blurry += 20 //Groggy vision for a small bit.
		if(prob(3))
			to_chat(H,"<span class='warning'>You shiver, your body continually being assaulted by the sensation of pins and needles.</span>")
			H.emote("shiver")
			H.make_jittery(10)
		if(prob(3))
			to_chat(H,"<span class='warning'>Your tongue feels numb and unresponsive.</span>")
			H.stuttering += 20

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"//Used to treat hallucination and remove mindbreaker
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME)
		if(dose >= 5) //Not effective in small doses, though it causes toxloss at higher ones, it will make the regeneration for brute and burn more 'efficient' at the cost of more nutrition.
			M.nutrition -= removed * 2
			M.adjustBruteLoss(-2 * removed)
			M.adjustFireLoss(-1 * removed)
		chem_effective = 0.5
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)//Primary use
	M.adjustToxLoss(5 * removed * chem_effective) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20 * chem_effective)

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "bitterness"
	metabolism = REM * 0.25 // see "long lasting"
	reagent_state = REAGENT_LIQUID
	color = "#FF3300"
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	if(alien == IS_SLIME)
		M.make_jittery(4) //Hyperactive fluid pumping results in unstable 'skeleton', resulting in vibration.
		if(dose >= 5)
			M.nutrition = (M.nutrition - (removed * 2)) //Sadly this movement starts burning food in higher doses.
	..()
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.25
		if(M.brainloss >= 10)
			M.Weaken(5)
		if(dose >= 10 && M.paralysis < 40)
			M.AdjustParalysis(1) //Messing with the core with a simple chemical probably isn't the best idea.
	M.adjustBrainLoss(-8 * removed * chem_effective) //the Brain damage heal
	M.add_chemical_effect(CE_PAINKILLER, 10 * chem_effective)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.AdjustBlinded(-5)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(istype(E))
			if(E.robotic >= ORGAN_ROBOT)
				return
			if(E.damage > 0)
				E.heal_damage_i(5 * removed, can_revive = TRUE)
			if(E.damage <= 5 && E.organ_tag == O_EYES)
				H.sdisabilities &= ~SDISABILITY_NERVOUS

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = 1

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT)
				continue
			if(I.damage > 0) //Peridaxon heals only non-robotic organs
				I.heal_damage_i(removed, can_revive = TRUE)
				H.Confuse(5)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(M.eye_blurry + 10, 100) //Eyes need to reset, or something
				H.sdisabilities &= ~SDISABILITY_NERVOUS
		if(alien == IS_SLIME)
			H.add_chemical_effect(CE_PAINKILLER, 20)
			if(prob(33))
				H.Confuse(10)

/datum/reagent/nanoperidaxon
	name = "Nano-Peridaxon"
	id = "nanoperidaxon"
	description = "Nanite cultures have been mixed into this peridaxon, increasing its efficacy range. Medicate cautiously."
	taste_description = "bitterness and iron"
	reagent_state = REAGENT_LIQUID
	color = "#664B9B"
	overdose = 10
	scannable = 1

/datum/reagent/nanoperidaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0)
				I.heal_damage_i(removed, can_revive = TRUE)
				H.Confuse(5)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(M.eye_blurry + 10, 100) //Eyes need to reset, or something
				H.sdisabilities &= ~SDISABILITY_NERVOUS
		if(alien == IS_SLIME)
			H.add_chemical_effect(CE_PAINKILLER, 20)
			if(prob(33))
				H.Confuse(10)

/datum/reagent/osteodaxon
	name = "Osteodaxon"
	id = "osteodaxon"
	description = "An experimental drug used to heal bone fractures."
	reagent_state = REAGENT_LIQUID
	color = "#C9BCE3"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/osteodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(3 * removed, 0)	//Gives the bones a chance to set properly even without other meds
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()		//Only works if the bone won't rebreak, as usual
				H.custom_pain("You feel a terrible agony tear through your bones!",60)
				H.AdjustWeakened(1)		//Bones being regrown will knock you over

/datum/reagent/myelamine
	name = "Myelamine"
	id = "myelamine"
	description = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	reagent_state = REAGENT_LIQUID
	color = "#4246C7"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	var/repair_strength = 3

/datum/reagent/myelamine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.eye_blurry += min(M.eye_blurry + (repair_strength * removed), 250)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/wound_heal = removed * repair_strength
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/respirodaxon
	name = "Respirodaxon"
	id = "respirodaxon"
	description = "Used to repair the tissue of the lungs and similar organs."
	taste_description = "metallic"
	reagent_state = REAGENT_LIQUID
	color = "#4444FF"
	metabolism = REM * 1.5
	overdose = 10
	scannable = 1

/datum/reagent/respirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LUNGS, O_VOICE, O_GBLADDER)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(M.reagents.has_reagent("gastirodaxon") || M.reagents.has_reagent("peridaxon"))
			if(H.losebreath >= 15 && prob(H.losebreath))
				H.Stun(2)
			else
				H.losebreath = clamp(H.losebreath + 3, 0, 20)
		else
			H.losebreath = max(H.losebreath - 4, 0)

/datum/reagent/gastirodaxon
	name = "Gastirodaxon"
	id = "gastirodaxon"
	description = "Used to repair the tissues of the digestive system."
	taste_description = "chalk"
	reagent_state = REAGENT_LIQUID
	color = "#8B4513"
	metabolism = REM * 1.5
	overdose = 10
	scannable = 1

/datum/reagent/gastirodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_APPENDIX, O_STOMACH, O_INTESTINE, O_NUTRIENT, O_PLASMA, O_POLYP)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(M.reagents.has_reagent("hepanephrodaxon") || M.reagents.has_reagent("peridaxon"))
			if(prob(10))
				H.vomit(1)
			else if(H.nutrition > 30)
				H.nutrition = max(0, H.nutrition - round(30 * removed))
		else
			H.adjustToxLoss(-10 * removed) // Carthatoline based, considering cost.

/datum/reagent/hepanephrodaxon
	name = "Hepanephrodaxon"
	id = "hepanephrodaxon"
	description = "Used to repair the common tissues involved in filtration."
	taste_description = "glue"
	reagent_state = REAGENT_LIQUID
	color = "#D2691E"
	metabolism = REM * 1.5
	overdose = 10
	scannable = 1

/datum/reagent/hepanephrodaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1
	if(alien == IS_SLIME)
		repair_strength = 0.4
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LIVER, O_KIDNEYS, O_APPENDIX, O_ACID, O_HIVE)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(M.reagents.has_reagent("cordradaxon") || M.reagents.has_reagent("peridaxon"))
			if(prob(5))
				H.vomit(1)
			else if(prob(5))
				to_chat(H,"<span class='danger'>Something churns inside you.</span>")
				H.adjustToxLoss(10 * removed)
				H.vomit(0, 1)
		else
			H.adjustToxLoss(-12 * removed) // Carthatoline based, considering cost.

/datum/reagent/cordradaxon
	name = "Cordradaxon"
	id = "cordradaxon"
	description = "Used to repair the specialized tissues involved in the circulatory system."
	taste_description = "rust"
	reagent_state = REAGENT_LIQUID
	color = "#FF4444"
	metabolism = REM * 1.5
	overdose = 10
	scannable = 1

/datum/reagent/cordradaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/repair_strength = 1
	if(alien == IS_SLIME)
		repair_strength = 0.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_HEART, O_SPLEEN, O_RESPONSE, O_ANCHOR, O_EGG)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(M.reagents.has_reagent("respirodaxon") || M.reagents.has_reagent("peridaxon"))
			H.losebreath = clamp(H.losebreath + 1, 0, 10)
		else
			H.adjustOxyLoss(-30 * removed) // Deals with blood oxygenation.

/datum/reagent/immunosuprizine
	name = "Immunosuprizine"
	id = "immunosuprizine"
	description = "An experimental powder believed to have the ability to prevent any organ rejection."
	taste_description = "flesh"
	reagent_state = REAGENT_SOLID
	color = "#7B4D4F"
	overdose = 20
	scannable = 1

/datum/reagent/immunosuprizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 1

	if(alien == IS_DIONA)	// It's a tree.
		strength_mod = 0.25

	if(alien == IS_SLIME)	// Diffculty bonding with internal cellular structure.
		strength_mod = 0.75

	if(alien == IS_SKRELL)	// Natural inclination toward toxins.
		strength_mod = 1.5

	if(alien == IS_UNATHI)	// Natural regeneration, robust biology.
		strength_mod = 1.75

	if(alien == IS_TAJARA)	// Highest metabolism.
		strength_mod = 2

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_DIONA)
			H.adjustToxLoss((30 / strength_mod) * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))	// Reset the rejection process, toggle it to not reject.
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents.has_reagent("spaceacillin") || H.reagents.has_reagent("corophizine"))	// Chemicals that increase your immune system's aggressiveness make this chemical's job harder.
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((15 / strength_mod))
						I.take_damage(1)

/datum/reagent/skrellimmuno
	name = "Malish-Qualem"
	id = "malish-qualem"
	description = "A strange, oily powder used by Malish-Katish to prevent organ rejection."
	taste_description = "mordant"
	reagent_state = REAGENT_SOLID
	color = "#84B2B0"
	metabolism = REM * 0.75
	overdose = 20
	scannable = 1

/datum/reagent/skrellimmuno/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 0.5

	if(alien == IS_SKRELL)
		strength_mod = 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_SKRELL)
			H.adjustToxLoss(20 * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents.has_reagent("spaceacillin") || H.reagents.has_reagent("corophizine"))
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((10 / strength_mod))
						I.take_damage(1)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = REAGENT_SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	var/mob/living/carbon/human/H = M
	if(alien == IS_SLIME && istype(H)) //Shifts them toward white, faster than Rezadone does toward grey.
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 510)/3)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 510)/3)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 510)/3)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 510)/3)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 510)/3)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 510)/3)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 510)/3)
			H.adjustToxLoss(6 * removed)

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		H.update_mutations()

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#605048"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.SetConfused(0)
	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 30)
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 20)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.radiation = max(M.radiation - 70 * removed, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.25
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	data = 0

/datum/reagent/spaceacillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, "<span class='notice'>You regain focus...</span>")
		else
			var/delay = (5 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, "<span class='warning'>Your senses feel unfocused, and divided.</span>")
	M.add_chemical_effect(CE_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)

/datum/reagent/spaceacillin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.8) // Not 100% as effective as injections, though still useful.

/datum/reagent/corophizine
	name = "Corophizine"
	id = "corophizine"
	description = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	taste_description = "burnt toast"
	reagent_state = REAGENT_LIQUID
	color = "#FFB0B0"
	mrate_static = TRUE
	overdose = 10
	scannable = 1
	data = 0

/datum/reagent/corophizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ANTIBIOTIC, ANTIBIO_SUPER)

	var/mob/living/carbon/human/H = M

	if(ishuman(M) && alien == IS_SLIME) //Everything about them is treated like a targetted organism. Widespread bodily function begins to fail.
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, "<span class='notice'>Your body ceases its revolt.</span>")
		else
			var/delay = (3 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, "<span class='critical'>It feels like your body is revolting!</span>")
		M.Confuse(7)
		M.adjustFireLoss(removed * 2)
		M.adjustToxLoss(removed * 2)
		if(dose >= 5 && M.toxloss >= 10) //It all starts going wrong.
			M.adjustBruteLoss(removed * 3)
			M.eye_blurry = min(20, max(0, M.eye_blurry + 10))
			if(prob(25))
				if(prob(25))
					to_chat(M, "<span class='danger'>Your pneumatic fluids seize for a moment.</span>")
				M.Stun(2)
				spawn(30)
					M.Weaken(2)
		if(dose >= 10 || M.toxloss >= 25) //Internal skeletal tubes are rupturing, allowing the chemical to breach them.
			M.adjustToxLoss(removed * 4)
			M.make_jittery(5)
		if(dose >= 20 || M.toxloss >= 60) //Core disentigration, cellular mass begins treating itself as an enemy, while maintaining regeneration. Slime-cancer.
			M.adjustBrainLoss(2 * removed)
			M.nutrition = max(H.nutrition - 20, 0)
		if(M.bruteloss >= 60 && M.toxloss >= 60 && M.brainloss >= 30) //Total Structural Failure. Limbs start splattering.
			var/obj/item/organ/external/O = pick(H.organs)
			if(prob(20) && !istype(O, /obj/item/organ/external/chest/unbreakable/slime) && !istype(O, /obj/item/organ/external/groin/unbreakable/slime))
				to_chat(M, "<span class='critical'>You feel your [O] begin to dissolve, before it sloughs from your body.</span>")
				O.droplimb() //Splat.
		return

	//Based roughly on Levofloxacin's rather severe side-effects
	if(prob(20))
		M.Confuse(5)
	if(prob(20))
		M.Weaken(5)
	if(prob(20))
		M.make_dizzy(5)
	if(prob(20))
		M.hallucination = max(M.hallucination, 10)

	//One of the levofloxacin side effects is 'spontaneous tendon rupture', which I'll immitate here. 1:1000 chance, so, pretty darn rare.
	if(ishuman(M) && rand(1,10000) == 1)
		var/obj/item/organ/external/eo = pick(H.organs) //Misleading variable name, 'organs' is only external organs
		eo.fracture()

/datum/reagent/spacomycaze
	name = "Spacomycaze"
	id = "spacomycaze"
	description = "An all-purpose painkilling antibiotic gel."
	taste_description = "oil"
	reagent_state = REAGENT_SOLID
	color = "#C1C1C8"
	metabolism = REM * 0.4
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	data = 0
	can_overdose_touch = TRUE

/datum/reagent/spacomycaze/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.adjustToxLoss(3 * removed)

/datum/reagent/spacomycaze/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.8)

/datum/reagent/spacomycaze/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, "<span class='notice'>The itching fades...</span>")
		else
			var/delay = (2 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, "<span class='warning'>Your skin itches.</span>")

	M.add_chemical_effect(CE_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)
	M.add_chemical_effect(CE_PAINKILLER, 20) // 5 less than paracetamol.

/datum/reagent/spacomycaze/touch_obj(var/obj/O)
	if(istype(O, /obj/item/stack/medical/crude_pack) && round(volume) >= 1)
		var/obj/item/stack/medical/crude_pack/C = O
		var/packname = C.name
		var/to_produce = min(C.amount, round(volume))

		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce)

		if(M && M.amount)
			holder.my_atom.visible_message("<span class='notice'>\The [packname] bubbles.</span>")
			remove_self(to_produce)

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	touch_met = 5

/datum/reagent/sterilizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)
		M.adjustToxLoss(2 * removed)
	return

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)
		M.adjustToxLoss(2 * removed)

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/debris/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/sterilizine/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			S.adjustToxLoss(rand(15, 25) * amount)	// Does more damage than water.
			S.visible_message("<span class='warning'>[S]'s flesh sizzles where the fluid touches it!</span>", "<span class='danger'>Your flesh burns in the fluid!</span>")
		remove_self(amount)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/mob/living/carbon/human/H = M
	if(alien == IS_SLIME && istype(H))
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 50)/2)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 50)/2)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 50)/2)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 50)/2)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 50)/2)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 50)/2)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 50)/2)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 50)/2)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 50)/2)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#BF80BF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FF80FF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FF80BF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination += 200

/datum/reagent/adranol//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = REAGENT_SOLID
	color = "#d5e2e5"

/datum/reagent/adranol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.confused)
		M.Confuse(-8*removed)
	if(M.eye_blurry)
		M.eye_blurry = max(M.eye_blurry - 8*removed, 0)
	if(M.jitteriness)
		M.make_jittery(-8 * removed)

/datum/reagent/qerr_quem
	name = "Qerr-quem"
	id = "querr_quem"
	description = "A potent stimulant and anti-anxiety medication, made for the Qerr-Katish."
	taste_description = "mint"
	reagent_state = REAGENT_LIQUID
	color = "#e6efe3"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/qerr_quem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

// This exists to cut the number of chemicals a merc borg has to juggle on their hypo.
/datum/reagent/healing_nanites
	name = "Restorative Nanites"
	id = "healing_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#555555"
	metabolism = REM * 4 // Nanomachines gotta go fast.
	scannable = TRUE
	affects_robots = TRUE

/datum/reagent/healing_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustOxyLoss(-4 * removed)
	M.adjustToxLoss(-2 * removed)
	M.adjustCloneLoss(-2 * removed)

////////////////////////// Anti-Noms Drugs //////////////////////////
/datum/reagent/ickypak
	name = "Ickypak"
	id = "ickypak"
	description = "A foul-smelling green liquid, for inducing muscle contractions to expel accidentally ingested things."
	reagent_state = REAGENT_LIQUID
	color = "#0E900E"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ickypak/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_dizzy(1)
	M.adjustHalLoss(2)

	for(var/belly in M.vore_organs)
		var/obj/belly/B = belly
		for(var/atom/movable/A in B)
			if(isliving(A))
				var/mob/living/P = A
				if(P.absorbed)
					continue
			if(prob(5))
				playsound(M, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)

/datum/reagent/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	description = "A frothy pink liquid, for causing cellular-level hetrogenous structure separation."
	reagent_state = REAGENT_LIQUID
	color = "#EF77E5"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/unsorbitol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_dizzy(1)
	M.adjustHalLoss(1)
	if(!M.confused) M.confused = 1
	M.confused = max(M.confused, 20)
	M.hallucination += 15

	for(var/belly in M.vore_organs)
		var/obj/belly/B = belly

		if(B.digest_mode == DM_ABSORB) //Turn off absorbing on bellies
			B.digest_mode = DM_HOLD

		for(var/mob/living/P in B)
			if(!P.absorbed)
				continue

			else if(prob(1))
				playsound(M, 'sound/vore/schlorp.ogg', 50, 1)
				P.absorbed = 0
				M.visible_message("<font color='green'><b>Something spills into [M]'s [lowertext(B.name)]!</b></font>")

//Nif repair juice
/datum/reagent/nif_repair_nanites
	name = "Programmed Nanomachines"
	id = "nifrepairnanites"
	description = "A thick grey slurry of NIF repair nanomachines."
	taste_description = "metallic"
	reagent_state = REAGENT_LIQUID
	color = "#333333"
	scannable = 1

/datum/reagent/nif_repair_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif)
			var/obj/item/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.durability = min(nif.durability + removed, initial(nif.durability))

/datum/reagent/firefighting_foam
	name = "Firefighting Foam"
	id = "firefoam"
	description = "A historical fire suppressant. Originally believed to simply displace oxygen to starve fires, it actually interferes with the combustion reaction itself. Vastly superior to the cheap water-based extinguishers found on most NT vessels."
	reagent_state = REAGENT_LIQUID
	color = "#A6FAFF"
	taste_description = "the inside of a fire extinguisher"

/datum/reagent/firefighting_foam/touch_turf(var/turf/T, reac_volume)
	if(reac_volume >= 1)
		var/obj/effect/foam/firefighting/F = (locate(/obj/effect/foam/firefighting) in T)
		if(!F)
			F = new(T)
		else if(istype(F))
			F.lifetime = initial(F.lifetime) //reduce object churn a little bit when using smoke by keeping existing foam alive a bit longer

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in T)
	if(hotspot && !isspaceturf(T))
		var/datum/gas_mixture/lowertemp = T.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * 19000, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if(prob(5))
			T.visible_message("<span class='warning'>The foam sizzles as it lands on \the [T]!</span>")

/datum/reagent/firefighting_foam/touch_obj(var/obj/O, reac_volume)
	O.water_act(reac_volume / 5)

/datum/reagent/firefighting_foam/touch_mob(var/mob/living/M, reac_volume)
	if(istype(M, /mob/living/simple_mob/slime)) //I'm sure foam is water-based!
		var/mob/living/simple_mob/slime/S = M
		S.adjustToxLoss(15 * reac_volume)
		S.visible_message("<span class='warning'>[S]'s flesh sizzles where the foam touches it!</span>", "<span class='danger'>Your flesh burns in the foam!</span>")

	M.adjust_fire_stacks(-reac_volume)
	M.ExtinguishMob()

//CRS (Cyberpsychosis) Medication
/datum/reagent/neuratrextate
	name = "Neuratrextate"
	id = "neuratrextate"
	description = "This military grade chemical compound functions as both a powerful immunosuppressant and a potent antipsychotic. Its trademark lime green coloration makes it easy to identify."
	taste_description = "sour metal"
	taste_mult = 2
	reagent_state = REAGENT_LIQUID
	metabolism = REM * 0.016
	mrate_static = TRUE
	color = "#52ca22"
	scannable = 1
	overdose = 16

/datum/reagent/neuratrextate/affect_ingest(mob/living/carbon/M)
	remove_self(30)
	to_chat(M, "<span class='warning'>It feels like there's a pile of knives in your stomach!</span>")
	M.druggy += 10
	M.vomit()

/datum/reagent/neuratrextate/overdose(var/mob/living/carbon/M)
	..()
	M.druggy += 30
	M.hallucination += 20
