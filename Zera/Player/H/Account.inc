#if !defined __PLAYER_ACCOUNT_H__
#define __PLAYER_ACCOUNT_H__

#define MAX_LOGIN_TRY 5
#define MAX_GIVE_MONEY_AMOUNT 100000

#define LEVEL_UP_EXP_MULTIPLIER 1000

enum E_PLAYER_INFO_LIST
{
	pIndex,
	pLevel,
	pExp,
	pMoney,
	pZeraMember,
	pNickName[MAX_PLAYER_NAME]
};

new playerInfo[MAX_PLAYERS + 1][E_PLAYER_INFO_LIST];

new haveAccount[MAX_PLAYERS];
new loggedIn[MAX_PLAYERS];
new saveAccount[MAX_PLAYERS];
new loginTime[MAX_PLAYERS];
new loginFailed[MAX_PLAYERS];
new tempPassword[MAX_PLAYERS][17];
new oldSaveTime[MAX_PLAYERS];

forward P_Account_Initialize();

forward P_Account_PlayerConnect(playerid);
forward P_Account_PlayerDisconnect(playerid);
forward P_Account_PlayerSpawn(playerid);
forward P_Account_PlayerIntroFinish(playerid);
forward P_Account_SobeitCheckPass(playerid);
forward P_Account_PlayerCommandText(playerid, const command[], params[]);
forward P_Account_DialogResponse(playerid, dialogid, response, listitem, const inputtext[]);
forward P_Account_PlayerSecondTimer(playerid);

forward SavePlayerAccount(playerid, register = 0);
forward TryPlayerLogin(playerid, const password[]);
forward CheckPlayerAccount(playerid);
forward CreatePlayerAccount(playerid);
forward ShowPlayerLoginDialog(playerid, register = 0);
forward IsPlayerLoggedIn(playerid);
forward GivePlayerExp(playerid, amount);
forward ShowPlayerStat(playerid, showplayerid = INVALID_PLAYER_ID, type = 0);

forward OnCheckPlayerAccount(playerid, const name[]);
forward OnSavePlayerAccount(playerid, index, register);
forward OnPlayerLogin(playerid, index);
forward OnCreatePlayerAccount(playerid, const name[]);

#endif
