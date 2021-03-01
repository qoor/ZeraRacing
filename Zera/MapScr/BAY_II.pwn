#if !defined __MAPSCR_BAY_II__
#define __MAPSCR_BAY_II__

public MapScr_BAY_II_Start()
{
	SetWeather(11);
	SetWorldTime(7);

	AddEventHandler(playerSecondTimer, "MS_BAY_II_PlayerSecondTimer");
}

public MapScr_BAY_II_Stop()
{
	RemoveEventHandler(playerSecondTimer, "MS_BAY_II_PlayerSecondTimer");
}

public MS_BAY_II_PlayerSecondTimer(playerid)
{
	new vehicleid;

	if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
		ChangeVehicleColor(vehicleid, 6, 0);
}

#endif
