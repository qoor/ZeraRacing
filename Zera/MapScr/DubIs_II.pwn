#if !defined __MAPSCR_DUBIS_II__
#define __MAPSCR_DUBIS_II__

static marker;

public MapScr_DubIs_II_Start()
{
	SetWeather(5);

	marker = CreateMarker(5043.212890625, 622.728515625, 1277.3880615234, MARKER_TYPE_CORONA, 4.0, 0, 0, 0, 0);
	
	AddEventHandler(playerMarkerHitEvent, "MS_DubIs_II_PlayerMarkerHit");
}

public MapScr_DubIs_II_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_DubIs_II_PlayerMarkerHit");
}

public MS_DubIs_II_PlayerMarkerHit(playerid, markerid)
{
	if (marker == markerid)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), -2.0, 1.63, 1.2);

		return 1;
	}

	return 0;
}

#endif
