#if !defined __MAPMANAGER_H__
#define __MAPMANAGER_H__

#define MAX_MAPS 200
#define MAX_MAP_TAG_LENGTH 20
#define MAX_MAP_SRC_LENGTH 128
#define MAX_MAP_MODULE_LENGTH 18
#define MAX_STREAM_OBJECTS 500
#define MAX_PLAYER_MAP_OBJECTS (MAX_OBJECTS - MAX_STREAM_OBJECTS)

#define MAP_DATA_TYPE_INI 1
#define MAP_DATA_TYPE_XML 2

#define MAP_DATA_TYPE MAP_DATA_TYPE_XML

#define MAP_PATH "Zera/maps"
#define MAP_SCR_MODULE_PACKAGE "MapScr"

#define MAP_CHANGE_TYPE_ASC 0
#define MAP_CHANGE_TYPE_DESC 1
#define MAP_CHANGE_TYPE_RANDOM 2
#define MAP_CHANGE_TYPE_SHUFFLE 3

#define MARKER_TYPE_CORONA 1
#define MARKER_TYPE_ARROW 2
#define MARKER_TYPE_CHECKPOINT 3
#define MARKER_TYPE_CYLINDER 4
#define MARKER_TYPE_RING 5

#define PICKUP_HIT_DELAY 70

enum E_MARKER_INFO
{
	mCreated,
	mObject,
	Float: mPosX,
	Float: mPosY,
	Float: mPosZ,
	Float: mSize,
	mPlayerHit[MAX_PLAYERS]
};

enum E_PLAYER_MAP_OBJECT_INFO
{
	pmoModelId,
	Float: pmoPosX,
	Float: pmoPosY,
	Float: pmoPosZ,
	Float: pmoRotX,
	Float: pmoRotY,
	Float: pmoRotZ,
	pmoObjectId[MAX_PLAYERS]
};

new mapDataFuncFoundEvent;
new mapNameChangedEvent;
new removeMapElementsEvent;
new gamemodeMapStartEvent;
new playerMarkerHitEvent;

new currentMap = -1;
new mapChangeType = MAP_CHANGE_TYPE_SHUFFLE;
new maxMapObjectID = -1;
new forceNextMap = -1;
new lastMinMapID = -1;
new lastMaxMapID = -1;
new lastShuffleIndex = -1;
new maxMarkerId = -1;
new ignoreWaterKill;

new currentMapSrc[MAX_MAP_SRC_LENGTH];
new currentMapModule[MAX_MAP_MODULE_LENGTH];

new shuffleMapList[MAX_MAPS] = { -1, ... };

new markers[MAX_PICKUPS][E_MARKER_INFO];

new playerMapObject[MAX_PLAYER_MAP_OBJECTS][E_PLAYER_MAP_OBJECT_INFO];

forward MapManager_PlayerDisconnect(playerid);
forward MapManager_PlayerSpawn(playerid);
forward MapManager_PlayerUpdate(playerid);

forward OnPlayerMarkerHit(playerid, markerid);

forward LoadMapData();
forward UnloadMapData();

forward GetNextMapID();
forward IsValidMap(mapid);
forward GetMinMaxMapID(&minOut, &maxOut);
forward GetMapName(mapid, output[], size = sizeof(output));
forward SetMapName(const mapName[]);
forward SetAuthorName(const authorName[]);
forward CreateMapObject(modelid, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, transparent = 0);

#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	forward OnMapDataFunctionFound(const tag[], const func[], const value[]);
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	forward GetMapSrc(mapid, output[], size = sizeof(output));
	forward GetMetaMapAttrValueFromName(mapid, name[], output[], size = sizeof(output));
	forward IsMapModule(const module[]);

	forward OnMapDataFunctionFound(const tag[], QXmlAttribute: attribute);
#endif

#endif
