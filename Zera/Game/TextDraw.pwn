#if !defined _GAME_TEXTDRAW
#define _GAME_TEXTDRAW

InitModule("Game_TextDraw")
{
	G_TextDraw_Initialize();

	AddEventHandler(D_PlayerConnect, "G_TextDraw_PlayerConnect");
	AddEventHandler(D_PlayerDisconnect, "G_TextDraw_PlayerDisconnect");
}

function G_TextDraw_Initialize()
{
	timeBox[0] = TextDrawCreate(621.000000,1.000000,".");
	TextDrawUseBox(timeBox[0],1);
	TextDrawBoxColor(timeBox[0],0xff4400ff);
	TextDrawTextSize(timeBox[0],0.000000,39.000000);
	TextDrawAlignment(timeBox[0],2);
	TextDrawFont(timeBox[0],3);
	TextDrawLetterSize(timeBox[0],1.000000,1.000000);
	TextDrawColor(timeBox[0],0xffffff00);
	TextDrawBackgroundColor(timeBox[0],0x00000000);
	TextDrawSetOutline(timeBox[0],1);
	TextDrawSetProportional(timeBox[0],1);
	TextDrawSetShadow(timeBox[0],1);
	
	timeBox[1] = TextDrawCreate(621.000000,-1.000000,".");
	TextDrawUseBox(timeBox[1],1);
	TextDrawBoxColor(timeBox[1],0xff8800ff);
	TextDrawTextSize(timeBox[1],2.000000,35.000000);
	TextDrawAlignment(timeBox[1],2);
	TextDrawBackgroundColor(timeBox[1],0x000000ff);
	TextDrawFont(timeBox[1],3);
	TextDrawLetterSize(timeBox[1],1.000000,1.000000);
	TextDrawColor(timeBox[1],0xffffffff);
	TextDrawSetOutline(timeBox[1],1);
	TextDrawSetProportional(timeBox[1],1);
	TextDrawSetShadow(timeBox[1],1);
	
	timeText = TextDrawCreate(604.000000,0.000000,"00:00   00:00");
	TextDrawAlignment(timeText,0);
	TextDrawBackgroundColor(timeText,0x000000ff);
	TextDrawFont(timeText,1);
	TextDrawLetterSize(timeText,0.134999,1.000000);
	TextDrawColor(timeText,0xffffffff);
	TextDrawSetProportional(timeText,1);
	TextDrawSetShadow(timeText,0);

	countText = TextDrawCreate(331.000000,120.000000, "Go!");
	TextDrawAlignment(countText,2);
	TextDrawBackgroundColor(countText,0x000000ff);
	TextDrawFont(countText,1);
	TextDrawLetterSize(countText,4.000000,16.000000);
	TextDrawColor(countText,0xffffffff);
	TextDrawSetOutline(countText,0);
	TextDrawSetProportional(countText,1);
	TextDrawSetShadow(countText,0);

	mapInfoText = TextDrawCreate(1.000000,435.000000,"~y~MAP: ~w~~n~~y~NEXT MAP: ~w~");
	TextDrawAlignment(mapInfoText,0);
	TextDrawBackgroundColor(mapInfoText,0x000000ff);
	TextDrawFont(mapInfoText,2);
	TextDrawLetterSize(mapInfoText,0.199999,0.599999);
	TextDrawSetOutline(mapInfoText,0);
	TextDrawColor(mapInfoText,0xffffffff);
	TextDrawSetProportional(mapInfoText,1);
	TextDrawSetShadow(mapInfoText,1);
	
	respawnText = TextDrawCreate(243.000000,399.000000,"Press space to respawn");
	TextDrawAlignment(respawnText,0);
	TextDrawBackgroundColor(respawnText,0x00000000);
	TextDrawFont(respawnText,1);
	TextDrawLetterSize(respawnText,0.399999,2.899999);
	TextDrawSetOutline(respawnText,0);
	TextDrawColor(respawnText,0xffffffff);
	TextDrawSetProportional(respawnText,1);
	TextDrawSetShadow(respawnText,0);
	
	speedoBack = TextDrawCreate(604.0000000000, 403.0000000000, "KM/H");
	TextDrawAlignment(speedoBack, 1);
	TextDrawBackgroundColor(speedoBack, 0x000000FF);
	TextDrawFont(speedoBack, 2);
	TextDrawLetterSize(speedoBack, 0.2500007152, 1.0000000000);
	TextDrawColor(speedoBack,0xFF8C00FF);
	TextDrawSetOutline(speedoBack, 1);
	TextDrawSetProportional(speedoBack, 1);
	TextDrawSetShadow(speedoBack, 0);
	
	rankBox[0] = TextDrawCreate(521.0000000000, 182.0000000000, "      Untitled");
	TextDrawUseBox(rankBox[0], 1);
	TextDrawBoxColor(rankBox[0], 0xFF8C0044);
	TextDrawTextSize(rankBox[0], 632.0000000000, 5.5555548667);
	TextDrawAlignment(rankBox[0], 1);
	TextDrawBackgroundColor(rankBox[0], 0x00000000);
	TextDrawFont(rankBox[0], 1);
	TextDrawLetterSize(rankBox[0], 0.1100006562, 0.7499999403);
	TextDrawColor(rankBox[0], 0xFFFFFFFF);
	TextDrawSetOutline(rankBox[0], 0);
	TextDrawSetProportional(rankBox[0], 1);
	TextDrawSetShadow(rankBox[0], 0);

	rankBox[1] = TextDrawCreate(576.5000000000, 192.0000000000, ".");
	TextDrawUseBox(rankBox[1], 1);
	TextDrawBoxColor(rankBox[1], 0xFF8C0022);
	TextDrawTextSize(rankBox[1], 65.1852951049, 111.5000000000);
	TextDrawAlignment(rankBox[1], 2);
	TextDrawBackgroundColor(rankBox[1], 0x00000000);
	TextDrawFont(rankBox[1], 3);
	TextDrawLetterSize(rankBox[1], 1.0000000000, 8.8000154495);
	TextDrawColor(rankBox[1], 0x00000000);
	TextDrawSetOutline(rankBox[1], 0);
	TextDrawSetProportional(rankBox[1], 1);
	TextDrawSetShadow(rankBox[1], 0);

	rankBox[2] = TextDrawCreate(520.6998291015, 181.0000000000, "hud:radar_airyard");
	TextDrawUseBox(rankBox[2], 1);
	TextDrawTextSize(rankBox[2], 8.4074096679, 8.0000000000);
	TextDrawFont(rankBox[2], 4);
	TextDrawColor(rankBox[2], 0xFFFFFFFF);

	rankTabList = TextDrawCreate(522.0000000000, 191.5000000000, "#   Name                 Time           Date");
	TextDrawTextSize(rankTabList, 663.0000000000, 0.0000000000);
	TextDrawAlignment(rankTabList, 1);
	TextDrawBackgroundColor(rankTabList, 0x000000FF);
	TextDrawFont(rankTabList, 1);
	//TextDrawLetterSize(rankTabList, 0.1200006508, 0.7899999523);
	TextDrawLetterSize(rankTabList, 0.1000006508, 0.7899999523);
	TextDrawColor(rankTabList, 0xFFFFFFFF);
	TextDrawSetOutline(rankTabList, 0);
	TextDrawSetProportional(rankTabList, 0);
	TextDrawSetShadow(rankTabList, 0);

	for (new i = 0; i < 10; ++i)
	{
		rankText[i] = TextDrawCreate(522.0000000000, 191.5000000000 + (7.2 * float(i + 1)), " ");
		TextDrawTextSize(rankText[i], 663.0000000000, 0.0000000000);
		TextDrawAlignment(rankText[i], 1);
		TextDrawBackgroundColor(rankText[i], 0x000000FF);
		TextDrawFont(rankText[i], 1);
		//TextDrawLetterSize(rankText[i], 0.1200006508, 0.7899999523);
		TextDrawLetterSize(rankText[i], 0.1000006508, 0.7899999523);
		TextDrawColor(rankText[i], 0xFFFFFFFF);
		TextDrawSetOutline(rankText[i], 0);
		TextDrawSetProportional(rankText[i], 0);
		TextDrawSetShadow(rankText[i], 0);
	}
}

