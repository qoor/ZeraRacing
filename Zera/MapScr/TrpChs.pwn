static marker;

public MapScr_TrpChs_Start()
{
	marker = createMarker (3614.599609375, -6181.5, 124.0, MARKER_TYPE_CORONA, 10, 255, 255, 0, 0);
	/*CreateSpeedPickup(4165.023925, -2174.047119, 1.397665);
	CreateSpeedPickup(3831.257324, -2261.465087, 39.509559);*/

	AddEventHandler(playerMarkerHitEvent, "MS_TrpChs_PlayerMarkerHit");
}

public MS_TrpChs_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker)
	{
		SetVehicleVelocity(GetPlayerVehicleID(playerid), 2.0, 0.0, 1.0);

		return 1;
	}

	return 0;
}

/*public G_ObjectFix_PlayerRacePickup(playerid, pickupid)
{
	if (pickupInfo[pickupid][iModel] == 4)
	{
		if (IsNull(currentMapSrc) == false)
		{
			if (strcmp(currentMapSrc, "crespro.map", true) == 0)
			{
				new vehicleid = playerVehicle[playerid];

				if (pickupid == speedPickup[0]) SetVehicleVelocity(vehicleid, 0.035253, -0.844147, -0.000045);
				else if (pickupid == speedPickup[1]) SetVehicleVelocity(vehicleid, -0.874192, -0.014244, 0.589082);
			}
		}
	}
}*/
