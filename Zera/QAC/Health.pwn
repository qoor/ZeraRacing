#if !defined __QAC_HEALTH__
#define __QAC_HEALTH__

InitModule("QAC_Health")
{
	AddEventHandler(D_PlayerConnect, "QAC_Health_PlayerConnect");
	AddEventHandler(D_VehicleSpawn, "QAC_Health_VehicleSpawn");
	AddEventHandler(playerSecondTimer, "QAC_Health_PlayerSecondTimer");
}

public QAC_Health_PlayerConnect(playerid)
{
	vehicleHealthCoolTime[playerid] = 0;

	return 0;
}

public QAC_Health_VehicleSpawn(vehicleid)
{
	oldVehicleHealth[vehicleid] = 1000.0;

	return 0;
}

public QAC_Health_PlayerSecondTimer(playerid)
{
	new Float: health;
	new Float: armour;
	new vehicleid;

	GetPlayerHealth(playerid, health);

	/*if (health > 100.0)
	{
		OnPlayerCheatDetected(playerid, CHEAT_TYPE_HEALTH, 0);
		
		return 1;
	}*/

	if ((vehicleid = GetPlayerVehicleID(playerid)) != 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
	{
		/*if (health > 1000.0)
		{
			OnPlayerCheatDetected(playerid, CHEAT_TYPE_HEALTH, 1);
			
			return 1;
		}*/

		if (vehicleHealthCoolTime[playerid] != 0)
			--vehicleHealthCoolTime[playerid];
		else if (vehicleHealthCoolTime[playerid] == 0)
		{
			GetVehicleHealth(vehicleid, health);
			
			if (health < oldVehicleHealth[vehicleid]) oldVehicleHealth[vehicleid] = health;
			else if (health > oldVehicleHealth[vehicleid])
			{
				OnPlayerCheatDetected(playerid, CHEAT_TYPE_HEALTH, 1);
				SetVehicleHealth(vehicleid, health);

				return 1;
			}
		}
	}

	GetPlayerArmour(playerid, armour);

	if (armour > 0.0)
	{
		OnPlayerCheatDetected(playerid, CHEAT_TYPE_ARMOUR);

		return 1;
	}

	return 0;
}

#endif
