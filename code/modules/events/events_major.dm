/datum/event_container/major
	severity = EVENT_LEVEL_MAJOR
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",						/datum/event/nothing,				135),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Blob",						/datum/event/blob, 					-20,	list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_SECURITY =  5), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Carp Migration",				/datum/event/carp_migration,		-20,	list(ASSIGNMENT_SECURITY =  10), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Meteor Wave",					/datum/event/meteor_wave,			-20,	list(ASSIGNMENT_ENGINEER =  10),1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Space Vines",					/datum/event/spacevine, 			50,		list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_GARDENER = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Viral Infection",				/datum/event/viral_infection,		-30,	list(ASSIGNMENT_MEDICAL =  15), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Spider Infestation",			/datum/event/spider_infestation,	-30, 	list(ASSIGNMENT_SECURITY = 10, ASSIGNMENT_MEDICAL = 5), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Major Vermin Infestation",	/datum/event/infestation/major, 	-15,	list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 10))
	)