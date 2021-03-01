#if !defined __GAME_SURVIVAL__
#define __GAME_SURVIVAL__

InitModule("Game_Survival")
{
	AddEventHandler(D_PlayerConnect, "G_Survival_PlayerConnect");
	AddEventHandler(D_PlayerSpawn, "G_Survival_PlayerSpawn");
	AddEventHandler(D_PlayerKeyStateChange, "G_Survival_PlayerKeyStateChange");
	AddEventHandler(D_PlayerDeath, "G_Survival_PlayerDeath");
	AddEventHandler(D_PlayerDisconnect, "G_Survival_PlayerDisconnect");
	AddEventHandler(playerSecondTimer, "G_Survival_PlayerSecondTimer");
	AddEventHandler(gamemodeMapStartEvent, "G_Survival_GamemodeMapStart");
	AddEventHandler(playerMapStartEvent, "G_Survival_PlayerMapStart");
	AddEventHandler(playerEliminatedEvent, "G_Survival_PlayerEliminated");
	AddEventHandler(playerPausedEvent, "G_Survival_PlayerPaused");
}

public G_Survival_PlayerConnect(playerid)
{
	survive[playerid] = 0;
	playerNoMove[playerid] = 0;

	lastPosX[playerid] = 0.0;
	lastPosY[playerid] = 0.0;
	lastPosZ[playerid] = 0.0;

	return 0;
}

public G_Survival_PlayerSpawn(playerid)
{
	#if SAMP_VERSION == SAMP_03d
		TextDrawShowForPlayer(playerid, deathListText[playerid]);
	#else
		PlayerTextDrawShow(playerid, deathListText[playerid]);
	#endif

	return 0;
}

public G_Survival_PlayerKeyStateChange(playerid, newkeys)
{
	if (IsGameProgress() && newkeys & KEY_SECONDARY_ATTACK)
	{
		if (GetPlayerVehicleID(playerid) != 0)
		{
			PlayerKill(playerid);

			return 1;
		}
	}

	return 0;
}

public G_Survival_PlayerDeath(playerid)
{
	if (survive[playerid] != 0) SetPlayerEliminate(playerid);

	return 0;
}

public G_Survival_PlayerDisconnect(playerid)
{
	if (modeExit == 0 && survive[playerid] != 0) SetPlayerEliminate(playerid);

	if (deathListIndex != -1)
	{
		for (new i = deathListIndex; i < deathListMaxIndex; ++i)
		{
			if (deathInfo[i][diPlayer] == playerid)
			{
				deathInfo[i][diPlayer] = INVALID_PLAYER_ID;

				break;
			}
		}
	}

	UpdateDeathList();

	return 0;
}

public G_Survival_PlayerSecondTimer(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new vehicleModel = GetVehicleModel(vehicleid);

	if (survive[playerid] != 0)
	{
		new Float: x, Float: y, Float: z;

		GetPlayerPos(playerid, x, y, z);

		if (IsGameProgress())
		{
			if (ignoreWaterKill == 0 && z < -0.5)
			{
				if (GetPlayerState(playerid) != PLAYER_STATE_WASTED && IsVehicleModelBoat(vehicleModel) == 0)
					PlayerKill(playerid);
			}

			#if DEBUG_MODE == 0
				if (GetPlayerDistanceFromPoint(playerid, lastPosX[playerid], lastPosY[playerid], lastPosZ[playerid]) < MIN_PLAYER_MOVE)
				{
					if ((++playerNoMove[playerid]) >= MAX_PLAYER_NO_MOVE_TIME) SetPlayerEliminate(playerid, 1);
					else if (playerNoMove[playerid] >= MAX_PLAYER_NO_MOVE_TIME - 5)
					{
						new string[145];

						format(string, sizeof(string), "움직임이 없습니다. %d초 안에 움직이지 않으면 탈락됩니다.", MAX_PLAYER_NO_MOVE_TIME - playerNoMove[playerid]);
						ServerClientMessage(playerid, string);
					}
				}
				else
				{
					if (playerNoMove[playerid] != 0) playerNoMove[playerid] = 0;

					lastPosX[playerid] = x;
					lastPosY[playerid] = y;
					lastPosZ[playerid] = z;
				}
			#endif
		}

		#if DEBUG_MODE == 0
			if (IsPlayerPaused(playerid) && playerNoMove[playerid] == 0)
			{
				new time = GetPlayerPauseTime(playerid);

				if (time >= MAX_PAUSE_TIME) SetPlayerEliminate(playerid, 1);
				else if (time >= MAX_PAUSE_TIME - 5)
				{
					new string[145];

					format(string, sizeof(string), "잠수로 인해 %d초 뒤 자동 탈락됩니다.", MAX_PAUSE_TIME - time);
					ServerClientMessage(playerid, string);
				}
			}
		#endif
	}

	if (vehicleid == playerVehicle[playerid] && (DEBUG_MODE != 0 || vehicleModel == 425 || legacyMap == 1)) RepairVehicle(vehicleid);

	if (respawnTime[playerid] != 0)
	{
		--respawnTime[playerid];

		if (respawnTime[playerid] == 1) ClearAnimations(playerid, 1);
		else if (respawnTime[playerid] == 0) SetPlayerRespawn(playerid);
	}

	return 0;
}

