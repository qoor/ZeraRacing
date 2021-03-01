static marker1;
static marker2;

public MapScr_FirstShit_Start()
{
	marker1 = CreateMarker(3159.7, -2188.2, 5.7, MARKER_TYPE_CORONA, 5.0, 255, 0, 0, 255);
	marker2 = CreateMarker(3283.4, -1271.5, 77.4, MARKER_TYPE_CORONA, 3.0, 0, 0, 255, 255);

	AddEventHandler(playerMarkerHitEvent, "MS_FirstShit_PlayerMarkerHit");
}

public MapScr_FirstShit_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_FirstShit_PlayerMarkerHit");
}

public MS_FirstShit_PlayerMarkerHit(playerid, markerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (markerid == marker1)
		SetVehicleVelocity(vehicleid, 0.0, 3.0, 1.5);
	else if (markerid == marker2)
		SetVehicleVelocity(vehicleid, 0.0, 0.5, 3.0);
	else
		return 0;
	
	return 1;
}
