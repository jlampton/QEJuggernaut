# QE Hunter
Quake Enhanced Juggernaut (A modification of the QEHunter mod by [JPiolho.](https://github.com/jpiolho/QEHunter))

This is a multiplayer mod where one player is the Juggernaut. The Juggernaut starts with a buffed health and armor amount.
The Juggernaut does 1.5x damage (6x when Quad Damage is picked up) and takes 1/2 damage.
Health pickups aren't allowed until the Juggernaut falls below 250 health. All health pickups are worth double their normal amount.
Armor pickups are always allowed with a cap at 400. Any armor pickup is worth double.
The juggernaut does not deal damage to itself, but everyone else does do self damage.

All other players are against the Juggernaut. 

If the Juggernaut dies due to the environment, a random player becomes the Juggernaut.
If a player kills the Juggernaut, they become the new Juggernaut. 

# Download
* [QEThings MPMods](https://mpmods.qethings.xyz) - Automatic install
* [Github Release](https://github.com/jlampton/QEJuggernaut/releases/latest) - Manual install

# Information

## How to manually install
1. Go to your 'Saved games' quake folder, NOT THE STEAM FOLDER. You can go to it by pressing Windows+R and typing: `%userprofile%\Saved Games\Nightdive Studios\Quake`
2. If a folder called '`id1`' already exists, delete it.
3. Extract zip into the 'Saved games' folder.
4. Verify that `id1` and `mpmod` folder are now inside 'Saved games'.

## How to run the mod
**NOTE:** If you're using [QEThings MPMods](https://mpmods.qethings.xyz), follow the instructions for it instead.

1. Open console and type `game mpmod`
2. Start a multiplayer game. The mod will start automatically.

## Server things

### Mapcycler
This mod features mapcycler config support. At the start of each map the following cfg will be executed: `mapcycler_qehunter.cfg`

Whenever the game decides to changelevel, it will run the following alias `nextmap_<current map name>`.

An example mapcycler would be:
```
alias "nextmap_dm4" "changelevel dm5"
alias "nextmap_dm5" "changelevel dm6"
alias "nextmap_dm6" "changelevel dm7"
alias "nextmap_dm7" "changelevel dm8"
alias "nextmap_dm8" "changelevel e1m2"
alias "nextmap_e1m2" "changelevel dm2"
alias "nextmap_dm2" "changelevel dm4"
```

## Credits
JLampton: Author

Originally Forked From https://github.com/jpiolho/QEHunter written by JPiolho.

