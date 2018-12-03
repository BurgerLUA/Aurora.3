var/list/devilpower_types = typesof(/datum/power/devil) - /datum/power/devil
var/list/datum/power/devil/devilpowers = list()

//Devil powers go here
//Lust
//Gluttony
//Greed
//Sloth
//Wrath
//Envy
//Pride

/datum/power/devil
	var/sin_cost = 0 //A sin point is generated every second for every follower, plus 1.
	var/follower_requirement = 0 //Minimum followers required to use this spell.
	var/category = "" //The category of spell. Leave blank for none.

//Main Powers
/datum/power/devil/lust_major //This is pretty strong. Gives the love disability.
	name = "Invoke Lust"
	desc = "The target falls in love with the first person they see."
	category = "lust"
	sin_cost = 300
	follower_requirement = 3

/datum/power/devil/gluttony_major //This is moderately strong.
	name = "Invoke Gluttony"
	desc = "The target gains bonuses from being full, however gets hungry quite easily."
	category = "gluttony"
	sin_cost = 200
	follower_requirement = 2

/datum/power/devil/greed_major //This is pretty weak.
	name = "Invoke Greed"
	desc = "The target has a very strong desire to obtain wealth. They gain bonuses if their bank account has a large sum of wealth. Gives the target permission to steal things."
	category = "greed"
	sin_cost = 300
	follower_requirement = 3

/datum/power/devil/sloth_major //Honestly pretty strong. Gives the pacifism disability as well as a constant painkiller.
	name = "Invoke Sloth"
	desc = "The target has a very strong desire to not care about anything."
	category = "sloth"
	sin_cost = 200
	follower_requirement = 2

/datum/power/devil/wrath_major //Moderately strong. Gives the beserk disability. Gives the target permission to be angry with people.
	name = "Invoke Wrath"
	desc = "The target gets very angry easily. Sometimes they turn green with wrath."
	category = "wrath"
	sin_cost = 200
	follower_requirement = 2

/datum/power/devil/envy_major //This is pretty strong. Gives the envy disability; an attraction to items other people have. Gives the target permission to steal things.
	name = "Invoke Envy"
	desc = "The target seems to have a strong desire to want things other people have."
	category = "envy"
	sin_cost = 300
	follower_requirement = 3

/datum/power/devil/pride_major
	//This is ultra strong. Pride is one of the deadliest of sins.
	//Basically gives the target permission to antag.
	//Cannot be used on loyalty implanted people.
	//Only unlocks if all other sins are committed.
	//If an


	name = "Invoke Pride"
	desc = "The target seems to have a strong desire to want things other people have."
	category = "pride"
	sin_cost = 500
	follower_requirement = 5



/datum/power/devil/lust
	name = "Provide Lust"
	desc = "A vial of love potion is conjured in your hands. If the love potion is used, your power is increased."
	category = "lust"
	sin_cost = 0
	follower_requirement = 0

/datum/power/devil/gluttony
	name = "Provide Gluttony"
	desc = "An unlimited serving of steak, chocolate, or alcohol is conjured in your hands. If the object is eaten from at least 5 times by one person, your power is increased."
	category = "gluttony"
	sin_cost = 0
	follower_requirement = 0

/datum/power/devil/greed
	name = "Provide Greed"
	desc = "A random crewmember's bank account card is conjured in your hands. If a crewmember other than it's owner uses the card, your power is increased."
	category = "greed"
	sin_cost = 300
	follower_requirement = 3

/datum/power/devil/sloth
	name = "Provide Sloth"
	desc = "The target is provided with an object that gives them anything they want without working hard for it. If they use the object, then your power is increased."
	category = "sloth"
	sin_cost = 200
	follower_requirement = 2

/datum/power/devil/wrath
	name = "Provide Wrath"
	desc = "A special voodoo doll is conjured in your hands. If a crewmember inflicts harm at least three times using the voodoo doll, your power is increased."
	category = "wrath"
	sin_cost = 200
	follower_requirement = 2

/datum/power/devil/envy //This is pretty strong. Gives the envy disability; an attraction to items other people have. Gives the target permission to steal things.
	name = "Provide Envy"
	desc = "A special contract is conjured in your hands that instantly swaps the occupation of the signer with a crewmember of their choosing. If it is used, your power is increased."
	category = "envy"
	sin_cost = 300
	follower_requirement = 3

/datum/power/devil/envy //This is pretty strong. Gives the envy disability; an attraction to items other people have. Gives the target permission to steal things.
	name = "Provide Pride"
	desc = ""
	category = "envy"
	sin_cost = 300
	follower_requirement = 3