#if !defined __GAME_MUSIC__
#define __GAME_MUSIC__

InitModule("Game_Music")
{
	G_Music_Initialize();

	AddEventHandler(D_PlayerConnect, "G_Music_PlayerConnect");
	AddEventHandler(D_PlayerSpawn, "G_Music_PlayerSpawn");
	AddEventHandler(sobeitCheckPass, "G_Music_PlayerSobeitCheckPass");
	AddEventHandler(playerMapStartEvent, "G_Music_PlayerMapStart");
}

function G_Music_Initialize()
{
	Audio_SetPack("zera_music");
}

public G_Music_PlayerConnect(playerid)
{
	playerBGM[playerid] = 0;

	return 0;
}

public G_Music_PlayerSpawn(playerid)
{
	if (playerBGM[playerid] == 0 && (IsGameCount() || IsGameProgress())) PlayMapBGM(playerid);

	return 0;
}

public G_Music_PlayerSobeitCheckPass(playerid)
{
	if (IsGameCount() || IsGameProgress()) PlayMapBGM(playerid);
}

public G_Music_PlayerMapStart(playerid)
{
	PlayMapBGM(playerid);
}

/*public Audio_OnClientConnect(playerid)
{
	if (IsGameProgress() && GetPlayerVehicleID(playerid) != 0) Audio_StopRadio(playerid);
}*/

public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	if (IsGameProgress() || IsGameCount())
	{
		//if (GetPlayerVehicleID(playerid) != 0) Audio_StopRadio(playerid);

		if (IsMapBGMAudioID(currentMap, current) && result == 0) PlayMapBGM(playerid);
	}
}

public Audio_OnRadioStationChange(playerid)
{
	Audio_StopRadio(playerid);
}

function PlayMapBGM(playerid, url[] = "")
{
	if (Audio_IsClientConnected(playerid))
	{
		if (playerBGM[playerid] != 0) StopMapBGM(playerid);

		//Audio_StopRadio(playerid);
		PlayAudioStreamForPlayer(playerid, "http://");

		if (IsNull(url)) playerBGM[playerid] = Audio_Play(playerid, currentMap + BGM_HANDLE_AREA, .loop = true);
		else playerBGM[playerid] = Audio_PlayStreamed(playerid, url, .loop = true);
	}
	else
	{
		StopAudioStreamForPlayer(playerid);
		
		if (IsNull(url)) PlayAudioStreamForPlayer(playerid, "http://");
		else PlayAudioStreamForPlayer(playerid, url);
	}

	return 1;
}

function StopMapBGM(playerid)
{
	if (Audio_IsClientConnected(playerid))
	{
		if (playerBGM[playerid] == 0) return 0;

		//if (radioOn != 0) Audio_SetRadioStation(playerid, random(13) + 1);

		Audio_Stop(playerid, playerBGM[playerid]);
		StopAudioStreamForPlayer(playerid);

		playerBGM[playerid] = 0;
	}
	else StopAudioStreamForPlayer(playerid);

	return 1;
}

#endif
