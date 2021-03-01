#if !defined __QAC_FREEZE__
#define __QAC_FREEZE__

InitModule("QAC_Freeze")
{
	AddEventHandler(D_PlayerConnect, "QAC_Freeze_PlayerConnect");
}

public QAC_Freeze_PlayerConnect(playerid)
{
	freezeTime[playerid] = 0;

	return 0;
}

public QAC_Freeze_PlayerSecondTimer(playerid)
{
	if (freezeTime[playerid] != 0)
	{
		old_TogglePlayerControllable(playerid, 1);

		if (freezeTime[playerid] > 0) --freezeTime[playerid];
		if (freezeTime[playerid] != 0) old_TogglePlayerControllable(playerid, 0);
	}

	return 0;
}

#endif
