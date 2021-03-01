#if !defined __GAME_RANK__
#define __GAME_RANK__

InitModule("Game_Rank")
{
	AddEventHandler(D_PlayerConnect, "G_Rank_PlayerConnect");
	AddEventHandler(D_PlayerCommandText, "G_Rank_PlayerCommandText");
	AddEventHandler(playerSecondTimer, "G_Rank_PlayerSecondTimer");
	AddEventHandler(gamemodeMapStartEvent, "G_Rank_GamemodeMapStart");

	LoadRanking();
}

public G_Rank_PlayerConnect(playerid)
{
	rankBoardTime[playerid] = 0;

	return 0;
}

public G_Rank_PlayerCommandText(playerid, const command[])
{
	if (strcmp(command, "/랭킹") == 0 || strcmp(command, "/rank", true) == 0 || strcmp(command, "/ranking", true) == 0)
	{
		if (IsPlayerRankingShow(playerid) == 0)
		{
			ToggleRankingBoardForPlayer(playerid, 1);
			
			rankBoardTime[playerid] = 12;
		}
		else
		{
			ToggleRankingBoardForPlayer(playerid, 0);

			rankBoardTime[playerid] = 0;
		}

		return 1;
	}

	return 0;
}

public G_Rank_PlayerSecondTimer(playerid)
{
	if (rankBoardTime[playerid] != 0)
	{
		if (--rankBoardTime[playerid] == 0) ToggleRankingBoardForPlayer(playerid, 0);
	}

	return 0;
}

public G_Rank_GamemodeMapStart()
{
	UpdateRankingBoard();
}

function LoadRanking()
{
	new Cache: result = mysql_query(MySQL, "SELECT * FROM ranking");
	new errno;

	if ((errno = mysql_errno(MySQL)) != 0)
	{
		cache_delete(result);
		ServerLog(LOG_TYPE_MYSQL, "랭킹 정보를 불러오는 도중 오류가 발생했습니다.", errno);
		SetServerClose();

		return 1;
	}

	new rows;
	new index = -1;
	new mapid = -1;
	new haveRankMap[MAX_MAPS];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; ++i)
	{
		if (cache_get_value_name_int(i, "R_MapID", mapid) && IsValidMap(mapid))
		{
			if (cache_get_value_name_int(i, "R_Rank", index))
			{
				--index;
				
				if (haveRankMap[mapid] == 0) haveRankMap[mapid] = 1;

				cache_get_value_name(i, "R_Player", ranker[mapid][index], MAX_PLAYER_NAME);
				cache_get_value_name_int(i, "R_Time", rankTime[mapid][index]);
				cache_get_value_name(i, "R_Date", rankDate[mapid][index], 11);
			}
		}
	}

	cache_delete(result);

	return 0;
}

function UpdateRanking(mapid, playerid, time)
{
	if (!IsPlayerConnected(playerid) || IsValidMap(mapid) == 0 || time <= 0)
		return -1;

	new oldPlayerRank = -1;
	new requireRank = -1;

	for (new i = 9; i >= 0; --i)
	{
		if (IsNull(ranker[mapid][i]) == false && strcmp(playerName[playerid], ranker[mapid][i], true) == 0)
		{
			if (time >= rankTime[mapid][i]) // 자신의 기존 기록과 일치하거나 더 느리게 완주한 경우 랭킹 업데이트 안 함.
				return -1;
			
			oldPlayerRank = i;
			break;
		}
	}

	for (new i = 0; i < 10; ++i)
	{
		if (rankTime[mapid][i] == 0 || time < rankTime[mapid][i])
		{
			requireRank = i; // 업데이트 돼야 하는 랭킹
			break;
		}
	}

	if (requireRank == -1) // 랭킹 TOP 10에 들 수 없는 기록인 경우 랭킹 업데이트 안 함.
		return -1;

	if (oldPlayerRank != -1) // 자신의 기존 기록이 있는 경우 (중복 방지를 위한 조건문)
	{
		if (requireRank > oldPlayerRank) // 업데이트 돼야 하는 랭킹이 본인의 기존 랭킹보다 더 낮은 위치인 경우, 중복 랭킹 등록 방지를 위해 랭킹 업데이트 안 함.
			return -1;
		
		if (requireRank < oldPlayerRank) // 업데이트 돼야 하는 랭킹이 본인의 랭킹보다 더 높은 위치라면 본인의 기록을 지워야 함.
			DeleteRankData(mapid, oldPlayerRank);
	}
	
	InsertRankData(mapid, requireRank, playerid, time);
	return requireRank;
}

