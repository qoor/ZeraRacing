#if !defined __GAME_MAP_H__
#define __GAME_MAP_H__

#define MAX_BUY_MAP_AMOUNT 5

#define MAP_BUY_DELAY 1500

enum E_BUY_MAP_INFO
{
	bmPlayer,
	bmPlayerName[MAX_PLAYER_NAME],
	bmMapID
}

new redo;
new arrivedCount;
new legacyMap = 1; // 레거시 맵이라는 가정을 기본값으로 함. (쉬운 판별을 위해서)
new buyMapCount;

new currentMapName[256];
new currentAuthorName[32];

new buyMapInfo[MAX_BUY_MAP_AMOUNT][E_BUY_MAP_INFO];
new mapBuyLastTime[MAX_MAPS];

forward G_Map_PlayerCommandText(playerid, const command[], params[]);
forward G_Map_DialogResponse(playerid, dialogid, response, listitem);
forward G_Map_PlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
forward G_Map_PlayerDisconnect(playerid);
forward G_Map_GamemodeMapStart();
#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	forward G_Map_MapDataFunctionFound(const tag[], const func[], const value[]);
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	forward G_Map_MapDataFunctionFound(const tag[], QXmlAttribute: attribute);
#endif
forward G_Map_MapNameChanged();

forward OnPlayerMapArrived(playerid);
forward ShowPlayerArriveTime(playerid, rank, time);
forward CreateMapObject(modelid, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, transparent = 0);
forward UpdateMapNameText();
forward ShowMapListForPlayer(playerid, type = 0);
forward ShowBuyMapInfoForPlayer(playerid);
forward GetCurrentNextMapID();
forward StartCurrentNextMap();
forward IsValidObjectModel(modelid);

#endif
