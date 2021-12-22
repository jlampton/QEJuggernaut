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
    value = JUGGERNAUT_INITIAL_ARMOR_BUFF;
    bit = IT_ARMOR3;

	p.armortype = type;
	p.armorvalue = value;

	p.items = p.items - (p.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	p.ammo_shells = 999;
	p.ammo_nails = 999;
	p.ammo_rockets = 999;
	p.ammo_cells = 999;
    p.max_health = JUGGERNAUT_INITIAL_HEALTH_BUFF;
    p.health = JUGGERNAUT_INITIAL_HEALTH_BUFF;
    return p;
}

entity(entity p) ResetNonJuggernautPlayer {
    // Remove anything crazy that the juggernaut had if they
    // finished the map as the juggernaut.
    p.items =  p.items - 
    (IT_ROCKET_LAUNCHER |
    IT_SUPER_SHOTGUN | 
    IT_NAILGUN |
    IT_SUPER_NAILGUN |
    IT_GRENADE_LAUNCHER |
    IT_LIGHTNING);
    
    p.armorvalue = 0;
	p.items = p.items - (p.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	p.ammo_shells = 20;
	p.ammo_nails = 0;
	p.ammo_rockets = 0;
	p.ammo_cells = 0;
    p.max_health = 250;
    p.health = 100;
    return p;
}

