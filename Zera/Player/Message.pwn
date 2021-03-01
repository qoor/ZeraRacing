#if !defined __PLAYER_MESSAGE__
#define __PLAYER_MESSAGE__

InitModule("Player_Message")
{
	AddEventHandler(D_PlayerText, "P_Message_PlayerText");
}

public P_Message_PlayerText(playerid, const text[])
{
	if (IsPlayerLoggedIn(playerid) == 0) return 0;

	new string[145];

	if (IsNull(playerItemValue[playerid][ITEM_TITLE]) == false)
		format(string, sizeof(string), "[%s] ", titles[strval(playerItemValue[playerid][ITEM_TITLE])]);
	
	if (playerInfo[playerid][pZeraMember] <= 0 || IsNull(playerInfo[playerid][pNickName]))
		strcat(string, playerName[playerid]);
	else
		strcat(string, playerInfo[playerid][pNickName]);
	
	format(string, sizeof(string), "%s(id:%d): %s", string, playerid, text);
	SendClientMessageToGamePlayers(string, GetPlayerColor(playerid), .tag = "");

	return 0;
}

function ServerClientMessage(playerid, const message[], COLOR = COLOR_SERVER, const tag[] = "Server")
{
	if (IsNull(tag) == false)
	{
		new string[145];
		
		format(string, sizeof(string), "[%s]: {FFFFFF}%s", tag, message);
		return SendClientMessage(playerid, COLOR, string);
	}
	
	return SendClientMessage(playerid, COLOR, message);
}

function SendClientMessageToGamePlayers(const message[], COLOR = COLOR_SERVER, const tag[] = "Server")
{
	contloop (new i : playerList)
	{
		if (IsPlayerLoggedIn(i)) ServerClientMessage(i, message, COLOR, tag);
	}
}

#endif
