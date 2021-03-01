#if !defined __GAME_COUNT__
#define __GAME_COUNT__

InitModule("Game_Count")
{
	AddEventHandler(gamemodeMapStartEvent, "G_Count_GamemodeMapStart");
	AddEventHandler(globalSecondTimer, "G_Count_GlobalSecondTimer");
}

public G_Count_GamemodeMapStart()
{
	if (countDelayTimer != 0)
	{
		KillTimer(countDelayTimer);

		countDelayTimer = 0;
	}

	TextDrawHideForAll(countText);

	gameInfo[gGameCount] = 0;
}

public G_Count_GlobalSecondTimer()
{
	if (gameInfo[gGameCount] != 0)
	{
		--gameInfo[gGameCount];

		if (gameInfo[gGameCount] >= 2 && gameInfo[gGameCount] <= 4)
		{
			new count[2];

			valstr(count, gameInfo[gGameCount] - 1);
			TextDrawSetString(countText, count);

			contloop (new playerid : playerList)
			{
				if (IsPlayerLoggedIn(playerid))
				{
					if (gameInfo[gGameCount] == 4) TextDrawShowForPlayer(playerid, countText);

					PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
				}
			}
		}
		else if (gameInfo[gGameCount] == 1)
		{
			if (gameInfo[gSurvivePlayers] < 1)
			{
				gameInfo[gGameCount] = 0;
				
				SetRequestMapStart();
			}
			else
			{
				new vehicleid;

				//SetGravity(0.008);
				TextDrawSetString(countText, "Go!");
				SetGameStartTime();
				UpdateGameTimeText();
				
				contloop (new playerid : playerList)
				{
					if (IsPlayerLoggedIn(playerid))
					{
						TextDrawShowForPlayer(playerid, timeBox[0]);
						TextDrawShowForPlayer(playerid, timeBox[1]);
						TextDrawShowForPlayer(playerid, timeText);
						PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
						
						if (survive[playerid] > 0)
						{
							if ((vehicleid = playerVehicle[playerid]) != 0)
							{
								SetPlayerUnfreeze(playerid);

								if (legacyMap == 1)
								{
									new keys, temp;
									
									GetPlayerKeys(playerid, keys, temp, temp);

									if (keys & KEY_FIRE)
									{
										nitroUse[playerid] = 1;
										
										AddVehicleComponent(vehicleid, 1010);
									}
								}
							}
						}
						else if (survive[playerid] == 0) TextDrawShowForPlayer(playerid, respawnText);
					}
				}
			}
		}
		else if (gameInfo[gGameCount] == 0) TextDrawHideForAll(countText);
	}

	return 0;
}

function StartGameCount()
{
	if (IsGameProgress() || IsGameCount() || countDelayTimer != 0) return 0;
			
	countDelayTimer = SetTimer("OnRequestStartCount", GetRealTimerTime(1000), 0);

	return 1;
}

function IsGameCount()
{
	return (IsGameProgress() == 0 && (gameInfo[gGameCount] > 0 || countDelayTimer != 0));
}

public OnRequestStartCount()
{
	countDelayTimer = 0;
	
	if (gameInfo[gSurvivePlayers] >= 1 && IsGameProgress() == 0 && gameInfo[gGameCount] == 0)
	{
		gameInfo[gGameCount] = 7;

		TextDrawSetString(countText, " ");

		contloop (new playerid : playerList)
		{
			if (IsPlayerLoggedIn(playerid))
			{
				FadeCamera(playerid, true, 1.75);
				TextDrawShowForPlayer(playerid, countText);
			}
		}
	}
}

#endif
