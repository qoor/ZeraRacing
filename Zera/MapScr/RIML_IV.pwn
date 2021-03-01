#if !defined __MAPSCR_RIML_IV__
#define __MAPSCR_RIML_IV__

static marker1;

public MapScr_RIML_IV_Start()
{
	marker1 = CreateMarker(1922.6434326172, -5129.04296875, 2.5284581184387, MARKER_TYPE_CORONA, 25.0, 0, 0, 0, 0);
	
	AddEventHandler(playerMarkerHitEvent, "MS_RIML_IV_PlayerMarkerHit");
}

public MapScr_RIML_IV_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_RIML_IV_PlayerMarkerHit");
}

public MS_RIML_IV_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker1)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, -0.5, 1.7);

		return 1;
	}

	return 0;
}

#endif
