#if !defined __GAME_SURVIVAL_H__
#define __GAME_SURVIVAL_H__

#define NORMAL_ELIMINATED_EXP 75
#define NORMAL_ELIMINATED_MONEY 50

#define LAST_ELIMINATED_EXP 100
#define LAST_ELIMINATED_MONEY 100

#define MAP_ARRIVE_MONEY 100

#define MIN_PLAYER_MOVE 2.0
#define MAX_PLAYER_NO_MOVE_TIME 20

#define MAX_PAUSE_TIME 20

enum E_DEATH_INFO_LIST
{
	diPlayer,
	diName[MAX_PLAYER_NAME],
	diHour,
	diMinute,
	diSecond
};

new deathInfo[MAX_PLAYERS][E_DEATH_INFO_LIST];

new playerEliminatedEvent;

new deathListIndex = -1;
new deathListMaxIndex = -1;

new survive[MAX_PLAYERS];
new playerNoMove[MAX_PLAYERS];

new Float: lastPosX[MAX_PLAYERS];
new Float: lastPosY[MAX_PLAYERS];
new Float: lastPosZ[MAX_PLAYERS];

forward G_Survival_PlayerConnect(playerid);
forward G_Survival_PlayerSpawn(playerid);
forward G_Survival_PlayerKeyStateChange(playerid, newkeys);
forward G_Survival_PlayerDeath(playerid);
forward G_Survival_PlayerDisconnect(playerid);
forward G_Survival_PlayerCommandText(playerid, const command[], const params[]);
forward G_Survival_PlayerSecondTimer(playerid);
forward G_Survival_GamemodeMapStart();
forward G_Survival_PlayerMapStart(playerid);
forward G_Survival_PlayerEliminated(playerid, oldsurvive);
forward G_Survival_PlayerPaused(playerid);

forward SetPlayerEliminate(playerid, respawn = 0);
forward UpdateDeathList(deathPlayer = INVALID_PLAYER_ID);
forward UpdatePlayerDeathList(playerid);

#endif
