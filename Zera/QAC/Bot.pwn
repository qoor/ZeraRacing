#if !defined __QAC_BOT__
#define __QAC_BOT__

InitModule("QAC_Bot")
{
	AddEventHandler(D_PlayerConnect, "QAC_Bot_PlayerConnect");
}

public QAC_Bot_PlayerConnect(playerid)
{
	new sameIPCount;
	new ip[16];

	ip = ipAddress[playerid];

	contloop (new i : playerList)
	{
		if (i != playerid && strcmp(ip, ipAddress[i]) == 0 && ++sameIPCount > MAX_ALLOW_SAME_IP_CONNECTIONS)
		{
			OnPlayerCheatDetected(playerid, CHEAT_TYPE_BOT);

			return 1;
		}
	}

	return 0;
}

#endif
