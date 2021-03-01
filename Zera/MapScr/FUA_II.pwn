#if !defined __MAPSCR_FUA_II__
#define __MAPSCR_FUA_II__

static marker1;
static marker2;
static marker3;

public MapScr_FUA_II_Start()
{
	marker1 = CreateMarker(6624.0732421875, -136.337890625, 32.825424194336, MARKER_TYPE_CORONA, 5.0, 0, 0, 0, 0);
	marker2 = CreateMarker(6770.3388671875, 160.03080749512, 67.850044250488, MARKER_TYPE_CORONA, 5.0, 0, 0, 0, 0);
	marker3 = CreateMarker(6544.8198242188, 631.17034912109, 14.142715454102, MARKER_TYPE_CORONA, 5.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_FUA_II_PlayerMarkerHit");
}

public MapScr_FUA_II_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_FUA_II_PlayerMarkerHit");
}

public MS_FUA_II_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker1)
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 1.0, 1.0, 1.0);
	else if (markerid == marker2)
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, 1.0, 2.0);
	else if (markerid == marker3)
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, 0.0, 2.5);
	else
		return 0;
	
	return 1;
}

#endif