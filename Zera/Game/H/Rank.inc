#if !defined __GAME_RANK_H__
#define __GAME_RANK_H__

new ranker[MAX_MAPS][11][MAX_PLAYER_NAME];
new rankTime[MAX_MAPS][11];
new rankDate[MAX_MAPS][11][11];

new rankBoardTime[MAX_PLAYERS];

forward G_Rank_PlayerConnect(playerid);
forward G_Rank_PlayerCommandText(playerid, const command[], const params[]);
forward G_Rank_PlayerSecondTimer(playerid);
forward G_Rank_GamemodeMapStart();

forward LoadRanking();
forward UpdateRanking(mapid, playerid, time);
forward IsPlayerRankingShow(playerid);
forward UpdateRankingBoard();

#endif
