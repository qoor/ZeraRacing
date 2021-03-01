#if !defined __PLAYER_MESSAGE_H__
#define __PLAYER_MESSAGE_H__

new const titles[][] = {
	"Bronze",
	"Silver",
	"Gold",
	"Platinum",
	"Diamond",
	"Challenger"
};

forward P_Message_PlayerText(playerid, const text[]);

forward ServerClientMessage(playerid, const message[], COLOR = COLOR_SERVER, const tag[] = "Server");
forward SendClientMessageToGamePlayers(const message[], COLOR = COLOR_SERVER, const tag[] = "Server");

#endif
