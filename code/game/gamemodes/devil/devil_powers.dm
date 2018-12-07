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
	var/obj/item/spawning_item

/datum/power/devil/lust
	name = "Provide Lust (1)"
	desc = "A vial of love potion is conjured in your hands. If the love potion is used, your power is increased."
	category = "lust"
	sin_cost = 0
	spawning_item = obj/item/weapon/reagent_containers/glass/bottle/love_potion

/datum/power/devil/gluttony
	name = "Provide Gluttony (1)"
	desc = "An unlimited serving of steak, chocolate, or alcohol is conjured in your hands. If the object is eaten from at least 5 times by one person, your power is increased."
	category = "gluttony"
	sin_cost = 0

/datum/power/devil/greed
	name = "Provide Greed (1)"
	desc = "A random crewmember's bank account card is conjured in your hands. If a crewmember other than it's owner uses the card, your power is increased."
	category = "greed"
	sin_cost = 300

/datum/power/devil/sloth
	name = "Provide Sloth (1)"
	desc = "The target is provided with an object that gives them anything they want without working hard for it. If they use the object, then your power is increased."
	category = "sloth"
	sin_cost = 200

/datum/power/devil/wrath
	name = "Provide Wrath (1)"
	desc = "A special voodoo doll is conjured in your hands. If a crewmember uses the voodoo doll, then your power is increased."
	category = "wrath"
	sin_cost = 200
	spawning_item = obj/item/poppet

/datum/power/devil/envy //This is pretty strong. Gives the envy disability; an attraction to items other people have. Gives the target permission to steal things.
	name = "Provide Envy (1)"
	desc = "A special contract is conjured in your hands that instantly swaps the occupation of the signer with a crewmember of their choosing. If it is used, your power is increased."
	category = "envy"
	sin_cost = 300

/datum/power/devil/pride //This is pretty strong. Gives the envy disability; an attraction to items other people have. Gives the target permission to steal things.
	name = "Provide Pride (1)"
	desc = ""
	category = "pride"
	sin_cost = 300