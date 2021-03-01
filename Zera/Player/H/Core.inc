#if !defined __PLAYER_CORE_H__
#define __PLAYER_CORE_H__

new playerName[MAX_PLAYERS][MAX_PLAYER_NAME];
new ipAddress[MAX_PLAYERS][16];

forward P_Core_PlayerConnect(playerid);
forward P_Core_PlayerRequestClass(playerid);
forward P_Core_PlayerCommandText(playerid);
forward P_Core_PlayerCommandTextFail(playerid, const command[]);
forward P_Core_PlayerDisconnect(playerid, reason);
forward P_Core_PlayerStateChange(playerid, newstate, oldstate);

forward PlayerKill(playerid);
forward RandomSkin();
forward IsNumeric(const string[]);
forward ReturnUser(const text[], playerid = INVALID_PLAYER_ID);

#endif
