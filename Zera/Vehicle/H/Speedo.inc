#if !defined __VEHICLE_SPEEDO_H__
#define __VEHICLE_SPEEDO_H__

new oldVehicleSpeed[MAX_PLAYERS];
new speedoToggle[MAX_PLAYERS];

forward V_Speedo_PlayerConnect(playerid);
forward V_Speedo_PlayerUpdate(playerid);

forward TogglePlayerSpeedo(playerid, toggle);
forward UpdatePlayerSpeedo(playerid);
forward UpdatePlayerSpeedoText(playerid, speed);
forward GetVehicleSpeed(vehicleid, zSpeed = 1);

#endif
