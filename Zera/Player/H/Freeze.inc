#if !defined __PLAYER_FREEZE_H__
#define __PLAYER_FREEZE_H__

new vehicleFreeze[MAX_PLAYERS];

forward P_Freeze_PlayerConnect(playerid);
forward P_Freeze_PlayerUpdate(playerid);
// forward P_Freeze_PlayerSecondTimer(playerid);

forward SetPlayerFreeze(playerid, Float: x, Float: y, Float: z, Float: angle);
forward SetPlayerUnfreeze(playerid);

#endif
