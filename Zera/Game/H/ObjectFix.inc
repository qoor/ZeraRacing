#if !defined _GAME_OBJECTFIX_H
#define _GAME_OBJECTFIX_H

#define DEFAULT_AUTOSTREAM_DELAY 2000

new objectMovedEvent;

new objectFixState = 1;

new autoStreamDelayTimer[MAX_PLAYERS];

forward G_ObjectFix_PlayerDisconnect(playerid);
forward G_ObjectFix_GamemodeMapStart();
forward G_ObjectFix_GlobalSecondTimer();
forward G_ObjectFix_PlayerSecondTimer(playerid);

forward OnRequireActiveAutoStream(playerid);

#endif
