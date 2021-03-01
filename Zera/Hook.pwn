#if !defined __HOOK__
#define __HOOK__

stock Qoo_fwrite(File: handle, const string[])
{
	for (new i = 0, length = strlen(string); i < length; ++i) fputchar(handle, string[i], false);
}
#if defined _ALS_fwrite
	#undef fwrite
#else
	#define _ALS_fwrite
#endif
#define fwrite Qoo_fwrite

native old_TogglePlayerControllable(playerid, toggle) = TogglePlayerControllable;
stock Qoo_TogglePlayerControllable(playerid, toggle, time = -1)
{
	if (toggle > 0 || time == 0)
	{
		toggle = 1;
		freezeTime[playerid] = 0;
	}
	else
	{
		toggle = 0;

		if (time < -1) time = -1;

		freezeTime[playerid] = time;
	}

	return TogglePlayerControllable(playerid, toggle);
}
#if defined _ALS_TogglePlayerControllable
	#undef TogglePlayerControllable
#else
	#define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable Qoo_TogglePlayerControllable

stock Qoo_Streamer_UpdateEx(playerid, Float: x, Float: y, Float: z, worldid = -1, interiorid = -1, autoStreamDelay = DEFAULT_AUTOSTREAM_DELAY)
{
	if (!IsPlayerConnected(playerid)) return 0;
	
	if (autoStreamDelay != 0)
	{
		Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_OBJECT, 1);
		Streamer_UpdateEx(playerid, x, y, z, worldid, interiorid);
		Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_OBJECT, 0);
		
		if (autoStreamDelayTimer[playerid] != 0) KillTimer(autoStreamDelayTimer[playerid]);

		autoStreamDelayTimer[playerid] = SetTimerEx("OnRequireActiveAutoStream", GetRealTimerTime(autoStreamDelay), 0, "i", playerid);
	}
	else Streamer_UpdateEx(playerid, x, y, z, worldid, interiorid);

	return 1;
}
#if defined _ALS_Streamer_UpdateEx
	#undef Streamer_UpdateEx
#else
	#define _ALS_Streamer_UpdateEx
#endif
#define Streamer_UpdateEx Qoo_Streamer_UpdateEx

native old_PutPlayerInVehicle(playerid, vehicleid, seatid) = PutPlayerInVehicle;
stock Qoo_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
	new value = PutPlayerInVehicle(playerid, vehicleid, seatid);

	if (value)
	{
		new Float: x, Float: y, Float: z;

		GetVehiclePos(vehicleid, x, y, z);
		Streamer_UpdateEx(playerid, x, y, z);
		
		GetVehicleHealth(vehicleid, oldPlayerVehicleHealth[playerid]);

		oldVehicleHealth[vehicleid] = oldPlayerVehicleHealth[playerid];

		UpdateVehicleHealthText(playerid, oldVehicleHealth[vehicleid]);
		
		vehicleHealthCoolTime[playerid] = VEHICLE_HEALTH_CHECK_COOL_TIME;
	}

	return value;
}
#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle Qoo_PutPlayerInVehicle

stock Qoo_RepairVehicle(vehicleid)
{
	new success = RepairVehicle(vehicleid);

	if (success)
	{
		contloop (new playerid : playerList)
		{
			if (GetPlayerVehicleID(playerid) == vehicleid)
			{
				if (oldPlayerVehicleHealth[playerid] < 1000.0)
				{
					oldPlayerVehicleHealth[playerid] = 1000.0;

					UpdateVehicleHealthText(playerid, 1000.0);

					oldVehicleHealth[vehicleid] = 1000.0;
					vehicleHealthCoolTime[playerid] = VEHICLE_HEALTH_CHECK_COOL_TIME;
				}

				break;
			}
		}
	}

	return success;
}
#if defined _ALS_RepairVehicle
	#undef RepairVehicle
#else
	#define _ALS_RepairVehicle
#endif
#define RepairVehicle Qoo_RepairVehicle

stock Qoo_SetVehicleHealth(vehicleid, Float: health, healthUpdate = 1)
{
	new success = SetVehicleHealth(vehicleid, health);

	if (success && healthUpdate != 0)
	{
		contloop (new playerid : playerList)
		{
			if (GetPlayerVehicleID(playerid) == vehicleid)
			{
				oldPlayerVehicleHealth[playerid] = health;

				UpdateVehicleHealthText(playerid, health);

				oldVehicleHealth[vehicleid] = health;
				vehicleHealthCoolTime[playerid] = VEHICLE_HEALTH_CHECK_COOL_TIME;

				break;
			}
		}
	}

	return success;
}
#if defined _ALS_SetVehicleHealth
	#undef SetVehicleHealth
#else
	#define _ALS_SetVehicleHealth
#endif
#define SetVehicleHealth Qoo_SetVehicleHealth

native old_GivePlayerMoney(playerid, money) = GivePlayerMoney;
#if defined _ALS_GivePlayerMoney
	#undef GivePlayerMoney
#else
	#define _ALS_GivePlayerMoney
#endif
#define GivePlayerMoney Qoo_GivePlayerMoney

native old_GetPlayerMoney(playerid) = GetPlayerMoney;
stock Qoo_GetPlayerMoney(playerid)
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;

	return playerInfo[playerid][pMoney];
}
#if defined _ALS_GetPlayerMoney
	#undef GetPlayerMoney
#else
	#define _ALS_GetPlayerMoney
#endif
#define GetPlayerMoney Qoo_GetPlayerMoney

stock Qoo_SetVehiclePos(vehicleid, Float: x, Float: y, Float: z)
{
	new value = SetVehiclePos(vehicleid, x, y, z);

	if (value != 0)
	{
		contloop (new playerid : playerList)
		{
			if (IsPlayerInVehicle(playerid, vehicleid))
			{
				playerNoMove[playerid] = 0;

				lastPosX[playerid] = x;
				lastPosY[playerid] = y;
				lastPosZ[playerid] = z;
				
				Streamer_UpdateEx(playerid, x, y, z);
			}
		}
	}

	return value;
}
#if defined _ALS_SetVehiclePos
	#undef SetVehiclePos
#else
	#define _ALS_SetVehiclePos
#endif
#define SetVehiclePos Qoo_SetVehiclePos

stock Qoo_SetPlayerPos(playerid, Float: x, Float: y, Float: z)
{
	new value = SetPlayerPos(playerid, x, y, z);

	if (value)
		Streamer_UpdateEx(playerid, x, y, z);
	
	return value;
}
#if defined _ALS_SetPlayerPos
	#undef SetPlayerPos
#else
	#define _ALS_SetPlayerPos
#endif
#define SetPlayerPos Qoo_SetPlayerPos

#endif
