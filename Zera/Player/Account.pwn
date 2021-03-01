#if !defined __PLAYER_ACCOUNT__
#define __PLAYER_ACCOUNT__

InitModule("Player_Account")
{
	Account_Initialize();

	contloop (new playerid : playerList)
	{
		if (introStarted[playerid] == 0) StartIntroForPlayer(playerid);
	}

	AddEventHandler(D_PlayerConnect, "P_Account_PlayerConnect");
	AddEventHandler(D_PlayerDisconnect, "P_Account_PlayerDisconnect");
	AddEventHandler(D_PlayerSpawn, "P_Account_PlayerSpawn");
	AddEventHandler(introFinishEvent, "P_Account_PlayerIntroFinish");
	AddEventHandler(sobeitCheckPass, "P_Account_SobeitCheckPass");
	AddEventHandler(D_PlayerCommandText, "P_Account_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "P_Account_DialogResponse");
	AddEventHandler(playerSecondTimer, "P_Account_PlayerSecondTimer");
}

function Account_Initialize()
{
	playerInfo[MAX_PLAYERS][pIndex] = -1;
	playerInfo[MAX_PLAYERS][pLevel] = 1;
}

function SavePlayerAccount(playerid, register = 0)
{
	if (register != 1 && IsPlayerLoggedIn(playerid) == 0) return 0;

	new query[1024];

	format(query, sizeof(query), "UPDATE account SET P_Level=%d", playerInfo[playerid][pLevel]);

	MySQLInt(query, sizeof(query), "P_Exp", playerInfo[playerid][pExp]);
	MySQLInt(query, sizeof(query), "P_Money", playerInfo[playerid][pMoney]);
	MySQLInt(query, sizeof(query), "P_ZeraMember", playerInfo[playerid][pZeraMember]);
	MySQLString(query, sizeof(query), "P_NickName", playerInfo[playerid][pNickName]);

	format(query, sizeof(query), "%s WHERE P_id=%d", query, playerInfo[playerid][pIndex]);

	mysql_tquery(MySQL, query, "OnSavePlayerAccount", "iii", playerid, playerInfo[playerid][pIndex], register);

	return 1;
}

public OnSavePlayerAccount(playerid, index, register)
{
	if (!IsPlayerConnected(playerid) || playerInfo[playerid][pIndex] != index) return;

	new error;

	if ((error = mysql_errno(MySQL)) != 0 || cache_affected_rows() == -1)
	{
		new string[145];

		format(string, sizeof(string), "계정 저장 도중 오류가 발생했습니다. (에러코드: %d)", (error != 0) ? error : -1);
		ServerLog(LOG_TYPE_MYSQL, string);

		if (register == 1)
		{
			ServerClientMessage(playerid, "계정 등록 중 오류가 발생했습니다. 다시 시도합니다.");
			SavePlayerAccount(playerid, 1);
		}
		else if (register == 2) ServerClientMessage(playerid, "계정 저장을 실패했습니다. 다시 시도해 주세요.");

		return;
	}

	if (register == 1)
	{
		haveAccount[playerid] = 1;

		ServerClientMessage(playerid, "계정 생성이 완료되었습니다. 로그인해 주세요.");
		ShowPlayerLoginDialog(playerid);
	}
	else if (register == 2) ServerClientMessage(playerid, "계정 저장이 완료되었습니다!");
}

function TryPlayerLogin(playerid, const password[])
{
	new query[256];

	mysql_format(MySQL, query, sizeof(query), "SELECT * FROM account WHERE P_id=%d AND P_Password=SHA2('%e',256)", playerInfo[playerid][pIndex], password);
	mysql_tquery(MySQL, query, "OnPlayerLogin", "ii", playerid, playerInfo[playerid][pIndex]);
}

public OnPlayerLogin(playerid, index)
{
	if (!IsPlayerConnected(playerid) || playerInfo[playerid][pIndex] != index) return;

	new string[145];
	new error;

	if ((error = mysql_errno(MySQL)) != 0)
	{
		format(string, sizeof(string), "계정 로그인 도중 오류가 발생했습니다. (에러코드: %d)", error);
		ServerLog(LOG_TYPE_MYSQL, string);

		return;
	}

	new rows;

	cache_get_row_count(rows);

	if (rows == 0)
	{
		if (++loginFailed[playerid] >= MAX_LOGIN_TRY)
		{
			ServerClientMessage(playerid, "비밀번호를 "#MAX_LOGIN_TRY"번 이상 틀려 접속이 종료됩니다.");

			Kick(playerid);
		}
		else
		{
			format(string, sizeof(string), "비밀번호가 일치하지 않습니다. 남은 시도 횟수는 %d번 입니다.", MAX_LOGIN_TRY - loginFailed[playerid]);
			ServerClientMessage(playerid, string);

			ShowPlayerLoginDialog(playerid);
		}

		return;
	}

	cache_get_value_name_int(0, "P_Level", playerInfo[playerid][pLevel]);
	cache_get_value_name_int(0, "P_Exp", playerInfo[playerid][pExp]);
	cache_get_value_name_int(0, "P_Money", playerInfo[playerid][pMoney]);
	cache_get_value_name_int(0, "P_ZeraMember", playerInfo[playerid][pZeraMember]);
	cache_get_value_name(0, "P_NickName", playerInfo[playerid][pNickName], MAX_PLAYER_NAME);

	LoadPlayerItems(playerid);
}

function OnPlayerLoginFinish(playerid)
{
	loggedIn[playerid] = 1;

	SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
	old_GivePlayerMoney(playerid, -old_GetPlayerMoney(playerid) + playerInfo[playerid][pMoney]);
	FadeCamera(playerid, false, 1.75);

	loginTime[playerid] = 3;
}

public P_Account_PlayerConnect(playerid)
{
	playerInfo[playerid] = playerInfo[MAX_PLAYERS];
	haveAccount[playerid] = 0;
	loggedIn[playerid] = 0;
	saveAccount[playerid] = 0;
	loginTime[playerid] = 0;
	loginFailed[playerid] = 0;
	tempPassword[playerid] = "";
	oldSaveTime[playerid] = 0;

	return 0;
}

public P_Account_PlayerDisconnect(playerid)
{
	if (IsPlayerLoggedIn(playerid)) SavePlayerAccount(playerid);

	return 0;
}

public P_Account_PlayerSpawn(playerid)
{
	if (loggedIn[playerid] == 0)
	{
		TogglePlayerControllable(playerid, 0);
		
		StartIntroForPlayer(playerid);

		return 1;
	}

	if (IsPlayerSobeitChecked(playerid) == 0)
	{
		#if DEBUG_MODE == 0
			CheckSobeit(playerid);

			return 1;
		#else
			CallSobeitCheckPassEvent(playerid);
		#endif
	}

	return 0;
}

public P_Account_PlayerIntroFinish(playerid)
{
	CheckPlayerAccount(playerid);
}

public P_Account_SobeitCheckPass(playerid)
{
	if (loggedIn[playerid] == 1)
	{
		loggedIn[playerid] = 2;

		#if DEBUG_MODE == 0
			SpawnPlayer(playerid);
		#endif
		SetPlayerJoinGame(playerid);
		SetPlayerColor(playerid, 0xAAAAAA00);
	}
}

public P_Account_PlayerCommandText(playerid, const command[], params[])
{
	new token_start, token_end;

	if (strcmp(command, "/저장") == 0 || strcmp(command, "/sav", true) == 0)
	{
		new now = GetTickCount(), coolTime = now - oldSaveTime[playerid];

		if (coolTime < 15000)
		{
			new string[145];

			format(string, sizeof(string), "당신은 아직 %d초 동안 계정을 저장할 수 없습니다.", (15000 - coolTime) / 1000);
			ServerClientMessage(playerid, string);

			return 1;
		}

		oldSaveTime[playerid] = now;

		ServerClientMessage(playerid, "계정을 저장 중입니다. 잠시만 기다려 주세요..");
		SavePlayerAccount(playerid, 2);

		return 1;
	}

	if (strcmp(command, "/스탯") == 0 || strcmp(command, "/내정보") == 0 || strcmp(command, "/stat", true) == 0)
	{
		ShowPlayerStat(playerid);

		return 1;
	}

	if (strcmp(command, "/거래") == 0 || strcmp(command, "/deal", true) == 0)
	{
		token_start = strtok_r(params, COMMAND_DELIMITER, token_end);
		if (token_start == -1) return ServerClientMessage(playerid, "사용법: {FFFFFF}/거래 [플레이어 번호/이름의 부분] [돈 액수]", .tag = "Command");

		new targetid = ReturnUser(params[token_start]);

		if (!IsPlayerConnected(targetid)) return ServerClientMessage(playerid, "접속하지 않은 플레이어입니다.");

		new amount;

		token_start = strtok_r(params, COMMAND_DELIMITER, token_end);
		if (token_start == -1) return ServerClientMessage(playerid, "사용법: {FFFFFF}/거래 [플레이어 번호/이름의 부분] [돈 액수]", .tag = "Command");

		amount = strval(params[token_start]);
		if (amount < 1 || amount > MAX_GIVE_MONEY_AMOUNT) return ServerClientMessage(playerid, "잘못된 액수입니다. $1~$"#MAX_GIVE_MONEY_AMOUNT" 사이로 거래가 가능합니다.");
		if (GetPlayerMoney(playerid) < amount) return ServerClientMessage(playerid, "당신은 거래할 돈이 부족합니다.");

		new string[145];

		GivePlayerMoney(playerid, -amount);
		GivePlayerMoney(targetid, amount);

		format(string, sizeof(string), "당신은 %s(id:%d)님에게 $%d을(를) 주었습니다.", playerName[targetid], targetid, amount);
		ServerClientMessage(playerid, string, .tag = "Deal");

		format(string, sizeof(string), "%s(id:%d)님이 당신에게 $%d을(를) 주었습니다.", playerName[targetid], targetid, amount);
		ServerClientMessage(playerid, string, .tag = "Deal");

		format(string, sizeof(string), "%s(id:%d)님이 %s(id:%d)님에게 $%d을(를) 주었습니다.", playerName[playerid], playerid, playerName[targetid], targetid, amount);
		SendClientMessageToGamePlayers(string, .tag = "Deal");

		return 1;
	}

	return 0;
}

public P_Account_DialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
	if (dialogid == DIALOG_REGISTER)
	{
		if (response == 0)
		{
			ServerClientMessage(playerid, "로그인을 하셔야 서버를 이용할 수 있습니다.");

			Kick(playerid);

			return 1;
		}

		new length;

		if ((length = strlen(inputtext)) < 4 || length > 16)
		{
			ServerClientMessage(playerid, "비밀번호는 4자 이상, 16자 이하로 설정해 주세요.");
			ShowPlayerLoginDialog(playerid);

			return 1;
		}

		strcpy(tempPassword[playerid], inputtext, 17);

		ShowPlayerLoginDialog(playerid, 1);

		return 1;
	}

	if (dialogid == DIALOG_REGISTER + 1)
	{
		if (response == 0)
		{
			ShowPlayerLoginDialog(playerid);

			return 1;
		}
		
		if (IsNull(inputtext))
		{
			ShowPlayerLoginDialog(playerid, 1);

			return 1;
		}

		if (strcmp(inputtext, tempPassword[playerid]) == 0) CreatePlayerAccount(playerid);
		else
		{
			ServerClientMessage(playerid, "설정한 비밀번호와 일치하지 않습니다. 다시 입력해 주세요.");
			ShowPlayerLoginDialog(playerid, 1);
		}

		return 1;
	}

	if (dialogid == DIALOG_LOGIN)
	{
		if (response == 0)
		{
			ServerClientMessage(playerid, "서버에 로그인하지 않으면 서비스를 이용할 수 없습니다.");
			Kick(playerid);

			return 1;
		}

		TryPlayerLogin(playerid, inputtext);

		return 1;
	}

	return 0;
}

public P_Account_PlayerSecondTimer(playerid)
{
	if (loginTime[playerid] != 0)
	{
		if (--loginTime[playerid] == 0)
		{
			TogglePlayerControllable(playerid, 1);
			SpawnPlayer(playerid);
		}
	}

	if (IsPlayerLoggedIn(playerid))
	{
		new money;

		if ((money = old_GetPlayerMoney(playerid)) != GetPlayerMoney(playerid)) old_GivePlayerMoney(playerid, -money + GetPlayerMoney(playerid));
	}

	return 0;
}

function CheckPlayerAccount(playerid)
{
	new query[128];

	mysql_format(MySQL, query, sizeof(query), "SELECT P_id FROM account WHERE P_Name = '%e' LIMIT 1", playerName[playerid]);
	mysql_tquery(MySQL, query, "OnCheckPlayerAccount", "is", playerid, playerName[playerid]);
}

public OnCheckPlayerAccount(playerid, const name[])
{
	if (!IsPlayerConnected(playerid) || strcmp(playerName[playerid], name, true) != 0) return;

	new string[145];
	new error;

	if ((error = mysql_errno(MySQL)) != 0)
	{
		format(string, sizeof(string), "계정 조회 도중 오류가 발생했습니다. (에러코드: %d)", error);
		ServerLog(LOG_TYPE_MYSQL, string);

		return;
	}

	cache_get_row_count(haveAccount[playerid]);

	if (haveAccount[playerid] != 0) cache_get_value_name_int(0, "P_id", playerInfo[playerid][pIndex]);

	ShowPlayerLoginDialog(playerid);
}

function CreatePlayerAccount(playerid)
{
	new query[256];
	new year, month, day;

	getdate(year, month, day);

	mysql_format(MySQL, query, sizeof(query), "INSERT INTO account (P_Name,P_Password,P_RegisterDate) VALUES('%s',SHA2('%e',256),'%04d-%02d-%02d')",
		playerName[playerid], tempPassword[playerid], year, month, day);
	mysql_tquery(MySQL, query, "OnCreatePlayerAccount", "is", playerid, playerName[playerid]);
}

public OnCreatePlayerAccount(playerid, const name[])
{
	if (!IsPlayerConnected(playerid) || strcmp(playerName[playerid], name, true) != 0) return;

	new string[145];
	new error, insertID;

	if ((error = mysql_errno(MySQL)) != 0 || (insertID = cache_insert_id()) == -1)
	{
		format(string, sizeof(string), "계정 가입 도중 오류가 발생했습니다. (에러코드: %d)", (error != 0) ? error : -1);
		ServerLog(LOG_TYPE_MYSQL, string);

		return;
	}

	playerInfo[playerid][pIndex] = insertID;

	SavePlayerAccount(playerid, 1);
}

function ShowPlayerLoginDialog(playerid, register = 0)
{
	if (loggedIn[playerid] != 0) return;

	if (haveAccount[playerid] == 0)
	{
		if (register == 1)
		{
			ShowPlayerDialog(playerid, DIALOG_REGISTER + 1, DIALOG_STYLE_PASSWORD, "비밀번호 확인", "방금 입력한 비밀번호를 다시 한 번 입력해 주세요.", "가입", "이전");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "가입", "당신은 계정이 없습니다.\n계정의 비밀번호를 설정해 주세요.\n\
				비밀번호는 4자 이상, 16자 이하로 해주세요.", "확인", "거절");
		}
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "로그인", "당신은 계정이 존재합니다.\n계정 비밀번호를 입력해 주세요.", "로그인", "거절");
	}
}

