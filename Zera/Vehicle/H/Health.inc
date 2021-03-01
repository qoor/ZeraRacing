#if !defined __VEHICLE_HEALTH_H__
#define __VEHICLE_HEALTH_H__

new healthTextShow[MAX_PLAYERS];
new Float: oldPlayerVehicleHealth[MAX_PLAYERS];

forward V_Health_PlayerConnect(playerid);
forward V_Health_Player80msTimer(playerid);

forward TogglePlayerHealthText(playerid, toggle);
forward UpdateVehicleHealthText(playerid, Float: health, ignoreSpectators = 0);

forward BlowVehicle(vehicleid);

#endif
