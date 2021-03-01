#if !defined __QAC_HEALTH_H__
#define __QAC_HEALTH_H__

#define VEHICLE_HEALTH_CHECK_COOL_TIME 3

new vehicleHealthCoolTime[MAX_PLAYERS];

new Float: oldVehicleHealth[MAX_VEHICLES] = { 1000.0, ... };

forward QAC_Health_PlayerConnect(playerid);
forward QAC_Health_VehicleSpawn(vehicleid);
forward QAC_Health_PlayerSecondTimer(playerid);

#endif
