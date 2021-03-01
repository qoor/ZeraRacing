#if !defined __GAME_HELP__
#define __GAME_HELP__

InitModule("Game_Help")
{
	AddEventHandler(D_PlayerCommandText, "G_Help_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "G_Help_DialogResponse");
}

public G_Help_PlayerCommandText(playerid, const command[])
{
	if (strcmp(command, "/����") == 0 || strcmp(command, "/help", true) == 0 || strcmp(command, "/?") == 0)
	{
		ShowPlayerHelpDialog(playerid);

		return 1;
	}

	return 0;
}

public G_Help_DialogResponse(playerid, dialogid, response, listitem)
{
	if (dialogid == DIALOG_HELP)
	{
		if (response != 0) ShowPlayerHelpDialog(playerid, listitem + 1);
		
		return 1;
	}

	if (dialogid == DIALOG_HELP + 1)
	{
		ShowPlayerHelpDialog(playerid);

		return 1;
	}

	return 0;
}

function ShowPlayerHelpDialog(playerid, step = 0)
{
	if (step == 0) ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Zera Racing ����", "���� �Ұ�\n������\nī��\n��Ģ\n���\n���弳��", "����", "���");
	else if (step == 1)
	{
		new string[2048];

		strcat(string, "{FFFFFF}New Zera Racing�� 2010�� [Z]STAR�� ���� ó�� ���� �Ǿ����ϴ�.\n");
		strcat(string, "MTA���� �����ϴ� �������� DM Race ��带 ��Ƽ�� ��� SA-MP���� ó�� ź���� �����Դϴ�.\n");
		strcat(string, "ù �õ��� ��ŭ ��忡 ������ ���� 2011�� Qoo�� �����̱� ��带 ������� ��, ���ο� ��尡 ź���߽��ϴ�.\n");
		strcat(string, "\n");
		strcat(string, "2015�� �ٽ� Zera Games�� ���ƿ� DM/DD/Shooter/Traning �� ���� �������� �õ�������,\n");
		strcat(string, "SA-MP�� ��︮�� �ʴٰ� �Ǵ��ϰ� 2017�� �ٽ� ������ ���� ��尡 �ϼ��Ǿ����ϴ�.");

		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ���� �Ұ�", string, "����", "");
	}
	else if (step == 2)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ������",
			"{FF0000}Zera Racing 2017\n\n\
			{FFFFFF}��ȹ, ����: {FF0000}Qoo\n\
			{FFFFFF}����: {FF0000}Roddy\n\
			{FFFFFF}��� ����: {FF0000}QModule "QMODULE_ENGINE_VERSION"\n\
			{FFFFFF}�÷�����: QXml v0.101, Streamer v2.9.4, BlueG MySQL R41-4\n\n\
			{FFFFFF}Copyright (c) {FF0000}Qoo. {FFFFFF}All rights reserved.", "����", "");
	}
	else if (step == 3)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ������",
			"{FFFFFF}Prison Break Role Play - http://cafe.daum.net/TFP\n\
			Zera Racing - http://cafe.daum.net/ZERa", "����", "");
	}
	else if (step == 4)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ��Ģ",
			"{FFFFFF}���� ��Ģ�� ī�信�� Ȯ���Ͻ� �� �ֽ��ϴ�.\n\
			{FF0000}ī�� �ּҴ� �Ʒ��� '����' ��ư�� ������ ��, �ٽ� �ߴ� ���� ��Ͽ��� 'ī��' �׸��� �����Ͻø� �˴ϴ�.", "����", "");
	}
	else if (step == 5)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ��Ģ",
			"{FF0000}COMMAND: {FFFFFF}/�κ��丮 /���� /�ŷ� /spm /������� /�뷡 /���ڵ� /��ŷ /�ʱ��Ÿ��\n\
			{FF0000}KEY: {FFFFFF}NUM 8(Burst) NUM 2(Jump) NUM 6(��Ʈ ���) Space Bar([Ż���ڸ� ��� ����] Ʈ���̴� ���)\n\
			{AAAAAA}COMMAND �غ� ��: /������� /�뷡\n\
			{AAAAAA}KEY �غ� ��: NUM 8(Burst) NUM 2(Jump)", "����", "");
	}
	else if (step == 6)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing ���弳��", "/fpslimit 48 [�������� 51~52�� ���� ��.]\n\
			Audio Plugin v0.5 R2 ��ġ", "Ȯ��", "");
	}
}

#endif
