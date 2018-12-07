/spell/targeted/devil
	name = "You shouldn't be seeing this."
	desc = "BURGER FUCKING FIX IT."

	charge_max = 300 SECONDS
	charge_type = Sp_RECHARGE

	spell_flags = SELECTABLE | IGNOREPREV
	invocation = "none"
	invocation_type = SpI_NONE
	range = 6
	max_targets = 1
	cooldown_min = 300

//LUST
/spell/targeted/devil/lust
	name = "Invoke Lust"
	desc = "The target falls in love with the first person they see."

/spell/targeted/devil/lust/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		if(!istype(H))
			continue
		var/obj/item/organ/brain/B = H.internal_organs_by_name["brain"]
		if(!H.has_trauma_type(/datum/brain_trauma/special/love))
			B.gain_trauma(/datum/brain_trauma/special/love,FALSE)

//GLUTTONY
/spell/targeted/devil/gluttony
	name = "Invoke Gluttony"
	desc = "The target gains bonuses from being full, however gets hungry quite easily."

/spell/targeted/devil/gluttony/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add gluttony

//GREED
/spell/targeted/devil/greed
	name = "Invoke Greed"
	desc = "The target has a very strong desire to obtain wealth. They gain bonuses if their bank account has a large sum of wealth. Gives the target permission to steal things."

/spell/targeted/devil/greed/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add greed

//SLOTH
/spell/targeted/devil/sloth
	name = "Invoke Sloth"
	desc = "The target has a very strong desire to not care about anything."

/spell/targeted/devil/sloth/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add sloth

//WRATH
/spell/targeted/devil/wrath
	name = "Invoke Wrath"
	desc = "The target gets very angry easily. Sometimes they turn green with wrath."

/spell/targeted/devil/wrath/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add wrath

//ENVY
/spell/targeted/devil/envy
	name = "Invoke Envy"
	desc = "The target seems to have a strong desire to want things other people have."

/spell/targeted/devil/envy/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add envy

//PRIDE
/spell/targeted/devil/pride
	name = "Invoke Pride"
	desc = "The target seems to have a strong desire to want things other people have."

/spell/targeted/devil/pride/cast(var/list/targets)
	for(var/mob/living/carbon/human/H in targets)
		world << H
		//Add pride





