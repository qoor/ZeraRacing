#if !defined __GAME_TRAINING__
#define __GAME_TRAINING__

InitModule("Game_Training")
{
	AddEventHandler(D_PlayerKeyStateChange, "G_Training_PlayerKeyStateChange");
	AddEventHandler(D_PlayerSpawn, "G_Training_PlayerSpawn");
	AddEventHandler(gamemodeMapStartEvent, "G_Training_GamemodeMapStart");
}

public G_Training_PlayerKeyStateChange(playerid, newkeys)
{
	if (newkeys == KEY_SPRINT)
	{
		if (mapChanging == 0 && IsGameProgress() && survive[playerid] == 0)
		{
			StartPlayerTrainingMode(playerid);

			return 1;
		}
	}

	return 0;
}

public G_Training_PlayerSpawn(playerid)
{
	if (mapChanging == 0 && IsGameProgress() && survive[playerid] == 0) TextDrawShowForPlayer(playerid, respawnText);

	return 0;
}

public G_Training_GamemodeMapStart()
{
	TextDrawHideForAll(respawnText);
}

function StartPlayerTrainingMode(playerid)
{
	survive[playerid] = -1;

	TextDrawHideForPlayer(playerid, respawnText);
	SetPlayerRespawn(playerid);
}

#endif
