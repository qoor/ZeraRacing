#if !defined __GAME_HELP__
#define __GAME_HELP__

InitModule("Game_Help")
{
	AddEventHandler(D_PlayerCommandText, "G_Help_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "G_Help_DialogResponse");
}

public G_Help_PlayerCommandText(playerid, const command[])
{
	if (strcmp(command, "/도움말") == 0 || strcmp(command, "/help", true) == 0 || strcmp(command, "/?") == 0)
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
	if (step == 0) ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Zera Racing 도움말", "서버 소개\n제작자\n카페\n규칙\n기능\n권장설정", "보기", "취소");
	else if (step == 1)
	{
		new string[2048];

		strcat(string, "{FFFFFF}New Zera Racing은 2010년 [Z]STAR에 의해 처음 서비스 되었습니다.\n");
		strcat(string, "MTA에서 흥행하는 컨텐츠인 DM Race 모드를 모티브 삼아 SA-MP에서 처음 탄생한 게임입니다.\n");
		strcat(string, "첫 시도인 만큼 모드에 문제가 많아 2011년 Qoo의 랜덤뽑기 모드를 기반으로 한, 새로운 모드가 탄생했습니다.\n");
		strcat(string, "\n");
		strcat(string, "2015년 다시 Zera Games로 돌아와 DM/DD/Shooter/Traning 등 종합 컨텐츠를 시도했으나,\n");
		strcat(string, "SA-MP엔 어울리지 않다고 판단하고 2017년 다시 완전히 새로 모드가 완성되었습니다.");

		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 서버 소개", string, "이전", "");
	}
	else if (step == 2)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 제작자",
			"{FF0000}Zera Racing 2017\n\n\
			{FFFFFF}기획, 제작: {FF0000}Qoo\n\
			{FFFFFF}도움: {FF0000}Roddy\n\
			{FFFFFF}모드 엔진: {FF0000}QModule "QMODULE_ENGINE_VERSION"\n\
			{FFFFFF}플러그인: QXml v0.101, Streamer v2.9.4, BlueG MySQL R41-4\n\n\
			{FFFFFF}Copyright (c) {FF0000}Qoo. {FFFFFF}All rights reserved.", "이전", "");
	}
	else if (step == 3)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 제작자",
			"{FFFFFF}Prison Break Role Play - http://cafe.daum.net/TFP\n\
			Zera Racing - http://cafe.daum.net/ZERa", "이전", "");
	}
	else if (step == 4)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 규칙",
			"{FFFFFF}서버 규칙은 카페에서 확인하실 수 있습니다.\n\
			{FF0000}카페 주소는 아래의 '이전' 버튼을 누르신 후, 다시 뜨는 도움말 목록에서 '카페' 항목을 선택하시면 됩니다.", "이전", "");
	}
	else if (step == 5)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 규칙",
			"{FF0000}COMMAND: {FFFFFF}/인벤토리 /상점 /거래 /spm /비번변경 /노래 /맵코드 /랭킹 /맵구매목록\n\
			{FF0000}KEY: {FFFFFF}NUM 8(Burst) NUM 2(Jump) NUM 6(고스트 모드) Space Bar([탈락자만 사용 가능] 트레이닝 모드)\n\
			{AAAAAA}COMMAND 준비 중: /비번변경 /노래\n\
			{AAAAAA}KEY 준비 중: NUM 8(Burst) NUM 2(Jump)", "이전", "");
	}
	else if (step == 6)
	{
		ShowPlayerDialog(playerid, DIALOG_HELP + 1, DIALOG_STYLE_MSGBOX, "Zera Racing 권장설정", "/fpslimit 48 [프레임이 51~52로 고정 됨.]\n\
			Audio Plugin v0.5 R2 설치", "확인", "");
	}
}

#endif
