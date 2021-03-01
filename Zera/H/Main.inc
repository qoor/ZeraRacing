#if !defined __MAIN_H__
#define __MAIN_H__

#pragma dynamic 5000

#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 30

#undef MAX_PLAYER_NAME
#define MAX_PLAYER_NAME 21

#include <a_mysql>
#include <audio>
#include <streamer>
#include <QXml>

#include <QFader>
#include <QModule>
#include <QContainer>

#include "./Zera/H/veh.inc"
#include "./Zera/H/vehiclesize.inc"

#define COMMAND_DELIMITER " "

new modeExit;

native IsValidVehicle(vehicleid);

forward Main_PlayerDisconnect(playerid);
forward Main_GameModeExit();

forward ShowGameModeLoadText();
forward SetServerClose();
forward SetServerRestart();

forward AntiDeAMX();

#endif
