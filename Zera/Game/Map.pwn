#if !defined __GAME_MAP__
#define __GAME_MAP__

InitModule("Game_Map")
{
	AddEventHandler(D_PlayerCommandText, "G_Map_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "G_Map_DialogResponse");
	AddEventHandler(D_PlayerTakeDamage, "G_Map_PlayerTakeDamage");
	AddEventHandler(D_PlayerDisconnect, "G_Map_PlayerDisconnect");
	AddEventHandler(gamemodeMapStartEvent, "G_Map_GamemodeMapStart");
	AddEventHandler(mapDataFuncFoundEvent, "G_Map_MapDataFunctionFound");
	AddEventHandler(mapNameChangedEvent, "G_Map_MapNameChanged");

	for (new i = 0; i < MAX_BUY_MAP_AMOUNT; ++i)
	{
		buyMapInfo[i][bmPlayer] = INVALID_PLAYER_ID;
		buyMapInfo[i][bmMapID] = -1;
	}
}

public G_Map_PlayerCommandText(playerid, const command[], params[])
{
	new token_start, token_end;

	if (strcmp(command, "/맵코드") == 0 || strcmp(command, "/맵번호") == 0 || strcmp(command, "/mapcode", true) == 0 || strcmp(command, "/mapid", true) == 0)
	{
		if (IsGameProgress() == 0) return ServerClientMessage(playerid, "게임이 진행중이지 않습니다.");

		new string[145];

		format(string, sizeof(string), "맵코드: %d", currentMap);
		SendClientMessage(playerid, -1, string);

		return 1;
	}

	if (strcmp(command, "/맵구매목록") == 0 || strcmp(command, "/맵목록") == 0 || strcmp(command, "/다음맵") == 0 || strcmp(command, "/넥스트맵") == 0 || strcmp(command, "/nextmap", true) == 0)
	{
		ShowBuyMapInfoForPlayer(playerid);

		return 1;
	}

	if (IsPlayerAdmin(playerid))
	{
		if (strcmp(command, "/redo", true) == 0)
		{
			if (IsGameProgress() == 0) return ServerClientMessage(playerid, "게임이 진행중이지 않습니다.");

			new string[145];

			redo = 1;

			format(string, sizeof(string), "관리자 %s님에 의해 라운드를 재시작합니다.", playerName[playerid]);
			SendClientMessageToGamePlayers(string);
			
			SetRequestMapStart();

			return 1;
		}

		if (strcmp(command, "/맵변경", true) == 0)
		{
			if (IsGameProgress() == 0) return ServerClientMessage(playerid, "게임이 진행중이지 않습니다.");

			ShowMapListForPlayer(playerid);

			return 1;
		}

		if (strcmp(command, "/맵변경타입") == 0 || strcmp(command, "/맵타입") == 0 || strcmp(command, "/맵변경방식") == 0 || strcmp(command, "/맵방식") == 0)
		{
			new type;

			token_start = strtok_r(params, COMMAND_DELIMITER, token_end);
			if (token_start == -1)
				return ServerClientMessage(playerid, "사용법: /맵(변경)타입 [0: 오름차순, 1: 내림차순, 2: 랜덤, 3: 셔플(기본값)]");
			
			if (type < MAP_CHANGE_TYPE_ASC || type > MAP_CHANGE_TYPE_SHUFFLE)
				return ServerClientMessage(playerid, "올바르지 않은 맵 변경 타입입니다.");
			
			new const mapChangeTypes[][] = {
				"오름차순",
				"내림차순",
				"랜덤",
				"셔플"
			};
			new string[145];

			mapChangeType = type;

			format(string, sizeof(string), "관리자 %s님이 맵 변경 방식을 %s(으)로 설정하였습니다.", playerName[playerid], mapChangeTypes[type]);
			SendClientMessageToGamePlayers(string);

			return 1;
		}
	}

	return 0;
}

public G_Map_DialogResponse(playerid, dialogid, response, listitem)
{
	if (dialogid == DIALOG_CHANGE_MAP)
	{
		if (response == 0 || IsPlayerAdmin(playerid) == 0) return 1;

		new mapid;
		new string[145];

		format(string, sizeof(string), "맵목록%d", listitem);
		mapid = GetPVarInt(playerid, string);

		if ((--mapid) >= 0)
		{
			if (IsGameProgress() == 0) ServerClientMessage(playerid, "게임이 진행중이지 않습니다.");
			else
			{
				forceNextMap = mapid;

				format(string, sizeof(string), "관리자 %s님에 의해 맵을 변경합니다.", playerName[playerid]);
				SendClientMessageToGamePlayers(string);

				GetMapName(mapid, string, 145);
				format(string, sizeof(string), "ㄴ 요청된 맵: %s"C_SERVER"", string);
				SendClientMessageToGamePlayers(string);

				SetRequestMapStart();
			}
		}
		else
		{
			ServerClientMessage(playerid, "일시적인 오류가 발생했습니다. 다시 시도해 주세요.");
			ShowMapListForPlayer(playerid);
		}

		return 1;
	}

	if (dialogid == DIALOG_BUY_MAP)
	{
		if (response == 0)
		{
			ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

			return 1;
		}

		new mapid;
		new string[145];

		format(string, sizeof(string), "맵목록%d", listitem);
		mapid = GetPVarInt(playerid, string);

		if ((--mapid) >= 0)
		{
			if (IsGameProgress() == 0)
			{
				ServerClientMessage(playerid, "게임이 진행중이지 않습니다.");
				ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

				return 1;
			}
			else if (IsValidMap(mapid) == 0) ServerClientMessage(playerid, "존재하지 않는 맵입니다.");
			else if (GetPlayerMoney(playerid) < itemList[ITEM_BUY_MAP][itPrice])
			{
				ServerClientMessage(playerid, "당신은 맵을 구매할 돈이 부족합니다.");
				ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

				return 1;
			}
			else
			{
				if (buyMapCount >= MAX_BUY_MAP_AMOUNT)
				{
					ServerClientMessage(playerid, "이미 "#MAX_BUY_MAP_AMOUNT"개의 맵이 구매되었습니다.");
					ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

					return 1;
				}

				new now = GetTickCount(), coolTime = MAP_BUY_DELAY - ((now - mapBuyLastTime[mapid]) / 1000);

				if (coolTime > 0)
				{
					format(string, sizeof(string), "이 맵은 약 %d분 후 다시 구매 가능합니다.", coolTime / 60);
					ServerClientMessage(playerid, string);
				}
				else
				{
					GivePlayerMoney(playerid, -itemList[ITEM_BUY_MAP][itPrice]);
					SavePlayerAccount(playerid);

					buyMapInfo[buyMapCount][bmPlayer] = playerid;
					strcpy(buyMapInfo[buyMapCount][bmPlayerName], playerName[playerid], MAX_PLAYER_NAME);
					buyMapInfo[buyMapCount++][bmMapID] = mapid;
					mapBuyLastTime[mapid] = now;

					GetMapName(mapid, string, 145);
					format(string, sizeof(string), "%s(id:%d)님의 맵 구매 "C_SERVER"%s", playerName[playerid], string);
					SendClientMessageToGamePlayers(string);
				}
			}
		}
		else ServerClientMessage(playerid, "일시적인 오류가 발생했습니다. 다시 시도해 주세요.");

		ShowMapListForPlayer(playerid, 1);

		return 1;
	}

	return 0;
}

public G_Map_PlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if (weaponid == 51 && IsPlayerConnected(issuerid))
	{
		new vehicleid = GetPlayerVehicleID(issuerid);

		if (vehicleid != 0)
		{
			if (GetVehicleModel(vehicleid) == 425)
			{
				new string[145];

				format(string, sizeof(string), "~w~You were ~r~killed ~w~by %s", playerName[issuerid]);

				GameTextForPlayer(playerid, " ", 100, 3);
				GameTextForPlayer(playerid, string, 3000, 5);
			}
		}
	}

	return 0;
}

public G_Map_PlayerDisconnect(playerid)
{
	for (new i = 0; i < buyMapCount; ++i)
	{
		if (buyMapInfo[i][bmPlayer] == playerid) buyMapInfo[i][bmPlayer] = INVALID_PLAYER_ID;
	}

	return 0;
}

public G_Map_GamemodeMapStart()
{
	arrivedCount = 0;
}

public G_Map_MapNameChanged()
{
	UpdateMapNameText();
}

#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	public G_Map_MapDataFunctionFound(const tag[], const func[], const value[])
	{
		new parameter[10][32];

		if (strcmp(tag, "pickup", true) == 0)
		{
			split(value, parameter, ',');

			if (strcmp(func, "CreateVehiclePickup", true) == 0)
			{
				CreateVehiclePickup(strval(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]), floatstr(parameter[3]));
			}
			else if (strcmp(func, "CreateNitroPickup", true) == 0)
			{
				CreateNitroPickup(floatstr(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]));
			}
			else if (strcmp(func, "CreateRepairPickup", true) == 0)
			{
				CreateRepairPickup(floatstr(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]));
			}
			else if (strcmp(func, "CreateTeleportPickup", true) == 0)
			{
				CreateTeleportPickup(floatstr(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]),
					floatstr(parameter[3]), floatstr(parameter[4]), floatstr(parameter[5]),
					floatstr(parameter[6]), floatstr(parameter[7]));
			}
			else if (strcmp(func, "CreateMarker", true) == 0)
			{
				CreateMapObject(strval(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]), floatstr(parameter[3]),
					0.0, 0.0, 0.0);
			}
			else if (strcmp(func, "CreateSpeedPickup", true) == 0)
			{
				CreateSpeedPickup(floatstr(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]), floatstr(parameter[3]));
			}
		}
		else if (strcmp(tag, "spawn", true) == 0)
		{
			split(value, parameter, ',');
			CreateSpawnPoint(strval(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]), floatstr(parameter[3]), floatstr(parameter[4]));
		}
	}
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	public G_Map_MapDataFunctionFound(const tag[], QXmlAttribute: attribute)
	{
		new key[MAX_MAP_TAG_LENGTH];
		new haveData;

		if (strcmp(tag, "racepickup", true) == 0)
		{
			new modelid;
			new vehicleModel;
			new type[32];
			new Float: x, Float: y, Float: z;

			for (haveData = SetAttributeFirst(attribute); haveData != 0; haveData = SetAttributeNext(attribute))
			{
				GetAttributeName(attribute, key);

				if (IsNull(key) == false)
				{
					if (strcmp(key, "type", true) == 0)
					{
						GetAttributeValue(attribute, type);

						if (IsNull(type) == false)
						{
							if (strcmp(type, "nitro", true) == 0)
								modelid = 1;
							else if (strcmp(type, "repair", true) == 0)
								modelid = 2;
							else if (strcmp(type, "vehiclechange", true) == 0)
								modelid = 3;
						}
					}
					else if (strcmp(key, "vehicle", true) == 0)
						vehicleModel = GetAttributeValueInt(attribute);
					else if (strcmp(key, "posX", true) == 0)
						x = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posY", true) == 0)
						y = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posZ", true) == 0)
						z = GetAttributeValueFloat(attribute);
				}
			}

			if (modelid != 0)
			{
				if (modelid == 1)
					CreateNitroPickup(x, y, z);
				else if (modelid == 2)
					CreateRepairPickup(x, y, z);
				else if (modelid == 3)
					CreateVehiclePickup(vehicleModel, x, y, z);
			}
		}
		else if (strcmp(tag, "spawnpoint", true) == 0)
		{
			new modelid;
			new Float: x, Float: y, Float: z, Float: angle;

			for (haveData = SetAttributeFirst(attribute); haveData != 0; haveData = SetAttributeNext(attribute))
			{
				GetAttributeName(attribute, key);

				if (IsNull(key) == false)
				{
					if (strcmp(key, "vehicle", true) == 0)
						modelid = GetAttributeValueInt(attribute);
					else if (strcmp(key, "posX", true) == 0)
						x = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posY", true) == 0)
						y = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posZ", true) == 0)
						z = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "rotZ", true) == 0)
						angle = GetAttributeValueFloat(attribute);
				}
			}

			if (modelid != 0)
				CreateSpawnPoint(modelid, x, y, z, angle);
		}
	}
