//DVIEW defines

#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.forceMove(center); \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

#define DVIEW(output, range, center, invis_flags) \
	dview_mob.forceMove(center); \
	dview_mob.see_invisible = invis_flags; \
	output = view(range, dview_mob); \
	dview_mob.loc = null;
