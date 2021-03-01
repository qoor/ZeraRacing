#if !defined __MAPSCR_RAINDRPS__
#define __MAPSCR_RAINDRPS__

static marker;

public MapScr_RainDrps_Start()
{
	marker = CreateMarker(7232.494140625, -8335.197265625, 21.372318267822, MARKER_TYPE_ARROW, 10.0, 25, 55, 27, 225);

	AddEventHandler(playerMarkerHitEvent, "MS_RainDrps_PlayerMarkerHit");
}

public MapScr_RainDrps_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_RainDrps_PlayerMarkerHit");
}

public MS_RainDrps_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, 5.0, 6.0);

		return 1;
	}

	return 0;
}

#endif
