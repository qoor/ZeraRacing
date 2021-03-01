#if !defined __GAME_MUSIC_H__
#define __GAME_MUSIC_H__

#define BGM_HANDLE_AREA 1000

new playerBGM[MAX_PLAYERS];

forward G_Music_Initialize();
forward G_Music_PlayerConnect(playerid);
forward G_Music_PlayerSpawn(playerid);
forward G_Music_PlayerSobeitCheckPass(playerid);
forward G_Music_PlayerMapStart(playerid);

forward PlayMapBGM(playerid, url[] = "");
forward StopMapBGM(playerid);

#endif
