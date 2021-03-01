#if !defined __PLAYER_ITEM__
#define __PLAYER_ITEM__

InitModule("Player_Item")
{
	AddEventHandler(D_PlayerConnect, "P_Item_PlayerConnect");
	AddEventHandler(D_PlayerSpawn, "P_Item_PlayerSpawn");
	AddEventHandler(D_PlayerCommandText, "P_Item_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "P_Item_DialogResponse");
	AddEventHandler(playerSecondTimer, "P_Item_PlayerSecondTimer");
}

public P_Item_PlayerConnect(playerid)
{
	vehicleColorState[playerid] = 0;
	wheelChangeState[playerid] = 0;
	vehicleLightState[playerid] = 0;

	for (new i = 0; i < sizeof(itemList); ++i)
	{
		playerItem[playerid][i][pitHave] = 0;
		playerItem[playerid][i][pitUse] = 0;
		playerItemValue[playerid][i] = "";
	}

	return 0;
}

public P_Item_PlayerSpawn(playerid)
{
	if (playerItem[playerid][ITEM_CHARACTER_SKIN][pitHave] == 0 || playerItem[playerid][ITEM_CHARACTER_SKIN][pitUse] == 0) SetPlayerSkin(playerid, RandomSkin());
	else
	{
		new skinid = strval(playerItemValue[playerid][ITEM_CHARACTER_SKIN]);

		SetPlayerSkin(playerid, skinid);
	}

	return 0;
}

public P_Item_PlayerCommandText(playerid, const command[])
{
	if (strcmp(command, "/인벤토리") == 0 || strcmp(command, "/아이템") == 0 || strcmp(command, "/inventory", true) == 0 || strcmp(command, "/inven", true) == 0 || strcmp(command, "/item", true) == 0)
	{
		ShowPlayerInventory(playerid);

		return 1;
	}

	return 0;
}

public P_Item_DialogResponse(playerid, dialogid, response, listitem)
{
	if (dialogid == DIALOG_INVENTORY)
	{
		if (response == 0) return 1;

		if (listitem == 0) ShowPlayerStat(playerid, .type = 1);
		else if (listitem == 1) ShowItemGroupListForPlayer(playerid);
		else if (listitem == 2) ShowItemShopDialogForPlayer(playerid);

		return 1;
	}

	if (dialogid == DIALOG_INVENTORY + 1)
	{
		if (response == 0)
		{
			ShowPlayerInventory(playerid);

			return 1;
		}

		new varName[32];

		format(varName, 32, "아이템그룹%d", listitem);
		
		new groupid = GetPVarInt(playerid, varName);
		
		if (groupid > 0)
		{
			itemGroupSelect[playerid] = groupid - 1;

			ShowPlayerItemList(playerid, itemGroupSelect[playerid]);
		}

		return 1;
	}

	if (dialogid == DIALOG_INVENTORY + 2)
	{
		if (response == 0)
		{
			ShowItemGroupListForPlayer(playerid);

			return 1;
		}

		new string[145];

		format(string, sizeof(string), "아이템번호%d", listitem);

		new index = GetPVarInt(playerid, string);

		if ((--index) >= 0)
		{
			new groupid = itemGroupSelect[playerid];
			
			if (itemList[index][itNotUseItem] == 1) ServerClientMessage(playerid, "인벤토리에서 사용할 수 있는 아이템이 아닙니다.");
			else if (playerItem[playerid][index][pitHave] == 0)
			{
				ServerClientMessage(playerid, "당신은 이 아이템을 가지고 있지 않습니다.");
			}
			else if (playerItem[playerid][index][pitUse] == 0)
			{
				if (itemGroup[groupid][itgNoOverlap] != 0)
				{
					for (new i = 0; i < sizeof(itemList); ++i)
					{
						if (itemList[i][itGroup] == groupid && playerItem[playerid][i][pitUse] == 1) UnUsePlayerItem(playerid, i);
					}
				}

				UsePlayerItem(playerid, index);

				format(string, sizeof(string), "{FFFFFF}%s "C_SERVER"아이템을 사용합니다.", itemList[index][itName]);
				ServerClientMessage(playerid, string);
			}
			else
			{
				UnUsePlayerItem(playerid, index);

				format(string, sizeof(string), "{FFFFFF}%s "C_SERVER"아이템 사용을 해제합니다.", itemList[index][itName]);
				ServerClientMessage(playerid, string);
			}

			ShowPlayerItemList(playerid, groupid);
		}

		return 1;
	}

	return 0;
}

public P_Item_PlayerSecondTimer(playerid)
{
	new vehicleid;
	new panels, doors, lights, tires;

	if ((vehicleid = GetPlayerVehicleID(playerid)) == playerVehicle[playerid])
	{
		if (playerItem[playerid][ITEM_RAINBOW_COLOR][pitUse] != 0)
		{
			if (++vehicleColorState[playerid] > 7) vehicleColorState[playerid] = 0;

			#if SAMP_VERSION == SAMP_03d
				if (vehicleColorState[playerid] == 1) ChangeVehicleColor(vehicleid, 151, 1);
				else if (vehicleColorState[playerid] == 2) ChangeVehicleColor(vehicleid, 6, 1);
				else if (vehicleColorState[playerid] == 3) ChangeVehicleColor(vehicleid, 65, 1);
				else if (vehicleColorState[playerid] == 4) ChangeVehicleColor(vehicleid, 144, 1);
				else if (vehicleColorState[playerid] == 5) ChangeVehicleColor(vehicleid, 184, 1);
				else if (vehicleColorState[playerid] == 6) ChangeVehicleColor(vehicleid, 169, 1);
				else if (vehicleColorState[playerid] == 7) ChangeVehicleColor(vehicleid, 211, 1);
			#else
				if (vehicleColorState[playerid] == 1) ChangeVehicleColor(vehicleid, 175, 1);
				else if (vehicleColorState[playerid] == 2) ChangeVehicleColor(vehicleid, 219, 1);
				else if (vehicleColorState[playerid] == 3) ChangeVehicleColor(vehicleid, 65, 1);
				else if (vehicleColorState[playerid] == 4) ChangeVehicleColor(vehicleid, 154, 1);
				else if (vehicleColorState[playerid] == 5) ChangeVehicleColor(vehicleid, 152, 1);
				else if (vehicleColorState[playerid] == 6) ChangeVehicleColor(vehicleid, 134, 1);
				else if (vehicleColorState[playerid] == 7) ChangeVehicleColor(vehicleid, 211, 1);
			#endif
		}
		else if (playerItem[playerid][ITEM_MR_BOB_COLOR_STORY][pitUse] != 0) ChangeVehicleColor(vehicleid, RandomVehicleColor(), RandomVehicleColor());
		else if (playerItem[playerid][ITEM_HERSHEYS_COLOR][pitUse] != 0)
		{
			vehicleColorState[playerid] = !vehicleColorState[playerid];

			ChangeVehicleColor(vehicleid, vehicleColorState[playerid], !vehicleColorState[playerid]);
		}

		if (playerItem[playerid][ITEM_RANDOM_WHEEL][pitUse] != 0)
		{
			if (++wheelChangeState[playerid] > 16) wheelChangeState[playerid] = 1;

			if (wheelChangeState[playerid] < 13) AddVehicleComponent(playerVehicle[playerid], 1072 + wheelChangeState[playerid]);
			else AddVehicleComponent(playerVehicle[playerid], 1083 + wheelChangeState[playerid]);
		}
		
		if (IsVehicleModelHelicopter(GetVehicleModel(vehicleid)) == 0 && playerItem[playerid][ITEM_TWINKLE_LIGHT][pitUse] != 0)
		{
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

			if (vehicleLightState[playerid] == 0)
			{
				vehicleLightState[playerid] = 1;
				lights = 1;
			}
			else
			{
				vehicleLightState[playerid] = 0;
				lights = 4;
			}

			UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		}
	}

	return 0;
}

function LoadPlayerItems(playerid)
{
	new query[128];

	format(query, sizeof(query), "SELECT * FROM playeritem WHERE PI_Player=%d", playerInfo[playerid][pIndex]);
	mysql_tquery(MySQL, query, "OnLoadPlayerItems", "ii", playerid, playerInfo[playerid][pIndex]);
}

public OnLoadPlayerItems(playerid, playerIndex)
{
	if (!IsPlayerConnected(playerid) || playerInfo[playerid][pIndex] != playerIndex) return;

	new errno;

	if ((errno = mysql_errno(MySQL)) != 0)
	{
		ServerLog(LOG_TYPE_MYSQL, "플레이어의 아이템 정보를 로드하는 도중 오류가 발생했습니다.", errno);

		return;
	}

	new rows;
	new index;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; ++i)
	{
		cache_get_value_name_int(i, "PI_ItemID", index);

		if (index >= 0 && index < sizeof(itemList))
		{
			cache_get_value_name_int(i, "PI_Use", playerItem[playerid][index][pitUse]);
			cache_get_value_name(i, "PI_Value", playerItemValue[playerid][index], 256);

			playerItem[playerid][index][pitHave] = 1;
		}
	}

	OnPlayerLoginFinish(playerid);
}

