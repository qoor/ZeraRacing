#if !defined __PLAYER_FREEZE__
#define __PLAYER_FREEZE__

InitModule("Player_Freeze")
{
	AddEventHandler(D_PlayerConnect, "P_Freeze_PlayerConnect");
	AddEventHandler(D_PlayerUpdate, "P_Freeze_PlayerUpdate");
	// AddEventHandler(playerSecondTimer, "P_Freeze_PlayerSecondTimer");
}

public P_Freeze_PlayerConnect(playerid)
{
	vehicleFreeze[playerid] = 0;

	return 0;
}

public P_Freeze_PlayerUpdate(playerid)
{
	if (vehicleFreeze[playerid] != 0)
	{
		new vehicleid = playerVehicle[playerid];

		if (vehicleid != 0)
		{
			new Float: fX, Float: fY, Float: fZ, Float: fAngle;
			new Float: health;

			GetVehiclePos(vehicleid, fX, fY, fZ);
			GetVehicleZAngle(vehicleid, fAngle);
			GetVehicleHealth(vehicleid, health);

			if (fX != spawnPositionX[playerid] || fY != spawnPositionY[playerid] || fZ != spawnPositionZ[playerid])
			{
				SetVehiclePos(vehicleid, spawnPositionX[playerid], spawnPositionY[playerid], spawnPositionZ[playerid]);
			}
			if (fAngle != spawnPositionA[playerid]) SetVehicleZAngle(vehicleid, spawnPositionA[playerid]);
			if (health < 1000.0) RepairVehicle(vehicleid);
		}
	}

	return 1;
}

/*public P_Freeze_PlayerSecondTimer(playerid)
{
	if (vehicleFreezeTime[playerid] > 0)
	{
		if (--vehicleFreezeTime[playerid] == 0) SetPlayerUnfreeze(playerid);
	}
}*/

public SetPlayerFreeze(playerid, Float: x, Float: y, Float: z, Float: angle)
{
	if (!IsPlayerConnected(playerid)) return 0;

	new vehicleid = playerVehicle[playerid];

	vehicleFreeze[playerid] = 1;
	spawnPositionX[playerid] = x;
	spawnPositionY[playerid] = y;
	spawnPositionZ[playerid] = z;
	spawnPositionA[playerid] = angle;

	if (vehicleid != 0)
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if (engine != 0) SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
	}

	return 1;
}

public SetPlayerUnfreeze(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;

	new vehicleid = playerVehicle[playerid];

	vehicleFreeze[playerid] = 0;

	if (vehicleid != 0)
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if (engine == 0) SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	}

	return 1;
}

#endif
