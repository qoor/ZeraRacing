static marker1;

public MapScr_MadWorld_Start()
{
	marker1 = CreateMarker(0.0, 0.0, 159.69999694824, MARKER_TYPE_CORONA, 30.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_MadWorld_PlayerMarkerHit");
}

public MapScr_MadWorld_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_MadWorld_PlayerMarkerHit");
}

public MS_MadWorld_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker1)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, -10.0, 0.0);

		return 1;
	}

	return 0;
}