function SavePlayerItem(playerid, itemid)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;
	if (itemid < 0 || itemid >= sizeof(itemList) || itemList[itemid][itNotSaveItem] == 1 || playerItem[playerid][itemid][pitHave] == 0) return 0;

	new query[256];

	mysql_format(MySQL, query, sizeof(query), "INSERT INTO playeritem (PI_Use,PI_Value) VALUES(%d,'%e') ON DUPLICATE KEY UPDATE PI_Player=%d, PI_Item=%d",
		playerItem[playerid][itemid][pitUse], (itemList[itemid][itHaveValue] == 0) ? ("") : playerItemValue[playerid][itemid],
		playerInfo[playerid][pIndex], itemid);
	mysql_tquery(MySQL, query, "OnSavePlayerItem", "iii", playerid, playerInfo[playerid][pIndex], itemid);

	return 1;
}

/*function SavePlayerItem(playerid, itemid, have, use, const value[])
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;
	if (itemid < 0 || itemid >= sizeof(itemList) || itemList[itemid][itNotSaveItem] == 1) return 0;

	#define MAX_LENGTH 256
	new query[256];

	if (playerItem[playerid][itemid][pitHave] != 0)
	{
		if (have == 0)
		{
			playerItem[playerid][itemid][pitHave] = 0;
			playerItem[playerid][itemid][pitUse] = 0;

			if (itemList[itemid][itHaveValue] != 0) playerItemValue[playerid][itemid] = "";

			format(query, 256, "DELETE FROM playeritem WHERE PI_Player=%d AND PI_ItemID=%d", playerInfo[playerid][pIndex], itemid);
		}
		else	
		{
			if (itemList[itemid][itHaveValue] != 0) strcpy(playerItemValue[playerid][itemid], value, 256);

			mysql_format(MySQL, query, 256, "UPDATE playeritem SET PI_Use=%d,PI_Value='%e' WHERE PI_Player=%d AND PI_ItemID=%d",
				use,
				(itemList[itemid][itHaveValue] == 0) ? ("") : value,
				playerInfo[playerid][pIndex], itemid);
		}
	}
	else
	{
		if (have == 0) return 1;

		playerItem[playerid][itemid][pitHave] = 1;

		if (itemList[itemid][itHaveValue] != 0) strcpy(playerItemValue[playerid][itemid], value, 256);

		mysql_format(MySQL, query, MAX_LENGTH, "INSERT INTO playeritem (PI_Player,PI_ItemID,PI_Use,PI_Value) VALUES(%d,%d,%d,'%e')",
			playerInfo[playerid][pIndex], itemid, use, value);
	}
	#undef MAX_LENGTH

	mysql_tquery(MySQL, query, "OnSavePlayerItem", "iii", playerid, playerInfo[playerid][pIndex], itemid);

	return 1;
}*/

