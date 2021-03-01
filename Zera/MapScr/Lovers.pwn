static jumpMarker;

public MapScr_Lovers_Start()
{
	jumpMarker = CreateMarker(3620.6999511719, -6891.8999023438, 32.400001525879, MARKER_TYPE_CORONA, 0.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Lovers_PlayerMarkerHit");
}

public MapScr_Lovers_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Lovers_PlayerMarkerHit");
}

public MS_Lovers_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == jumpMarker)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, -2.0, 10.0);

		return 1;
	}

	return 0;
}
