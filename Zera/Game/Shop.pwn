#if !defined __GAME_SHOP__
#define __GAME_SHOP__

InitModule("Game_Shop")
{
	AddEventHandler(D_PlayerConnect, "G_Shop_PlayerConnect");
	AddEventHandler(D_PlayerCommandText, "G_Shop_PlayerCommandText");
	AddEventHandler(D_DialogResponse, "G_Shop_DialogResponse");

	InitShop();
}

public G_Shop_PlayerConnect(playerid)
{
	itemGroupSelect[playerid] = -1;

	return 0;
}

public G_Shop_PlayerCommandText(playerid, const command[])
{
	if (strcmp(command, "/����") == 0 || strcmp(command, "/shop", true) == 0)
	{
		ShowItemShopDialogForPlayer(playerid);

		return 1;
	}

	return 0;
}

public G_Shop_DialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
	if (dialogid == DIALOG_SHOP)
	{
		if (response == 0) return 1;

		if (listitem == sizeof(itemGroup))
		{
			ShowPlayerInventory(playerid);

			return 1;
		}

		itemGroupSelect[playerid] = listitem;

		ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

		return 1;
	}
	
	if (dialogid == DIALOG_SHOP + 1)
	{
		if (response == 0)
		{
			ShowItemShopDialogForPlayer(playerid);

			return 1;
		}

		new groupid = itemGroupSelect[playerid];
		new index = GetItemID(groupid, listitem);

		if (index != -1)
		{
			if (itemList[index][itHaveValue] == 0 && playerItem[playerid][index][pitHave] == 1)
			{
				ServerClientMessage(playerid, "����� �̹� �� �������� ������ �ֽ��ϴ�.");
			}
			else
			{
				if (GetPlayerMoney(playerid) < itemList[index][itPrice]) ServerClientMessage(playerid, "����� �� �������� ������ ���� �����մϴ�.");
				else if (index == ITEM_STATIC_VEHICLE_COLOR)
				{
					ShowBuyCarColorDialogForPlayer(playerid);

					return 1;
				}
				else if (index == ITEM_CHARACTER_SKIN)
				{
					ShowBuySkinDialogForPlayer(playerid);

					return 1;
				}
				else if (index == ITEM_BUY_MAP)
				{
					ShowMapListForPlayer(playerid, 1);

					return 1;
				}
				else if (index == ITEM_TITLE)
				{
					if (strval(playerItemValue[playerid][index]) >= sizeof(titles) - 1)
						ServerClientMessage(playerid, "����� �̹� ���� ���� ����� Īȣ�� ����Ǿ� �ֽ��ϴ�.");
					else
					{
						new string[145];

						GivePlayerMoney(playerid, -itemList[index][itPrice]);
						SavePlayerAccount(playerid);
						
						playerItem[playerid][index][pitHave] = 1;

						if (IsNull(playerItemValue[playerid][index]))
							playerItemValue[playerid][index] = "0";
						else
							format(playerItemValue[playerid][index], 256, "%d", strval(playerItemValue[playerid][index]) + 1);
						
						SavePlayerItem(playerid, index);

						format(string, sizeof(string), "���ο� Īȣ %s��(��) �����ϼ̽��ϴ�.", titles[strval(playerItemValue[playerid][index])]);
						ServerClientMessage(playerid, string);
					}
				}
				else
				{
					new string[145];

					GivePlayerMoney(playerid, -itemList[index][itPrice]);
					SavePlayerAccount(playerid);

					playerItem[playerid][index][pitHave] = 1;

					if (itemList[index][itNotUseItem] == 0) UsePlayerItem(playerid, index);
					else SavePlayerItem(playerid, index);

					format(string, sizeof(string), "����� %s �������� $%d(��)�� �����ϼ̽��ϴ�.", itemList[index][itName], itemList[index][itPrice]);
					ServerClientMessage(playerid, string);
				}

				ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);
			}
		}

		return 1;
	}

	if (dialogid == DIALOG_SHOP + 2)
	{
		if (response == 1)
		{
			new length;

			if ((length = strlen(inputtext)) > 20 || length < 3 || strchr(inputtext, ',') == -1)
			{
				ShowBuyCarColorDialogForPlayer(playerid);

				return 1;
			}

			new colorStrValue[2][11];
			new color1, color2;

			split(inputtext, colorStrValue, ',');

			color1 = strval(colorStrValue[0]);
			color2 = strval(colorStrValue[1]);

			if (color1 < 0 || color1 > 255 || color2 < 0 || color1 > 255)
			{
				ServerClientMessage(playerid, "���� ���� �ڵ�� 0~255������ �Է��� �� �ֽ��ϴ�.");
				ShowBuyCarColorDialogForPlayer(playerid);

				return 1;
			}

			if (GetPlayerMoney(playerid) < itemList[ITEM_STATIC_VEHICLE_COLOR][itPrice]) ServerClientMessage(playerid, "����� �� �������� ������ ���� �����մϴ�.");
			else
			{
				new string[21];

				format(string, sizeof(string), "%d,%d", color1, color2);

				GivePlayerMoney(playerid, -itemList[ITEM_STATIC_VEHICLE_COLOR][itPrice]);
				SavePlayerAccount(playerid);

				playerItem[playerid][ITEM_STATIC_VEHICLE_COLOR][pitHave] = 1;
				playerItemValue[playerid][ITEM_STATIC_VEHICLE_COLOR] = string;

				UsePlayerItem(playerid, ITEM_STATIC_VEHICLE_COLOR);

				format(string, sizeof(string), "����� %s �������� $%d(��)�� �����ϼ̽��ϴ�.", itemList[ITEM_STATIC_VEHICLE_COLOR][itName], itemList[ITEM_STATIC_VEHICLE_COLOR][itPrice]);
				ServerClientMessage(playerid, string);
			}
		}

		ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

		return 1;
	}

	if (dialogid == DIALOG_SHOP + 3)
	{
		if (response == 1)
		{
			if (GetPlayerMoney(playerid) < itemList[ITEM_STATIC_VEHICLE_COLOR][itPrice])
			{
				ServerClientMessage(playerid, "����� �� �������� ������ ���� �����մϴ�.");
				ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);
				
				return 1;
			}

			if (IsNull(inputtext))
			{
				ShowBuySkinDialogForPlayer(playerid);

				return 1;
			}

			new skinid = strval(inputtext);

			if (skinid < 0 || skinid > 299)
			{
				ServerClientMessage(playerid, "�÷��̾� ��Ų �ڵ�� 0~299������ �Է��� �� �ֽ��ϴ�.");
				ShowBuySkinDialogForPlayer(playerid);

				return 1;
			}

			new string[4];

			valstr(string, skinid);

			GivePlayerMoney(playerid, -itemList[ITEM_CHARACTER_SKIN][itPrice]);
			SavePlayerAccount(playerid);

			playerItem[playerid][ITEM_CHARACTER_SKIN][pitHave] = 1;
			playerItemValue[playerid][ITEM_CHARACTER_SKIN] = string;
			
			UsePlayerItem(playerid, ITEM_CHARACTER_SKIN);

			format(string, sizeof(string), "����� %s �������� $%d(��)�� �����ϼ̽��ϴ�.", itemList[ITEM_CHARACTER_SKIN][itName], itemList[ITEM_CHARACTER_SKIN][itPrice]);
			ServerClientMessage(playerid, string);
		}

		ShowPlayerItemList(playerid, itemGroupSelect[playerid], 1);

		return 1;
	}

	return 0;
}