public OnSavePlayerItem(playerid, playerIndex, itemid)
{
	if (!IsPlayerConnected(playerid) || playerInfo[playerid][pIndex] != playerIndex) return;

	new errno;

	if ((errno = mysql_errno(MySQL)) != 0) ServerLog(LOG_TYPE_MYSQL, "플레이어 아이템을 저장하는 도중 오류가 발생했습니다.", errno);
}

function ShowPlayerInventory(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "인벤토리", "내 정보\n내 아이템\n상점 이동", "선택", "취소");
}

function UsePlayerItem(playerid, itemid)
{
	if (itemList[itemid][itNotUseItem] == 0 && playerItem[playerid][itemid][pitHave] == 1 && playerItem[playerid][itemid][pitUse] == 0)
	{
		playerItem[playerid][itemid][pitUse] = 1;

		if (itemid == ITEM_STATIC_VEHICLE_COLOR)
		{
			new color1, color2;
			
			GetPlayerStaticVehicleColor(playerid, color1, color2);
			ChangeVehicleColor(playerVehicle[playerid], color1, color2);
		}

		SavePlayerItem(playerid, itemid);
	}
}

function UnUsePlayerItem(playerid, itemid)
{
	if (itemList[itemid][itNotUseItem] == 0 && playerItem[playerid][itemid][pitHave] == 1 && playerItem[playerid][itemid][pitUse] == 1)
	{
		playerItem[playerid][itemid][pitUse] = 0;

		SavePlayerItem(playerid, itemid);
	}
}

function GetPlayerStaticVehicleColor(playerid, &color1, &color2)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;

	if (playerItem[playerid][ITEM_STATIC_VEHICLE_COLOR][pitHave] != 0 && playerItem[playerid][ITEM_STATIC_VEHICLE_COLOR][pitUse] != 0)
	{
		new colorValue[2][11];

		split(playerItemValue[playerid][ITEM_STATIC_VEHICLE_COLOR], colorValue, ',');

		color1 = strval(colorValue[0]);
		color2 = strval(colorValue[1]);
	}
	else
	{
		color1 = RandomVehicleColor();
		color2 = RandomVehicleColor();
	}

	return 1;
}

#endif
