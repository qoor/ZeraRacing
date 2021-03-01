#if !defined __QAC_JETPACK__
#define __QAC_JETPACK__

InitModule("QAC_Jetpack")
{
	AddEventHandler(D_PlayerUpdate, "QAC_Jetpack_PlayerUpdate");
}

public QAC_Jetpack_PlayerUpdate(playerid)
{
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
		OnPlayerCheatDetected(playerid, CHEAT_TYPE_JETPACK);

		return 0;
	}

	return 1;
}

#endif
