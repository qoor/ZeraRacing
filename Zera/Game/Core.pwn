#if !defined __GAME_CORE__
#define __GAME_CORE__

InitModule("Game")
{
	Game_Initialize();

	AddEventHandler(D_GameModeExit, "G_Core_GameModeExit");
	AddEventHandler(D_PlayerConnect, "G_Core_PlayerConnect");
	AddEventHandler(D_PlayerSpawn, "G_Core_PlayerSpawn");
	AddEventHandler(D_PlayerExitVehicle, "G_Core_PlayerExitVehicle");
	AddEventHandler(D_PlayerDeath, "G_Core_PlayerDeath");
	AddEventHandler(D_PlayerDisconnect, "G_Core_PlayerDisconnect");
	AddEventHandler(D_PlayerKeyStateChange, "G_Core_PlayerKeyStateChange");
	AddEventHandler(gamemodeMapStartEvent, "G_Core_GamemodeMapStart");
	AddEventHandler(globalSecondTimer, "G_Core_GlobalSecondTimer");
	AddEventHandler(playerSecondTimer, "G_Core_PlayerSecondTimer");
	AddEventHandler(removeMapElementsEvent, "G_Core_RemoveMapElements");
	AddEventHandler(playerEliminatedEvent, "G_Core_PlayerEliminated");
	AddEventHandler(playerMapStartEvent, "G_Core_PlayerMapStart");
}

function Game_Initialize()
{
	gameInfo[gWinner] = INVALID_PLAYER_ID;
}

public G_Core_GameModeExit()
{
	gameInfo[gGameStartTime] = 0;

	if (startDelayTimer != 0) KillTimer(startDelayTimer);

	return 0;
}

public G_Core_PlayerConnect(playerid)
{
	respawnTime[playerid] = 0;
	notReady[playerid] = 0;

	return 0;
}

public G_Core_PlayerSpawn(playerid)
{
	if (IsGameProgress() == 0 && survive[playerid] == 0) // 잠수중엔 SpawnPlayer를 호출해도 잠수가 풀릴 때 까지 스폰되지 않기 때문에 문제 없음.
	{
		survive[playerid] = 1;
		++gameInfo[gSurvivePlayers];

		if (gameInfo[gGameCount] == 0) SetPlayerNotReady(playerid);
	}
	
	if (survive[playerid] != 0) SelectPlayerSpawnPoint(playerid);

	return 0;
}

public G_Core_PlayerExitVehicle(playerid)
{
	//if (IsVehicleModelBike(GetVehicleModel(playerVehicle[playerid])) == 0)
	//{
	new Float: health;

	GetPlayerHealth(playerid, health);

	if (health > 0.0)
	{
		new Float: x, Float: y, Float: z;

		GetVehicleVelocity(playerVehicle[playerid], x, y, z);
		ClearAnimations(playerid, 1);
		PutPlayerInVehicle(playerid, playerVehicle[playerid], 0);
		SetVehicleVelocity(playerVehicle[playerid], x, y, z);
	}
	//}

	return 0;
}

public G_Core_PlayerDeath(playerid)
{
	if (GetPlayerVehicleID(playerid) != 0)
	{
		new Float: x, Float: y, Float: z;
		new Float: camX, Float: camY, Float: camZ;

		GetPlayerCameraPos(playerid, camX, camY, camZ);
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, camX, camY, camZ);
		SetPlayerCameraLookAt(playerid, x, y, z);

		respawnTime[playerid] = 2;
	}

	return 0;
}

public G_Core_PlayerDisconnect(playerid)
{
	if (IsPlayerLoggedIn(playerid)) --gameInfo[gPlayers];

	return 0;
}

