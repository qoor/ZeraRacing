static marker;

public MapScr_Lullaby_Start()
{
	marker = CreateMarker(2438.5529785156, -3542.7993164063, 3.841064453125, MARKER_TYPE_CORONA, 15.0, 255, 255, 255, 255);

	AddEventHandler(playerMarkerHitEvent, "MS_Lullaby_PlayerMarkerHit");
}

public MapScr_Lullaby_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Lullaby_PlayerMarkerHit");
}

public MS_Lullaby_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), -3.0, 0.0, 0.8);

		return 1;
	}

	return 0;
}