function IsPlayerLoggedIn(playerid)
{
	return (IsPlayerConnected(playerid) && loggedIn[playerid] == 2);
}

stock Qoo_GivePlayerMoney(playerid, money)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;

	playerInfo[playerid][pMoney] += money;

	return old_GivePlayerMoney(playerid, money);
}

function GivePlayerExp(playerid, amount)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;

	playerInfo[playerid][pExp] += amount;

	if (playerInfo[playerid][pLevel] > 0 && playerInfo[playerid][pExp] > 0)
	{
		new multiple = (playerInfo[playerid][pLevel] * LEVEL_UP_EXP_MULTIPLIER);
		new levelUp = playerInfo[playerid][pExp] / multiple;

		if (levelUp > 0)
		{
			new string[145];

			playerInfo[playerid][pLevel] += levelUp;
			playerInfo[playerid][pExp] %= multiple;

			SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
			SavePlayerAccount(playerid);

			format(string, sizeof(string), "축하합니다! 레벨이 %d로 올랐습니다.", playerInfo[playerid][pLevel]);
			ServerClientMessage(playerid, string);
		}
	}

	return 1;
}

function ShowPlayerStat(playerid, showplayerid = INVALID_PLAYER_ID, type = 0)
{
	if (showplayerid == INVALID_PLAYER_ID) showplayerid = playerid;
	if (IsPlayerLoggedIn(playerid) == 0 || IsPlayerLoggedIn(showplayerid) == 0) return 0;

	new string[1024];

	format(string, sizeof(string), "ID: %s\t레벨: %d\tEXP: [%d/%d]\t돈: $%d", playerName[playerid], playerInfo[playerid][pLevel],
		playerInfo[playerid][pExp], (playerInfo[playerid][pLevel] * LEVEL_UP_EXP_MULTIPLIER), playerInfo[playerid][pMoney]);
	
	if (type == 0) ShowPlayerDialog(showplayerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "계정 정보", string, "확인", "");
	else if (type == 1) ShowPlayerDialog(showplayerid, DIALOG_INVENTORY + 3, DIALOG_STYLE_MSGBOX, "계정 정보", string, "확인", "");

	return 1;
}

#endif
