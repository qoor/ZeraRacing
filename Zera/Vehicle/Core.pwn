#if !defined __VEHICLE_CORE__
#define __VEHICLE_CORE__

InitModule("Vehicle")
{
	#if SAMP_VERSION == SAMP_037
		AddEventHandler(D_PlayerConnect, "V_Core_PlayerConnect");
	#endif
	AddEventHandler(D_PlayerStateChange, "V_Core_PlayerStateChange");
	#if DEBUG_MODE != 0
		AddEventHandler(D_PlayerKeyStateChange, "V_Core_PlayerKeyStateChange");
	#endif
	AddEventHandler(playerEliminatedEvent, "V_Core_PlayerEliminated");
}

#if SAMP_VERSION == SAMP_037
	public V_Core_PlayerConnect(playerid)
	{
		DisableRemoteVehicleCollisions(playerid, 1);

		return 0;
	}
#endif

public V_Core_PlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER)
	{
		ResetPlayerWeapons(playerid);

		if (IsGameProgress() || IsGameCount()) Audio_StopRadio(playerid);
	}

	return 0;
}

#if DEBUG_MODE != 0
	public V_Core_PlayerKeyStateChange(playerid, newkeys)
	{
		if (newkeys & KEY_ANALOG_UP)
		{
			new vehicleid;

			if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
			{
				new Float: fVX, Float: fVY, Float: fVZ;

				GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
				SetVehicleVelocity(vehicleid, fVX * 2.0, fVY * 2.0, fVZ * 2.0);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			}
		}
		else if (newkeys & KEY_ANALOG_DOWN)
		{
			new vehicleid;

			if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
			{
				new Float: fVX, Float: fVY, Float: fVZ;

				GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
				SetVehicleVelocity(vehicleid, fVX, fVY, fVZ + 1.0);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			}
		}

		return 0;
	}
#endif

public V_Core_PlayerEliminated(playerid)
{
	if (ghostMode[playerid] == 0) SetVehicleVirtualWorld(playerVehicle[playerid], playerid + 1);
}

stock SetPlayerVehicleModel(playerid, vehicleid, modelid, refresh = 0)
{
	if (modelid < 400 || modelid > 611 || IsValidVehicle(vehicleid) == 0) return 0;
	
	new oldmodelid;
	
	if ((oldmodelid = GetVehicleModel(vehicleid)) == modelid) return 0;

	new panels, doors, lights, tires;
	new engine, plights, alarm, pdoors, bonnet, boot, objective;
	new color1, color2;
	new Float: fX, Float: fY, Float: fZ, Float: fAngle;
	new Float: fVX, Float: fVY, Float: fVZ;
	new Float: fHealth;
	new Float: fOldHeight, Float: fNewHeight;

	GetPlayerStaticVehicleColor(playerid, color1, color2);
	GetVehicleParamsEx(vehicleid, engine, plights, alarm, pdoors, bonnet, boot, objective);
	GetVehiclePos(vehicleid, fX, fY, fZ);
	GetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
	GetVehicleZAngle(vehicleid, fAngle);
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	GetVehicleHealth(vehicleid, fHealth);
	
	fOldHeight = GetVehicleModelCOMToBase(oldmodelid);
	fNewHeight = GetVehicleModelCOMToBase(modelid);

	DestroyVehicle(vehicleid);

	if (fOldHeight > 0.0 && fNewHeight > fOldHeight) fZ += (fNewHeight - fOldHeight);

	if ((vehicleid = CreateVehicle(modelid, fX, fY, fZ + 1.0, fAngle, color1, color2, -1)) == 0) return 0;

	playerVehicle[playerid] = vehicleid;

	SetVehicleParamsEx(vehicleid, 1, plights, alarm, pdoors, bonnet, boot, objective);

	if (IsPlayerEnabledGhostMode(playerid))
		SetVehicleVirtualWorld(vehicleid, playerid + 1);

	if (refresh == 0)
	{
		if (IsArrivedSomeone() == 0)
			LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		
		old_PutPlayerInVehicle(playerid, vehicleid, 0);

		if (IsVehicleModelHelicopter(modelid))
			fVZ += 1.0;
		
		SetVehicleVelocity(vehicleid, fVX, fVY, fVZ);
		UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		SetVehicleHealth(vehicleid, fHealth, 0);
	}
	else
		SetVehicleHealth(vehicleid, 1000.0);

	if (survive[playerid] > 0)
	{
		contloop (new i : playerList)
		{
			if (spectatePlayer[i] == playerid) UpdatePlayerSpectating(i);
		}
	}

	return 1;
}

stock RefreshPlayerVehicle(playerid)
{
	/*if (IsValidVehicle(playerVehicle[playerid]) == 0)
		return 0;*/
	
	new vehicleid = playerVehicle[playerid];
	new modelid = 411;

	if (IsValidVehicle(vehicleid))
	{
		modelid = GetVehicleModel(vehicleid);

		DestroyVehicle(vehicleid);
	}

	playerVehicle[playerid] = CreateVehicle(modelid, 0.0, 0.0, 3.0, 0.0, RandomVehicleColor(), RandomVehicleColor(), -1);
	
	if (IsPlayerEnabledGhostMode(playerid))
		SetVehicleVirtualWorld(vehicleid, playerid + 1);
	
	return 1;
}

stock IsVehicleModelBike(modelid)
{
	return (modelid == 448 || (modelid >= 461 && modelid <= 463) || modelid == 468 || modelid == 471 || modelid == 481 || modelid == 509 || modelid == 510 ||
		(modelid >= 521 && modelid <= 523) || modelid == 581 || modelid == 586);
}

stock IsVehicleModelBoat(modelid)
{
	return (modelid == 430 || modelid == 446 || (modelid >= 452 && modelid <= 454) || modelid == 472 || modelid == 473 || modelid == 484 || modelid == 493 || modelid == 595);
}

stock IsVehicleModelAirplane(modelid)
{
	return (modelid == 460 || modelid == 476 || (modelid >= 511 && modelid <= 513) || modelid == 519 || modelid == 520 || modelid == 539 || modelid == 553 || modelid == 577 ||
		modelid == 592 || modelid == 593);
}

stock IsVehicleModelHelicopter(modelid)
{
	return (modelid == 417 || modelid == 425 || modelid == 447 || modelid == 469 || modelid == 487 || modelid == 488 || modelid == 497 || modelid == 548 || modelid == 563);
}

function RandomVehicleColor()
{
	new color;

	random(256); // For REAL random
	random(256);

	do
		color = random(256);
	while (IsValidVehicleColor(color) == 0);

	return color;
}

function IsValidVehicleColor(color)
{
	switch (color)
	{
		case 0..126:
			return 1;
	#if SAMP_VERSION == SAMP_03d
		case 128:
			return 1;
		case 130..132:
			return 1;
		case 142:
			return 1;
		case 144..161:
			return 1;
		case 165..176:
			return 1;
		case 180..186:
			return 1;
		case 255:
			return 1;
	#else
		case 128..255:
			return 1;
	#endif
	}

	return 0;
}

#endif
