#if !defined __QAC_CORE__
#define __QAC_CORE__

public OnPlayerCheatDetected(playerid, E_CHEAT_TYPE_INFO: cheatType, {Float, _}: ...)
{
	new string[145];

	if (cheatType == CHEAT_TYPE_SOBEIT)
	{
		sobeitCheck[playerid] = -1;

		format(string, sizeof(string), "%s(id:%d)�Կ��Լ� S0beit�� �����Ǿ� �߹�˴ϴ�.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� S0beit�� �����Ǿ� �߹�˴ϴ�.", .tag = "QAC");
		Kick(playerid);
	}
	else if (cheatType == CHEAT_TYPE_HEALTH)
	{
		new type;

		if (numargs() > 2) type = getarg(2);

		if (type == 0)
		{
			format(string, sizeof(string), "%s(id:%d)���� ü�� �� ����� �ǽɵ˴ϴ�.", playerName[playerid], playerid);
			SendClientMessageToGamePlayers(string, .tag = "QAC");
		}
		else if (type == 1)
		{
			format(string, sizeof(string), "%s(id:%d)���� ���� ü�� �� ����� �ǽɵ˴ϴ�.", playerName[playerid], playerid);
			SendClientMessageToGamePlayers(string);
		}
	}
	else if (cheatType == CHEAT_TYPE_ARMOUR)
	{
		format(string, sizeof(string), "%s(id:%d)���� �Ƹ� �� ������� ���˴ϴ�.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� �Ƹ� �� ������� ���˴ϴ�.", .tag = "QAC");
		BanEx(playerid, "�Ƹ� ��");
	}
	else if (cheatType == CHEAT_TYPE_JETPACK)
	{
		format(string, sizeof(string), "%s(id:%d)���� ��Ʈ�� �� ������� ���˴ϴ�.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� ��Ʈ�� �� ������� ���˴ϴ�.", .tag = "QAC");
		BanEx(playerid, "��Ʈ�� ��");
	}
	else if (cheatType == CHEAT_TYPE_SPEED)
	{
		format(string, sizeof(string), "%s(id:%d)���� ���ǵ� �� ����� �ǽɵǾ� ���˴ϴ�.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� ���ǵ� �� ����� �ǽɵǾ� ���˴ϴ�.", .tag = "QAC");
		BanEx(playerid, "���ǵ� ��");
	}
	else if (cheatType == CHEAT_TYPE_BOT)
	{
		format(string, sizeof(string), "%s(id:%d)���� �� ���α׷� ����� �ǽɵǾ� ���˴ϴ�.", playerName[playerid], playerid);
		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� �� ���α׷� ������� �ǽɵǾ� ���˴ϴ�.", .tag = "QAC");

		format(string, sizeof(string), "banip %s", ipAddress[playerid]);
		SendRconCommand(string);

		Kick(playerid);
	}
	else if (cheatType == CHEAT_TYPE_WEAPON)
	{
		new weaponid = getarg(2);

		format(string, sizeof(string), "%s(id:%d)���� ���� �� ����� �ǽɵǾ� ���˴ϴ�.", playerName[playerid], playerid);

		if (weaponid != 0)
		{
			new weaponName[32];
			
			GetWeaponName(weaponid, weaponName, sizeof(weaponName));
			format(string, sizeof(string), "%s (��ȯ �� ����: %s)", string, weaponName);
		}
		else
			strcat(string, " (S0beit ���� �� ON)");

		SendClientMessageToGamePlayers(string, .tag = "QAC");
		ServerClientMessage(playerid, "����� ���� �� ����� �ǽɵǾ� ���˴ϴ�.", .tag = "QAC");

		BanEx(playerid, "���� ��");
	}
}

#endif