function InsertRankData(mapid, rank, playerid, time)
{
	new query[256];
	new year, month, day;
	new date[11];

	getdate(year, month, day);
	format(date, sizeof(date), "%04d-%02d-%02d", year, month, day);

	if (rank < 9 && rankTime[mapid][rank + 1] != 0)
	{
		for (new i = 9; i > rank; --i)
		{
			if (rankTime[mapid][i] == 0)
				continue;
			
			ranker[mapid][i] = ranker[mapid][i - 1];
			rankTime[mapid][i] = rankTime[mapid][i - 1];
			rankDate[mapid][i] = rankDate[mapid][i - 1];
		}

		format(query, sizeof(query), "UPDATE ranking SET R_Rank + 1 WHERE R_MapID = %d AND R_Rank > %d", rank);
		mysql_tquery(MySQL, query);
	}

	ranker[mapid][rank] = playerName[playerid];
	rankTime[mapid][rank] = time;
	rankDate[mapid][rank] = date;

	mysql_format(MySQL, query, sizeof(query), "INSERT INTO ranking (R_Player,R_Time,R_Date) VALUES('%e',%d,%s) ON DUPLICATE KEY UPDATE R_MapID=%d, R_Rank=%d",
		playerName[playerid], time, date, mapid, rank);
	mysql_tquery(MySQL, query);
}

stock DeleteRankData(mapid, rank)
{
	if (rankTime[mapid][rank] == 0) return 0;

	new query[128];

	format(query, sizeof(query), "DELETE FROM ranking WHERE R_MapID = %d AND R_Rank = %d", mapid, rank);
	mysql_tquery(MySQL, query);

	if (rank < 9 && rankTime[mapid][rank + 1] != 0) // 만약 랭킹이 8 + 1(9)위보다 높고 뒤에 다른 랭킹이 존재한다면
	{
		new i = rank + 1;

		for (; i < 10; ++i)
		{
			if (rankTime[mapid][i] == 0)
				break;
			
			ranker[mapid][i - 1] = ranker[mapid][i];
			rankTime[mapid][i - 1] = rankTime[mapid][i];
			rankDate[mapid][i - 1] = rankDate[mapid][i];
		}

		format(query, sizeof(query), "UPDATE ranking SET R_Rank = R_Rank - 1 WHERE R_MapID = %d AND R_Rank > %d", mapid, rank);
		mysql_tquery(MySQL, query);

		rank = i - 1;
	}

	ranker[mapid][rank] = "";
	rankTime[mapid][rank] = 0;
	rankDate[mapid][rank] = "";

	return 0;
}

function ToggleRankingBoardForPlayer(playerid, toggle)
{
	if (toggle == 0)
	{
		TextDrawHideForPlayer(playerid, rankBox[0]);
		TextDrawHideForPlayer(playerid, rankBox[1]);
		TextDrawHideForPlayer(playerid, rankBox[2]);
		TextDrawHideForPlayer(playerid, rankTabList);
		
		for (new i = 0; i < 10; ++i) TextDrawHideForPlayer(playerid, rankText[i]);

		rankBoardTime[playerid] = 0;
	}
	else
	{
		TextDrawShowForPlayer(playerid, rankBox[0]);
		TextDrawShowForPlayer(playerid, rankBox[1]);
		TextDrawShowForPlayer(playerid, rankBox[2]);
		TextDrawShowForPlayer(playerid, rankTabList);
		
		for (new i = 0; i < 10; ++i) TextDrawShowForPlayer(playerid, rankText[i]);
	}
}

function IsPlayerRankingShow(playerid)
{
	return (IsPlayerConnected(playerid) && rankBoardTime[playerid] != 0);
}

function UpdateRankingBoard()
{
	new string[256];
	new timeStr[20];
	new minute, second, milsecond;

	GetMapName(currentMap, string, 256);
	format(string, 256, "      %s", string);
	TextDrawSetString(rankBox[0], string);

	for (new i = 0; i < 10; ++i)
	{
		milsecond = rankTime[currentMap][i];
		second = (milsecond / 1000);

		if (second > 0)
		{
			minute = (second / 60);
			second = (second % 60);
			milsecond = (milsecond % 1000);

			format(string, sizeof(string), "%d. ", i + 1);
			format(timeStr, sizeof(timeStr), "%02d:%02d:%03d", minute, second, milsecond);
			format(string, sizeof(string), "%4s%21s%15s%s", string, ranker[currentMap][i], timeStr, rankDate[currentMap][i]);
		}
		else
		{
			format(string, sizeof(string), "%d. ", i + 1);
			format(string, sizeof(string), "%4sEmpty", string);
		}

		TextDrawSetString(rankText[i], string);
	}
}

#endif
