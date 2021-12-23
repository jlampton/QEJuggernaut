float modelindex_eyes;
float modelindex_player;

void(float corpse) respawn;

void(entity player,float newTeam) Juggernaut_SetTeam =
{
    player.team = player.juggernautTeam = newTeam;

    // Send the player colors
    stuffcmd(player,"color ");
    stuffcmd(player,ftos(player.team-1));
    stuffcmd(player,"\n");
}

void() Juggernaut_SwapTeams_Think =
{
    Juggernaut_SetTeam(self.owner,JUGGERNAUT_TEAM_HUNTER);
    Juggernaut_SetTeam(self.enemy,JUGGERNAUT_TEAM_JUGGERNAUT);

    ExecuteAs(respawn(FALSE),self.enemy);

    if(self.owner.deadflag != DEAD_NO) {
        ExecuteAs(respawn(FALSE),self.owner);
    }
}

void() Juggernaut_ReassignJuggernaut_Think =
{
    dprint("Reassigning Juggernaut...\n");

    local entity newJuggernaut;
    newJuggernaut = RandomPlayer();

    dprint("\"");
    dprint(newJuggernaut.netname);
    dprint("\" is the new Juggernaut\n");

    Juggernaut_SetTeam(newJuggernaut, JUGGERNAUT_TEAM_JUGGERNAUT);

    ExecuteAs(respawn(FALSE),newJuggernaut);

    centerprint(newJuggernaut, "You've been changed to Juggernaut due to the previous player quitting.\n");

    if(newJuggernaut == self) {
        return;
    }
    // If there was a previous Juggernaut then set them as a hunter.
    if(self && self.owner) {
        Juggernaut_SetTeam(self.owner, JUGGERNAUT_TEAM_HUNTER);
        self.owner.cnt -= self.owner.cnt & JUGGERNAUT_FL_CANT_RESPAWN;
        ExecuteAs(respawn(FALSE),self.owner);
    }
}

void(entity attacker) Juggernaut_Killed =
{
    // Check if the killer is a hunter
	if(attacker && attacker.classname == "player"
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
	} else {
        if(self.oldenemy)
        {
            // Swap teams
            local entity swap = ExecuteDelayed(Juggernaut_SwapTeams_Think,3.0);
            swap.owner = self;
            swap.enemy = self.oldenemy;
        }
        else {
            // The Juggernaut died before anybody hurting them. Choose randomly
            local entity swap = ExecuteDelayed(Juggernaut_ReassignJuggernaut_Think,3.0);
            swap.owner = self;
        }

        self.cnt |= JUGGERNAUT_FL_CANT_RESPAWN;
    }
}

void(entity target) Juggernaut_PrintSpawnMessage =
{
    if(target.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT) {
        centerprint(target,"You are the Juggernaut\n\nYou have all weapons and full ammo.\nHealth and Armor are worth double.\nEveryone is coming for you!\n\nReady?");
    } else {
        centerprint(target,"You are a hunter\nFind the Juggernaut\nBe careful.. The Juggernaut is really strong.\nTeam up and eliminate them!");
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
       // Hide host
       if(juggernaut_host && Juggernaut_GetServerOptions() & SERVERSETTINGS_HIDEHOST) {
		ExecuteDelayed(Juggernaut_HideHost_Think,0.1).owner = self;
	}

    // Handle host mode
    if(juggernaut_host == self)
	{
        // Set noclip
		self.movetype = MOVETYPE_NOCLIP;
		self.solid = SOLID_NOT;

        // Set flags so bots and monsters don't target
		self.flags |= FL_FLY | FL_NOTARGET | FL_GODMODE;
		self.takedamage = DAMAGE_NO;

        // Remove weapons
		self.items = 0;
		self.weapon = IT_AXE;
		self.weaponmodel = string_null;

        // Remove the player model entirely
		setmodel (self, string_null);
		self.modelindex = modelindex_player; // Still allow the player to move around

        return;
	}

    // Remove 'cant respawn' flag
    self.cnt -= self.cnt & JUGGERNAUT_FL_CANT_RESPAWN;

    if(self.juggernautTeam == JUGGERNAUT_TEAM_JUGGERNAUT) {
        self = HydrateJuggernautPlayer(self);
        self.waitmin = time;
        self.pos1 = self.origin;
        self.impulse = 7; // grab rocket launcher to indicate that other weapons are available.
	}
    else {
        self = ResetNonJuggernautPlayer(self);
        self.impulse = 2; // Set back to shotgun to remove any remnants of the last weapon used.
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