#endif

public OnPlayerMapArrived(playerid)
{
	if (survive[playerid] <= 0)
	{
		PlayerKill(playerid);
		return;
	}
	
	new arriveTime = GetTickCount() - gameInfo[gGameStartTime];
	new rank = UpdateRanking(currentMap, playerid, arriveTime);

	GivePlayerMoney(playerid, MAP_ARRIVE_MONEY);
	SavePlayerAccount(playerid);
	ServerClientMessage(playerid, "Hunter 보너스: $"#MAP_ARRIVE_MONEY"", .tag = "Hunter");
	TogglePlayerSpeedo(playerid, 0);
	ShowPlayerArriveTime(playerid, rank, arriveTime);

	if ((++arrivedCount) == 1)
	{
		new vehicleid;

		SetWeather(6);
		SetWorldTime(23);

		contloop (new i : playerList)
		{
			if (IsPlayerLoggedIn(i) == 0 || survive[i] == -1)
				continue;

			SetPlayerInterior(i, 0);
			SetPlayerVirtualWorld(i, 0);
			
			if ((vehicleid = GetPlayerVehicleID(i)) != 0)
			{
				LinkVehicleToInterior(vehicleid, 0);
				SetVehicleVirtualWorld(vehicleid, 0);
			}

			if (spectatePlayer[i] == playerid)
				TogglePlayerSpeedo(i, 0);

			if (i != playerid)
			{
				GameTextForPlayer(i, " ", 100, 3);
				GameTextForPlayer(i, "~w~Hunter reached!", 3000, 5);
			}
		}
	}
	else
	{
		contloop (new i : playerList)
		{
			if (IsPlayerLoggedIn(i) == 0 || survive[i] == -1)
				continue;
			
			if (spectatePlayer[i] == playerid)
				TogglePlayerSpeedo(i, 0);
		}
	}	
}

function ShowPlayerArriveTime(playerid, rank, time)
{
	new milsecond = (time % 1000), second = (time / 1000), minute = (second / 60);
	new string[145];
	new timeString[64];

	second %= 60;

	ServerClientMessage(playerid, "당신은 Hunter를 탑승했습니다.", .tag = "Arrive");

	if (rank != -1)
		format(string, sizeof(string), "랭크: "C_SERVER"%d ", rank + 1);

	format(timeString, sizeof(timeString), "{FFFFFF}타임: "C_SERVER"%02d:%02d:%03d", minute, second, milsecond);
	strcat(string, timeString);
	ServerClientMessage(playerid, string, .tag = "Arrive");

	if (rank != -1)
		format(string, sizeof(string), "%s(id:%d)님이 %d번째 랭크에 등록되셨습니다! ", playerName[playerid], playerid, rank + 1);
	else
		format(string, sizeof(string), "%s(id:%d)님이 맵을 완주하셨습니다! ", playerName[playerid], playerid);

	strcat(string, timeString);

	contloop (new i : playerList)
	{
		if (i != playerid && IsPlayerLoggedIn(i))
			ServerClientMessage(i, string, .tag = "Ranking");
	}
}

function UpdateMapNameText()
{
	new string[512];

	if (buyMapCount <= 0 || IsValidMap(buyMapInfo[0][bmMapID]) == 0) format(string, 512, "~y~~n~MAP: ~w~%s", currentMapName);
	else
	{
		GetMapName(buyMapInfo[0][bmMapID], string);
		format(string, sizeof(string), "~y~MAP: ~w~%s~n~~y~NEXT MAP: %s", currentMapName, string);
	}
	
	TextDrawSetString(mapInfoText, string);

	format(string, sizeof(string), "mapname %s", currentMapName);
	SendRconCommand(string);
}

function ShowMapListForPlayer(playerid, type = 0)
{
	new minID, maxID;
	new temp[256];
	new string[4096];
	new listIndex;

	GetMinMaxMapID(minID, maxID);

	for (new i = minID; i <= maxID; ++i)
	{
		GetMapName(i, temp);
		format(string, sizeof(string), "%s%s\n", string, temp);
		
		format(temp, sizeof(temp), "맵목록%d", listIndex++);
		SetPVarInt(playerid, temp, i + 1);
	}

	if (type == 0) ShowPlayerDialog(playerid, DIALOG_CHANGE_MAP, DIALOG_STYLE_LIST, "맵 변경", string, "변경", "취소");
	else if (type == 1) ShowPlayerDialog(playerid, DIALOG_BUY_MAP, DIALOG_STYLE_LIST, "맵 구매", string, "구매", "취소");
}

function ShowBuyMapInfoForPlayer(playerid)
{
	if (buyMapCount > 0)
	{
		new mapName[128];
		new string[1024];

		for (new i = 0; i < buyMapCount; ++i)
		{
			if (IsValidMap(buyMapInfo[i][bmMapID])) GetMapName(buyMapInfo[i][bmMapID], mapName);
			else mapName = "맵 정보 없음";

			format(string, sizeof(string), "%s%d. %s (구매자: %s)\n", string, i + 1, mapName, buyMapInfo[i][bmPlayerName]);
		}

		ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "맵 구매 현황", string, "확인", "");
	}
}

