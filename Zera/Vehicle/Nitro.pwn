#if !defined __VEHICLE_NITRO__
#define __VEHICLE_NITRO__

InitModule("Vehicle_Nitro")
{
	AddEventHandler(D_PlayerConnect, "V_Nitro_PlayerConnect");
	AddEventHandler(D_PlayerKeyStateChange, "V_Nitro_PlayerKeyStateChange");
	AddEventHandler(playerSecondTimer, "V_Nitro_PlayerSecondTimer");
}

public V_Nitro_PlayerConnect(playerid)
{
	nitroUse[playerid] = 0;

	return 0;
}

public V_Nitro_PlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (IsGameProgress() && legacyMap == 1)
	{
		if (newkeys & KEY_FIRE)
		{
			if (nitroUse[playerid] == 0)
			{
				new vehicleid;
				
				nitroUse[playerid] = 1;

				if ((vehicleid = GetPlayerVehicleID(playerid)) != 0) AddVehicleComponent(vehicleid, 1010);
			}
		}

		if (!(newkeys & KEY_FIRE) && (oldkeys & KEY_FIRE))
		{
			if (nitroUse[playerid] == 1) nitroUse[playerid] = 0;
		}
	}

	return 0;
}

public V_Nitro_PlayerSecondTimer(playerid)
{
	if (legacyMap == 1 && nitroUse[playerid] == 1)
	{
		new vehicleid;

		if ((vehicleid = GetPlayerVehicleID(playerid)) != 0) AddVehicleComponent(vehicleid, 1010);
	}

	return 0;
}

#endif
