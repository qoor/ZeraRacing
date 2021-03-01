#if !defined __QAC_POSITION__
#define __QAC_POSITION__

InitModule("QAC_Position")
{
	AddEventHandler(playerSecondTimer, "QAC_Position_PlayerSecondTimer");
}

public QAC_Position_PlayerSecondTimer(playerid)
{
	new vehicleid;

	if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
	{
		if (GetVehicleSpeed(vehicleid, 0) >= 1000)
		{
			OnPlayerCheatDetected(playerid, CHEAT_TYPE_SPEED);

			return 1;
		}
	}

	return 0;
}

#endif
