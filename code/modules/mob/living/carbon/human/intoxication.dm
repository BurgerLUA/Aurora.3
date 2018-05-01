var/mob/living/carbon/human/alcohol_clumsy = 0

//This proc handles the effects of being intoxicated. Removal of intoxication is done elswhere: By the liver, in organ_internal.dm
/mob/living/carbon/human/proc/handle_intoxication()


	var/SR = species.ethanol_resistance
	if (SR == -1)
		//This species can't get drunk, how did we even get here?
		intoxication = 0
		return

	//Godmode messes some things up, so no more BSTs getting drunk unless they toggle it off
	if (status_flags & GODMODE)
		intoxication = 0 //Zero out intoxication but don't return, let the rest of this function run to remove any residual effects
		slurring = 0
		confused = 0
		eye_blurry = 0
		drowsyness = 0
		paralysis = 0
		sleeping = 0
		//Many of these parameters normally tick down in life code, but some parts of that code don't run in godmode, so this prevents a BST being stuck with blurred vision

	src.bac = round(intoxication/max(vessel.get_reagent_amount("blood"),1),0.01)

	if(bac > INTOX_BUZZED*SR && bac < INTOX_MUSCLEIMP*SR && !(locate(/datum/modifier/buzzed) in modifiers))
		src.show_message("<span class='notice'>You feel buzzed.</span>")
		add_modifier(/datum/modifier/buzzed, MODIFIER_CUSTOM)

	if(bac > INTOX_JUDGEIMP*SR)
		if (dizziness == 0)
			src.show_message("<span class='notice'>You feel a little tipsy.</span>")
		var/target_dizziness = min(1000,(BASE_DIZZY + ((bac - INTOX_JUDGEIMP*SR)*10)/SR))
		make_dizzy(target_dizziness - dizziness)

	if(bac > INTOX_MUSCLEIMP*SR)
		if(drowsyness == 0)
			src.show_message("<span class='notice'>You feel sluggish.</span>")
		drowsyness = max(drowsyness, 1)

	if(bac > INTOX_REACTION*SR)
		if (confused == 0)
			src.show_message("<span class='warning'>You feel uncoordinated and unsteady on your feet!</span>")
		confused = max(confused, 10)
		slurring = max(slurring, 20)
		drowsyness = max(drowsyness, 10)
		if (!alcohol_clumsy && !(CLUMSY in mutations))
			mutations.Add(CLUMSY)
			alcohol_clumsy = 1
	else
		if (alcohol_clumsy)
			src.show_message("<span class='notice'>You feel more sober and steady.</span>")
			mutations.Remove(CLUMSY)
			alcohol_clumsy = 0

	if(bac > INTOX_VOMIT*SR)
		add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		drowsyness = max(drowsyness, 20)
		slurring = max(slurring, 30)
		if (life_tick % 4 == 1)
			var/chance = BASE_VOMIT_CHANCE + ((bac - INTOX_VOMIT*SR)*VOMIT_CHANCE_SCALE)
			if (prob(chance))
				delayed_vomit()

	if(bac > INTOX_BALANCE*SR)
		slurring = max(slurring, 50)
		if (life_tick % 4 == 1 && prob(10))
			src.visible_message("<span class='warning'>[src] loses balance and falls to the ground!</span>","<span class='warning'>You lose balance and fall to the ground!</span>")
			paralysis = max(paralysis,3 SECONDS)
			if(bac > INTOX_CONSCIOUS*SR)
				slurring = max(slurring, 70)
				src.visible_message("<span class='danger'>[src] loses consciousness!</span>","<span class='danger'>You lose consciousness!</span>")
				paralysis = max(paralysis, 60 SECONDS)
				sleeping  = max(sleeping, 60 SECONDS)
				adjustBrainLoss(3,10)
			else if(bac > INTOX_BLACKOUT*SR)
				slurring = max(slurring, 80)
				src.visible_message("<span class='danger'>[src] blackouts!</span>","<span class='danger'>You blackout!</span>")
				paralysis = max(paralysis, 20 SECONDS)
				sleeping  = max(sleeping, 20 SECONDS)
				adjustBrainLoss(5,30)
			else if(prob(10))
				slurring = max(slurring, 90)
				src.show_message("<span class='notice'>You decide that you like the ground and spend a few seconds to rest.</span>")
				sleeping  = max(sleeping, 6 SECONDS)
				adjustBrainLoss(1,5)

	if (bac > INTOX_DEATH*SR) //Death usually occurs here
		adjustOxyLoss(10,100)
		adjustBrainLoss(1,50)


//Pleasant feeling from being slightly drunk
//Makes you faster and reduces sprint cost
//Wears off if you get too drunk or too sober, a balance must be maintained
/datum/modifier/buzzed

/datum/modifier/buzzed/activate()
	..()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.move_delay_mod += -0.75
		H.sprint_cost_factor += -0.1

/datum/modifier/buzzed/deactivate()
	..()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.move_delay_mod -= -0.75
		H.sprint_cost_factor -= -0.1

/datum/modifier/buzzed/custom_validity()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		if (H.bac >= INTOX_BUZZED*H.species.ethanol_resistance && H.bac <= INTOX_MUSCLEIMP*H.species.ethanol_resistance)
			return 1
	return 0