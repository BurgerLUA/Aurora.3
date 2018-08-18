#define BATTLE_MONSTERS_GEN_PREFIX 1
#define BATTLE_MONSTERS_GEN_ROOT 2
#define BATTLE_MONSTERS_GEN_SUFFIX 3

var/datum/controller/subsystem/battle_monsters/SSbattlemonsters

/datum/controller/subsystem/battle_monsters
	name = "Battle Monsters"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/monster_elements
	var/list/monster_roots
	var/list/monster_titles

	var/list/monster_elements_rng
	var/list/monster_roots_rng
	var/list/monster_titles_rng

/datum/controller/subsystem/battle_monsters/New()
    NEW_SS_GLOBAL(SSbattlemonsters)

/datum/controller/subsystem/battle_monsters/Initialize()
	GenerateDatum(BATTLE_MONSTERS_GEN_PREFIX)
	GenerateDatum(BATTLE_MONSTERS_GEN_ROOT)
	GenerateDatum(BATTLE_MONSTERS_GEN_SUFFIX)

/datum/controller/subsystem/battle_monsters/proc/GenerateDatum(var/generation_type)

	var/list/datum_paths

	switch(generation_type)
		if(BATTLE_MONSTERS_GEN_PREFIX)
			datum_paths = subtypesof(/datum/battle_monsters/element)
		if(BATTLE_MONSTERS_GEN_ROOT)
			datum_paths = subtypesof(/datum/battle_monsters/monster)
		if(BATTLE_MONSTERS_GEN_SUFFIX)
			datum_paths = subtypesof(/datum/battle_monsters/title)

	var/list/id_datum_list = list()
	var/list/id_rng_list = list()

	for(var/path in datum_paths)
		var/datum/battle_monsters/generated = new path()
		if(!generated.id)
			continue
		id_datum_list[generated.id] = generated
		id_rng_list[generated.id] = generated.rarity

	switch(generation_type)
		if(BATTLE_MONSTERS_GEN_PREFIX)
			monster_elements = id_datum_list
			monster_elements_rng = id_rng_list
		if(BATTLE_MONSTERS_GEN_ROOT)
			monster_roots = id_datum_list
			monster_roots_rng = id_rng_list
		if(BATTLE_MONSTERS_GEN_SUFFIX)
			monster_titles = id_datum_list
			monster_titles_rng = id_rng_list