public G_Core_PlayerKeyStateChange(playerid, newkeys)
{
	if (newkeys & KEY_ANALOG_UP)
	{
		if (IsGameProgress() == 0 || (burst[playerid] == 0 && survive[playerid] != -1) || IsPlayerInVehicle(playerid, playerVehicle[playerid]) == 0)
			return 1;
		
		new Float: vx, Float: vy, Float: vz;
		new string[64];

		if (survive[playerid] != -1)
			--burst[playerid];

		GetVehicleVelocity(playerVehicle[playerid], vx, vy, vz);
		SetVehicleVelocity(playerVehicle[playerid], vx * 2.0, vy * 2.0, vz * 2.0);

		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, "~r~ Burst !", 840, 3);

		format(string, sizeof(string), "%s(id:%d) -> Burst!", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "Boost");

		return 1;
	}

	if (newkeys & KEY_ANALOG_DOWN)
	{
		if (IsGameProgress() == 0 || (jump[playerid] == 0 && survive[playerid] != -1) || IsPlayerInVehicle(playerid, playerVehicle[playerid]) == 0)
			return 1;
		
		new Float: vx, Float: vy, Float: vz;
		new string[64];

		if (jump[playerid] != -1)
			--jump[playerid];

		GetVehicleVelocity(playerVehicle[playerid], vx, vy, vz);
		SetVehicleVelocity(playerVehicle[playerid], vx, vy, vz + 1);

		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, "~r~ Jump !", 840, 3);

		format(string, sizeof(string), "%s(id:%d) -> Jump!", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "Boost");

		return 1;
	}

	return 0;
}

public G_Core_PlayerStateChange(playerid, newstate)
{
	if (newstate == PLAYER_STATE_ONFOOT)
	{
		if (mapChanging == 0 && IsGameProgress())
		{
			new vehicleid = playerVehicle[playerid];

			if (IsValidVehicle(vehicleid))
			{
				new Float: health;

				GetPlayerHealth(playerid, health);

				if (health > 0.0)
				{
					new Float: fX, Float: fY, Float: fZ;

					GetVehiclePos(vehicleid, fX, fY, fZ);
					SetPlayerPos(playerid, fX, fY, fZ);
					PutPlayerInVehicle(playerid, vehicleid, 0);
				}
			}
		}
	}

	return 0;
}

public G_Core_GlobalSecondTimer()
{
	#if DEBUG_MODE == 0
		if (IsGameProgress())
		{
			UpdateGameTimeText();
			
			if (mapChanging == 0 && GetGameTime() >= gameInfo[gTimeLeft]) SetRequestMapStart();
		}
	#endif

	return 0;
}

public G_Core_PlayerSecondTimer(playerid)
{
	if (mapChanging == 0 && IsGameProgress() && survive[playerid] != 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED && IsPlayerInVehicle(playerid, playerVehicle[playerid]) == 0)
	{
		new Float: x, Float: y, Float: z;

		GetVehiclePos(playerVehicle[playerid], x, y, z);
		PutPlayerInVehicle(playerid, playerVehicle[playerid], 0);
		Audio_StopRadio(playerid);
	}

	return 0;
}

public G_Core_GamemodeMapStart()
{
	new string[145];

	gameInfo[gGameStartTime] = 0;
	gameInfo[gSurvivePlayers] = 0;
	gameInfo[gWinner] = INVALID_PLAYER_ID;
	gameInfo[gLoadedPlayers] = 0;

	SetTimeLeftTime(ROUND_TIME);
	//SetGravity(0.0);

	TextDrawHideForAll(timeBox[0]);
	TextDrawHideForAll(timeBox[1]);
	TextDrawHideForAll(timeText);

	format(string, sizeof(string), "Map Starting: %s", currentMapName);
	SendClientMessageToGamePlayers(string);

	contloop (new playerid : playerList)
	{
		notReady[playerid] = 0;

		StopMapBGM(playerid);
		
		if (IsPlayerLoggedIn(playerid) && IsPlayerPaused(playerid) == 0)
		{
			survive[playerid] = 1;
			++gameInfo[gSurvivePlayers];
			respawnTime[playerid] = 0;
			burst[playerid] = 1;
			jump[playerid] = 1;

			vehicleFreeze[playerid] = 0;

			GameTextForPlayer(playerid, " ", 100, 3);

			SetPlayerNotReady(playerid);

			TriggerEventNoSuspend(playerMapStartEvent, "i", playerid);
		}
	}
}