public G_Survival_GamemodeMapStart()
{
	if (deathListIndex != -1)
	{
		for (new i = deathListIndex; i <= deathListMaxIndex; ++i)
		{
			deathInfo[i][diPlayer] = INVALID_PLAYER_ID;
			strcpy(deathInfo[i][diName], " ", MAX_PLAYER_NAME);
			deathInfo[i][diHour] = 0;
			deathInfo[i][diMinute] = 0;
			deathInfo[i][diSecond] = 0;
		}

		deathListIndex = -1;
		deathListMaxIndex = -1;
	}
}

public G_Survival_PlayerMapStart(playerid)
{
	#if SAMP_VERSION == SAMP_03d
		TextDrawSetString(deathListText[playerid], " ");
	#else
		PlayerTextDrawSetString(playerid, deathListText[playerid], " ");
	#endif
}

public G_Survival_PlayerEliminated(playerid, oldsurvive)
{
	if (oldsurvive <= 0)
		return;
	
	UpdateDeathList(playerid);
	
	if (gameInfo[gSurvivePlayers] > 0)
	{
		if (IsGameProgress())
		{
			if (gameInfo[gSurvivePlayers] == 1)
			{
				new i;

				contloop (i : playerList)
				{
					if (survive[i] > 0)
					{
						gameInfo[gWinner] = i;

						break;
					}
				}

				new string[145];

				format(string, sizeof(string), "~w~%s ~y~is last survivor!", playerName[i]);
				GameTextForAll(string, 10000, 3);
				format(string, sizeof(string), "%s(id:%d){FFFFFF}님이 마지막으로 생존하셨습니다!", playerName[i], i);
				SendClientMessageToGamePlayers(string);
			}

			GivePlayerExp(playerid, NORMAL_ELIMINATED_EXP);
			GivePlayerMoney(playerid, NORMAL_ELIMINATED_MONEY);
			SavePlayerAccount(playerid);

			ServerClientMessage(playerid, "당신은 "#NORMAL_ELIMINATED_EXP"EXP와 $"#NORMAL_ELIMINATED_MONEY"을(를) 받았습니다.");
		}
	}
	else
	{
		if (IsGameProgress() && gameInfo[gWinner] == playerid)
		{
			GivePlayerExp(playerid, LAST_ELIMINATED_EXP);
			GivePlayerMoney(playerid, LAST_ELIMINATED_MONEY);
			SavePlayerAccount(playerid);

			ServerClientMessage(playerid, "당신은 "#LAST_ELIMINATED_EXP"EXP와 $"#LAST_ELIMINATED_MONEY"을(를) 받았습니다.");

			new Float: x, Float: y, Float: z;
			new Float: camX, Float: camY, Float: camZ;

			GetPlayerPos(playerid, x, y, z);

			contloop (new i : playerList)
			{
				if (spectatePlayer[i] == playerid)
				{
					GetPlayerPos(i, camX, camY, camZ);
					SetPlayerCameraPos(i, camX, camY, camZ);
					SetPlayerCameraLookAt(i, x, y, z);
					
					TogglePlayerHealthText(i, 0);
					TogglePlayerSpeedo(i, 0);

					spectatePlayer[i] = INVALID_PLAYER_ID;
				}
			}

			TextDrawHideForAll(respawnText);
		}

		SetRequestMapStart(1);
	}

	SetPlayerColor(playerid, 0xAAAAAA00);
}

public G_Survival_PlayerPaused(playerid)
{
	if (IsGameProgress() == 0 && notReady[playerid] == 1 && survive[playerid] > 0) SetPlayerEliminate(playerid, 1);
}

function SetPlayerEliminate(playerid, respawn = 0)
{
	#if DEBUG_MODE == 0
		if (IsPlayerLoggedIn(playerid) && survive[playerid] != 0 && modeExit == 0 && mapChanging == 0)
		{
			new oldSurvive = survive[playerid];

			survive[playerid] = 0;

			if (oldSurvive > 0) --gameInfo[gSurvivePlayers];

			TriggerEventNoSuspend(playerEliminatedEvent, "ii", playerid, oldSurvive);

			if (notReady[playerid] != 0) SetPlayerReady(playerid);

			if (respawn == 1)
			{
				if (ghostMode[playerid] == 0) SetVehicleVirtualWorld(playerVehicle[playerid], playerid + 1);

				SetPlayerRespawn(playerid);
			}

			return 1;
		}

		return 0;
	#else
		if (IsPlayerLoggedIn(playerid) && respawn != 0) {}
		
		return 1;
	#endif
}

function UpdateDeathList(deathPlayer = INVALID_PLAYER_ID)
{
	#if DEBUG_MODE == 0
		if (IsPlayerConnected(deathPlayer))
		{
			if (deathListIndex == -1) deathListMaxIndex = deathListIndex = gameInfo[gSurvivePlayers];
			else --deathListIndex;

			if (deathListIndex >= 0)
			{
				new time = GetGameTime();

				deathInfo[deathListIndex][diPlayer] = deathPlayer;
				strcpy(deathInfo[deathListIndex][diName], playerName[deathPlayer], MAX_PLAYER_NAME);
				deathInfo[deathListIndex][diHour] = (time / 3600);
				deathInfo[deathListIndex][diMinute] = ((time % 3600) / 60);
				deathInfo[deathListIndex][diSecond] = ((time % 3600) % 60);
			}
		}

		contloop (new i : playerList)
		{
			if (IsPlayerLoggedIn(i)) UpdatePlayerDeathList(i);
		}
	#else
		if (IsPlayerConnected(deathPlayer)) {}
	#endif
}

stock UpdatePlayerDeathList(playerid)
{
	#if DEBUG_MODE == 0
		if (deathListMaxIndex != -1 && deathListIndex >= 0)
		{
			new string[1024];
			new targetid;
			new spectateMe;
			new showPlayer = (spectatePlayer[playerid] == INVALID_PLAYER_ID) ? playerid : spectatePlayer[playerid];

			for (new i = deathListMaxIndex; i >= deathListIndex; --i)
			{
				spectateMe = 0;
				targetid = deathInfo[i][diPlayer];

				if (playerid == targetid)
				{
					if (survive[playerid] == -1) spectateMe = 1;
				}
				else if (IsPlayerConnected(targetid))
				{
					if (survive[showPlayer] >= 1 && survive[targetid] == 0 && spectatePlayer[targetid] == showPlayer) spectateMe = 1;
				}

				if (spectateMe == 0)
				{
					if (i == deathListMaxIndex)
					{
						format(string, sizeof(string), "~w~%d) %s: %d:%02d:%02d", i + 1, deathInfo[i][diName], deathInfo[i][diHour], deathInfo[i][diMinute], deathInfo[i][diSecond]);
					}
					else
					{
						format(string, sizeof(string), "~w~%d) %s: %d:%02d:%02d~n~%s", i + 1, deathInfo[i][diName],
							deathInfo[i][diHour], deathInfo[i][diMinute], deathInfo[i][diSecond], string);
					}
				}
				else
				{
					if (i == deathListMaxIndex)
					{
						format(string, sizeof(string), "~y~%d) ~w~%s: %d:%02d:%02d", i + 1, deathInfo[i][diName], deathInfo[i][diHour], deathInfo[i][diMinute], deathInfo[i][diSecond]);
					}
					else
					{
						format(string, sizeof(string), "~y~%d) ~w~%s: %d:%02d:%02d~n~%s", i + 1, deathInfo[i][diName],
							deathInfo[i][diHour], deathInfo[i][diMinute], deathInfo[i][diSecond], string);
					}
				}
			}

			#if SAMP_VERSION == SAMP_03d
				TextDrawSetString(deathListText[playerid], string);
			#else
				PlayerTextDrawSetString(playerid, deathListText[playerid], string);
			#endif
		}
	#endif
}

#endif
