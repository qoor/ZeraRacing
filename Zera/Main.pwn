#if !defined __MAIN__
#define __MAIN__

#define HOSTNAME "¡Ú [Z] 2017 Á¦¶ó DM ·¹ÀÌ½Ì ¡Ú"
#define VERSION "v0.764 beta"
#define MODETEXT VERSION
#define MAPNAME "Waiting for players"
#define WEBSITE "cafe.daum.net/TFP"

//=========================================
#include "./Zera/H/Main.inc"
#include "./Zera/H/Hook.inc"

#include "./Zera/H/MySQL.inc"
#include "./Zera/H/MapManager.inc"
#include "./Zera/H/Dialog.inc"
#include "./Zera/H/Timer.inc"
#include "./Zera/H/Module.inc"
#include "./Zera/H/Log.inc"
#include "./Zera/H/Color.inc"

//-----------------------------------------
#include "./Zera/QAC/H/Core.inc"

#include "./Zera/QAC/H/Freeze.inc"
#include "./Zera/QAC/H/Sobeit.inc"
#include "./Zera/QAC/H/Position.inc"
#include "./Zera/QAC/H/Health.inc"
#include "./Zera/QAC/H/Jetpack.inc"
#include "./Zera/QAC/H/Bot.inc"
#include "./Zera/QAC/H/Weapon.inc"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Vehicle/H/Core.inc"

#include "./Zera/Vehicle/H/Health.inc"
#include "./Zera/Vehicle/H/Speedo.inc"
#include "./Zera/Vehicle/H/Nitro.inc"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Game/H/Core.inc"

#include "./Zera/Game/H/TextDraw.inc"
#include "./Zera/Game/H/Map.inc"
#include "./Zera/Game/H/Ghost.inc"
#include "./Zera/Game/H/Spectate.inc"
#include "./Zera/Game/H/ObjectFix.inc"
#include "./Zera/Game/H/Pickup.inc"
#include "./Zera/Game/H/Count.inc"
#include "./Zera/Game/H/Survival.inc"
#include "./Zera/Game/H/Help.inc"
#include "./Zera/Game/H/Music.inc"
#include "./Zera/Game/H/Training.inc"
#include "./Zera/Game/H/Rank.inc"
#include "./Zera/Game/H/Shop.inc"
#include "./Zera/Game/H/Debug.inc"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Player/H/Core.inc"

#include "./Zera/Player/H/Account.inc"
#include "./Zera/Player/H/Message.inc"
#include "./Zera/Player/H/Intro.inc"
#include "./Zera/Player/H/Item.inc"
#include "./Zera/Player/H/Pause.inc"
#include "./Zera/Player/H/Freeze.inc"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/MapScr/H/BAY_II.inc"
#include "./Zera/MapScr/H/Blank.inc"
#include "./Zera/MapScr/H/Craving.inc"
#include "./Zera/MapScr/H/DarkestHour.inc"
#include "./Zera/MapScr/H/DubIs_II.inc"
#include "./Zera/MapScr/H/FirstShit.inc"
#include "./Zera/MapScr/H/FUA_II.inc"
#include "./Zera/MapScr/H/Halo.inc"
#include "./Zera/MapScr/H/Lullaby.inc"
#include "./Zera/MapScr/H/Lovers.inc"
#include "./Zera/MapScr/H/LvlUp.inc"
#include "./Zera/MapScr/H/MadWorld.inc"
#include "./Zera/MapScr/H/Needed_II.inc"
#include "./Zera/MapScr/H/Newnight.inc"
#include "./Zera/MapScr/H/RainDrps.inc"
#include "./Zera/MapScr/H/RIML_IV.inc"
#include "./Zera/MapScr/H/RTD_III.inc"
#include "./Zera/MapScr/H/Ruffneck.inc"
#include "./Zera/MapScr/H/Shrekt.inc"
//-----------------------------------------
//=========================================

//=========================================
#include "./Zera/Hook.pwn"

#include "./Zera/MapManager.pwn"
#include "./Zera/Module.pwn"
#include "./Zera/MySQL.pwn"
#include "./Zera/Timer.pwn"
#include "./Zera/Log.pwn"

//-----------------------------------------
#include "./Zera/QAC/Core.pwn"

#include "./Zera/QAC/Bot.pwn"
#include "./Zera/QAC/Freeze.pwn"
#include "./Zera/QAC/Health.pwn"
#include "./Zera/QAC/Jetpack.pwn"
#include "./Zera/QAC/Position.pwn"
#include "./Zera/QAC/Sobeit.pwn"
#include "./Zera/QAC/Weapon.pwn"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Player/Core.pwn"

#include "./Zera/Player/Account.pwn"
#include "./Zera/Player/Freeze.pwn"
#include "./Zera/Player/Intro.pwn"
#include "./Zera/Player/Item.pwn"
#include "./Zera/Player/Message.pwn"
#include "./Zera/Player/Pause.pwn"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Vehicle/Core.pwn"

#include "./Zera/Vehicle/Health.pwn"
#include "./Zera/Vehicle/Nitro.pwn"
#include "./Zera/Vehicle/Speedo.pwn"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/Game/Core.pwn"

