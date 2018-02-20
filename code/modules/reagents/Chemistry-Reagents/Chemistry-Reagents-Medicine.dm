/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	taste_description = "bitterness"
	var/datum/modifier/modifier

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, 25)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/adrenaline, MODIFIER_REAGENT, src, _strength = 0.6, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/inaprovaline/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM * 1.5//Get to overdose state a bit faster
	taste_description = "bitterness"
	taste_mult = 3

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(5 * removed, 0)

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien)
	..()//Bicard overdose heals internal wounds
	if(ishuman(M))
		var/healpower = 1
		var/mob/living/carbon/human/H = M
		for (var/a in H.organs)
			var/obj/item/organ/external/E = a
			for (var/w in E.wounds)
				var/datum/wound/W = w
				if (W && W.internal)
					healpower = W.heal_damage(healpower,1)
					if (healpower <= 0)
						return

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 6 * removed)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	taste_description = "bitterness"
	taste_mult = 1.5

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 12 * removed)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#00A000"
	scannable = 1

	taste_description = "a roll of gauze"

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(0, M.drowsyness - 6 * removed)
	M.hallucination = max(0, M.hallucination - 9 * removed)
	M.adjustToxLoss(-4 * removed)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else
		M.adjustOxyLoss(-15 * removed)

	holder.remove_reagent("lexorin", 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else
		M.adjustOxyLoss(-300 * removed)

	holder.remove_reagent("lexorin", 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1

	taste_description = "bitterness"

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustOxyLoss(-6 * removed)
	M.heal_organ_damage(3 * removed, 3 * removed)
	M.adjustToxLoss(-3 * removed)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = 1
	taste_description = "sludge"

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-10 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)
		M.adjustToxLoss(-10 * removed)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = 1
	taste_description = "slime"

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-30 * removed)
		M.adjustOxyLoss(-30 * removed)
		M.heal_organ_damage(30 * removed, 30 * removed)
		M.adjustToxLoss(-30 * removed)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	metabolism = 0.02
	taste_description = "sickness"

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 50)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 25)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 30
	scannable = 1
	metabolism = 0.02
	taste_description = "sourness"

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 80)

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 40)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 20
	metabolism = 0.02
	taste_description = "bitterness"

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 60)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	var/datum/modifier/modifier
	taste_description = "bitterness"

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 40)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/adrenaline, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/synaptizine/Destroy()
	QDEL_NULL(modifier)
	return ..()


/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustBrainLoss(-30 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_mult = 0.33 //Specifically to cut the dull toxin taste out of foods using carrot
	taste_description = "dull toxin"

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		for(var/obj/item/organ/I in H.internal_organs)
			if((I.damage > 0) && (I.robotic != 2)) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	var/datum/modifier = null
	taste_description = "acid"

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/hyperzine/Destroy()
	QDEL_NULL(modifier)
	return ..()

#define ETHYL_INTOX_COST	3 //The cost of power to remove one unit of intoxication from the patient
#define ETHYL_REAGENT_POWER	20 //The amount of power in one unit of ethyl

//Ethylredoxrazine will remove a number of units of alcoholic substances from the patient's blood and stomach, equal to its pow
//Once all alcohol in the body is neutralised, it will then cure intoxication and sober the patient up
/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	metabolism = REM * 0.3
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/P = removed * ETHYL_REAGENT_POWER
	var/DP = dose * ETHYL_REAGENT_POWER//tiny optimisation

	//These status effects will now take a little while for the dose to build up and remove them
	M.dizziness = max(0, M.dizziness - DP)
	M.drowsyness = max(0, M.drowsyness - DP)
	M.stuttering = max(0, M.stuttering - DP)
	M.confused = max(0, M.confused - DP)

	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				var/amount = min(P, R.volume)
				M.ingested.remove_reagent(R.id, amount)
				P -= amount
				if (P <= 0)
					return

	//Even though alcohol is not supposed to be injected, ethyl removes it from the blood too,
	//as a treatment option if someone was dumb enough to do this
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				var/amount = min(P, R.volume)
				M.bloodstr.remove_reagent(R.id, amount)
				P -= amount
				if (P <= 0)
					return

	if (M.intoxication && P > 0)
		var/amount = min(M.intoxication * ETHYL_INTOX_COST, P)
		M.intoxication = max(0, (M.intoxication - (amount / ETHYL_INTOX_COST)))
		P -= amount

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_radiation(-30 * removed)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_radiation(-70 * removed)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5
	taste_description = "bitterness"

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/obj/item/organ/external/E in H.organs)//For each external bodypart
			for (var/datum/wound/W in E.wounds)//We check each wound on that bodypart
				W.germ_level -= min(removed*20, W.germ_level)//Clean the wound a bit. Note we only clean wounds on the part, not the part itself.
				if (W.germ_level <= 0)
					W.disinfected = 1//The wound becomes disinfected if fully cleaned

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 1*60*10

