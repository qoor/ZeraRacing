#if !defined __PLAYER_CORE__
#define __PLAYER_CORE__

InitModule("Player")
{
	AddEventHandler(D_PlayerConnect, "P_Core_PlayerConnect");
	AddEventHandler(D_PlayerRequestClass, "P_Core_PlayerRequestClass");
	AddEventHandler(D_PlayerCommandText, "P_Core_PlayerCommandText");
	AddEventHandler(D_PlayerCommandTextFail, "P_Core_PlayerCommandTextFail");
	AddEventHandler(D_PlayerDisconnect, "P_Core_PlayerDisconnect", MAX_EVENT_HANDLERS);
	AddEventHandler(D_PlayerStateChange, "P_Core_PlayerStateChange");
}

public P_Core_PlayerConnect(playerid)
{
	GetPlayerName(playerid, playerName[playerid], MAX_PLAYER_NAME);

	if (strlen(playerName[playerid]) < 3) return 1;

	new string[145];

	GetPlayerIp(playerid, ipAddress[playerid], 16);

	if (IsValidVehicle(playerVehicle[playerid]) == 0) playerVehicle[playerid] = CreateVehicle(411, 0.0, 0.0, 3.0, 0.0, RandomVehicleColor(), RandomVehicleColor(), -1);

	SetVehicleVirtualWorld(playerVehicle[playerid], playerid + 1);
	SetPlayerColor(playerid, 0x00000000);
	SetSpawnInfo(playerid, NO_TEAM, 0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

	format(string, sizeof(string), "* {FFFFFF}%s"C_SERVER"님이 게임에 참가했습니다", playerName[playerid]);
	SendClientMessageToAll(COLOR_SERVER, string);

	return 0;
}

public P_Core_PlayerRequestClass(playerid)
{
	SpawnPlayer(playerid);

	return 1;
}

public P_Core_PlayerCommandText(playerid)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 1;

	return 0;
}

public P_Core_PlayerCommandTextFail(playerid, const command[])
{
	new string[145];
	
	format(string, sizeof(string), "'%s'은(는) 존재하지 않는 명령어입니다. '/도움말'을 참고해 주세요.", command);
	ServerClientMessage(playerid, string);

	return 1;
}

public P_Core_PlayerDisconnect(playerid, reason)
{
	if (!IsPlayerConnected(playerid)) return 1;

	new string[145];

	format(string, sizeof(string), "* {FFFFFF}%s"C_SERVER"님이 게임을 떠났습니다.", playerName[playerid]);

	if (reason != 1)
	{
		strcat(string, " [{FFFFFF}");

		if (reason == 0) strcat(string, "타임아웃");
		else strcat(string, "킥/밴");

		strcat(string, ""C_SERVER"]");
	}
	
	SendClientMessageToAll(COLOR_SERVER, string);

	return 0;
}

public P_Core_PlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_DRIVER)
		ResetPlayerWeapons(playerid);
	
	return 0;
}

function PlayerKill(playerid)
{
	new Float: x, Float: y, Float: z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z);
	SetPlayerHealth(playerid, 0.0);
}

function SetPlayerRespawn(playerid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) StopPlayerSpectating(playerid);
	else
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 0.0, 0.0, 0.0);
		SetPlayerHealth(playerid, 100.0);
		SpawnPlayer(playerid);
	}
}

function RandomSkin()
{
	new skinid;

	do skinid = random(299) + 1;
	while (skinid == 74);

	return skinid;
}

function IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	
	return 1;
}

function ReturnUser(const text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;

	while (text[pos] < 0x21) // Strip out leading spaces
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
		pos++;
	}

	new userid = INVALID_PLAYER_ID;

	if (IsNumeric(text[pos])) // Check whole passed string
	{
		// If they have a numeric name you have a problem (although names are checked on id failure)
		userid = strval(text[pos]);

		if (userid >= 0 && userid < MAX_PLAYERS)
		{
			if (IsPlayerConnected(userid)) return userid;
			else
			{
				/*if (playerid != INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
				}*/
				userid = INVALID_PLAYER_ID;
			}
		}
		/*else
		{
			if (playerid != INVALID_PLAYER_ID)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
			}
			userid = INVALID_PLAYER_ID;
		}
		return userid;*/
		// Removed for fallthrough code
	}
	// They entered [part of] a name or the id search failed (check names just incase)
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];

	contloop (new i : playerList)
	{
		GetPlayerName(i, name, sizeof (name));

		if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
		{
			if (len == strlen(name)) // Exact match
			{
				return i; // Return the exact player on an exact match
				// Otherwise if there are two players:
				// Me and MeYou any time you entered Me it would find both
				// And never be able to return just Me's id
			}
			else // Partial match
			{
				count++;
				userid = i;
			}
		}
	}

	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}

	return userid; // INVALID_USER_ID for bad return
}

#endif
