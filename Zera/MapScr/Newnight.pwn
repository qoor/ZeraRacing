#if !defined __MAPSCR_NEWNIGHT__
#define __MAPSCR_NEWNIGHT__

static speed;
static speed1;

static marker1;
static marker2;

public MapScr_Newnight_Start()
{
	speed = CreateMarker(3425.3266601563, -1755.1885986328, 41.308689117432, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);
	speed1 = CreateMarker(3425.3266601563, -1724.9295654297, 41.308689117432, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);

	marker1 = CreateMarker(5520.482421875, -895.27612304688, 5.7020754814148, MARKER_TYPE_CORONA, 5.0, 0, 0, 0, 0);
	marker2 = CreateMarker(5364.3603515625, -895.27612304688, 5.7020754814148, MARKER_TYPE_CORONA, 5.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Newnight_PlayerMarkerHit");
}

public MapScr_Newnight_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Newnight_PlayerMarkerHit");
}

public MS_Newnight_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == speed || markerid == speed1)
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 2.0, 0.0, 0.6);
	else if (markerid == marker1 || markerid == marker2)
	{
		SetPlayerFreeze(playerid, 2982.3312988281, 2400.6540527344, 734.54528808594, 270.0);
		SetTimerEx("SetPlayerUnfreeze", GetRealTimerTime(1000), 0, "i", playerid);
	} 
	else
		return 0;
	
	return 1;
}

#endif
