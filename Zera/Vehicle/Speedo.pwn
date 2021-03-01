#if !defined __VEHICLE_SPEEDO__
#define __VEHICLE_SPEEDO__

InitModule("Vehicle_Speedo")
{
	AddEventHandler(D_PlayerConnect, "V_Speedo_PlayerConnect");
	AddEventHandler(D_PlayerUpdate, "V_Speedo_PlayerUpdate");
}

public V_Speedo_PlayerConnect(playerid)
{
	oldVehicleSpeed[playerid] = 0;
	speedoToggle[playerid] = 0;

	return 0;
}

public V_Speedo_PlayerUpdate(playerid)
{
	UpdatePlayerSpeedo(playerid);

	return 1;
}

function TogglePlayerSpeedo(playerid, toggle)
{
	if (!IsPlayerConnected(playerid) || speedoToggle[playerid] == toggle) return 0;

	if (toggle >= 1)
	{
		#if SAMP_VERSION == SAMP_03d
			TextDrawShowForPlayer(playerid, playerSpeedo[playerid]);
		#else
			PlayerTextDrawShow(playerid, playerSpeedo[playerid]);
		#endif
		TextDrawShowForPlayer(playerid, speedoBack);

		speedoToggle[playerid] = 1;

		UpdatePlayerSpeedo(playerid);
	}
	else
	{
		#if SAMP_VERSION == SAMP_03d
			TextDrawHideForPlayer(playerid, playerSpeedo[playerid]);
		#else
			PlayerTextDrawHide(playerid, playerSpeedo[playerid]);
		#endif
		TextDrawHideForPlayer(playerid, speedoBack);

		speedoToggle[playerid] = 0;
	}

	return 1;
}

function UpdatePlayerSpeedo(playerid)
{
	if (speedoToggle[playerid] == 1)
	{
		new vehicleid;

		if (spectatePlayer[playerid] != INVALID_PLAYER_ID) vehicleid = GetPlayerVehicleID(spectatePlayer[playerid]);
		else vehicleid = GetPlayerVehicleID(playerid);

		if (vehicleid != 0)
		{
			new speed = GetVehicleSpeed(vehicleid);

			if (oldVehicleSpeed[playerid] != speed)
			{
				UpdatePlayerSpeedoText(playerid, speed);

				oldVehicleSpeed[playerid] = speed;
			}
		}
	}
}

function UpdatePlayerSpeedoText(playerid, speed)
{
	new speedoText[11];

	format(speedoText, sizeof(speedoText), "%03d", speed);
	#if SAMP_VERSION == SAMP_03d
		TextDrawSetString(playerSpeedo[playerid], speedoText);
	#else
		PlayerTextDrawSetString(playerid, playerSpeedo[playerid], speedoText);
	#endif
}

function GetVehicleSpeed(vehicleid, zSpeed = 1)
{
	new Float: velX, Float: velY, Float: velZ;

	GetVehicleVelocity(vehicleid, velX, velY, velZ);

	velX = floatabs(velX);
	velY = floatabs(velY);
	
	if (zSpeed == 1)
	{
		velZ = floatabs(velZ);
		
		return floatround(floatsqroot((velX * velX) + (velY * velY) + (velZ * velZ)) * 161.483);
	}

	return floatround(floatsqroot((velX * velX) + (velY * velY)) * 161.483);
}

#endif
