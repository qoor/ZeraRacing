#if !defined __QAC_WEAPON__
#define __QAC_WEAPON__

InitModule("QAC_Weapon")
{
	AddEventHandler(playerSecondTimer, "QAC_Weapon_PlayerSecondTimer");
}

public QAC_Weapon_PlayerSecondTimer(playerid)
{
	if (IsPlayerLoggedIn(playerid) == 0)
		return 0;
	
	new weaponid;

	if ((weaponid = GetPlayerWeapon(playerid)) != 0 && weaponid != WEAPON_PARACHUTE)
	{
		OnPlayerCheatDetected(playerid, CHEAT_TYPE_WEAPON, weaponid);

		return 1;
	}

	return 0;
}

#endif
