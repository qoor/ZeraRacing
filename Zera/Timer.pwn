#if !defined __TIMER__
#define __TIMER__

InitModule("Timer")
{
	SetTimer("OnSecondTimer", GetRealTimerTime(1000), 1);
	SetTimer("On80msTimer", GetRealTimerTime(100), 1);
	SetTimer("On50msTimer", GetRealTimerTime(50), 1);
}

public OnSecondTimer()
{
	HandlerLoop (globalSecondTimer)
	{
		if ((HandlerAction(globalSecondTimer, "")) != 0) break;
	}

	contloop (new playerid : playerList)
	{
		HandlerLoop (playerSecondTimer)
		{
			if ((HandlerAction(playerSecondTimer, "i", playerid)) != 0) break;
		}
	}
}

public On80msTimer()
{
	HandlerLoop (global80msTimer)
	{
		if ((HandlerAction(global80msTimer, "")) != 0) break;
	}

	contloop (new playerid : playerList)
	{
		HandlerLoop (player80msTimer)
		{
			if ((HandlerAction(player80msTimer, "i", playerid)) != 0) break;
		}
	}
}

public On50msTimer()
{
	HandlerLoop (global50msTimer)
	{
		if ((HandlerAction(global50msTimer, "")) != 0) break;
	}
}

#endif
