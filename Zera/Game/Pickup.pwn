#if !defined __GAME_PICKUP__
#define __GAME_PICKUP__

InitModule("Game_Pickup")
{
	G_Pickup_Initialize();

	AddEventHandler(D_PlayerUpdate, "G_PickupPlayerUpdate");

	#if PICKUP_MOVE_MODE == PICKUP_MOVE_OBJECT
		AddEventHandler(objectMovedEvent, "G_PickupDynamicObjectMoved");
	#else
		AddEventHandler(global50msTimer, "G_PickupGlobal50msTimer");
	#endif
	AddEventHandler(removeMapElementsEvent, "G_PickupRemoveMapElements");
}

function G_Pickup_Initialize()
{
	for (new i = 0; i <= MAX_PICKUPS; ++i)
	{
		pickupInfo[i][iText3D] = Text3D: INVALID_3DTEXT_ID;
	}
}

public G_PickupPlayerUpdate(playerid)
{
	for (new pickupid = 0; pickupid <= maxPickupID; ++pickupid)
	{
		if (pickupInfo[pickupid][iModel] != 0)
		{
			if (IsPlayerInRangeOfPoint(playerid, pickupInfo[pickupid][iRange],
				pickupInfo[pickupid][iPosX], pickupInfo[pickupid][iPosY], pickupInfo[pickupid][iPosZ]))
			{
				if (pickupInfo[pickupid][iPickuped][playerid] == 0)
				{
					pickupInfo[pickupid][iPickuped][playerid] = 1;

					SetTimerEx("OnPlayerRacePickupPickuped", GetRealTimerTime(PICKUP_HIT_DELAY), 0, "ii", playerid, pickupid);
					//OnPlayerRacePickupPickuped(playerid, pickupid);
				}
			}
			else if (pickupInfo[pickupid][iPickuped][playerid] != 0) pickupInfo[pickupid][iPickuped][playerid] = 0;
		}
	}

	return 1;
}

#if PICKUP_MOVE_MODE == PICKUP_MOVE_OBJECT
	public G_PickupDynamicObjectMoved(objectid)
	{
		if (objectid >= minPickupObject && objectid <= maxPickupObject)
		{
			new Float: x, Float: y, Float: z, Float: rotation;
			new i;

			/*Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_X, x);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Y, y);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, z);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MOVE_R_Z, rotation);*/

			for (i = 0; i <= maxPickupID; ++i)
			{
				if (pickupInfo[i][iObject] == objectid)
				{
					x = pickupInfo[i][iPosX];
					y = pickupInfo[i][iPosY];
					z = pickupInfo[i][iPosZ];
					rotation = pickupInfo[i][iObjectRot];

					break;
				}
			}

			if (i <= maxPickupID)
			{
				if (rotation == -90.0)
				{
					pickupInfo[i][iObjectRot] = -180.0;

					MoveDynamicObject(objectid, x, y, z - 0.001, 0.004, 0.0, 0.0, -180.0);
				}
				else if (rotation == -180.0)
				{
					pickupInfo[i][iObjectRot] = 90.0;

					MoveDynamicObject(objectid, x, y, z + 0.001, 0.004, 0.0, 0.0, 90.0);
				}
				else if (rotation == 90.0)
				{
					pickupInfo[i][iObjectRot] = 0.0;
					
					MoveDynamicObject(objectid, x, y, z - 0.001, 0.004, 0.0, 0.0, 0.0);
				}
				else if (rotation == 0.0)
				{
					pickupInfo[i][iObjectRot] = -90.0;
					
					MoveDynamicObject(objectid, x, y, z + 0.001, 0.004, 0.0, 0.0, -90.0);
				}
			}
		}

		return 0;	
	}
#else
	public G_PickupGlobal50msTimer()
	{
		if ((objectRot += 9.0) >= 360.0) objectRot = 0.0;

		for (new pickupid = 0; pickupid <= maxPickupID; ++pickupid)
		{
			if (pickupInfo[pickupid][iModel] != 0) SetDynamicObjectRot(pickupInfo[pickupid][iObject], 0.0, 0.0, objectRot);
		}

		return 0;
	}
#endif

public G_PickupRemoveMapElements()
{
	ResetPickupData();
}

public OnPlayerRacePickupPickuped(playerid, pickupid)
{
	new vehicleid;
	
	if ((vehicleid = GetPlayerVehicleID(playerid)) != 0)
	{
		new modelid = pickupInfo[pickupid][iModel];
		new soundPlay;

		if (modelid >= 400)
		{
			if (modelid == GetVehicleModel(vehicleid)) return;

			soundPlay = 1;

			SetPlayerVehicleModel(playerid, vehicleid, modelid);

			if (modelid == 425) OnPlayerMapArrived(playerid);
		}
		else if (modelid == 1)
		{
			soundPlay = 1;
			
			AddVehicleComponent(vehicleid, 1010);
		}
		else if (modelid == 2)
		{
			soundPlay = 1;
			
			RepairVehicle(vehicleid);
		}
		/*else if (modelid == 3)
		{
			new Float: fNewX = pickupInfo[pickupid][iNewPosX],
				Float: fNewY = pickupInfo[pickupid][iNewPosY],
				Float: fNewZ = pickupInfo[pickupid][iNewPosZ],
				Float: fNewA = pickupInfo[pickupid][iNewPosA]
			;

			Streamer_UpdateEx(playerid, fNewX, fNewY, fNewZ);
			SetVehiclePos(vehicleid, fNewX, fNewY, fNewZ);
			SetVehicleZAngle(vehicleid, fNewA);
			
			SetPlayerFreeze(playerid, fNewX, fNewY, fNewZ, fNewA);
			SetTimerEx("SetPlayerUnfreeze", GetRealTimerTime(2000), 0, "i", playerid);
		}*/

		if (soundPlay == 1) PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);

		TriggerEventWithBreak(racePickupEvent, 1, "ii", playerid, pickupid);
	}
}