public G_Core_RemoveMapElements()
{
	if (gameInfo[gMaxText3Ds] > Text3D: 0)
	{
		for (new i = 0, j = (_: gameInfo[gMaxText3Ds]); i <= j; ++i)
		{
			if (IsValidDynamic3DTextLabel(Text3D: i)) DestroyDynamic3DTextLabel(Text3D: i);
		}
	}

	gameInfo[gMaxText3Ds] = Text3D: 0;
	legacyMap = 1;
}

public G_Core_PlayerEliminated(playerid)
{
	if (IsGameProgress() == 0 && IsGameCount() == 0) SetPlayerReady(playerid);
}

public G_Core_PlayerMapStart(playerid)
{
	SetPlayerRespawn(playerid);
}

function SetGameStartTime()
{
	gameInfo[gGameStartTime] = GetTickCount();
}

function SetTimeLeftTime(time)
{
	gameInfo[gTimeLeft] = time;
}

public OnRequestMapStart(status)
{
	if (status == 0)
	{
		if (gameInfo[gPlayers] > 0)
		{
			if (startDelayTimer != 0) KillTimer(startDelayTimer);

			contloop (new i : playerList)
			{
				if (IsPlayerLoggedIn(i)) FadeCamera(i, false, 1.75);
			}

			startDelayTimer = SetTimerEx("OnRequestMapStart", GetRealTimerTime(3000), 0, "i", 1);
		}
		else OnRequestMapStart(1);
	}
	else if (status == 1)
	{
		startDelayTimer = 0;
		mapChanging = 0;
		
		StartCurrentNextMap();
	}
}

function SetRequestMapStart(coolTime = 0)
{
	for (new i = 0, maxLoop = gameInfo[gSpawnPointCount]; i < maxLoop; ++i)
	{
		gameInfo[gSpawnCarModel][i] = 0;
		gameInfo[gSpawnPointX][i] = 0.0;
		gameInfo[gSpawnPointY][i] = 0.0;
		gameInfo[gSpawnPointZ][i] = 0.0;
		gameInfo[gSpawnPointA][i] = 0.0;
	}
	
	gameInfo[gSpawnPointCount] = 0;
	mapChanging = 1;

	contloop (new i : playerList)
		respawnTime[i] = 0;

	if (startDelayTimer != 0)
		KillTimer(startDelayTimer);

	if (coolTime != 0 && gameInfo[gPlayers] > 0)
		startDelayTimer = SetTimerEx("OnRequestMapStart", GetRealTimerTime(3000), 0, "i", 0);
	else
		OnRequestMapStart(0);
}

function CreateSpawnPoint(vehicleModel, Float: x, Float: y, Float: z, Float: a)
{
	new index = gameInfo[gSpawnPointCount];

	if (index >= MAX_SPAWN_POINTS) return 0;

	gameInfo[gSpawnCarModel][index] = vehicleModel;
	gameInfo[gSpawnPointX][index] = x;
	gameInfo[gSpawnPointY][index] = y;
	gameInfo[gSpawnPointZ][index] = z;
	gameInfo[gSpawnPointA][index] = a;

	++gameInfo[gSpawnPointCount];

	return 1;
}