function StartCurrentNextMap()
{
	if (redo == 1)
	{
		SetNextMap(currentMap);

		redo = 0;
	}
	else
	{
		if (buyMapCount > 0)
		{
			--buyMapCount;

			if (IsValidMap(buyMapInfo[0][bmMapID])) SetNextMap(buyMapInfo[0][bmMapID]);

			new i;

			for (i = 0; i < buyMapCount; ++i)
			{
				buyMapInfo[i][bmPlayer] = buyMapInfo[i + 1][bmPlayer];
				strcpy(buyMapInfo[i][bmPlayerName], buyMapInfo[i + 1][bmPlayerName], MAX_PLAYER_NAME);
				buyMapInfo[i][bmMapID] = buyMapInfo[i + 1][bmMapID];
			}

			buyMapInfo[i][bmPlayer] = INVALID_PLAYER_ID;
			strcpy(buyMapInfo[i][bmPlayerName], "", MAX_PLAYER_NAME);
			buyMapInfo[i][bmMapID] = -1;
		}
	}

	StartNextMap();
}

function IsValidObjectModel(modelid)
{
	switch(modelid)
	{
		case 321..397: {
		return true;
		}
		case 615..661: {
		return true;
		}
		case 664: {
		return true;
		}
		case 669..698: {
		return true;
		}
		case 700..792: {
		return true;
		}
		case 800..906: {
		return true;
		}
		case 910..964: {
		return true;
		}
		case 966..998: {
		return true;
		}
		case 1000..1193: {
		return true;
		}
		case 1207..1325: {
		return true;
		}
		case 1327..1572: {
		return true;
		}
		case 1574..1698: {
		return true;
		}
		case 1700..2882: {
		return true;
		}
		case 2885..3135: {
		return true;
		}
		case 3167..3175: {
		return true;
		}
		case 3178: {
		return true;
		}
		case 3187: {
		return true;
		}
		case 3193: {
		return true;
		}
		case 3214: {
		return true;
		}
		case 3221: {
		return true;
		}
		case 3241..3244: {
		return true;
		}
		case 3246: {
		return true;
		}
		case 3249..3250: {
		return true;
		}
		case 3252..3253: {
		return true;
		}
		case 3255..3265: {
		return true;
		}
		case 3267..3347: {
		return true;
		}
		case 3350..3415: {
		return true;
		}
		case 3417..3428: {
		return true;
		}
		case 3430..3609: {
		return true;
		}
		case 3612..3783: {
		return true;
		}
		case 3785..3869: {
		return true;
		}
		case 3872..3882: {
		return true;
		}
		case 3884..3888: {
		return true;
		}
		case 3890..3973: {
		return true;
		}
		case 3975..4541: {
		return true;
		}
		case 4550..4762: {
		return true;
		}
		case 4806..5084: {
		return true;
		}
		case 5086..5089: {
		return true;
		}
		case 5105..5375: {
		return true;
		}
		case 5390..5682: {
		return true;
		}
		case 5703..6010: {
		return true;
		}
		case 6035..6253: {
		return true;
		}
		case 6255..6257: {
		return true;
		}
		case 6280..6347: {
		return true;
		}
		case 6349..6525: {
		return true;
		}
		case 6863..7392: {
		return true;
		}
		case 7415..7973: {
		return true;
		}
		case 7978..9193: {
		return true;
		}
		case 9205..9267: {
		return true;
		}
		case 9269..9478: {
		return true;
		}
		case 9482..10310: {
		return true;
		}
		case 10315..10744: {
		return true;
		}
		case 10750..11417: {
		return true;
		}
		case 11420..11681: {
		return true;
		}
		case 12800..13563: {
		return true;
		}
		case 13590..13667: {
		return true;
		}
		case 13672..13890: {
		return true;
		}
		case 14383..14528: {
		return true;
		}
		case 14530..14554: {
		return true;
		}
		case 14556: {
		return true;
		}
		case 14558..14643: {
		return true;
		}
		case 14650..14657: {
		return true;
		}
		case 14660..14695: {
		return true;
		}
		case 14699..14728: {
		return true;
		}
		case 14735..14765: {
		return true;
		}
		case 14770..14856: {
		return true;
		}
		case 14858..14883: {
		return true;
		}
		case 14885..14898: {
		return true;
		}
		case 14900..14903: {
		return true;
		}
		case 15025..15064: {
		return true;
		}
		case 16000..16790: {
		return true;
		}
		case 17000..17474: {
		return true;
		}
		case 17500..17974: {
		return true;
		}
		case 17976: {
		return true;
		}
		case 17978: {
		return true;
		}
		case 18000..18036: {
		return true;
		}
		case 18038..18102: {
		return true;
		}
		case 18104..18105: {
		return true;
		}
		case 18109: {
		return true;
		}
		case 18112: {
		return true;
		}
		/*case 18200..18859: {
		return true;
		}*/
		case 18200..18631: {
		return true;
		}
		case 18632..19346: { // SA-MP 0.3c ~ 0.3d Objects
		return true;
		}
	#if SAMP_VERSION >= SAMP_03z
		case 19347..19521: {
		return true;
		}
		#if SAMP_VERSION >= SAMP_037
			case 19522..19999: {
			return true;
			}
			case 11682..11698: {
			return true;
			}
			case 11700..11753: {
			return true;
			}
		#endif
	#endif
		/*case 18862..19198: {
		return true;
		}
		case 19200..19274: {
		return true;
		}
		case 19277..19595: {
		return true;
		}
		case 19597..19999: {
		return true;
		}*/
	}

	return false;
}

function IsArrivedSomeone()
{
	return (arrivedCount > 0);
}

#endif
