static marker1;

static object1;
static object2;
static object3;
static object4;

public MapScr_DarkestHour_Start()
{
	marker1 = CreateMarker(5719.689453125, 3786.787109375, 207.39219665527, MARKER_TYPE_CYLINDER, 20.0, 0, 0, 0, 0);

	object1 = CreatePlayerMapObjectForAll(8558, 5720.076171875, 3405.427734375, 28.581020355225, 270, 0, 0);
	object2 = CreatePlayerMapObjectForAll(3458, 5720.076171875, 3404.3974609375, 29.609607696533, 0, 0, 0);
	object3 = CreatePlayerMapObjectForAll(8558, 5720.076171875, 3403.3642578125, 28.556421279907, 90, 0, 0);
	object4 = CreatePlayerMapObjectForAll(3458, 5720.076171875, 3404.3891601563, 27.511211395264, 0, 180, 0);

	AddEventHandler(playerMarkerHitEvent, "MS_DarkestHour_PlayerMarkerHit");
}

public MapScr_DarkestHour_Stop()
{
	AddEventHandler(playerMarkerHitEvent, "MS_DarkestHour_PlayerMarkerHit");
}

public MS_DarkestHour_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == marker1)
	{
		MovePlayerMapObject(playerid, object1, 4313.1533203125, 3615.5725097656, 139.04570007324, 0.2);
		MovePlayerMapObject(playerid, object2, 4313.1533203125, 3615.5725097656, 139.04570007324, 0.2);
		MovePlayerMapObject(playerid, object3, 4313.1533203125, 3615.5725097656, 139.04570007324, 0.2);
		MovePlayerMapObject(playerid, object4, 4313.1533203125, 3615.5725097656, 139.04570007324, 0.2);

		return 1;
	}

	return 0;
}
