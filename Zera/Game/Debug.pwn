#if !defined __GAME_DEBUG__
#define __GAME_DEBUG__

InitModule("Game_Debug")
{
	AddEventHandler(D_PlayerKeyStateChange, "G_Debug_PlayerKeyStateChange");
}

public G_Debug_PlayerKeyStateChange(playerid, newkeys)
{
	if (newkeys & KEY_ANALOG_LEFT)
	{
		new vehicleid;

		if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
		{
			new Float: x, Float: y, Float: z;
			new Float: vx, Float: vy, Float: vz;
			new string[145];

			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleVelocity(vehicleid, vx, vy, vz);

			format(string, sizeof(string), "(ÁÂÇ¥) %f, %f, %f", x, y, z);
			ServerClientMessage(playerid, string, .tag = "Debug");

			format(string, sizeof(string), "(¼Óµµ) %f, %f, %f", vx, vy, vz);
			ServerClientMessage(playerid, string, .tag = "Debug");

			return 1;
		}
	}

	return 0;
}

#endif
