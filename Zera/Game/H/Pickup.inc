#if !defined __GAME_PICKUP_H__
#define __GAME_PICKUP_H__

#define MAX_SPEED_PICKUPS 30

#define PICKUP_MOVE_OBJECT 0
#define PICKUP_MOVE_ROTATION 1

#define PICKUP_MOVE_MODE PICKUP_MOVE_ROTATION

enum E_PICKUP_INFO_LIST
{
	iModel,
	iObject,
	#if PICKUP_MOVE_MODE == PICKUP_MOVE_OBJECT
		Float: iObjectRot,
	#endif
	Float: iPosX,
	Float: iPosY,
	Float: iPosZ,
	Float: iNewPosX,
	Float: iNewPosY,
	Float: iNewPosZ,
	Float: iNewPosA,
	Float: iRange,
	Text3D: iText3D,
	iPickuped[MAX_PLAYERS]
};

new pickupInfo[MAX_PICKUPS + 1][E_PICKUP_INFO_LIST];

new racePickupEvent;

new minPickupObject = -1;
new maxPickupObject = -1;
new maxPickupID = -1;

#if PICKUP_MOVE_MODE == PICKUP_MOVE_ROTATION
	new Float: objectRot;
#endif

forward G_Pickup_Initialize();
forward G_PickupPlayerUpdate(playerid);
#if PICKUP_MOVE_MODE == PICKUP_MOVE_OBJECT
	forward G_PickupDynamicObjectMoved(objectid);
#else
	forward G_PickupGlobal50msTimer();
#endif
forward G_PickupRemoveMapElements();

forward OnPlayerRacePickupPickuped(playerid, pickupid);

#endif
