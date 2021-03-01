#if !defined __GAME_SHOP_H__
#define __GAME_SHOP_H__

#define MAX_ITEM_GROUPS 4

enum _: E_ITEM_GROUP_LIST
{
	ITEM_GROUP_CAR_COLOR,
	ITEM_GROUP_CAR_COMPONENT,
	ITEM_GROUP_PLAYER,
	ITEM_GROUP_GAME
};

enum E_ITEM_LIST_INFO
{
	itName[32],
	itPrice,
	itGroup,
	itNotUseItem,
	itNotSaveItem,
	itHaveValue
};

enum E_ITEM_GROUP_INFO
{
	itgName[32],
	itgNoOverlap
}

new const itemList[][E_ITEM_LIST_INFO] = {
	// Name			Price	Group			NotUseItem	NotSaveItem HaveValue
	// Car Color
	{ "������ �÷�", 80000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "�� �������� �÷� �̾߱�(AMOLED)", 130000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "�㽬 ��Ű & ũ�� �÷�", 50000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "���� ����", 10000, ITEM_GROUP_CAR_COLOR, 0, 0, 1 },
	// Car Component
	{ "���� ��", 250000, ITEM_GROUP_CAR_COMPONENT, 0, 0, 0 },
	{ "����Ʈ ��¦��", 250000, ITEM_GROUP_CAR_COMPONENT, 0, 0, 0 },
	// Player
	{ "ĳ���� ��Ų", 60000, ITEM_GROUP_PLAYER, 0, 0, 1 },
	{ "Īȣ ����", 30000, ITEM_GROUP_PLAYER, 1, 0, 1 },
	// Game
	{ "�� ����", 2000, ITEM_GROUP_GAME, 1, 1, 1 }
};

new const itemGroup[][E_ITEM_GROUP_INFO] = {
	{ "���� ���� ������", 1 },
	{ "���� ���� ������", 0 },
	{ "�÷��̾� ������", 0 },
	{ "���� ���� ������", 0 }
};

new itemGroupMaxItems[sizeof(itemGroup)];

new itemGroupSelect[MAX_PLAYERS] = { -1, ... };

forward G_Shop_PlayerConnect(playerid);
forward G_Shop_PlayerCommandText(playerid, const command[], const params[]);
forward G_Shop_DialogResponse(playerid, dialogid, response, listitem, const inputtext[]);

forward InitShop();

forward ShowItemShopDialogForPlayer(playerid);
forward ShowItemGroupListForPlayer(playerid, type = 0);
forward ShowPlayerItemList(playerid, groupid, type = 0);

forward GetItemID(groupid, groupItem);

#endif