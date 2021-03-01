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
	{ "무지개 컬러", 80000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "밥 아저씨의 컬러 이야기(AMOLED)", 130000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "허쉬 쿠키 & 크림 컬러", 50000, ITEM_GROUP_CAR_COLOR, 0, 0, 0 },
	{ "고정 색상", 10000, ITEM_GROUP_CAR_COLOR, 0, 0, 1 },
	// Car Component
	{ "랜덤 휠", 250000, ITEM_GROUP_CAR_COMPONENT, 0, 0, 0 },
	{ "라이트 반짝이", 250000, ITEM_GROUP_CAR_COMPONENT, 0, 0, 0 },
	// Player
	{ "캐릭터 스킨", 60000, ITEM_GROUP_PLAYER, 0, 0, 1 },
	{ "칭호 구매", 30000, ITEM_GROUP_PLAYER, 1, 0, 1 },
	// Game
	{ "맵 구매", 2000, ITEM_GROUP_GAME, 1, 1, 1 }
};

new const itemGroup[][E_ITEM_GROUP_INFO] = {
	{ "차량 색상 아이템", 1 },
	{ "차량 외형 아이템", 0 },
	{ "플레이어 아이템", 0 },
	{ "게임 관련 아이템", 0 }
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
