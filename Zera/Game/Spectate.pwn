#if !defined __GAME_SPECTATE__
#define __GAME_SPECTATE__

InitModule("Game_Spectate")
{
	AddEventHandler(D_PlayerConnect, "G_Spectate_PlayerConnect");
	AddEventHandler(D_PlayerSpawn, "G_Spectate_PlayerSpawn");
	AddEventHandler(D_VehicleStreamOut, "G_Spectate_VehicleStreamOut");
	AddEventHandler(D_PlayerUpdate, "G_Spectate_PlayerUpdate");
	AddEventHandler(D_PlayerKeyStateChange, "G_Spectate_PlayerKeyStateChange");
	AddEventHandler(D_PlayerClickPlayer, "G_Spectate_PlayerClickPlayer");
	AddEventHandler(playerEliminatedEvent, "G_Spectate_PlayerEliminated");
}

public G_Spectate_PlayerConnect(playerid)
{
	spectatePlayer[playerid] = INVALID_PLAYER_ID;
	lrKeyPressed[playerid] = 0;

	return 0;
}

public G_Spectate_PlayerSpawn(playerid)
{
	if (IsGameProgress() && survive[playerid] == 0)
	{
		new targetid;

		if ((targetid = GetRandomSurvivePlayer()) != INVALID_PLAYER_ID)
		{
			SetPlayerSpectatePlayer(playerid, targetid);
			ServerClientMessage(playerid, "현재 게임이 진행중입니다. 다른 플레이어를 관전합니다.");
			ServerClientMessage(playerid, "방향키 좌, 우키를 누르거나 Tab키를 누르고 플레이어를 더블클릭 하여 다른 플레이어를 관전할 수 있습니다.");
		}
	}

	return 0;
}

public G_Spectate_VehicleStreamOut(vehicleid, forplayerid)
{
	if (survive[forplayerid] == 0 && spectatePlayer[forplayerid] != INVALID_PLAYER_ID)
	{
		if (vehicleid == GetPlayerVehicleID(spectatePlayer[forplayerid])) UpdatePlayerSpectating(forplayerid);
	}

	return 0;
}

public G_Spectate_PlayerUpdate(playerid)
{
	if (survive[playerid] == 0 && spectatePlayer[playerid] != INVALID_PLAYER_ID)
	{
		new tempKey, leftright;

		GetPlayerKeys(playerid, tempKey, tempKey, leftright);

		if (lrKeyPressed[playerid] != leftright)
		{
			if (leftright != 0) ChangePlayerSpectatePlayer(playerid, leftright);
			
			lrKeyPressed[playerid] = leftright;
		}
	}

	return 1;
}

public G_Spectate_PlayerKeyStateChange(playerid, newkeys)
{
	if (survive[playerid] == 0 && lrKeyPressed[playerid] == 0)
	{
		if (newkeys == KEY_FIRE)
		{
			ChangePlayerSpectatePlayer(playerid, KEY_LEFT);

			return 1;
		}
		else if (newkeys == KEY_HANDBRAKE)
		{
			ChangePlayerSpectatePlayer(playerid, KEY_RIGHT);

			return 1;
		}
	}

	return 0;
}

public G_Spectate_PlayerClickPlayer(playerid, clickplayerid)
{
	if (survive[playerid] != 0)
	{
		ServerClientMessage(playerid, "게임 중에는 다른 플레이어를 관전할 수 없습니다.");

		return 1;
	}
	if (survive[clickplayerid] <= 0)
	{
		ServerClientMessage(playerid, "생존하지 않은 플레이어입니다.");

		return 1;
	}
	if (spectatePlayer[playerid] == clickplayerid) return 1;

	SetPlayerSpectatePlayer(playerid, clickplayerid);

	return 0;
}

public G_Spectate_PlayerEliminated(playerid)
{
	if (gameInfo[gSurvivePlayers] > 0) StopSpectatePlayer(playerid);
}

function SetPlayerSpectatePlayer(playerid, targetid)
{
	if (!IsPlayerConnected(targetid) || survive[targetid] == 0) return 0;

	spectatePlayer[playerid] = targetid;

	TogglePlayerSpectating(playerid, 1);
	UpdatePlayerSpectating(playerid);

	return 1;
}

function ChangePlayerSpectatePlayer(playerid, lrKey)
{
	new minID = INVALID_PLAYER_ID, maxID = INVALID_PLAYER_ID;

	contloop (new i : playerList)
	{
		if (survive[i] > 0)
		{
			if (minID == INVALID_PLAYER_ID) minID = i;

			maxID = i;
		}
	}

	if (minID != INVALID_PLAYER_ID)
	{
		new newSpecPlayer = spectatePlayer[playerid];

		if (minID == maxID) newSpecPlayer = minID;
		else
		{
			if (lrKey == KEY_LEFT)
			{
				do
				{
					if (--newSpecPlayer < minID)
					{
						newSpecPlayer = maxID;

						break;
					}
				} while (survive[newSpecPlayer] <= 0);
			}
			else
			{
				do
				{
					if (++newSpecPlayer > maxID)
					{
						newSpecPlayer = minID;

						break;
					}
				} while (survive[newSpecPlayer] <= 0);
			}
		}

		if (newSpecPlayer != spectatePlayer[playerid]) SetPlayerSpectatePlayer(playerid, newSpecPlayer);
	}
}

function UpdatePlayerSpectating(playerid)
{
	new targetid = spectatePlayer[playerid];
	
	if (survive[playerid] != 0 || targetid == INVALID_PLAYER_ID) return 0;
	if (!IsPlayerConnected(targetid))
	{
		StopPlayerSpectating(playerid);

		return 0;
	}

	new targetVehicle = playerVehicle[targetid];
	
	new Float: fX, Float: fY, Float: fZ;

	GetVehiclePos(targetVehicle, fX, fY, fZ);
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
	Streamer_UpdateEx(playerid, fX, fY, fZ);
	PlayerSpectateVehicle(playerid, targetVehicle);

	if (GetVehicleModel(targetVehicle) == 425) TogglePlayerSpeedo(playerid, 0);

	UpdateDeathList();

	return 1;
}

function StopSpectatePlayer(targetid)
{
	contloop (new playerid : playerList)
	{
		if (spectatePlayer[playerid] == targetid) StopPlayerSpectating(playerid);
	}
}

function StopPlayerSpectating(playerid)
{
	if (spectatePlayer[playerid] != INVALID_PLAYER_ID)
	{
		spectatePlayer[playerid] = INVALID_PLAYER_ID;

		UpdateDeathList();
	}
	
	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) TogglePlayerSpectating(playerid, 0);
	else SpawnPlayer(playerid);
}

#endif