/datum/controller/subsystem/battle_monsters/proc/GetRandomPrefix()
	return FindMatchingPrefix(pickweight(monster_elements_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomRoot()
	return FindMatchingRoot(pickweight(monster_roots_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomSuffix()
	return FindMatchingSuffix(pickweight(monster_titles_rng))

/datum/controller/subsystem/battle_monsters/proc/FindMatchingPrefix(var/text,var/failsafe = FALSE)
	if(monster_elements[text])
		return monster_elements[text]
	else if(failsafe)
		return GetRandomPrefix()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/FindMatchingRoot(var/text,var/failsafe = FALSE)
	if(monster_roots[text])
		return monster_roots[text]
	else if(failsafe)
		return GetRandomRoot()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/FindMatchingSuffix(var/text,var/failsafe = FALSE)
	if(monster_titles[text])
		return monster_titles[text]
	else if(failsafe)
		return GetRandomSuffix()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/GetSpeciesGeneral(var/card_defense_type)
	switch(card_defense_type)
		if(BATTLE_MONSTERS_DEFENSETYPE_NONE)
			return "monster"
		if(BATTLE_MONSTERS_DEFENSETYPE_DEMIGOD)
			return "demi-god"
		if(BATTLE_MONSTERS_DEFENSETYPE_CYBORG)
			return "cyborg"
		if(BATTLE_MONSTERS_DEFENSETYPE_HYBRID)
			return "hybrid"
		if(BATTLE_MONSTERS_DEFENSETYPE_FERALDRAGON)
			return "feral dragon"
		if(BATTLE_MONSTERS_DEFENSETYPE_DRAGONHYBRID)
			return "human-dragon hybrid"
		if(BATTLE_MONSTERS_DEFENSETYPE_GIANT)
			return "colossus"
		if(BATTLE_MONSTERS_DEFENSETYPE_HUMAN)
			return "human"
		if(BATTLE_MONSTERS_DEFENSETYPE_GOD)
			return "god"
		if(BATTLE_MONSTERS_DEFENSETYPE_MACHINE)
			return "machine"
		if(BATTLE_MONSTERS_DEFENSETYPE_CREATURE)
			return "creature"
		if(BATTLE_MONSTERS_DEFENSETYPE_DRAGON)
			return "dragon"
		if(BATTLE_MONSTERS_DEFENSETYPE_COLOSSUS)
			return "colossus"
		if(BATTLE_MONSTERS_DEFENSETYPE_GIANT_DRAGON)
			return "giant dragon"

/datum/controller/subsystem/battle_monsters/proc/GetSpecies(card_defense_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Human" = BATTLE_MONSTERS_DEFENSETYPE_HUMAN,
		"God" = BATTLE_MONSTERS_DEFENSETYPE_GOD,
		"Machine" = BATTLE_MONSTERS_DEFENSETYPE_MACHINE,
		"Creature" = BATTLE_MONSTERS_DEFENSETYPE_CREATURE,
		"Dragon" = BATTLE_MONSTERS_DEFENSETYPE_DRAGON,
		"Colossus" = BATTLE_MONSTERS_DEFENSETYPE_COLOSSUS
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_defense_type))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Monster", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetAttackType(var/card_attack_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Spellcaster" = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER,
		"Swordsman" = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN,
		"Commander" = BATTLE_MONSTERS_ATTACKTYPE_ARMY,
		"Brawler" = BATTLE_MONSTERS_ATTACKTYPE_CLAWS,
		"Crusher" = BATTLE_MONSTERS_ATTACKTYPE_CLUB
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_attack_type))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Regular", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetWeapons(var/card_attack_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"staff" = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER,
		"sword" = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN,
		"army" = BATTLE_MONSTERS_ATTACKTYPE_ARMY,
		"claws" = BATTLE_MONSTERS_ATTACKTYPE_CLAWS,
		"club" = BATTLE_MONSTERS_ATTACKTYPE_CLUB
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_attack_type))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "fists", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetElements(var/card_elements,var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Neutral" = BATTLE_MONSTERS_ELEMENT_NEUTRAL,
		"Fire" = BATTLE_MONSTERS_ELEMENT_FIRE,
		"Energy" = BATTLE_MONSTERS_ELEMENT_ENERGY,
		"Water" = BATTLE_MONSTERS_ELEMENT_WATER,
		"Ice" = BATTLE_MONSTERS_ELEMENT_ICE,
		"Earth" = BATTLE_MONSTERS_ELEMENT_EARTH,
		"Stone" = BATTLE_MONSTERS_ELEMENT_STONE,
		"Dark" = BATTLE_MONSTERS_ELEMENT_DARK,
		"Light" = BATTLE_MONSTERS_ELEMENT_LIGHT,
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_elements))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Neutral", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetStarLevel(var/power_rating)
	return min(10,1 + round( (power_rating^1.25) * 0.00012))

