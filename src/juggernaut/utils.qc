#define ExecuteAs(function,executionAs) {\
    local entity __executeAsOSelf = self;\
    self = executionAs;\
    function;\
    self = __executeAsOSelf;\
}(void)__NULL__


float(entity p) IsPlayerActive =
{
    return p.netname != "";
}

entity(entity previous) LoopPlayers =
{
    local entity p = previous;
    while((p = find(p,classname,"player")))
    {
        // Only loop through active players
        if(IsPlayerActive(p))
            return p;
    }

    return world;
}

entity(void() function,float delay) ExecuteDelayed =
{
    local entity ent = spawn();
    ent.think = function;
    ent.nextthink = time + delay;

    return ent;
}

entity(entity p) HydrateJuggernautPlayer {
    local	float	type, value, bit;
    
    p.items =  
        IT_ROCKET_LAUNCHER | 
        IT_SHOTGUN |
        IT_SUPER_SHOTGUN | 
        IT_NAILGUN |
        IT_SUPER_NAILGUN |
        IT_GRENADE_LAUNCHER |
        IT_LIGHTNING;

    type = 0.8;
    value = 400;
    bit = IT_ARMOR3;

	p.armortype = type;
	p.armorvalue = value;

	p.items = p.items - (p.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	p.ammo_shells = 999;
	p.ammo_nails = 999;
	p.ammo_rockets = 999;
	p.ammo_cells = 999;
    p.max_health = 650;
    p.health = 650;
    return p;
}

