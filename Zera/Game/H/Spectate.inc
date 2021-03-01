#if !defined _GAME_SPECTATE_H
#define _GAME_SPECTATE_H

new spectatePlayer[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new lrKeyPressed[MAX_PLAYERS];

forward G_Spectate_PlayerConnect(playerid);
forward G_Spectate_PlayerSpawn(playerid);
forward G_Spectate_VehicleStreamOut(vehicleid, forplayerid);
forward G_Spectate_PlayerUpdate(playerid);
forward G_Spectate_PlayerKeyStateChange(playerid, newkeys);
forward G_Spectate_PlayerClickPlayer(playerid, clickplayerid);
forward G_Spectate_PlayerMapStart(playerid);
forward G_Spectate_PlayerEliminated(playerid);

forward SetPlayerSpectatePlayer(playerid, targetid);
forward ChangePlayerSpectatePlayer(playerid, lrKey);
forward UpdatePlayerSpectating(playerid);
forward StopPlayerSpectating(playerid);

#endif
