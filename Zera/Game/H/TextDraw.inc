#if !defined _GAME_TEXTDRAW_H
#define _GAME_TEXTDRAW_H

new Text: countText;
new Text: mapInfoText;
new Text: respawnText;
new Text: timeBox[2];
new Text: timeText;
new Text: speedoBack;
new Text: rankBox[3];
new Text: rankTabList;
new Text: rankText[10];

#if SAMP_VERSION == SAMP_03d
	#define TEXT_TYPE Text
#else
	#define TEXT_TYPE PlayerText
#endif

new TEXT_TYPE: playerSpeedo[MAX_PLAYERS];
new TEXT_TYPE: healthText[MAX_PLAYERS];
new TEXT_TYPE: deathListText[MAX_PLAYERS];

forward G_TextDraw_PlayerConnect(playerid);
forward G_TextDraw_PlayerDisconnect(playerid);

#endif