function CreateVehiclePickup(modelid, Float: x, Float: y, Float: z)
{
	new pickupid = GetEmptyPickupIndex();

	if (pickupid != -1)
	{
		CreateRacePickup(3096, modelid, x, y, z);
		CreateMap3DTextLabel(GetVehicleModelName(modelid), 0xFFFFFFFF, x, y, z + 2.0);

		#if DEBUG_MODE >= 3
			printf("[pickup] CreateVehiclePickup(modelid = %d, Float: x = %f, Float: y = %f, Float: z = %f", modelid, x, y, z);
		#endif
	}

	return pickupid;
}

function CreateNitroPickup(Float: x, Float: y, Float: z)
{
	new pickupid = GetEmptyPickupIndex();

	if (pickupid != -1)
	{
		CreateRacePickup(3096, 1, x, y, z);
		CreateMap3DTextLabel("Nitro", 0xFFFFFFFF, x, y, z + 2.0);

		if (legacyMap == 1) legacyMap = 0;

		#if DEBUG_MODE >= 3
			printf("[pickup] CreateNitroPickup(Float: x = %f, Float: y = %f, Float: z = %f", x, y, z);
		#endif
	}

	return pickupid;
}

function CreateRepairPickup(Float: x, Float: y, Float: z)
{
	new pickupid = GetEmptyPickupIndex();

	if (pickupid != -1)
	{
		CreateRacePickup(3096, 2, x, y, z);
		CreateMap3DTextLabel("Repair", 0xFFFFFFFF, x, y, z + 2.0);

		if (legacyMap == 1) legacyMap = 0;

		#if DEBUG_MODE >= 3
			printf("[pickup] CreateRepairPickup(Float: x = %f, Float: y = %f, Float: z = %f", x, y, z);
		#endif
	}

	return pickupid;
}

/*stock CreateSpeedPickup(Float: x, Float: y, Float: z, Float: range = 3.5)
{
	new pickupid = GetEmptyPickupIndex();

	if (pickupid != -1)
	{
		CreatePickupObject(pickupid, 1317, x, y, z, 0.0, 0.0, 0.0);

		if (range == 0.0) range = 3.5;

		pickupInfo[pickupid][iModel] = 4;
		pickupInfo[pickupid][iPosX] = x;
		pickupInfo[pickupid][iPosY] = y;
		pickupInfo[pickupid][iPosZ] = z;
		pickupInfo[pickupid][iRange] = range;

		speedPickup[speedPickupCount++] = pickupid;
	}

	return pickupid;
}*/

stock CreateRacePickup(modelid, type, Float: x, Float: y, Float: z, Float: range = 3.5)
{
	if (modelid <= 0) return -1;

	new pickupid = GetEmptyPickupIndex();

	if (pickupid != -1)
	{
		CreatePickupObject(pickupid, modelid, x, y, z, 0.0, 0.0, 0.0);

		if (range == 0.0) range = 3.5;

		pickupInfo[pickupid][iModel] = type;
		pickupInfo[pickupid][iPosX] = x;
		pickupInfo[pickupid][iPosY] = y;
		pickupInfo[pickupid][iPosZ] = z;
		pickupInfo[pickupid][iRange] = range;
	}

	return pickupid;
}

function CreatePickupObject(pickupid, modelid, Float: x, Float: y, Float: z, Float: rx = 0.0, Float: ry = 0.0, Float: rz = 0.0)
{
	new objectid = pickupInfo[pickupid][iObject] = CreateMapObject(modelid, x, y, z, rx, ry, rz);

	if (minPickupObject > objectid) minPickupObject = objectid;
	if (maxPickupObject < objectid) maxPickupObject = objectid;

	#if PICKUP_MOVE_MODE == PICKUP_MOVE_OBJECT
		pickupInfo[pickupid][iObjectRot] = -90.0;

		MoveDynamicObject(objectid, x, y, z + 0.001, 0.004, 0.0, 0.0, -90.0);
	#endif

	if (maxPickupID < pickupid) maxPickupID = pickupid;

	return objectid;
}

function GetEmptyPickupIndex()
{
	for (new i = 0; i < MAX_PICKUPS; ++i)
	{
		if (pickupInfo[i][iObject] == 0) return i;
	}

	return -1;
}

function CreateMap3DTextLabel(const text[], color, Float: x, Float: y, Float: z)
{
	new Text3D: textLabel = CreateDynamic3DTextLabel(text, color, x, y, z, 300.0);

	if (gameInfo[gMaxText3Ds] < textLabel) gameInfo[gMaxText3Ds] = textLabel;
}

function ResetPickupData()
{
	for (new i = 0; i <= maxPickupID; ++i)
	{
		if (pickupInfo[i][iModel] != 0) pickupInfo[i] = pickupInfo[MAX_PICKUPS];
	}

	minPickupObject = -1;
	maxPickupObject = -1;
	maxPickupID = -1;
}

#endif
