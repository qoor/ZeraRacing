#if !defined __MODULE__
#define __MODULE__

InitModule("Module")
{
	modulesLoaded = AddEvent("OnModulesLoaded");

	introStartEvent = AddEvent("OnPlayerIntroStart");
	introFinishEvent = AddEvent("OnPlayerIntroFinish");
	sobeitCheckPass = AddEvent("OnPlayerSobeitCheckPass");

	objectMovedEvent = AddEvent("OnDynamicObjectMoved");

	globalSecondTimer = AddEvent("OnGlobalSecondTimer");
	playerSecondTimer = AddEvent("OnPlayerSecondTimer");
	global80msTimer = AddEvent("OnGlobal80msTimer");
	player80msTimer = AddEvent("OnPlayer80msTimer");
	global50msTimer = AddEvent("OnGlobal50msTimer");

	mapDataFuncFoundEvent = AddEvent("OnMapDataFunctionFound");
	mapNameChangedEvent = AddEvent("OnMapNameChanged");
	removeMapElementsEvent = AddEvent("OnRemoveMapElements");
	gamemodeMapStartEvent = AddEvent("OnGamemodeMapStart");
	playerMarkerHitEvent = AddEvent("OnPlayerMarkerHit");

	playerMapStartEvent = AddEvent("OnPlayerGamemodeMapStart");
	racePickupEvent = AddEvent("OnPlayerRacePickupPickuped");
	playerEliminatedEvent = AddEvent("OnPlayerEliminated");
	playerPausedEvent = AddEvent("OnPlayerPause");
}

#endif
