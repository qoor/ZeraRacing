#if !defined __GAME_OBJECTFIX__
#define __GAME_OBJECTFIX__

InitModule("Game_ObjectFix")
{
	AddEventHandler(D_PlayerDisconnect, "G_ObjectFix_PlayerDisconnect");
	AddEventHandler(globalSecondTimer, "G_ObjectFix_GlobalSecondTimer");
	AddEventHandler(playerSecondTimer, "G_ObjectFix_PlayerSecondTimer");
}

public G_ObjectFix_PlayerDisconnect(playerid)
{
	if (autoStreamDelayTimer[playerid] != 0)
	{
		KillTimer(autoStreamDelayTimer[playerid]);

		autoStreamDelayTimer[playerid] = 0;
	}

	return 0;
}

public G_ObjectFix_GlobalSecondTimer()
{
	if (objectFixState == 1) objectFixState = 2;
	else objectFixState = 1;

	return 0;
}

public G_ObjectFix_PlayerSecondTimer(playerid)
{
	if (IsPlayerLoggedIn(playerid))
	{
		if (mapChanging == 0 && IsArrivedSomeone() == 0 && survive[playerid] != -1 && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
		{
			new interior = objectFixState;
			new vehicleid;

			SetPlayerInterior(playerid, interior);
			
			if ((vehicleid = GetPlayerVehicleID(playerid)) != 0) LinkVehicleToInterior(vehicleid, interior);
		}
	}

	return 0;
}

public OnDynamicObjectMoved(objectid)
{
	TriggerEvent(objectMovedEvent, 1, "i", objectid);

	return 1;
}

public OnRequireActiveAutoStream(playerid)
{
	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_OBJECT, 1);
}

#endif
