#if !defined __QAC_CORE__
#define __QAC_CORE__

public OnPlayerCheatDetected(playerid, E_CHEAT_TYPE_INFO: cheatType, {Float, _}: ...)
{
	new string[145];

	if (cheatType == CHEAT_TYPE_SOBEIT)
	{
		sobeitCheck[playerid] = -1;

		format(string, sizeof(string), "%s(id:%d)님에게서 S0beit가 감지되어 추방됩니다.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 S0beit가 감지되어 추방됩니다.", .tag = "QAC");
		Kick(playerid);
	}
	else if (cheatType == CHEAT_TYPE_HEALTH)
	{
		new type;

		if (numargs() > 2) type = getarg(2);

		if (type == 0)
		{
			format(string, sizeof(string), "%s(id:%d)님은 체력 핵 사용이 의심됩니다.", playerName[playerid], playerid);
			SendClientMessageToGamePlayers(string, .tag = "QAC");
		}
		else if (type == 1)
		{
			format(string, sizeof(string), "%s(id:%d)님은 차량 체력 핵 사용이 의심됩니다.", playerName[playerid], playerid);
			SendClientMessageToGamePlayers(string);
		}
	}
	else if (cheatType == CHEAT_TYPE_ARMOUR)
	{
		format(string, sizeof(string), "%s(id:%d)님은 아머 핵 사용으로 블럭됩니다.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 아머 핵 사용으로 블럭됩니다.", .tag = "QAC");
		BanEx(playerid, "아머 핵");
	}
	else if (cheatType == CHEAT_TYPE_JETPACK)
	{
		format(string, sizeof(string), "%s(id:%d)님은 제트팩 핵 사용으로 블럭됩니다.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 제트팩 핵 사용으로 블럭됩니다.", .tag = "QAC");
		BanEx(playerid, "제트팩 핵");
	}
	else if (cheatType == CHEAT_TYPE_SPEED)
	{
		format(string, sizeof(string), "%s(id:%d)님은 스피드 핵 사용이 의심되어 블럭됩니다.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 스피드 핵 사용이 의심되어 블럭됩니다.", .tag = "QAC");
		BanEx(playerid, "스피드 핵");
	}
	else if (cheatType == CHEAT_TYPE_BOT)
	{
		format(string, sizeof(string), "%s(id:%d)님은 봇 프로그램 사용이 의심되어 블럭됩니다.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 봇 프로그램 사용으로 의심되어 블럭됩니다.", .tag = "QAC");

		format(string, sizeof(string), "banip %s", ipAddress[playerid]);
		SendRconCommand(string);

		Kick(playerid);
	}
	else if (cheatType == CHEAT_TYPE_WEAPON)
	{
		new weaponid = getarg(2);

		format(string, sizeof(string), "%s(id:%d)님은 무기 핵 사용이 의심되어 블럭됩니다.", playerName[playerid], playerid);

		if (weaponid != 0)
		{
			new weaponName[32];
			
			GetWeaponName(weaponid, weaponName, sizeof(weaponName));
			format(string, sizeof(string), "%s (소환 한 무기: %s)", string, weaponName);
		}
		else
			strcat(string, " (S0beit 무기 핵 ON)");

		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "당신은 무기 핵 사용이 의심되어 블럭됩니다.", .tag = "QAC");

		BanEx(playerid, "무기 핵");
	}
}

#endif
