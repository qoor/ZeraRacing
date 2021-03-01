#if !defined __PLAYER_PAUSE__
#define __PLAYER_PAUSE__

InitModule("Player_Pause")
{
	AddEventHandler(D_PlayerConnect, "P_Pause_PlayerConnect");
	AddEventHandler(D_PlayerUpdate, "P_Pause_PlayerUpdate");
	AddEventHandler(playerSecondTimer, "P_Pause_PlayerSecondTimer");
}

public P_Pause_PlayerConnect(playerid)
{
	paused[playerid] = 0;
	pauseTime[playerid] = 0;
	pauseNoticed[playerid] = 0;

	return 0;
}

public P_Pause_PlayerUpdate(playerid)
{
	if (paused[playerid] == 1)
	{
		paused[playerid] = 0;
		pauseTime[playerid] = 0;
		pauseNoticed[playerid] = 0;
	}

	return 1;
}

public P_Pause_PlayerSecondTimer(playerid)
{
	if (IsPlayerLoggedIn(playerid))
	{
		if (paused[playerid] == 0) paused[playerid] = 1;
		else
		{
			if ((++pauseTime[playerid]) >= 2 && pauseNoticed[playerid] == 0)
			{
				TriggerEventNoSuspend(playerPausedEvent, "i", playerid);

				pauseNoticed[playerid] = 1;
			}
		}
	}

	return 0;
}

stock IsPlayerPaused(playerid)
{
	return (IsPlayerConnected(playerid) && IsPlayerLoggedIn(playerid) && pauseTime[playerid] >= 2);
}

stock GetPlayerPauseTime(playerid)
{
	return (IsPlayerConnected(playerid) ? pauseTime[playerid] : 0);
}

#endif
