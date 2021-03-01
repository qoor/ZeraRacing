#if !defined __MAPSCR_RUFFNECK__
#define __MAPSCR_RUFFNECK__

static gravityjump1;
static gravityjump2;
static gravityjump3;
static gravityjump4;
static gravityjump5;

public MapScr_Ruffneck_Start()
{
	gravityjump1 = CreateMarker(3792.3999022345, -2292.0, 19.10000038147, MARKER_TYPE_RING, 4.0, 0, 0, 0, 0);
	gravityjump2 = CreateMarker(4421.1000976563, 99.5, 67.800003051758, MARKER_TYPE_RING, 4.0, 0, 0, 0, 0);
	gravityjump3 = CreateMarker(3897.4013671875, -2374.580078125, 11.202823638916, MARKER_TYPE_CORONA, 9.0, 0, 0, 0, 0);
	gravityjump4 = CreateMarker(4184.974609375, -3310.3620605469, 6.0, MARKER_TYPE_RING, 10.0, 0, 0, 0, 0);
	gravityjump5 = CreateMarker(1111.0, -1435.3000488281, 7.8000001907349, MARKER_TYPE_RING, 20.0, 0, 0, 0, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Ruffneck_PlayerMarkerHit");
}

public MapScr_Ruffneck_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Ruffneck_PlayerMarkerHit");
}

public MS_Ruffneck_PlayerMarkerHit(playerid, markerid)
{
	new Float: fVX, Float: fVY, Float: fVZ;
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if (markerid == gravityjump1)
	{
		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 0.0, fVY + 1.2, fVZ + 0.9);
	}
	else if (markerid == gravityjump2)
	{
		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 0.0, fVY + 1.2, fVZ + 0.9);
	}
	else if (markerid == gravityjump3)
	{
		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 0.0, fVY - 0.5, fVZ + 0.916);
	}
	else if (markerid == gravityjump4)
	{
		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 0.0, fVY, fVZ + 4.0);
	}
	else if (markerid == gravityjump5)
	{
		GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		SetVehicleVelocity(vehicleid, 0.0, fVY - 1.0, fVZ + 1.15);
	}
	else
		return 0;
	
	return 1;
}

#endif
