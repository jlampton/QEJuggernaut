float modelindex_eyes;
float modelindex_player;

void(float corpse) respawn;


void() Juggernaut_SwapTeams_Think =
{
    self.owner.juggernautTeam = JUGGERNAUT_TEAM_HUNTER;
    self.enemy.juggernautTeam = JUGGERNAUT_TEAM_JUGGERNAUT;

    ExecuteAs(respawn(FALSE),self.enemy);

    if(self.owner.deadflag != DEAD_NO) {
        ExecuteAs(respawn(FALSE),self.owner);
    }
}

void() Juggernaut_ReassignJuggernaut_Think =
{
    dprint("Reassigning Juggernaut...\n");

    local entity p;
    local float foundHunter = FALSE;

    // Loop through all the players until we find a new hunter
    while((p = LoopPlayers(p)))
    {
        // Sometimes, the juggernaut may die due to the environment. 
        // If so, remove them and respawn as a hunter.
        if(p.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT){
            // Ignore any inputs from the player until they are forced to respawn.
            p.juggernautTeam = JUGGERNAUT_TEAM_HUNTER;
            ExecuteAs(respawn(FALSE),p);
        }else {
            if(!foundHunter && p.juggernautTeam != JUGGERNAUT_TEAM_JUGGERNAUT)
            {
                // Winner!
                dprint("\"");
                dprint(p.netname);
                dprint("\" is the new Juggernaut\n");
    
                p.juggernautTeam = JUGGERNAUT_TEAM_JUGGERNAUT;
    
                ExecuteAs(respawn(FALSE),p);
                foundHunter = TRUE;
                centerprint(p,"You've been changed to Juggernaut due to the previous player dying or quitting.\n");
            }
        }
    }
}

void(entity attacker) Juggernaut_Killed =
{
    // Check if the killer is a survivor
	if(attacker.classname == "player"
		&& attacker.juggernautTeam != JUGGERNAUT_TEAM_JUGGERNAUT)
	{
        local entity p;
        while((p = LoopPlayers(p)))
        {
            if(p == attacker || p == self)
            continue;
            
            centerprint(p,"The Juggernaut has been killed!\n");
        }

        centerprint(attacker,"You killed the Juggernaut\n");
        centerprint(self,"You've been killed by a hunter!\n");
        
        bprint(attacker.netname);
        bprint(" killed the Juggernaut!\n");

		// Swap teams
        local entity swap = ExecuteDelayed(Juggernaut_SwapTeams_Think,3.0);
        swap.owner = self;
        swap.enemy = attacker;

        // Mark both players as non-respawnable
        self.cnt |= JUGGERNAUT_FL_CANT_RESPAWN;
        attacker.cnt |= JUGGERNAUT_FL_CANT_RESPAWN;
	}
    else if(attacker.classname != "player") {
        self.cnt |= JUGGERNAUT_FL_CANT_RESPAWN;
        ExecuteDelayed(Juggernaut_ReassignJuggernaut_Think,5);
    }
}

void(entity target) Juggernaut_PrintSpawnMessage =
{
    if(target.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT) {
        centerprint(target,"You are the Juggernaut\n\nYou do 1.5x Damage, take half damage, and powerups are stronger.\nEveryone is coming for you!\n\nReady?");
    } else {
        centerprint(target,"You are a hunter\nFind the Juggernaut\n\nTeam up and eliminate them!");
    }
}

void() Juggernaut_ClientDisconnect =
{
    if(self.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT) {
        dprint("Juggernaut left the game\n");
        ExecuteDelayed(Juggernaut_ReassignJuggernaut_Think,5);
    }
}


void() Juggernaut_StartingMessage_Think =
{
    if(!self.enemy) {
        remove(self);
        return;
    }

    centerprint(self.enemy,"Welcome to Juggernaut!\nOne player (Juggernaut) is almost a god, the other players are here to kill the Juggernaut. \n\nAny bugs are probably related to the mod\nHave fun!");

    if(--self.cnt <= 0) {
        Juggernaut_PrintSpawnMessage(self.enemy);
        remove(self);
    }

    self.nextthink = time + 1.0;
}

void() Juggernaut_SpawnStartingMessageEntity =
{
    local entity s = spawn();
    s.enemy = self;
    s.cnt = 5;
    s.think = Juggernaut_StartingMessage_Think;
    s.nextthink = time + 1.0;
}

void() Juggernaut_OnGameStart =
{
    juggernaut_status = JUGGERNAUT_STATUS_ROUND_STARTING;
}

void() Juggernaut_OnPrecache =
{
    precache_sound(JUGGERNAUT_SOUND_JUGGERNAUT_DEATH);
    precache_sound(JUGGERNAUT_SOUND_JUGGERNAUT_LAND);
    precache_sound(JUGGERNAUT_SOUND_JUGGERNAUT_PAIN);
}

void() Juggernaut_PutClientInServer =
{
    // Remove 'cant respawn' flag
    self.cnt -= self.cnt & JUGGERNAUT_FL_CANT_RESPAWN;

    if(self.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT) {
        self = HydrateJuggernautPlayer(self);
        self.waitmin = time;
        self.pos1 = self.origin;
	}
    else {
       // self.alpha = 1;
    }

    Juggernaut_PrintSpawnMessage(self);
}

void(entity player) Juggernaut_AssignTeamToPlayer =
{
    if(juggernaut_status == JUGGERNAUT_STATUS_ROUND_STARTING)
    {
        local float numberJuggernauts = 0;
        local float numberHunters = 0;

        // Find out how many of each exist in the game
        local entity p = world;
        while((p = LoopPlayers(p)))
        {
            if(p.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT)
                numberJuggernauts++;
            else if(p.juggernautTeam == JUGGERNAUT_TEAM_HUNTER)
                numberHunters++;
        }

        // Assign the team. Prevent host from being juggernaut on start 
        // to allow absent hosting.
        if(numberHunters == 0)
        {
            player.juggernautTeam = JUGGERNAUT_TEAM_HUNTER;
        }
        else if(numberJuggernauts == 0)
        {
            player.juggernautTeam = JUGGERNAUT_TEAM_JUGGERNAUT;
        }
        else {
            player.juggernautTeam = JUGGERNAUT_TEAM_HUNTER;
        }

        // Set an impossible team so that the color is set in PlayerPreThink
        player.team = -1;
    }
}


void() Juggernaut_PlayerPreThink =
{
    if(self.team != self.juggernautTeam)
    {
        self.team = self.juggernautTeam;

        // Send the player colors
        stuffcmd(self,"color ");
        stuffcmd(self,ftos(self.team-1));
        stuffcmd(self,"\n");
    }

    if(!(self.cnt & JUGGERNAUT_FL_SEEN_STARTING_MESSAGE))
	{
        Juggernaut_SpawnStartingMessageEntity();

		// Mark as message sent
		self.cnt |= JUGGERNAUT_FL_SEEN_STARTING_MESSAGE;
	}

}