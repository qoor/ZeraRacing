#if !defined __QAC_SOBEIT_H__
#define __QAC_SOBEIT_H__

#define SOBEIT_CHECK_INIT_TIME 5
#define SOBEIT_CHECK_TIME 10

new sobeitCheckPass;

new sobeitCheck[MAX_PLAYERS];

forward QAC_Sobeit_PlayerConnect(playerid);
forward QAC_Sobeit_PlayerSpawn(playerid);
forward QAC_Sobeit_PlayerSecondTimer(playerid);

forward CheckSobeit(playerid);
forward StopCheckSobeit(playerid);
forward IsPlayerSobeitChecked(playerid);
forward CallSobeitCheckPassEvent(playerid);

#endif