/datum/reagent/antidepressants
	name = "Experimental Antidepressant"
	id = "antidepressants"
	description = "Some nameless, experimental antidepressant that you should obviously not have your hands on."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = 0.001
	data = 0
	taste_description = "bugs"
	var/goodmessage = list("Your mind feels healthy.","You feel calm and relaxed.","The world seems like a better place now.") //Messages when all your brain trauma is cured.
	var/badmessage = list("Your mind seems lost...","You feel agitated...","It feels like the world is out to get you...") //Messages when you still have brain trauma
	var/worstmessage = list("Your mind starts to break down...","Things aren't what they seem...","You hate yourself...") //Messages when the user is at the risk for more trauma
	var/list/cure_effects = list(
		/datum/brain_trauma/mild/hallucinations = 10 //Dosage required to supress this type of trauma. Can target a specific brain trauma too.
	)
	var/list/dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 10 //Chance every 5 minutes to add a trauma. Chance reduces based on the amount of reagant consumed.
	)
	var/list/withdraw_effects = list(
		/datum/brain_trauma/mild/hallucinations = 10 // Chance every 5 minutes to add a trauma, if you withdrawl from the medication. Increases with dosage.
	)
	var/list/overdose_effects = list(
		/datum/brain_trauma/mild/hallucinations
	)
	var/maxdose = 0 // Internal value
	var/totaldose = 0 //Internal value

/datum/reagent/antidepressants/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	totaldose += removed
	maxdose = max(maxdose,volume)

	if(!ishuman(M) || world.time < data)
		return
	var/hastrauma = 0 //whether or not the brain has trauma
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/brain/B = H.internal_organs_by_name["brain"]

	if(B) //You won't feel anything if you don't have a brain.
		for(var/x in B.traumas)
			var/datum/brain_trauma/BT = x
			var/goalvolume = cure_effects[BT]
			if (goalvolume <= volume) // If the dosage is greater than the goal, then suppress the trauma.
				if(!BT.suppressed)
					BT.on_lose()
					BT.suppressed = 1
			else if(goalvolume-1 > volume) // -1 So it doesn't spam back and forth constantly if reagents are being metabolized
				if(BT.suppressed)
					BT.on_gain()
					BT.suppressed = 0
					hastrauma = 1

		for(var/k in dosage_effects)
			var/datum/brain_trauma/BT = k
			var/percentchance = max(0,dosage_effects[k] - totaldose*10) // If you've been taking this medication for a while then side effects are rarer.
			if(!H.has_trauma_type(BT) && prob(percentchance))
				B.gain_trauma(BT,FALSE)

		M << volume
		M << maxdose

		if(volume < maxdose*0.5)
			H << pick(worstmessage)
			for(var/k in withdraw_effects)
				var/datum/brain_trauma/BT = k
				var/percentchance = max(withdraw_effects[k] * (maxdose/20)) //The highest the dosage, the more likely it is do get withdrawl traumas.
				if(!H.has_trauma_type(BT) && prob(percentchance))
					B.gain_trauma(BT,FALSE)
		else if(hastrauma || volume < maxdose*0.25)
			H << pick(badmessage)
		else
			H << pick(goodmessage)

	maxdose = (maxdose + volume)/2 //Ease in or out the new maxdose
	data = world.time + ANTIDEPRESSANT_MESSAGE_DELAY

/datum/reagent/antidepressants/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Nicotine is a stimulant and relaxant commonly found in tobacco products. It is very poisonous, unless at very low doses."
	reagent_state = LIQUID
	color = "#333333"
	metabolism = 0.01
	overdose = 3
	data = 0
	taste_description = "bitterness"
	goodmessage = list("You feel good.","You feel relaxed.","You feel alert and focused.")
	badmessage = list("You start to crave nicotine...")
	worstmessage = list("You need your nicotine fix!")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia = 0.1,
		/datum/brain_trauma/mild/muscle_weakness/ = 0.1
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/muscle_weakness/ = 100
	)
	var/datum/modifier/modifier

