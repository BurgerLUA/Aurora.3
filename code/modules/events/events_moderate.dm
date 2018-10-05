/datum/event_container/moderate
	severity = EVENT_LEVEL_MODERATE
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",							/datum/event/nothing,						200),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 					/datum/event/spontaneous_appendicitis, 		-50,	list(ASSIGNMENT_MEDICAL = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Carp School",						/datum/event/carp_migration,				-25, 	list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",			/datum/event/communications_blackout,		60),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Electrical Storm",					/datum/event/electrical_storm, 				20,		list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",					/datum/event/gravity,	 					100),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grid Check",						/datum/event/grid_check, 					20,		list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Ion Storm",						/datum/event/ionstorm, 						0,		list(ASSIGNMENT_AI = 45, ASSIGNMENT_CYBORG = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Meteor Shower",					/datum/event/meteor_shower,					-40,	list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",						/datum/event/prison_break,					-15,	list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Virology",		/datum/event/prison_break/virology,			-15,	list(ASSIGNMENT_MEDICAL = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Xenobiology",	/datum/event/prison_break/xenobiology,		-15,	list(ASSIGNMENT_SCIENTIST = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",					/datum/event/radiation_storm, 				-25, 	list(ASSIGNMENT_MEDICAL = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",				/datum/event/random_antag,		 			0,		list(ASSIGNMENT_ANY = 1, ASSIGNMENT_SECURITY = 1),0,10,125, list("Extended")),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",						/datum/event/rogue_drone, 					-25,	list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Spider Infestation",		/datum/event/spider_infestation/moderate,	-50,	list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Viral Infection",					/datum/event/viral_infection, 				-50,	list(ASSIGNMENT_MEDICAL = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Vermin Infestation",		/datum/event/infestation/moderate, 			30,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 15))
	)