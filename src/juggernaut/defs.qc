.float juggernautTeam;
float gamemode;
float juggernaut_status;

float GM_HOST_JUGGERNAUT_START = 1;

float JUGGERNAUT_STATUS_ROUND_STARTING = 0;
float JUGGERNAUT_STATUS_ROUND_IN_PROGRESS = 1;

float JUGGERNAUT_FL_SEEN_STARTING_MESSAGE = 1;
float JUGGERNAUT_FL_CANT_RESPAWN = 2;

float JUGGERNAUT_TEAM_NONE = 1;
float JUGGERNAUT_TEAM_JUGGERNAUT = 5;
float JUGGERNAUT_TEAM_HUNTER = 12;

// Health buff and armor buff maximums for after the initial super buff is gone.
// We want the Juggernaut to be able to maintain a health level of 250 and an armor level of 400.
float JUGGERNAUT_HEALTH_BUFF_REPLENISH_LEVEL_CAP = 250;
float JUGGERNAUT_ARMOR_BUFF_REPLENISH_LEVEL_CAP = 400;
float JUGGERNAUT_HEALTH_BUFF_REPLENISH_LEVEL_CAP_MEGAHEALTH = 400;

// Initial health and armor buff amounts
float JUGGERNAUT_INITIAL_HEALTH_BUFF = 600;
float JUGGERNAUT_INITIAL_ARMOR_BUFF = 400;

// Juggernaut damage and defense buffs
float JUGGERNAUT_DAMAGE_DEALT_MULTIPLIER = 1;
float JUGGERNAUT_DAMAGE_TAKEN_MULTIPLIER = 1;

string JUGGERNAUT_SOUND_JUGGERNAUT_DEATH = "shalrath/death.wav";
string JUGGERNAUT_SOUND_JUGGERNAUT_PAIN = "shalrath/pain.wav";
string JUGGERNAUT_SOUND_JUGGERNAUT_LAND = "demon/dland2.wav";

string JUGGERNAUT_SOUND_HIT = "misc/menu3.wav";

#define invisibleTime lip