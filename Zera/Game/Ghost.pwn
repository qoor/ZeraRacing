#if !defined _GAME_GHOST
#define _GAME_GHOST

InitModule("Game_Ghost")
{
	AddEventHandler(D_PlayerConnect, "G_Ghost_PlayerConnect");
	AddEventHandler(D_PlayerKeyStateChange, "G_Ghost_PlayerKeyStateChange");
	AddEventHandler(playerMapStartEvent, "G_Ghost_PlayerMapStart");
}

public G_Ghost_PlayerConnect(playerid)
{
	ghostMode[playerid] = 0;

	return 0;
}

public G_Ghost_PlayerKeyStateChange(playerid, newkeys)
{
	if (newkeys & KEY_ANALOG_RIGHT)
	{
		new string[145];

		if (ghostMode[playerid] == 0)
		{
			ghostMode[playerid] = 1;

			string = "고스트 모드가 켜졌습니다.";
		}
		else
		{
			ghostMode[playerid] = 0;

			string = "고스트 모드가 꺼졌습니다.";
		}

		if (IsArrivedSomeone() == 0 && survive[playerid] > 0)
		{
			new virtualWorld;
			
			if (ghostMode[playerid] == 0)
				strcat(string, " 타인이 보이지 않습니다.");
			else
			{
				virtualWorld = playerid + 1;

				strcat(string, " 타인이 보여집니다.");
			}

			SetPlayerVirtualWorld(playerid, virtualWorld);
			SetVehicleVirtualWorld(playerVehicle[playerid], virtualWorld);
		}

		ServerClientMessage(playerid, string);
		return 1;
	}

	return 0;
}

public G_Ghost_PlayerMapStart(playerid)
{
	if (GetPlayerVirtualWorld(playerid) == 0)
	{
		if (ghostMode[playerid] != 0)
		{
			SetPlayerVirtualWorld(playerid, playerid + 1);
			SetVehicleVirtualWorld(playerVehicle[playerid], playerid + 1);
		}
	}
	else if (ghostMode[playerid] == 0) SetPlayerVirtualWorld(playerid, 0);

	return 0;
}

function IsPlayerEnabledGhostMode(playerid)
{
	return (IsPlayerConnected(playerid) && survive[playerid] == -1 || (IsArrivedSomeone() == 0 && ghostMode[playerid] != 0));
}

#endif