#include "./Zera/Game/Count.pwn"
#include "./Zera/Game/Debug.pwn"
#include "./Zera/Game/Ghost.pwn"
#include "./Zera/Game/Help.pwn"
#include "./Zera/Game/Map.pwn"
#include "./Zera/Game/Music.pwn"
#include "./Zera/Game/ObjectFix.pwn"
#include "./Zera/Game/Pickup.pwn"
#include "./Zera/Game/Rank.pwn"
#include "./Zera/Game/Shop.pwn"
#include "./Zera/Game/Spectate.pwn"
#include "./Zera/Game/Survival.pwn"
#include "./Zera/Game/TextDraw.pwn"
#include "./Zera/Game/Training.pwn"
//-----------------------------------------

//-----------------------------------------
#include "./Zera/MapScr/BAY_II.pwn"
#include "./Zera/MapScr/Blank.pwn"
#include "./Zera/MapScr/Craving.pwn"
#include "./Zera/MapScr/DarkestHour.pwn"
#include "./Zera/MapScr/DubIs_II.pwn"
#include "./Zera/MapScr/FirstShit.pwn"
#include "./Zera/MapScr/FUA_II.pwn"
#include "./Zera/MapScr/Halo.pwn"
#include "./Zera/MapScr/Lullaby.pwn"
#include "./Zera/MapScr/Lovers.pwn"
#include "./Zera/MapScr/LvlUp.pwn"
#include "./Zera/MapScr/MadWorld.pwn"
#include "./Zera/MapScr/Needed_II.pwn"
#include "./Zera/MapScr/Newnight.pwn"
#include "./Zera/MapScr/RainDrps.pwn"
#include "./Zera/MapScr/RIML_IV.pwn"
#include "./Zera/MapScr/RTD_III.pwn"
#include "./Zera/MapScr/Ruffneck.pwn"
#include "./Zera/MapScr/Shrekt.pwn"
//-----------------------------------------
//=========================================

InitModule("Main")
{
	AntiDeAMX();

	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	SetNameTagDrawDistance(70.0);
	EnableStuntBonusForAll(0);
	#if SAMP_VERSION == SAMP_037
		SetObjectsDefaultCameraCol(1);
	#endif
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

	ToggleServerLogSave(1);

	Streamer_TickRate(100);
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, MAX_STREAM_OBJECTS);

	AddEventHandler(D_GameModeExit, "Main_GameModeExit");

	AddModule("Module");
	AddModule("MySQL");
	AddModule("MapManager");
	AddModule("Timer");

	AddModule("Player");
	AddModule("Player_Intro");
	AddModule("Player_Account");
	AddModule("Player_Message");
	AddModule("Player_Item");
	AddModule("Player_Pause");
	AddModule("Player_Freeze");

	AddModule("Vehicle");
	AddModule("Vehicle_Health");
	AddModule("Vehicle_Speedo");
	AddModule("Vehicle_Nitro");

	AddModule("QAC_Freeze");
	AddModule("QAC_Sobeit");
	AddModule("QAC_Health");
	AddModule("QAC_Jetpack");
	AddModule("QAC_Position");
	AddModule("QAC_Bot");
	AddModule("QAC_Weapon");

	AddModule("Game");
	AddModule("Game_Map");
	AddModule("Game_TextDraw");
	AddModule("Game_Music");
	AddModule("Game_ObjectFix");
	AddModule("Game_Count");
	AddModule("Game_Spectate");
	#if SAMP_VERSION != SAMP_037
		AddModule("Game_Ghost");
	#endif
	AddModule("Game_Pickup");
	AddModule("Game_Survival");
	AddModule("Game_Training");
	AddModule("Game_Help");
	AddModule("Game_Rank");
	AddModule("Game_Shop");
	#if DEBUG_MODE > 0
		AddModule("Game_Debug");
	#endif

	/*AddModule("MapScr_Blank");
	AddModule("MapScr_Craving");
	AddModule("MapScr_DubIs_II");
	AddModule("MapScr_FUA_II");
	AddModule("MapScr_LvlUp");
	AddModule("MapScr_Newnight");
	AddModule("MapScr_RainDrps");
	AddModule("MapScr_RIML_IV");
	AddModule("MapScr_Ruffneck");
	AddModule("MapScr_TFShit");*/

	AddEventHandler(D_PlayerDisconnect, "Main_PlayerDisconnect");
	
	ShowGameModeLoadText();
	
	TriggerEventNoSuspend(modulesLoaded, "");
}

public Main_PlayerDisconnect(playerid)
{
	if (IsValidVehicle(playerVehicle[playerid]))
	{
		DestroyVehicle(playerVehicle[playerid]);

		playerVehicle[playerid] = 0;
	}

	return 0;
}

public Main_GameModeExit()
{
	modeExit = 1;
	
	Audio_DestroyTCPServer();

	return 0;
}

function ShowGameModeLoadText()
{
	SendRconCommand("hostname "#HOSTNAME"");
	SetGameModeText(MODETEXT);
	SendRconCommand("mapname "#MAPNAME"");
	SendRconCommand("weburl "#WEBSITE"");

	print("-------------------------");
	print("    Zera Racing 2017");
	print("   Version: "#VERSION"");
	print("      Made by Qoo");
	print("-------------------------");

	SetRequestMapStart();

	return 0;
}

stock SetServerClose() { SendRconCommand("exit"); }
stock SetServerRestart() { GameModeExit(); }

function AntiDeAMX()
{
	new temp[][] = {
		"Made by",
		"Qoo"
	};

	#pragma unused temp
}

#endif