/datum/reagent/antidepressants/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	. = ..()

	var/mob/living/carbon/human/NewM = M
	if(istype(NewM))
		var/obj/item/organ/H = NewM.internal_organs_by_name["heart"]
		if(istype(H))
			H.take_damage(removed * 0.25,1)

		M.add_chemical_effect(CE_PAINKILLER, 5)
		if (!modifier)
			modifier = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = 0.125, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/antidepressants/methylphenidate
	name = "methylphenidate"
	id = "methylphenidate"
	description = "Methylphenidate is an AHDH treatment drug that treats basic distractions such as phobias and hallucinations at moderate doses. Withdrawl effects are rare. Side effects are rare, and include hallucinations."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel focused.","You feel like you have no distractions.","You feel willing to work.")
	badmessage = list("You feel a little distracted...","You feel slight agitation...","You feel a dislike towards work...")
	worstmessage = list("You feel completely distrtacted...","You feel like you don't want to work...","You think you see things...")
	cure_effects = list(
		/datum/brain_trauma/special/imaginary_friend = 40,
		/datum/brain_trauma/mild/hallucinations = 20,
		/datum/brain_trauma/mild/phobia/ = 20
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 5,
		/datum/brain_trauma/mild/hallucinations = 2
	)

/datum/reagent/antidepressants/fluvoxamine
	name = "fluvoxamine"
	id = "fluvoxamine"
	description = "Fluvoxamine is safe and effective at treating basic phobias, as well as schizophrenia and muscle weakness at higher doses. Withdrawl effects are rare. Side effects are rare, and include hallucinations."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You do not feel the need to worry about simple things.","You feel calm and level-headed.","You feel fine.")
	badmessage = list("You feel a little blue.","You feel slight agitation...","You feel a little nervous...")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia/ = 5,
		/datum/brain_trauma/severe/split_personality = 20,
		/datum/brain_trauma/special/imaginary_friend = 40,
		/datum/brain_trauma/mild/muscle_weakness = 20
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 5,
		/datum/brain_trauma/mild/hallucinations = 2
	)

/datum/reagent/antidepressants/sertraline
	name = "sertraline"
	id = "sertraline"
	description = "Sertraline is cheap, safe, and effective at treating basic phobias, however it does not last as long as other antidepressants. Withdrawl effects are uncommon. Side effects are rare."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.01
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel fine.","You feel rational.","You feel decent.")
	badmessage = list("You feel a little blue.","You feel slight agitation...","You feel a little nervous...")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia/ = 5
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 10,
		/datum/brain_trauma/mild/hallucinations = 5
	)

/datum/reagent/antidepressants/escitalopram
	name = "escitalopram"
	id = "escitalopram"
	description = "Escitalopram is expensive, safe and very effective at treating basic phobias as well as advanced phobias like monophobia. A common side effect is drowsiness, and a rare side effect is hallucinations. Withdrawl effects are uncommon."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel relaxed.","You feel at ease.","You feel care free.")
	badmessage = list("You feel worried.","You feel slight agitation.","You feel nervous.")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia/ = 1,
		/datum/brain_trauma/severe/monophobia = 10
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 10,
		/datum/brain_trauma/mild/hallucinations = 10
	)

/datum/reagent/antidepressants/escitalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness += removed*100
	. = ..()

/datum/reagent/antidepressants/paroxetine
	name = "paroxetine"
	id = "paroxetine"
	description = "Paroxetine is effective at treating basic phobias while also preventing the body from overheating. Side effects are rare, and include hallucinations. Withdrawl effects are frequent and unsafe."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You do not feel the need to worry about simple things.","You feel calm and level-headed.","You feel decent.")
	badmessage = list("You worry about the littlest thing.","You feel like you are at risk.","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","Your hear dangerous thoughts in your head...","You are really starting to see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia/ = 10
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 50
	)

/datum/reagent/antidepressants/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - removed*100)
	. = ..()

