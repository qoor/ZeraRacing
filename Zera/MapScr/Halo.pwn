static gate;

static gate1_bal;
static gate2_bal;
static gate3_bal;

static gate1_jobb;
static gate2_jobb;
static gate3_jobb;

public MapScr_Halo_Start()
{
	gate = CreateMarker(3562.0, 3886.0, 3638.0, MARKER_TYPE_CORONA, 15, 0, 0, 0);

	gate1_bal = CreatePlayerMapObjectForAll(3115, 3482.0, 3894.0, 3673.0, 45.0, 90.0, 0.0);
	gate2_bal = CreatePlayerMapObjectForAll(3115, 3483.0, 3892.0, 3656.0, 45.0, 90.0, 0.0);
	gate3_bal = CreatePlayerMapObjectForAll(3115, 3842.0, 3893.0, 3642.0, 45.0, 90.0, 0.0);

	gate1_jobb = CreatePlayerMapObjectForAll(3115, 3482.0, 3916.0, 3673.0, 45.0, 90.0, 0.0);
	gate2_jobb = CreatePlayerMapObjectForAll(3115, 3483.0, 3919.0, 3656.0, 225.0, 270.0, 180.0);
	gate3_jobb = CreatePlayerMapObjectForAll(3115, 3482.0, 3917.0, 3640.0, 225.0, 270.0, 180.0);

	AddEventHandler(playerMarkerHitEvent, "MapScr_Halo_PlayerMarkerHit");
}

public MapScr_Halo_Stop()
{
	RemoveEventHandler(playerMarkerHitEvent, "MapScr_Halo_PlayerMarkerHit");
}

public MapScr_Halo_PlayerMarkerHit(playerid, markerid)
{
	if (markerid == gate)
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		if (vehicleid != 0)
		{
			MovePlayerMapObject(playerid, gate1_bal, 3482.0, 3885.0, 3673.0, 2.0);
			MovePlayerMapObject(playerid, gate2_bal, 3483.0, 3881.0, 3658.0, 2.0);
			MovePlayerMapObject(playerid, gate3_bal, 3482.0, 3885.0, 3642.0, 2.0);

			MovePlayerMapObject(playerid, gate1_jobb, 3482.0, 3925.0, 3673.0, 2.0);
			MovePlayerMapObject(playerid, gate2_jobb, 3483.0, 3930.0, 3658.0, 2.0);
			MovePlayerMapObject(playerid, gate3_jobb, 3482.0, 3926.0, 3640.0, 2.0);
		}
	}

	return 0;
}
