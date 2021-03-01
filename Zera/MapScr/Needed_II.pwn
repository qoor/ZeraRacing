static pushback;
static speed1;
static speed2;

public MapScr_Needed_II_Start()
{
	pushback = CreateMarker(5897.88965, 2847.77246, 112.974, MARKER_TYPE_CHECKPOINT, 4.0, 0, 0, 255, 255);
	speed1 = CreateMarker(3654.38037, 394.103, 0.6759, MARKER_TYPE_CYLINDER, 5.0, 0, 0, 255, 0);
	speed2 = CreateMarker(4940.4209, 2348.30688, 198.179, MARKER_TYPE_CYLINDER, 3.0, 0, 0, 255, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Needed_II_PlayerMarkerHit");
}

public MapScr_Needed_II_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Needed_II_PlayerMarkerHit");
}

public MS_Needed_II_PlayerMarkerHit(playerid, markerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float: velX, Float: velY, Float: velZ;

	if (markerid == pushback)
	{
		GetVehicleVelocity(vehicleid, velX, velY, velZ);
		SetVehicleVelocity(vehicleid, -velX, -velY, -velZ);
	}
	else if (markerid == speed1 || markerid == speed2)
	{
		GetVehicleVelocity(vehicleid, velX, velY, velZ);
		SetVehicleVelocity(vehicleid, velX * 1.3, velY * 1.3, velZ * 1.3);
	}
	else
		return 0;
	
	return 1;
}