/datum/controller/subsystem/battle_monsters/proc/FormatText(var/text,var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum)

	var/list/generated_stats = SSbattlemonsters.GenerateStats(prefix_datum,root_datum,suffix_datum)

	world << "PRINTING LIST:"
	world << generated_stats

	world << "MUH NAME"

	world << generated_stats[BATTLE_MONSTERS_CARD_NAME]

	var/list/replacements = list(
		"%NAME" = generated_stats[BATTLE_MONSTERS_CARD_NAME],

		"%DESCRIPTION" = generated_stats[BATTLE_MONSTERS_CARD_DESCRIPTION],
		"%STARLEVEL" = GetStarLevel(generated_stats[BATTLE_MONSTERS_CARD_POWER]),
		"%SPECIAL_EFFECTS" = generated_stats[BATTLE_MONSTERS_CARD_SPECIALEFFECTS],

		"%SPECIES_C" = capitalize(GetSpeciesGeneral(generated_stats[BATTLE_MONSTERS_CARD_DEFENSETYPE])),
		"%SPECIES_LIST" = GetSpecies(generated_stats[BATTLE_MONSTERS_CARD_DEFENSETYPE], ", "),
		"%SPECIES" = GetSpeciesGeneral(generated_stats[BATTLE_MONSTERS_CARD_DEFENSETYPE]),

		"%TYPE" = GetAttackType(generated_stats[BATTLE_MONSTERS_CARD_ATTACKTYPE]),
		"%ATTACKTYPE_LIST" = GetAttackType(generated_stats[BATTLE_MONSTERS_CARD_ATTACKTYPE], ", "),
		"%WEAPON_AND" = GetWeapons(generated_stats[BATTLE_MONSTERS_CARD_ATTACKTYPE]),

		"%ELEMENT_AND" = GetElements(generated_stats[BATTLE_MONSTERS_CARD_ELEMENTS]),
		"%ELEMENT_OR" = GetElements(generated_stats[BATTLE_MONSTERS_CARD_ELEMENTS], " or "),
		"%ELEMENT_LIST" = GetElements(generated_stats[BATTLE_MONSTERS_CARD_ELEMENTS], ", "),

		"%ATTACK_POINTS" = generated_stats[BATTLE_MONSTERS_CARD_ATTACKPOINTS],
		"%DEFENSE_POINTS" = generated_stats[BATTLE_MONSTERS_CARD_DEFENSEPOINTS]
	)

	for(var/word in replacements)
		text = replacetext(text,word,replacements[word])

	return text

/datum/controller/subsystem/battle_monsters/proc/GetFormatting()
	return "<b>%NAME</b> | %ELEMENT_LIST %TYPE | %SPECIES_C %ATTACKTYPE_LIST<br>\
			Keywords: %SPECIES_LIST<br>\
			ATK: %ATTACK_POINTS | DEF: %DEFENSE_POINTS<br>\
			%SPECIAL_EFFECTS<br>\
			The card depicts %DESCRIPTION"


/datum/controller/subsystem/battle_monsters/proc/ExamineCard(var/mob/user,var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum)
	to_chat(user,FormatText(GetFormatting(),prefix_datum,root_datum,suffix_datum))

