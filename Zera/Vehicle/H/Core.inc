#if !defined __V1EHICLE_CORE_H__
#define __VEHICLE_CORE_H__

new playerVehicle[MAX_PLAYERS];

forward V_Core_PlayerConnect(playerid);
forward V_Core_PlayerStateChange(playerid, newstate, oldstate);
#if DEBUG_MODE != 0
	forward V_Core_PlayerKeyStateChange(playerid, newkeys);
#endif
forward V_Core_PlayerEliminated(playerid);

forward RandomVehicleColor();
forward RefreshPlayerVehicle(playerid);

#endif
