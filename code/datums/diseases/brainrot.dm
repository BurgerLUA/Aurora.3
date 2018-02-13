/datum/disease/brainrot
	name = "Brainrot"
	max_stages = 4
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Alkysine"
	cure_id = list("alkysine")
	agent = "Cryptococcus Cosmosis"
	affected_species = list("Human")
	curable = 0
	cure_chance = 15//higher chance to cure, since two reagents are required
	desc = "This disease destroys the braincells, causing brain fever, brain necrosis and general intoxication."
	severity = "Major"

/datum/disease/brainrot/stage_act() //Removed toxloss because damaging diseases are pretty horrible. Last round it killed the entire station because the cure didn't work -- Urist
	..()
	switch(stage)
		if(2)
			if(prob(2))
				send_emote("blink",affected_mob)
			if(prob(2))
				send_emote("yawn",affected_mob)
			if(prob(2))
				affected_mob << "<span class='warning'>Your don't feel like yourself.</span>"
			if(prob(5))
				affected_mob.adjustBrainLoss(1, 55)
				affected_mob.updatehealth()
		if(3)
			if(prob(2))
				send_emote("stare",affected_mob)
			if(prob(2))
				send_emote("drool",affected_mob)
			if(prob(10))//shouldn't retard you to death now
				affected_mob.adjustBrainLoss(2, 55)
				affected_mob.updatehealth()
				if(prob(2))
					affected_mob << "<span class='warning'>You try to remember something important...but can't.</span>"
		if(4)
			if(prob(2))
				send_emote("stare",affected_mob)
			if(prob(2))
				send_emote("drool",affected_mob)
			if(prob(15)) //shouldn't retard you to death now
				affected_mob.adjustBrainLoss(3, 55)
				affected_mob.updatehealth()
				if(prob(2))
					affected_mob << "<span class='warning'>A strange buzzing fills your head, removing all thoughts.</span>"
			if(prob(3))
				affected_mob << "<span class='warning'>You lose consciousness...</span>"
				for(var/mob/O in viewers(affected_mob, null))
					O.show_message("[affected_mob] suddenly collapses", 1)
				affected_mob.Paralyse(rand(5,10))
				if(prob(1))
					send_emote("snore",affected_mob)
			if(prob(15))
				affected_mob.stuttering += 3
	return
