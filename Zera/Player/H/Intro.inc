#if !defined __PLAYER_INTRO_H__
#define __PLAYER_INTRO_H__

new introStartEvent;
new introFinishEvent;

new introStarted[MAX_PLAYERS];

forward P_Intro_PlayerConnect(playerid);
forward P_Intro_PlayerIntroStart(playerid);

forward OnPlayerIntroFinish(playerid);

#endif