public G_TextDraw_PlayerConnect(playerid)
{
	#if SAMP_VERSION == SAMP_03d
		deathListText[playerid] = TextDrawCreate(15.000000,140.000000, " ");
		TextDrawAlignment(deathListText[playerid],0);
		TextDrawBackgroundColor(deathListText[playerid],0x000000ff);
		TextDrawFont(deathListText[playerid],1);
		TextDrawLetterSize(deathListText[playerid],0.199999,0.699999);
		TextDrawColor(deathListText[playerid],0xffffffff);
		TextDrawSetOutline(deathListText[playerid],0);
		TextDrawSetProportional(deathListText[playerid],1);
		TextDrawSetShadow(deathListText[playerid],1);

		playerSpeedo[playerid] = TextDrawCreate(618.0000000000, 413.0000000000, "000");
		TextDrawAlignment(playerSpeedo[playerid], 3);
		TextDrawBackgroundColor(playerSpeedo[playerid], 0x000000FF);
		TextDrawFont(playerSpeedo[playerid], 2);
		TextDrawLetterSize(playerSpeedo[playerid], 0.5100004673, 2.4999985694);
		TextDrawColor(playerSpeedo[playerid],0xFF8C00FF);
		TextDrawSetOutline(playerSpeedo[playerid], 1);
		TextDrawSetProportional(playerSpeedo[playerid], 0);
		TextDrawSetShadow(playerSpeedo[playerid], 0);
		
		healthText[playerid] = TextDrawCreate(38.000000,318.000000,"....................");
		TextDrawAlignment(healthText[playerid],0);
		TextDrawBackgroundColor(healthText[playerid],0x00ff00ff);
		TextDrawFont(healthText[playerid],3);
		TextDrawLetterSize(healthText[playerid],0.499999,1.000000);
		TextDrawColor(healthText[playerid],0x00ff00ff);
		TextDrawSetOutline(healthText[playerid],1);
		TextDrawSetProportional(healthText[playerid],1);
		TextDrawSetShadow(healthText[playerid],1);
	#else
		deathListText[playerid] = CreatePlayerTextDraw(playerid, 15.000000,140.000000, " ");
		PlayerTextDrawAlignment(playerid, deathListText[playerid],0);
		PlayerTextDrawBackgroundColor(playerid, deathListText[playerid],0x000000ff);
		PlayerTextDrawFont(playerid, deathListText[playerid],1);
		PlayerTextDrawLetterSize(playerid, deathListText[playerid],0.199999,0.699999);
		PlayerTextDrawColor(playerid, deathListText[playerid],0xffffffff);
		PlayerTextDrawSetOutline(playerid, deathListText[playerid],0);
		PlayerTextDrawSetProportional(playerid, deathListText[playerid],1);
		PlayerTextDrawSetShadow(playerid, deathListText[playerid],1);

		playerSpeedo[playerid] = CreatePlayerTextDraw(playerid, 618.0000000000, 413.0000000000,"000");
		PlayerTextDrawAlignment(playerid, playerSpeedo[playerid], 3);
		PlayerTextDrawBackgroundColor(playerid, playerSpeedo[playerid],0x000000ff);
		PlayerTextDrawFont(playerid, playerSpeedo[playerid],2);
		PlayerTextDrawLetterSize(playerid, playerSpeedo[playerid],0.5100004673, 2.4999985694);
		PlayerTextDrawColor(playerid, playerSpeedo[playerid],0xFF8C00FF);
		PlayerTextDrawSetOutline(playerid, playerSpeedo[playerid],1);
		PlayerTextDrawSetProportional(playerid, playerSpeedo[playerid],0);
		PlayerTextDrawSetShadow(playerid, playerSpeedo[playerid],0);
		
		healthText[playerid] = CreatePlayerTextDraw(playerid, 38.000000,318.000000,"....................");
		PlayerTextDrawAlignment(playerid, healthText[playerid],0);
		PlayerTextDrawBackgroundColor(playerid, healthText[playerid],0x00ff00ff);
		PlayerTextDrawFont(playerid, healthText[playerid],3);
		PlayerTextDrawLetterSize(playerid, healthText[playerid],0.499999,1.000000);
		PlayerTextDrawColor(playerid, healthText[playerid],0x00ff00ff);
		PlayerTextDrawSetOutline(playerid, healthText[playerid],1);
		PlayerTextDrawSetProportional(playerid, healthText[playerid],1);
		PlayerTextDrawSetShadow(playerid, healthText[playerid],1);
	#endif

	return 0;
}

public G_TextDraw_PlayerDisconnect(playerid)
{
	#if SAMP_VERSION == SAMP_03d
		if (_: deathListText[playerid] != INVALID_TEXT_DRAW) TextDrawDestroy(deathListText[playerid]);
		if (_: playerSpeedo[playerid] != INVALID_TEXT_DRAW) TextDrawDestroy(playerSpeedo[playerid]);
		if (_: healthText[playerid] != INVALID_TEXT_DRAW) TextDrawDestroy(healthText[playerid]);
	#else
		if (_: deathListText[playerid] != INVALID_TEXT_DRAW) PlayerTextDrawDestroy(playerid, deathListText[playerid]);
		if (_: playerSpeedo[playerid] != INVALID_TEXT_DRAW) PlayerTextDrawDestroy(playerid, playerSpeedo[playerid]);
		if (_: healthText[playerid] != INVALID_TEXT_DRAW) PlayerTextDrawDestroy(playerid, healthText[playerid]);
	#endif

	return 0;
}

#endif
