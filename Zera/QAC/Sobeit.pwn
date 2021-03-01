#if !defined __QAC_SOBEIT__
#define __QAC_SOBEIT__

InitModule("QAC_Sobeit")
{
	AddEventHandler(D_PlayerConnect, "QAC_Sobeit_PlayerConnect");
	AddEventHandler(playerSecondTimer, "QAC_Sobeit_PlayerSecondTimer");
}

public QAC_Sobeit_PlayerConnect(playerid)
{
	sobeitCheck[playerid] = -1;

	return 0;
}

public QAC_Sobeit_PlayerSecondTimer(playerid)
{
	if (sobeitCheck[playerid] > 0)
	{
		++sobeitCheck[playerid];

		if (sobeitCheck[playerid] > 3)
		{
			new Float: camVelTemp, Float: camVelZ;

			GetPlayerCameraFrontVector(playerid, camVelTemp, camVelTemp, camVelZ);

			if (camVelZ < -0.1)
			{
				OnPlayerCheatDetected(playerid, CHEAT_TYPE_SOBEIT);

				return 1;
			}

			if (sobeitCheck[playerid] == SOBEIT_CHECK_INIT_TIME)
			{
				playerPosZ[playerid] += 10.0;

				SetPlayerPos(playerid, playerPosX[playerid], playerPosY[playerid], playerPosZ[playerid]);
				SetCameraBehindPlayer(playerid);
			}
			else if (sobeitCheck[playerid] > SOBEIT_CHECK_INIT_TIME)
			{
				if (sobeitCheck[playerid] >= SOBEIT_CHECK_TIME)
				{
					sobeitCheck[playerid] = 0;

					SetPlayerVirtualWorld(playerid, 0);
					CallSobeitCheckPassEvent(playerid);
				}
				else
				{
					new Float: x, Float: y, Float: z;

					GetPlayerPos(playerid, x, y, z);

					if (x != playerPosX[playerid] || y != playerPosY[playerid] || z != playerPosZ[playerid] || GetPlayerAnimationIndex(playerid) != 1132)
					{
						OnPlayerCheatDetected(playerid, CHEAT_TYPE_SOBEIT);

						return 1;
					}
				}
			}
		}

		return 1;
	}

	return 0;
}

stock CheckSobeit(playerid)
{
	if (IsPlayerSobeitChecked(playerid)) return;
	
	sobeitCheck[playerid] = 1;
	freezeTime[playerid] = 0;

	ClearAnimations(playerid, 1);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	old_TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	GetPlayerPos(playerid, playerPosX[playerid], playerPosY[playerid], playerPosZ[playerid]);
}

stock StopCheckSobeit(playerid)
{
	if (IsPlayerSobeitChecked(playerid) == 0) return;

	sobeitCheck[playerid] = 0;

	ClearAnimations(playerid, 1);
	SetPlayerVirtualWorld(playerid, 0);
	old_TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);

	CallSobeitCheckPassEvent(playerid);
}

function IsPlayerSobeitChecked(playerid)
{
	return (IsPlayerConnected(playerid) && sobeitCheck[playerid] == 0);
}

function CallSobeitCheckPassEvent(playerid)
{
	TriggerEventNoSuspend(sobeitCheckPass, "i", playerid);
}

#endif
