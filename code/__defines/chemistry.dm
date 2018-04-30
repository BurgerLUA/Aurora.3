#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3
#define CHEM_BREATHE 4

#define MINIMUM_CHEMICAL_VOLUME 0.01

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  4
#define IS_UNATHI  8
#define IS_TAJARA  16
#define IS_XENOS   32
#define IS_MACHINE 64
#define IS_VAURCA  128
#define IS_UNDEAD  256

#define CE_STABLE "stable" // Inaprovaline
#define CE_ANTIBIOTIC "antibiotic" // Spaceacilin
#define CE_BLOODRESTORE "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER "painkiller"
#define CE_ALCOHOL "alcohol" // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic" // Liver damage
#define CE_SPEEDBOOST "gofast" // Hyperzine

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_chlorophoride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

//Alcohol
#define INTOX_BUZZED     0.02
#define INTOX_JUDGEIMP   0.06
#define INTOX_MUSCLEIMP  0.08
#define INTOX_REACTION   0.10
#define INTOX_VOMIT		 0.12
#define INTOX_BALANCE    0.15
#define INTOX_BLACKOUT   0.20
#define INTOX_CONSCIOUS  0.30
#define INTOX_DEATH      0.45

//How many units of alcohol to remove per second
#define INTOX_FILTER_HEALTHY 0.3
#define INTOX_FILTER_BRUISED 0.15
#define INTOX_FILTER_DAMAGED 0.05

#define		BASE_DIZZY		100

#define		BASE_VOMIT_CHANCE			2
#define		VOMIT_CHANCE_SCALE			0.2
