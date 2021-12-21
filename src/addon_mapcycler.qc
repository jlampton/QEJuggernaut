// Add this file to progs.src, at the end

// Define your options here
#define MAPCYCLER_MODNAME "qerocketonly"


//
// Addon code
//
#pragma warning disable F321
__accumulate void() worldspawn =
{
    localcmd("exec mapcycle_"MAPCYCLER_MODNAME".cfg\n");
}
#pragma warning enable F321

float changingMap;
__wrap void() GotoNextMap =
{
    if(changingMap)
        return;

    // Execute nextmap alias, if available
    localcmd("nextmap_");
    localcmd(mapname);
    localcmd("\n");

    changingMap = TRUE;

    local entity ent = spawn();
    ent.think = prior;
    ent.nextthink = time + 0.25;
}

__wrap void() NextLevel =
{
    local entity o = find(world, classname, "trigger_changelevel");

    // Create a fake trigger changelevel if it doesn't exist
    if(!o)
    {
        o = spawn();
        o.classname = "trigger_changelevel";
        o.map = "start";
    }

    prior();
}