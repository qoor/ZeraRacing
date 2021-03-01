#if !defined __VEHICLE_HEALTH__

InitModule("Vehicle_Health")
{
	AddEventHandler(D_PlayerConnect, "V_Health_PlayerConnect");
	AddEventHandler(player80msTimer, "V_Health_Player80msTimer");
}

public V_Health_PlayerConnect(playerid)
{
	healthTextShow[playerid] = 0;
	oldPlayerVehicleHealth[playerid] = 0.0;

	return 0;
}

public V_Health_Player80msTimer(playerid)
{
	if (healthTextShow[playerid] != 0)
	{
		new vehicleid;

		if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
		{
			new Float: health;

			GetVehicleHealth(vehicleid, health);

			if (oldPlayerVehicleHealth[playerid] != health)
			{
				oldPlayerVehicleHealth[playerid] = health;
				
				UpdateVehicleHealthText(playerid, health, .ignoreSpectators = (survive[playerid] == 1) ? 0 : 1);
			}
		}
		else if (oldPlayerVehicleHealth[playerid] != 0.0) oldPlayerVehicleHealth[playerid] = 0.0;
	}

	return 0;
}

function TogglePlayerHealthText(playerid, toggle)
{
	if (!IsPlayerConnected(playerid) || toggle == healthTextShow[playerid]) return 0;

	if (toggle == 0)
	{
		healthTextShow[playerid] = 0;

		#if SAMP_VERSION == SAMP_03d
			TextDrawHideForPlayer(playerid, healthText[playerid]);
		#else
			PlayerTextDrawHide(playerid, healthText[playerid]);
		#endif
	}
	else
	{
		new vehicleid;
		new isSpectating = (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING &&
			IsPlayerConnected(spectatePlayer[playerid]) && (vehicleid = GetPlayerVehicleID(spectatePlayer[playerid])) != 0);

		healthTextShow[playerid] = 1;

		if (isSpectating || (vehicleid = GetPlayerVehicleID(playerid)) != 0)
		{
			new Float: health;

			GetVehicleHealth(vehicleid, health);

			oldPlayerVehicleHealth[playerid] = health;

			UpdateVehicleHealthText(playerid, health, isSpectating);
		}
	}

	return 1;
}

function UpdateVehicleHealthText(playerid, Float: health, ignoreSpectators = 0)
{
	if (!IsPlayerConnected(playerid) || healthTextShow[playerid] == 0) return 0;

	new healthGauge;
	new healthColor;
	new string[21];

	healthGauge = floatround(health / 50.0, floatround_ceil);

	if (healthGauge > 5)
	{
		if (healthGauge > 20) healthGauge = 20;

		for (new i = 0; i < healthGauge; ++i) strcat(string, ".", 21);
	}
	else string = ". . . . . . . .";

	switch (healthGauge)
	{
		case 18..20: healthColor = 0x00FF00FF;
		case 15..17: healthColor = 0xBCE55CFF;
		case 12..14: healthColor = 0xC4B73BFF;
		case 9..11: healthColor = 0xFFFF00FF;
		case 6..8: healthColor = 0xFF4500FF;
		default: healthColor = 0xFF0000FF;
	}

	#if SAMP_VERSION == SAMP_03d
		TextDrawColor(healthText[playerid], healthColor);
		TextDrawBackgroundColor(healthText[playerid], healthColor);
		TextDrawSetString(healthText[playerid], string);
		TextDrawShowForPlayer(playerid, healthText[playerid]);
	#else
		PlayerTextDrawColor(playerid, healthText[playerid], healthColor);
		PlayerTextDrawBackgroundColor(playerid, healthText[playerid], healthColor);
		PlayerTextDrawSetString(playerid, healthText[playerid], string);
		PlayerTextDrawShow(playerid, healthText[playerid]);
	#endif

	if (ignoreSpectators == 0)
	{
		contloop (new i : playerList)
		{
			if (spectatePlayer[i] == playerid) UpdateVehicleHealthText(i, health, .ignoreSpectators = 1);
		}
	}

	return 1;
}

stock BlowVehicle(vehicleid)
{
	if (IsValidVehicle(vehicleid) == 0)
		return 0;
	
	new bool: pedIn;

	contloop (new i : playerList)
	{
		if (IsPlayerInVehicle(i, vehicleid))
		{
			pedIn = true;
			break;
		}
	}

	if (!pedIn)
		return SetVehicleHealth(vehicleid, 0.0);
	
	new Float: x, Float: y, Float: z;

	GetVehiclePos(vehicleid, x, y, z);
	SetVehicleHealth(vehicleid, 400.0);

	for (new i = 0; i < 3; ++i)
		CreateExplosion(x, y, z, 8, 10.0);

	return 1;
}

#endif