/datum/reagent/antidepressants/duloxetine
	name = "duloxetine"
	id = "duloxetine"
	description = "Duloxetine is effective at treating basic phobias and concussions. A rare side effect is hallucinations. Withdrawl effects are common."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel at ease.","Your mind feels healthy..")
	badmessage = list("You worry about the littlest thing.","Your head starts to feel weird...","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","Your head feels really weird.","You are really starting to see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/concussion = 10,
		/datum/brain_trauma/mild/phobia/ = 10
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 25,
		/datum/brain_trauma/mild/concussion = 10
	)

/datum/reagent/antidepressants/venlafaxine
	name = "venlafaxine"
	id = "venlafaxine"
	description = "Venlafaxine is effective at treating basic phobias, monophobia, and stuttering. Side effects are uncommon and include hallucinations. Withdrawl effects are common."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel at ease.","Your mind feels healthy..","You feel unafraid to speak...")
	badmessage = list("You worry about the littlest thing.","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","You are really starting to see things...")
	cure_effects = list(
		/datum/brain_trauma/mild/phobia = 10,
		/datum/brain_trauma/mild/stuttering = 5,
		/datum/brain_trauma/severe/monophobia = 10
	)
	dosage_effects = list(
		/datum/brain_trauma/mild/hallucinations = 10
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 25
	)

/datum/reagent/antidepressants/risperidone
	name = "risperidone"
	id = "risperidone"
	description = "Risperidone is a potent antipsychotic medication used to treat schizophrenia, stuttering, speech impediment, monophobia, hallucinations, tourettes, and muscle spasms. Side effects are common and include pacifism. Withdrawl symptoms are dangerous and almost always occur."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.25
	data = 0
	taste_description = "paper"
	goodmessage = list("Your mind feels as one.","You feel comfortable speaking.","Your body feels good.","Your thoughts are pure.")
	badmessage = list("You start hearing voices...","You think you see things...","You feel really upset...","You want attention...")
	worstmessage = list("You think you start seeing things...","You swear someone inside you spoke to you...","You hate feeling alone...","You feel really upset.")
	cure_effects = list(
		/datum/brain_trauma/severe/split_personality = 10,
		/datum/brain_trauma/special/imaginary_friend = 20,
		/datum/brain_trauma/mild/stuttering = 5,
		/datum/brain_trauma/mild/speech_impediment = 10,
		/datum/brain_trauma/severe/monophobia = 10,
		/datum/brain_trauma/mild/hallucinations = 10,
		/datum/brain_trauma/mild/muscle_spasms = 20,
		/datum/brain_trauma/mild/tourettes = 20
	)
	dosage_effects = list(
		/datum/brain_trauma/severe/pacifism = 25
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/hallucinations = 100,
		/datum/brain_trauma/severe/split_personality = 10,
		/datum/brain_trauma/special/imaginary_friend = 20,
		/datum/brain_trauma/mild/tourettes = 50,
		/datum/brain_trauma/severe/monophobia = 50
	)

/datum/reagent/antidepressants/olanzapine
	name = "olanzapine"
	id = "olanzapine"
	description = "Olanzapine is a high-strength, expensive antipsychotic medication used to treat schizophrenia, stuttering, speech impediment, monophobia, hallucinations, tourettes, and muscle spasms. Side effects are common and include pacifism. The medication metabolizes quickly, and withdrawl is dangerous."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.005
	data = 0
	taste_description = "paper"
	goodmessage = list("Your mind feels as one.","You feel comfortable speaking.","Your body feels good.","Your thoughts are pure.","Your body feels responsive.","You can handle being alone.")
	badmessage = list("You start hearing voices...","You think you see things...","You want a friend...")
	worstmessage = list("You think you start seeing things...","You swear someone inside you spoke to you...")
	cure_effects = list(
		/datum/brain_trauma/severe/split_personality = 5,
		/datum/brain_trauma/special/imaginary_friend = 10,
		/datum/brain_trauma/mild/stuttering = 2,
		/datum/brain_trauma/mild/speech_impediment = 5,
		/datum/brain_trauma/severe/monophobia = 5,
		/datum/brain_trauma/mild/muscle_spasms = 10,
		/datum/brain_trauma/mild/tourettes = 20
	)
	dosage_effects = list(
		/datum/brain_trauma/severe/pacifism = 25
	)
	withdraw_effects = list(
		/datum/brain_trauma/mild/hallucinations = 200,
		/datum/brain_trauma/severe/split_personality = 50,
		/datum/brain_trauma/special/imaginary_friend = 50
	)

