#if !defined __PLAYER_INTRO__
#define __PLAYER_INTRO__

InitModule("Player_Intro")
{
	AddEventHandler(D_PlayerConnect, "P_Intro_PlayerConnect");
	AddEventHandler(introStartEvent, "P_Intro_PlayerIntroStart");
}

public P_Intro_PlayerConnect(playerid)
{
	introStarted[playerid] = 0;

	return 0;
}

public P_Intro_PlayerIntroStart(playerid)
{
	FadeCamera(playerid, true, 0.0);
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);

	OnPlayerIntroFinish(playerid);
}

public OnPlayerIntroFinish(playerid)
{
	TriggerEventNoSuspend(introFinishEvent, "i", playerid);
}

function StartIntroForPlayer(playerid)
{
	if (introStarted[playerid] != 0) return 0;

	introStarted[playerid] = 1;

	TriggerEventNoSuspend(introStartEvent, "i", playerid);

	return 1;
}

#endif
