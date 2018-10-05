/datum/event_container/mundane
	severity = EVENT_LEVEL_MUNDANE
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",					/datum/event/nothing,				120),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",				/datum/event/apc_damage,			-15, 	list(ASSIGNMENT_ENGINEER = 30)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",		/datum/event/brand_intelligence,	-20, 	list(ASSIGNMENT_ENGINEER = 20),	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",				/datum/event/camera_damage,			10, 		list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",				/datum/event/economic_event,		300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",					/datum/event/carp_migration, 		-20, 	list(ASSIGNMENT_SECURITY = 20, ASSIGNMENT_ENGINEER = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",				/datum/event/money_hacker, 			10),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",				/datum/event/money_lotto, 			0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 				/datum/event/mundane_news, 			300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "PDA Spam",					/datum/event/pda_spam, 				0, 		list(ASSIGNMENT_ANY = 4), 0, 25, 50),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",					/datum/event/wallrot, 				-20,	list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Clogged Vents",				/datum/event/vent_clog, 			0, 		list(ASSIGNMENT_MEDICAL = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "False Alarm",				/datum/event/false_alarm, 			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Supply Drop",				/datum/event/supply_drop, 			80),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "CCIA General Notice",		/datum/event/ccia_general_notice, 	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane Vermin Infestation",/datum/event/infestation, 			60,		list(ASSIGNMENT_JANITOR = 30))

	)