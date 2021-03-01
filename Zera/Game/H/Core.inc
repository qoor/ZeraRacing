#if !defined _GAME_CORE_H
#define _GAME_CORE_H

#define ROUND_TIME 1800
#define MAX_SPAWN_POINTS MAX_PLAYERS

enum E_GAME_INFO_LIST
{
	gGameCount,
	gPlayers,
	gLoadedPlayers,
	gTimeLeft,
	gGameStartTime,
	gSurvivePlayers,
	gSpawnPointCount,
	Float: gSpawnPointX[MAX_SPAWN_POINTS],
	Float: gSpawnPointY[MAX_SPAWN_POINTS],
	Float: gSpawnPointZ[MAX_SPAWN_POINTS],
	Float: gSpawnPointA[MAX_SPAWN_POINTS],
	gSpawnCarModel[MAX_SPAWN_POINTS],
	Text3D: gMaxText3Ds,
	gWinner
};

new gameInfo[E_GAME_INFO_LIST];

new playerMapStartEvent;

new startDelayTimer;

new mapChanging;

new respawnTime[MAX_PLAYERS];
new notReady[MAX_PLAYERS];

new burst[MAX_PLAYERS];
new jump[MAX_PLAYERS];

new Float: spawnPositionX[MAX_PLAYERS];
new Float: spawnPositionY[MAX_PLAYERS];
new Float: spawnPositionZ[MAX_PLAYERS];
new Float: spawnPositionA[MAX_PLAYERS];

forward Game_Initialize();
forward G_Core_GameModeExit();
forward G_Core_PlayerConnect(playerid);
forward G_Core_PlayerSpawn(playerid);
forward G_Core_PlayerCommandText(playerid, const command[]);
forward G_Core_PlayerUpdate(playerid);
forward G_Core_PlayerExitVehicle(playerid);
forward G_Core_PlayerDeath(playerid);
forward G_Core_PlayerDisconnect(playerid);
forward G_Core_PlayerKeyStateChange(playerid, newkeys);
forward G_Core_PlayerStateChange(playerid, newstate);
forward G_Core_GlobalSecondTimer();
forward G_Core_PlayerSecondTimer(playerid);
forward G_Core_PlayerPaused(playerid);
forward G_Core_GamemodeMapStart();
forward G_Core_RemoveMapElements();
forward G_Core_PlayerEliminated(playerid);
forward G_Core_PlayerMapStart(playerid);

forward SetGameStartTime();
forward SetTimeLeftTime(time);
forward OnRequestMapStart(status);
forward SetRequestMapStart(coolTime = 0);
forward IsGameProgress();
forward UpdateGameTimeText();
forward SetPlayerJoinGame(playerid);
forward SetPlayerNotReady(playerid);
forward SetPlayerReady(playerid);
forward GetNotReadyPlayerCount();

#endif