function InitShop()
{
	new groupid;

	for (new i = 0; i < sizeof(itemList); ++i)
	{
		if ((groupid = itemList[i][itGroup]) >= 0 && groupid < sizeof(itemGroup)) ++itemGroupMaxItems[groupid];
	}
}

function ShowItemShopDialogForPlayer(playerid)
{
	ShowItemGroupListForPlayer(playerid, 1);
}

function ShowItemGroupListForPlayer(playerid, type = 0)
{
	new string[1024];
	new varName[32];
	new groupid;
	new itemCount[sizeof(itemGroup)];

	if (type == 0)
	{
		for (new i = 0; i < sizeof(itemList); ++i)
		{
			groupid = itemList[i][itGroup];

			if (itemList[i][itNotUseItem] != 0) --itemCount[groupid];
		}
	}

	for (new i = 0; i < sizeof(itemGroup); ++i)
	{
		if (type == 0)
		{
			if (itemCount[i] + itemGroupMaxItems[i] <= 0) continue;

			format(varName, sizeof(varName), "�����۱׷�%d", i);
			SetPVarInt(playerid, varName, i + 1);
		}

		format(string, sizeof(string), "%s%s\n", string, itemGroup[i][itgName]);
	}

	if (type == 0) ShowPlayerDialog(playerid, DIALOG_INVENTORY + 1, DIALOG_STYLE_LIST, "�κ��丮", string, "����", "����");
	else if (type == 1)
	{
		strcat(string, "�κ��丮�� �̵�");
		ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "������ ����", string, "����", "���");
	}

	SendClientMessage(playerid, 0x00FF00FF, "�ʷϻ�: ��� ��{FFFFFF}, �Ͼ��: ��� ����, {AAAAAA}ȸ��: ����");
}