/datum/controller/subsystem/battle_monsters/proc/GenerateStats(var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum,var/limiter = BATTLE_MONSTERS_GENERATION_ALL)

	var/list/returning_list = list(
		BATTLE_MONSTERS_CARD_NAME = "Unknown",
		BATTLE_MONSTERS_GENERATION_DESCRIPTION = "",
		BATTLE_MONSTERS_GENERATION_SPECIALEFFECTS = "",
		BATTLE_MONSTERS_CARD_ELEMENTS = 0x0,
		BATTLE_MONSTERS_CARD_ATTACKTYPE = 0x0,
		BATTLE_MONSTERS_CARD_DEFENSETYPE = 0x0,
		BATTLE_MONSTERS_CARD_RARITYSCORE = 0,
		BATTLE_MONSTERS_CARD_ATTACKPOINTS = 0,
		BATTLE_MONSTERS_CARD_DEFENSEPOINTS = 0,
		BATTLE_MONSTERS_CARD_POWER = 0,
		BATTLE_MONSTERS_CARD_STARLEVEL = 0,
	)

	if(1) // if(limiter & BATTLE_MONSTERS_GENERATION_NAME)
		returning_list[BATTLE_MONSTERS_CARD_NAME] = root_datum.name
		if(prefix_datum.name)
			returning_list[BATTLE_MONSTERS_CARD_NAME] = "[prefix_datum.name] [returning_list[BATTLE_MONSTERS_CARD_NAME]]"
		if(suffix_datum.name)
			returning_list[BATTLE_MONSTERS_CARD_NAME] = "[returning_list[BATTLE_MONSTERS_CARD_NAME]], [suffix_datum.name]"

	if(1) // if(limiter & BATTLE_MONSTERS_GENERATION_DESCRIPTION)
		returning_list[BATTLE_MONSTERS_CARD_DESCRIPTION] = root_datum.description
		if(prefix_datum.description)
			returning_list[BATTLE_MONSTERS_CARD_DESCRIPTION] += " [prefix_datum.description]"
		if(suffix_datum.description)
			returning_list[BATTLE_MONSTERS_CARD_DESCRIPTION] += "<br><i>[suffix_datum.description]</i>"

	if(1) // if(limiter & BATTLE_MONSTERS_GENERATION_SPECIALEFFECTS)
		if(prefix_datum.special_effects)
			returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS] = trim("[returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS]][prefix_datum.special_effects]<br>")
		if(root_datum.special_effects)
			returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS] = trim("[returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS]][root_datum.special_effects]<br>")
		if(suffix_datum.special_effects)
			returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS] = trim("[returning_list[BATTLE_MONSTERS_CARD_SPECIALEFFECTS]][suffix_datum.special_effects]<br>")

	if(1) // if(limiter & BATTLE_MONSTERS_GENERATION_FORM)
		returning_list[BATTLE_MONSTERS_CARD_ELEMENTS] = prefix_datum.elements | root_datum.elements | suffix_datum.elements
		returning_list[BATTLE_MONSTERS_CARD_ATTACKTYPE] = prefix_datum.attack_type | root_datum.attack_type | suffix_datum.attack_type
		returning_list[BATTLE_MONSTERS_CARD_DEFENSETYPE] = prefix_datum.defense_type | root_datum.defense_type | suffix_datum.defense_type

	if(1) // if(limiter & BATTLE_MONSTERS_GENERATION_STATS)
		returning_list[BATTLE_MONSTERS_CARD_RARITYSCORE] = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score
		returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] = (prefix_datum.attack_add + root_datum.attack_add + suffix_datum.attack_add) * (prefix_datum.attack_mul * root_datum.attack_mul * suffix_datum.attack_mul)
		returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS] = (prefix_datum.defense_add + root_datum.defense_add + suffix_datum.defense_add) * (prefix_datum.defense_mul * root_datum.defense_mul * suffix_datum.defense_mul)
		returning_list[BATTLE_MONSTERS_CARD_POWER] = (prefix_datum.power_add + root_datum.power_add + suffix_datum.power_add) * (prefix_datum.power_mul * root_datum.power_mul * suffix_datum.power_mul)
		if(returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] >= returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS])
			returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS] = returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS]/(returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] + returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS])
			returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] = 1 - returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS]
		else
			returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] = returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS]/(returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] + returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS])
			returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS] = 1 - returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS]

		returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS] = round(returning_list[BATTLE_MONSTERS_CARD_POWER] * returning_list[BATTLE_MONSTERS_CARD_ATTACKPOINTS],100)
		returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS] = round(returning_list[BATTLE_MONSTERS_CARD_POWER] * returning_list[BATTLE_MONSTERS_CARD_DEFENSEPOINTS],100)
		returning_list[BATTLE_MONSTERS_CARD_STARLEVEL] = GetStarLevel(returning_list[BATTLE_MONSTERS_CARD_POWER])

	return returning_list

#undef BATTLE_MONSTERS_GEN_PREFIX
#undef BATTLE_MONSTERS_GEN_ROOT
#undef BATTLE_MONSTERS_GEN_SUFFIX