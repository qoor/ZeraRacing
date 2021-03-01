#if !defined _GAME_GHOST_H
#define _GAME_GHOST_H

new ghostMode[MAX_PLAYERS];

forward G_Ghost_PlayerConnect(playerid);
forward G_Ghost_PlayerKeyStateChange(playerid, newkeys);
forward G_Ghost_PlayerMapStart(playerid);

forward IsPlayerEnabledGhostMode(playerid);

#endif
