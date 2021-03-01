static speed1;
static speed2;
static marker1;

public MapScr_RTD_III_Start()
{
	speed1 = CreateMarker(4456.7001953125, -1453.8000488281, 40.0, MARKER_TYPE_CORONA, 15.0, 1, 1, 1, 1);
	speed2 = CreateMarker(4499.1000976563, -1419.5999755859, 40.0, MARKER_TYPE_CORONA, 15.0, 1, 1, 1, 1);
	marker1 = CreateMarker(4746.2001953125, -514.0, 2064.3999023438, MARKER_TYPE_CORONA, 10.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_RTD_III_PlayerMarkerHit");
}

public MapScr_RTD_III_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_RTD_III_PlayerMarkerHit");
}

public MS_RTD_III_PlayerMarkerHit(playerid, markerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (markerid == speed1)
		SetVehicleVelocity(vehicleid, 1.0, 0.0, 1.0);
	else if (markerid == speed2)
		SetVehicleVelocity(vehicleid, 0.0, -1.0, 1.0);
	else if (markerid == marker1)
		SetPlayerTime(playerid, 5, 24);
	else
		return 0;
	
	return 1;
}
