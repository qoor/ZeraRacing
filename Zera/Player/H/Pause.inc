#if !defined __PLAYER_PAUSE_H__
#define __PLAYER_PAUSE_H__

new playerPausedEvent;

new paused[MAX_PLAYERS];
new pauseTime[MAX_PLAYERS];
new pauseNoticed[MAX_PLAYERS];

forward P_Pause_PlayerConnect(playerid);
forward P_Pause_PlayerUpdate(playerid);
forward P_Pause_PlayerSecondTimer(playerid);

forward IsPlayerPaused(playerid);
forward GetPlayerPauseTime(playerid);

#endif
