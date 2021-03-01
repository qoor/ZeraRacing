#if !defined __MAPSCR_CRAVING__
#define __MAPSCR_CRAVING__

static gravityjump;

public MapScr_Craving_Start()
{
	gravityjump = CreateMarker(7725.9033203125, -2082.71484375, 17.239999771118, MARKER_TYPE_CORONA, 10.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Craving_PlayerMarkerHit");
}

public MapScr_Craving_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Craving_PlayerMarkerHit");
}

public MS_Craving_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == gravityjump)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, -4.0, 6.0);

		return 1;
	}

	return 0;
}

#endif