function ShowPlayerItemList(playerid, groupid, type = 0)
{
	new string[1024];
	new varName[32];
	new listCount;

	for (new i = 0; i < sizeof(itemList); ++i)
	{
		if (itemList[i][itGroup] == groupid && (type == 1 || itemList[i][itNotUseItem] == 0))
		{
			if (itemList[i][itNotUseItem] == 1 || playerItem[playerid][i][pitHave] == 1)
			{
				if (playerItem[playerid][i][pitUse] == 1) strcat(string, "{00FF00}");
				else strcat(string, "{FFFFFF}");
			}
			else strcat(string, "{AAAAAA}");

			if (type == 0)
			{
				format(varName, sizeof(varName), "�����۹�ȣ%d", listCount++);
				SetPVarInt(playerid, varName, i + 1);

				format(string, sizeof(string), "%s%s\n", string, itemList[i][itName]);
			}
			else format(string, sizeof(string), "%s%s ($%d)\n", string, itemList[i][itName], itemList[i][itPrice]);
		}
	}

	if (type == 0) ShowPlayerDialog(playerid, DIALOG_INVENTORY + 2, DIALOG_STYLE_LIST, "�� ������ ���", string, "���", "����");
	else if (type == 1) ShowPlayerDialog(playerid, DIALOG_SHOP + 1, DIALOG_STYLE_LIST, "���� ������ ���", string, "����", "����");
}

function GetItemID(groupid, groupItem)
{
	if (groupid < 0 || groupid >= sizeof(itemGroup)) return -1;

	for (new i = 0; i < groupid; ++i) groupItem += itemGroupMaxItems[i];

	if (groupItem >= sizeof(itemList)) return -1;

	return groupItem;
}

function ShowBuyCarColorDialogForPlayer(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_SHOP + 2, DIALOG_STYLE_INPUT, "���� ���� ���� ����", "������ ���� ���� ���� �Է��� �ּ���.\n\
		���� ���� �ڵ� ����: 0~255\n\
		�Է� ����: �����ڵ�,�����ڵ� (Ex: 0,1)\n\
		������ �� �� ���ϸ� �������� �籸�� �ؾ� �ٲ� �� �ֽ��ϴ�.", "����", "����");
}

function ShowBuySkinDialogForPlayer(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_SHOP + 3, DIALOG_STYLE_INPUT, "ĳ���� ��Ų ����", "ĳ������ ��Ų �𵨰��� �Է��� �ּ���.\n\
		���� ���� �ڵ� ����: 0~299 (74�� ����)\n\
		�Է� ����: �𵨹�ȣ (Ex: 85)\n\
		ĳ���� ���� �� �� ���ϸ� �������� �籸�� �ؾ� �ٲ� �� �ֽ��ϴ�.", "����", "����");
}

#endif
