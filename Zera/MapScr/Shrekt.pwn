static blow1;

static marker1;
static marker2;
static marker3;
static marker4;
static marker5;

public MapScr_Shrekt_Start()
{
	blow1 = CreateMarker(3265.8901367188, -1822.8192138672, 19.213899612427, MARKER_TYPE_CORONA, 10.0, 0, 0, 0, 0);

	marker1 = CreateMarker(4216.2919921875, -1403.2880859375, 63.983501434326, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);
	marker2 = CreateMarker(4240.3442382813, -1444.7537841797, 63.983501434326, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);
	marker3 = CreateMarker(2701.6999511719, -6308.6000976563, 1514.4000244141, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);
	marker4 = CreateMarker(3552.1000976563, -7642.3999023438, 7.8000001907349, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);
	marker5 = CreateMarker(3996.1496582031, 2227.2548828125, 19.57776260376, MARKER_TYPE_CORONA, 5.0, 0, 255, 255, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_Shrekt_PlayerMarkerHit");
}

public MapScr_Shrekt_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MS_Shrekt_PlayerMarkerHit");
}

public MS_Shrekt_PlayerMarkerHit(playerid, markerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (markerid == blow1)
	{
		new Float: z;

		GetVehicleZAngle(vehicleid, z);

		if (z > 227.0)
		{
			SendClientMessage(playerid, 0x1B59E0FF, " ");
			SendClientMessage(playerid, 0x1B59E0FF, " ");
			SendClientMessage(playerid, 0x1B59E0FF, "{CC6600} Do it backward Motherfucker.");
			SendClientMessage(playerid, 0x1B59E0FF, " ");
			SendClientMessage(playerid, 0x1B59E0FF, " ");
			
			BlowVehicle(vehicleid);
		}
	}
	else if (markerid == marker1 || markerid == marker2)
	{
		SetVehiclePos(vehicleid, 1909.5073242188, -6607.8461914063, 1808.51953125);
		SetVehicleZAngle(vehicleid, 90.0);
		SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	}
	else if (markerid == marker3)
	{
		SetVehiclePos(vehicleid, 2621.6000976563, -6097.8999023438, 53.799999237061);
		SetVehicleZAngle(vehicleid, 90.0);
		SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	}
	else if (markerid == marker4)
	{
		SetVehiclePos(vehicleid, 3143.1000976563, -793.5, 23.799999237061);
		SetVehicleZAngle(vehicleid, 0.0);
		SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	}
	else if (markerid == marker5)
	{
		SetVehiclePos(vehicleid, 2856.1398925781, -514.69787597656, 21.717399597168);
		SetVehicleZAngle(vehicleid, 265.5);
		SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	}
	else
		return 0;
	
	return 1;
}