/datum/reagent/antidepressants/hextrasenil
	name = "Hextrasenil"
	id = "hextrasenil"
	description = "Hextrasenil is a super-strength, fast-metabolizing, expensive antipsychotic medication intended for the use in criminal rehabilitation that treats tourettes, schizophrenia, hallucinations, and loyalty issues. Side effects include undying loyalty to NanoTrasen and respect for authority. Withdrawl effects include undying hatred towards NanoTrasen."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.02 //Not meant to last a long time.
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel loyal to NanoTrasen. Please take your pills.","You feel the need to contribute to cause of NanoTrasen. Please take your pills.","You wouldn't think about hurting NanoTrasen at all. Please take your pills.","You do not feel the need to express emotion. Please take your pills.","You feel that NanoTrasen has your best interests at heart. Please take your pills.","You respect the Chain of Command. Please take your pills.")
	badmessage = list("You start to think if you need these pills...","Do I need these pills?","Should I be taking pills anymore?")
	worstmessage = list("You start to realise that the system is corrupt...","NanoTrasen is corrupt...")
	cure_effects = list(
		/datum/brain_trauma/severe/split_personality = 5, //Gotta remove those enemies to nanotrasen.
		/datum/brain_trauma/special/imaginary_friend = 5,
		/datum/brain_trauma/mild/tourettes = 5
	)
	withdraw_effects = list()

/datum/reagent/antidepressants/trisyndicotin
	name = "Trisyndicotin"
	id = "trisyndicotin"
	description = "Trisyndicotin is a super-strength, expensive antipsychotic medication intended for the use in interigation. Side effects include undying hatred to NanoTrasen and disrespect for authority."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.01
	data = 0
	taste_description = "freedom"
	goodmessage = list("You distrust Nanotrasen and their people.","You feel woke.","You have urges to speak out against NanoTrasen.","You feel the need to complain about NanoTrasen on the web.","You feel like things should be better.")
	badmessage = list() //Actual Freedom.
	worstmessage = list() //Actual Freedom.
	cure_effects = list(
		/datum/brain_trauma/severe/pacifism = 10
	)

//Things that are not cured by medication:
//Dumbness
//Gerstmann Syndrome
//Cerebral Near-Blindness
//Mutism
//Cerebral Blindness
//Paralysis
//Narcolepsy
//Discoordination
//Aphasia
//Pacifism

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "sickness"

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/ipecac
	name = "Ipecac"
	id = "ipecac"
	description = "A simple emetic, Induces vomiting in the patient, emptying stomach contents"
	reagent_state = LIQUID
	color = "#280f0b"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "sweet syrup"

/datum/reagent/ipecac/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (prob(10+dose))
		M << pick("You feel nauseous", "Ugghh....", "Your stomach churns uncomfortably", "You feel like you're about to throw up", "You feel queasy","You feel pressure in your abdomen")

	if (prob(dose))
		M.vomit()

/datum/reagent/ipecac/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed) //If you inject it you're doing it wrong

/datum/reagent/azoth
	name = "Azoth"
	id = "azoth"
	description = "Azoth is a miraculous medicine, capable of healing internal injuries."
	reagent_state = LIQUID
	color = "#BF0000"
	taste_description = "bitter metal"
	overdose = 5

/datum/reagent/azoth/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/A in H.organs)
			var/obj/item/organ/external/E = A
			for (var/X in E.wounds)
				var/datum/wound/W = X
				if (W && W.internal)
					E.wounds -= W
					return 1

			if(E.status & ORGAN_BROKEN)
				E.status &= ~ORGAN_BROKEN
				E.stage = 0
				return 1

/datum/reagent/azoth/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustBruteLoss(5)

/datum/reagent/elixir
	name = "Elixir of Life"
	id = "elixir_life"
	description = "A mythical substance, the cure for the ultimate illness."
	color = "#ffd700"
	affects_dead = 1
	taste_description = "eternal blissfulness"

/datum/reagent/elixir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		if(M && M.stat == DEAD)
			M.stat = 0
			M.visible_message("<span class='danger'>\The [M] shudders violently!!</span>")