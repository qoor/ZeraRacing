#if !defined __QAC_CORE_H__
#define __QAC_CORE_H__

enum E_CHEAT_TYPE_INFO
{
	CHEAT_TYPE_SOBEIT,
	CHEAT_TYPE_HEALTH,
	CHEAT_TYPE_ARMOUR,
	CHEAT_TYPE_JETPACK,
	CHEAT_TYPE_SPEED,
	CHEAT_TYPE_BOT,
	CHEAT_TYPE_WEAPON
};

forward OnPlayerCheatDetected(playerid, E_CHEAT_TYPE_INFO: cheatType, {Float, _}: ...);

#endif
