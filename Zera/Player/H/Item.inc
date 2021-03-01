#if !defined __PLAYER_ITEM_H__
#define __PLAYER_ITEM_H__

enum _: E_ITEM_LIST
{
	ITEM_RAINBOW_COLOR,
	ITEM_MR_BOB_COLOR_STORY,
	ITEM_HERSHEYS_COLOR,
	ITEM_STATIC_VEHICLE_COLOR,

	ITEM_RANDOM_WHEEL,
	ITEM_TWINKLE_LIGHT,

	ITEM_CHARACTER_SKIN,

	ITEM_BUY_MAP,

	ITEM_TITLE
};

enum E_PLAYER_ITEM_INFO
{
	pitHave,
	pitUse
};

new playerItem[MAX_PLAYERS][sizeof(itemList)][E_PLAYER_ITEM_INFO];
new playerItemValue[MAX_PLAYERS][sizeof(itemList)][256];

new vehicleColorState[MAX_PLAYERS];
new wheelChangeState[MAX_PLAYERS];
new vehicleLightState[MAX_PLAYERS];

forward P_Item_PlayerConnect(playerid);
forward P_Item_PlayerSpawn(playerid);
forward P_Item_PlayerCommandText(playerid, const command[], const params[]);
forward P_Item_DialogResponse(playerid, dialogid, response, listitem);
forward P_Item_PlayerSecondTimer(playerid);

forward LoadPlayerItems(playerid);
forward SavePlayerItem(playerid, itemid);
forward ShowPlayerInventory(playerid);
forward UsePlayerItem(playerid, itemid);
forward UnUsePlayerItem(playerid, itemid);
forward GetPlayerStaticVehicleColor(playerid, &color1, &color2);

forward OnLoadPlayerItems(playerid, playerIndex);
forward OnSavePlayerItem(playerid, playerIndex, itemid);

#endif
