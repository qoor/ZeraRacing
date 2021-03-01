#if !defined __MAPSCR_BLANK__
#define __MAPSCR_BLANK__

static marker;

public MapScr_Blank_Start()
{
	marker = CreateMarker(4062.5183105469516465, -2031.5021972656, 1023.913757324, MARKER_TYPE_CORONA, 2.0, 155, 300, 200, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Blank_PlayerMarkerHit");
}

public MapScr_Blank_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Blank_PlayerMarkerHit");
}

public MS_Blank_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, 1.0, 0.0);

		return 1;
	}

	return 0;
}

#endif