function SelectPlayerSpawnPoint(playerid)
{
	new spawnPoint = playerid;
	new vehicleid = playerVehicle[playerid];
	new vehicleModel;
	new Float: fX, Float: fY, Float: fZ, Float: fA;

	if (spawnPoint >= gameInfo[gSpawnPointCount]) spawnPoint = (spawnPoint % gameInfo[gSpawnPointCount]);

	fX = spawnPositionX[playerid] = gameInfo[gSpawnPointX][spawnPoint];
	fY = spawnPositionY[playerid] = gameInfo[gSpawnPointY][spawnPoint];
	fZ = spawnPositionZ[playerid] = gameInfo[gSpawnPointZ][spawnPoint];
	fA = spawnPositionA[playerid] = gameInfo[gSpawnPointA][spawnPoint];
	vehicleModel = gameInfo[gSpawnCarModel][spawnPoint];

	if (GetVehicleModel(vehicleid) != vehicleModel)
		SetPlayerVehicleModel(playerid, vehicleid, vehicleModel, 1);
	else
		RefreshPlayerVehicle(playerid);
	
	vehicleid = playerVehicle[playerid];

	if (IsPlayerEnabledGhostMode(playerid))
		SetPlayerVirtualWorld(playerid, playerid + 1);
	else
		SetPlayerVirtualWorld(playerid, 0);

	SetVehiclePos(vehicleid, fX, fY, fZ);
	SetVehicleZAngle(vehicleid, fA);
	PutPlayerInVehicle(playerid, vehicleid, 0);
	SetCameraBehindPlayer(playerid);
	TogglePlayerHealthText(playerid, 1);
	TogglePlayerSpeedo(playerid, 1);

	if (survive[playerid] > 0)
		SetPlayerColor(playerid, 0xFFFFFFFF);

	SetPlayerFreeze(playerid, fX, fY, fZ, fA);

	if (IsGameProgress())
		SetTimerEx("SetPlayerUnfreeze", GetRealTimerTime(3000), 0, "i", playerid);
	else
	{
		if (gameInfo[gGameCount] != 0)
			TextDrawShowForPlayer(playerid, countText);
		else
			SetPlayerReady(playerid);
	}
}

stock GetGameTime()
{
	if (gameInfo[gGameStartTime] == 0)
		return 0;
	
	return ((GetTickCount() - gameInfo[gGameStartTime]) / 1000);
}

function UpdateGameTimeText()
{
	new chString[20];
	new gameTime = (GetTickCount() - gameInfo[gGameStartTime]) / 1000;
	new remTime = gameInfo[gTimeLeft] - gameTime;
	new rMinute, rSecond;
	new gMinute, gSecond;

	if (remTime < 0) remTime = 0;

	rMinute = (remTime / 60);
	rSecond = (remTime % 60);

	gMinute = (gameTime / 60);
	gSecond = (gameTime % 60);
	
	format(chString, sizeof(chString), "%02d:%02d   %02d:%02d", rMinute, rSecond, gMinute, gSecond);
	TextDrawSetString(timeText, chString);
}

function IsGameProgress()
{
	return (gameInfo[gGameStartTime] != 0 && gameInfo[gGameCount] <= 1);
}

function GetRandomSurvivePlayer()
{
	if (gameInfo[gSurvivePlayers] <= 0)
		return INVALID_PLAYER_ID;

	new targetid;
	new checked[MAX_PLAYERS];
	new playerCheckCount;
	
	do
	{
		targetid = random(MAX_PLAYERS);

		if (checked[targetid] == 0)
		{
			checked[targetid] = 1;

			if (++playerCheckCount >= MAX_PLAYERS) break;
		}
	} while (survive[targetid] <= 0);

	return targetid;
}

function SetPlayerJoinGame(playerid)
{
	++gameInfo[gPlayers];

	if (IsGameProgress() || IsGameCount()) FadeCamera(playerid, true, 1.75);

	TextDrawShowForPlayer(playerid, mapInfoText);

	if (IsGameProgress())
	{
		TextDrawShowForPlayer(playerid, timeBox[0]);
		TextDrawShowForPlayer(playerid, timeBox[1]);
		TextDrawShowForPlayer(playerid, timeText);
	}
}

function SetPlayerNotReady(playerid)
{
	if (!IsPlayerConnected(playerid) || IsGameProgress() || IsGameCount() || survive[playerid] <= 0) return 0;
	
	notReady[playerid] = 1;

	return 1;
}

function SetPlayerReady(playerid)
{
	if (!IsPlayerConnected(playerid) || IsGameProgress() || IsGameCount()) return 0;

	notReady[playerid] = 0;

	if (GetNotReadyPlayerCount() == 0) StartGameCount();

	return 1;
}

function GetNotReadyPlayerCount()
{
	if (IsGameProgress() || IsGameCount()) return 0;

	new count;

	contloop (new i : playerList)
	{
		if (survive[i] > 0 && notReady[i] == 1) ++count;
	}

	return count;
}

#endif
