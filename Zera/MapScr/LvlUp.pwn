#if !defined __MAPSCR_LVLUP__
#define __MAPSCR_LVLUP__

static gravityjump1;
static gravityjump2;
static gravityjump3;

public MapScr_LvlUp_Start()
{
	gravityjump1 = CreateMarker(6030, -2815.6000976563, 3.9000000953674, MARKER_TYPE_CORONA, 10.0, 0, 0, 0, 0);
	gravityjump2 = CreateMarker(5161.7001953125, -3337.7998046875, 9.6000003814697, MARKER_TYPE_CORONA, 6.0, 0, 0, 0, 0);
	gravityjump3 = CreateMarker(5871.6000976563, -886.79998779297, 80.699996948242, MARKER_TYPE_CORONA, 6.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_LvlUp_PlayerMarkerHit");
}

public MapScr_LvlUp_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_LvlUp_PlayerMarkerHit");
}

public MS_LvlUp_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == gravityjump1)
	{
		new Float: fVX, Float: fVY, Float: fVZ;
		new vehicleid = GetPlayerVehicleID(playerid);

		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, -1.0, fVY - 0.1, fVZ + 2.0);

		return 1;
	}
	else if (markerid == gravityjump2)
	{
		new Float: fVX, Float: fVY, Float: fVZ;
		new vehicleid = GetPlayerVehicleID(playerid);

		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 1.0, fVY + 2.4, fVZ + 2.4);
	}
	else if (markerid == gravityjump3)
	{
		new Float: fVX, Float: fVY, Float: fVZ;
		new vehicleid = GetPlayerVehicleID(playerid);

		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 1.0, fVY + 2.4, fVZ + 2.4);
	}
	else
		return 0;
	
	return 1;
}

#endif
