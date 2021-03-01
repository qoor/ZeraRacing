#if !defined __MAPMANAGER__
#define __MAPMANAGER__

InitModule("MapManager")
{
	for (new objectid = 0, playerid = 0; objectid < MAX_PLAYER_MAP_OBJECTS; ++objectid)
	{
		for (; playerid < MAX_PLAYERS; ++playerid)
			playerMapObject[objectid][pmoObjectId][playerid] = INVALID_OBJECT_ID;
	}

	AddEventHandler(D_PlayerDisconnect, "MapManager_PlayerDisconnect");
	AddEventHandler(D_PlayerSpawn, "MapManager_PlayerSpawn");
	AddEventHandler(D_PlayerUpdate, "MapManager_PlayerUpdate");
}

public MapManager_PlayerDisconnect(playerid)
{
	for (new objectid = 0; objectid < MAX_PLAYER_MAP_OBJECTS; ++objectid)
	{
		if (playerMapObject[objectid][pmoModelId] == 0)
			continue;
		if (playerMapObject[objectid][pmoObjectId][playerid] == INVALID_OBJECT_ID)
			continue;

		playerMapObject[objectid][pmoObjectId][playerid] = INVALID_OBJECT_ID;
	}

	return 0;
}

public MapManager_PlayerSpawn(playerid)
{
	ShowAllPlayerMapObjectForPlayer(playerid);

	return 0;
}

public MapManager_PlayerUpdate(playerid)
{
	for (new markerid = 0; markerid <= maxMarkerId; ++markerid)
	{
		if (markers[markerid][mCreated] == 0)
			continue;
		
		if (IsPlayerInRangeOfPoint(playerid, markers[markerid][mSize], markers[markerid][mPosX], markers[markerid][mPosY], markers[markerid][mPosZ]))
		{
			if (markers[markerid][mPlayerHit][playerid] == 0)
			{
				markers[markerid][mPlayerHit][playerid] = 1;

				SetTimerEx("OnPlayerMarkerHit", GetRealTimerTime(PICKUP_HIT_DELAY), 0, "ii", playerid, markerid);
			}
		}
		else if (markers[markerid][mPlayerHit][playerid] != 0)
			markers[markerid][mPlayerHit][playerid] = 0;
	}

	return 1;
}

public OnPlayerMarkerHit(playerid, markerid)
{
	TriggerEventWithBreak(playerMarkerHitEvent, 1, "ii", playerid, markerid + 1);
}

function SetNextMap(mapid)
{
	if (IsValidMap(mapid) == 0) return 0;
	
	forceNextMap = mapid;

	return 1;
}

function StartNextMap()
{
	if (forceNextMap != -1 && IsValidMap(forceNextMap))
	{
		currentMap = forceNextMap;
		forceNextMap = -1;
	}
	else
		currentMap = GetNextMapID();

	if (currentMap != -1)
		LoadMapData();
}

function LoadMapData()
{
	UnloadMapData();

	new string[256];
	new tag[MAX_MAP_TAG_LENGTH];

#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	format(string, sizeof(string), ""MAP_PATH"/%d.ini", currentMap);

	if (fexist(string) == 0) return 0;

	new File: fFile = fopen(string, io_read);

	new i, length;
	new parameter[256];
	new tagBracketOpen = -1;
	new funcBracketOpen = -1, funcBracketClose = -1;
	new ignoreParse;
	new temp[MAX_MAP_TAG_LENGTH];

	while (fread(fFile, string))
	{
		if (IsNull(string)) continue;

		length = strlen(string);
		funcBracketOpen = -1;
		funcBracketClose = -1;
		ignoreParse = 0;

		for (i = 0; i < length; ++i)
		{
			if (string[i] == '\r' || string[i] == '\n') string[i] = 0;
		}

		if (IsNull(string)) continue;

		for (i = 0; i < length; ++i)
		{
			if (string[i] == '(') funcBracketOpen = i;
			else if (string[i] == ')') funcBracketClose = i;
			else if (string[i] == '[')
			{
				if (tagBracketOpen == -1) tagBracketOpen = i;
			}
			else if (string[i] == ']')
			{
				if (tagBracketOpen != -1 && tagBracketOpen < i)
				{
					strmid(temp, string, tagBracketOpen + 1, i, MAX_MAP_TAG_LENGTH);

					if (strcmp(temp, "DM", true) != 0)
					{
						tagBracketOpen = -1;
						ignoreParse = 1;
						tag = temp;

						break;
					}
				}
			}
		}

		if (ignoreParse == 0 && IsNull(tag) == false)
		{
			if (funcBracketOpen != -1)
			{
				if (funcBracketClose != -1) length = funcBracketClose;

				strmid(parameter, string, funcBracketOpen + 1, length);
				
				string[funcBracketOpen] = 0;

				OnMapDataFunctionFound(tag, string, parameter);
			}
			else OnMapDataFunctionFound(tag, "\1", string);
		}
	}

	fclose(fFile);
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	#if DEBUG_MODE > 0
		new oldTick = GetTickCount();
	#endif

	if (ReadMetaMapData(currentMap) == 0)
		return 0;

	if (IsNull(currentMapSrc))
		return 0;
	
	format(string, sizeof(string), ""MAP_PATH"/%s", currentMapSrc);

	if (fexist(string) == 0)
		return 0;
	
	new QXmlDocument: document = CreateXMLDocument(string);

	if (IsValidXMLDocument(document) == 0)
		return 0;
	
	new QXmlNode: node = CreateXMLNodePointer(document);
	new loadSuccess;

	if (IsValidXMLNodePointer(node))
	{
		if (SetNodeFirstChild(node))
		{
			GetNodeName(node, tag);

			if (IsNull(tag) == false && strcmp(tag, "map", true) == 0)
			{
				GetNodeData(node);

				loadSuccess = 1;
			}
		}

		DestroyXMLNodePointer(node);
	}
	
	DestroyXMLDocument(document);

	if (loadSuccess == 0)
		return 0;

	#if DEBUG_MODE > 0
		printf("¸Ê ·Îµù ¿Ï·á: %dms", GetTickCount() - oldTick);
	#endif
#endif

	if (IsNull(currentMapModule) == false)
	{
		format(string, sizeof(string), ""MAP_SCR_MODULE_PACKAGE"_%s_Start", currentMapModule);
		
		if (funcidx(string) != -1) CallLocalFunction(string, "");
		else
		{
			strcat(string, " module is not created.");
			ServerLog(LOG_TYPE_ERROR, string);
		}
	}

	if (IsNull(currentMapName))
		format(currentMapName, sizeof(currentMapName), "%d", currentMap);

	format(string, sizeof(string), "Map Starting: %s", currentMapName);
	ServerLog(LOG_TYPE_INFO, string);

	TriggerEventNoSuspend(gamemodeMapStartEvent, "");

	return 1;
}

public UnloadMapData()
{
	RemoveMapElements();

	currentMapName = "";
	currentMapSrc = "";

	if (IsNull(currentMapModule) == false)
	{
		new moduleStopFunc[32];

		format(moduleStopFunc, sizeof(moduleStopFunc), ""MAP_SCR_MODULE_PACKAGE"_%s_Stop", currentMapModule);
		
		if (funcidx(moduleStopFunc) != -1) CallLocalFunction(moduleStopFunc, "");
	}

	currentMapModule = "";
	ignoreWaterKill = 0;
}

function GetNextMapID()
{
	new minMapID, maxMapID;

	if (GetMinMaxMapID(minMapID, maxMapID) == 0 || maxMapID == -1) return -1;

	new newMapID = currentMap;

	if (mapChangeType == MAP_CHANGE_TYPE_ASC)
	{
		if (++newMapID > maxMapID) newMapID = 0;
	}
	else if (mapChangeType == MAP_CHANGE_TYPE_DESC)
	{
		if (newMapID == 0) newMapID = maxMapID;
		else --newMapID;
	}
	else if (mapChangeType == MAP_CHANGE_TYPE_RANDOM)
	{
		if (maxMapID > 0)
		{
			random(maxMapID + 1); // For REAL random
			random(maxMapID + 1);

			while (newMapID == currentMap) newMapID = random(maxMapID + 1);
		}
	}
	else if (mapChangeType == MAP_CHANGE_TYPE_SHUFFLE)
	{
		new listExpired = (lastMinMapID != minMapID || lastMaxMapID != maxMapID);

		if (listExpired || lastShuffleIndex >= maxMapID - minMapID)
		{
			new randA, randB;
			new temp;
			new range = (maxMapID - minMapID) + 1;

			if (listExpired)
			{
				new index;
				new i;

				lastMinMapID = minMapID;
				lastMaxMapID = maxMapID;

				for (i = 0; i <= lastShuffleIndex; ++i)
					shuffleMapList[i] = -1;

				for (i = minMapID; i <= maxMapID; ++i)
				{
					shuffleMapList[index] = i;

					++index;
				}
			}

			lastShuffleIndex = -1;

			random(range); // For REAL random
			random(range);

			for (new i = minMapID; i <= maxMapID; ++i) // Shuffle amount of map
			{
				randA = random(range);
				randB = random(range);

				temp = shuffleMapList[randA];
				shuffleMapList[randA] = shuffleMapList[randB];
				shuffleMapList[randB] = temp;
			}
		}

		newMapID = shuffleMapList[++lastShuffleIndex];
	}

	return newMapID;
}

#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	public OnMapDataFunctionFound(const tag[], const func[], const value[])
	{
		new parameter[10][32];

		if (strcmp(tag, "mapname", true) == 0) SetMapName(value);
		else if (strcmp(tag, "author", true) == 0) SetAuthorName(value);
		else if (strcmp(tag, "gametime", true) == 0) SetWorldTime(strval(value));
		else if (strcmp(tag, "weather", true) == 0) SetWeather(strval(value));
		else if (strcmp(tag, "object", true) == 0)
		{
			split(value, parameter, ',');

			CreateMapObject(strval(parameter[0]), floatstr(parameter[1]), floatstr(parameter[2]), floatstr(parameter[3]),
					floatstr(parameter[4]), floatstr(parameter[5]), floatstr(parameter[6]), strval(parameter[7]));
		}

		TriggerEventNoSuspend(mapDataFuncFoundEvent, "sss", tag, func, value);
	}

	stock GetMapName(mapid, output[], size = sizeof(output))
	{
		if (IsValidMap(mapid))
		{
			new string[256];

			format(string, sizeof(string), ""MAP_PATH"/%d.ini", mapid);

			if (fexist(string) == 0) return 0;

			new File: fFile = fopen(string, io_read);
			new i, mapNameTagFound;

			while (fread(fFile, string))
			{
				if (IsNull(string)) continue;

				for (i = strlen(string); i >= 0; --i)
				{
					if (string[i] == '\r' || string[i] == '\n') string[i] = 0;
				}

				if (IsNull(string)) continue;

				if (mapNameTagFound == 0)
				{
					if (strcmp(string, "[mapname]", true) == 0)
					{
						mapNameTagFound = 1;
						
						continue;
					}
				}
				else
				{
					strcpy(output, string, size);
					fclose(fFile);

					return 1;
				}
			}

			fclose(fFile);
		}

		return 0;
	}
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	function ReadMetaMapData(mapid)
	{
		new QXmlDocument: document = CreateXMLDocument(""MAP_PATH"/meta.xml");

		if (IsValidXMLDocument(document) == 0)
			return 0;
		
		new QXmlNode: node = CreateXMLNodePointer(document);
		new mapFound;

		if (IsValidXMLNodePointer(node))
		{
			if (SetNodeFirstChild(node) && SetNodeToMapID(node, mapid))
			{
				new QXmlAttribute: attribute = CreateXMLAttributePointer(node);
						
				if (IsValidXMLAttributePointer(attribute))
				{
					new name[MAX_MAP_TAG_LENGTH];

					mapFound = 1;

					GetNodeName(node, name);
					OnMapDataFunctionFound(name, attribute);

					DestroyXMLAttributePointer(attribute);
				}
			}

			DestroyXMLNodePointer(node);
		}

		DestroyXMLDocument(document);

		return mapFound;
	}

	function GetNodeData(QXmlNode: sourceNode)
	{
		if (IsValidXMLNodePointer(sourceNode) == 0)
			return 0;
		
		new tag[MAX_MAP_TAG_LENGTH];
		new QXmlNode: node = CreateXMLCloneNodePointer(sourceNode);

		if (IsValidXMLNodePointer(node) == 0)
			return 0;
		
		new QXmlAttribute: attribute = QXmlAttribute: INVALID_XML_POINTER;

		for (new pathFound = SetNodeFirstChild(node); pathFound != 0; pathFound = SetNodeNextSibling(node))
		{
			attribute = CreateXMLAttributePointer(node);

			if (IsValidXMLAttributePointer(attribute))
			{
				GetNodeName(node, tag);
				
				OnMapDataFunctionFound(tag, attribute);

				DestroyXMLAttributePointer(attribute);
			}

			GetNodeData(node);
		}

		DestroyXMLNodePointer(node);

		return 1;
	}

	public OnMapDataFunctionFound(const tag[], QXmlAttribute: attribute)
	{
		new haveData;
		new key[MAX_MAP_TAG_LENGTH];

		if (strcmp(tag, "info", true) == 0)
		{
			new srcFound;

			for (haveData = SetAttributeFirst(attribute); haveData != 0; haveData = SetAttributeNext(attribute))
			{
				GetAttributeName(attribute, key);

				if (IsNull(key) == false)
				{
					if (strcmp(key, "name", true) == 0)
					{
						new mapName[sizeof(currentMapName)];
						
						GetAttributeValue(attribute, mapName);
						SetMapName(mapName);
					}
					else if (strcmp(key, "author", true) == 0)
						GetAttributeValue(attribute, currentAuthorName);
					else if (strcmp(key, "src", true) == 0)
					{
						srcFound = 1;
						
						GetAttributeValue(attribute, currentMapSrc);
					}
					else if (strcmp(key, "time", true) == 0)
						SetWorldTime(GetAttributeValueInt(attribute));
					else if (strcmp(key, "weather", true) == 0)
						SetWeather(GetAttributeValueInt(attribute));
					else if (strcmp(key, "module", true) == 0)
						GetAttributeValue(attribute, currentMapModule);
					else if (strcmp(key, "waterkill", true) == 0)
						ignoreWaterKill = _: (!GetAttributeValueBool(attribute));
				}
			}

			if (srcFound == 0) currentMapSrc = "";
		}
		else if (strcmp(tag, "object", true) == 0)
		{
			new modelid;
			new Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz;
			new transparent;

			for (haveData = SetAttributeFirst(attribute); haveData != 0; haveData = SetAttributeNext(attribute))
			{
				GetAttributeName(attribute, key);

				if (IsNull(key) == false)
				{
					if (strcmp(key, "collisions", true) == 0)
					{
						if (GetAttributeValueBool(attribute) == false)
							return;
					}
					if (strcmp(key, "model", true) == 0)
						modelid = GetAttributeValueInt(attribute);
					else if (strcmp(key, "interior", true) == 0)
					{
						if (GetAttributeValueInt(attribute) != 0)
							transparent = 1;
					}
					else if (strcmp(key, "posX", true) == 0)
						x = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posY", true) == 0)
						y = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posZ", true) == 0)
						z = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "rotX", true) == 0)
						rx = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "rotY", true) == 0)
						ry = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "rotZ", true) == 0)
						rz = GetAttributeValueFloat(attribute);
				}
			}

			if (modelid != 0) CreateMapObject(modelid, x, y, z, rx, ry, rz, transparent);
		}
		else if (strcmp(tag, "marker", true) == 0)
		{
			new type[16];
			new markerType;
			new red, green, blue;
			new Float: x, Float: y, Float: z;

			for (haveData = SetAttributeFirst(attribute); haveData != 0; haveData = SetAttributeNext(attribute))
			{
				GetAttributeName(attribute, key);

				if (IsNull(key) == false)
				{
					if (strcmp(key, "type", true) == 0)
					{
						GetAttributeValue(attribute, type);

						if (IsNull(type) == false)
						{
							if (strcmp(type, "corona", true) == 0)
								markerType = MARKER_TYPE_CORONA;
							else if (strcmp(type, "arrow", true) == 0)
								markerType = MARKER_TYPE_ARROW; // modelid = 1559;
							else if (strcmp(type, "cylinder", true) == 0)
								markerType = MARKER_TYPE_CYLINDER;
							else if (strcmp(type, "ring", true) == 0)
								markerType = MARKER_TYPE_RING;
							else if (strcmp(type, "checkpoint", true) == 0)
								markerType = MARKER_TYPE_CHECKPOINT;
						}
					}
					else if (strcmp(key, "color", true) == 0)
					{
						new colorString[10];
						new i, size;

						GetAttributeValue(attribute, colorString);

						for (i = 0, size = strlen(colorString) - 3; i < size; ++i)
							colorString[i] = colorString[i + 1];
						
						colorString[6] = 0;

						GetIntToRGB(GetHexToIntValue(colorString), red, green, blue);
					}
					else if (strcmp(key, "posX", true) == 0)
						x = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posY", true) == 0)
						y = GetAttributeValueFloat(attribute);
					else if (strcmp(key, "posZ", true) == 0)
						z = GetAttributeValueFloat(attribute);
				}
			}

			if (markerType != 0)
				CreateMarker(x, y, z, markerType, _, red, green, blue);
		}

		HandlerLoop (mapDataFuncFoundEvent)
		{
			HandlerAction(mapDataFuncFoundEvent, "si", tag, _: attribute);
		}
	}

	stock GetMapName(mapid, output[], size = sizeof(output))
	{
		if (mapid != currentMap || IsNull(currentMapName))
			return GetMetaMapAttrValueFromName(mapid, "name", output, size);
		
		return strcpy(output, currentMapName, size);
	}

	stock SetNodeToMapID(QXmlNode: node, mapid)
	{
		if (IsValidXMLNodePointer(node))
		{
			new index = -1;

			for (new pathFound = SetNodeFirstChild(node); pathFound != 0; pathFound = SetNodeNextSibling(node))
			{
				if (++index == mapid)
					return 1;
			}
		}

		return 0;
	}

	stock GetMapSrc(mapid, output[], size = sizeof(output))
	{
		if (IsNull(currentMapSrc))
			return GetMetaMapAttrValueFromName(mapid, "src", output, size);

		return strcpy(currentMapSrc, output, size);
	}

	function GetMetaMapAttrValueFromName(mapid, name[], output[], size = sizeof(output))
	{
		if (IsNull(name) || fexist(""MAP_PATH"/meta.xml") == 0)
			return 0;

		new QXmlDocument: document = CreateXMLDocument(""MAP_PATH"/meta.xml");

		if (IsValidXMLDocument(document) == 0)
			return 0;

		new QXmlNode: node = CreateXMLNodePointer(document);
		new success;

		if (IsValidXMLNodePointer(node))
		{
			new pointerMoved;

			SetNodeFirstChild(node);

			pointerMoved = SetNodeToMapID(node, mapid);

			if (pointerMoved == 1)
			{
				new QXmlAttribute: attribute = CreateXMLAttributePointer(node);

				if (IsValidXMLAttributePointer(attribute))
				{
					new tag[MAX_MAP_TAG_LENGTH];

					for (new pathFound = SetAttributeFirst(attribute); pathFound != 0; pathFound = SetAttributeNext(attribute))
					{
						GetAttributeName(attribute, tag);

						if (IsNull(tag) == false && strcmp(tag, name, true) == 0)
						{
							GetAttributeValue(attribute, output, size);

							success = 1;

							break;
						}
					}

					DestroyXMLAttributePointer(attribute);
				}
			}
			
			DestroyXMLNodePointer(node);
		}

		DestroyXMLDocument(document);

		return success;
	}
#endif

function RemoveMapElements()
{
	for (new i = 0; i <= maxMapObjectID; ++i)
	{
		if(IsValidDynamicObject(i))
		{
			StopDynamicObject(i);
			DestroyDynamicObject(i);
		}
	}

	for (new i = 0; i <= maxMarkerId; ++i)
	{
		markers[i][mCreated] = 0;
		markers[i][mObject] = INVALID_OBJECT_ID;
		markers[i][mPosX] = 0.0;
		markers[i][mPosY] = 0.0;
		markers[i][mPosZ] = 0.0;
		markers[i][mSize] = 0.0;
	}

	maxMarkerId = -1;

	for (new i = 0; i < MAX_PLAYER_MAP_OBJECTS; ++i)
		DestroyPlayerMapObjectForAll(i);

	TriggerEventNoSuspend(removeMapElementsEvent, "");
}

stock IsValidMap(mapid)
{
#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	new string[128];

	format(string, sizeof(string), ""MAP_PATH"/%d.ini", mapid);

	return (fexist(string));
#elseif MAP_DATA_TYPE == MAP_DATA_TYPE_XML
	if (fexist(""MAP_PATH"/meta.xml") == 0)
		return 0;

	new QXmlDocument: document = CreateXMLDocument(""MAP_PATH"/meta.xml");

	if (IsValidXMLDocument(document) == 0)
		return 0;

	new QXmlNode: node = CreateXMLNodePointer(document);
	new success;
	
	if (IsValidXMLNodePointer(node))
	{
		SetNodeFirstChild(node);

		success = SetNodeToMapID(node, mapid);

		DestroyXMLNodePointer(node);
	}

	DestroyXMLDocument(document);

	return success;
#endif
}

stock IsMapModule(const module[])
{
	return (IsNull(currentMapModule) == false && strcmp(currentMapModule, module) == 0);
}

stock GetMinMaxMapID(&minOut, &maxOut)
{
	minOut = -1;
	maxOut = -1;

#if MAP_DATA_TYPE == MAP_DATA_TYPE_INI
	for (new i = 0; i < MAX_MAPS; ++i)
	{
		if (IsValidMap(i))
		{
			if (minOut == -1) minOut = i;
			if (i > maxOut) maxOut = i;
		}
	}
#else
	if (fexist(""MAP_PATH"/meta.xml") == 0)
		return 0;

	new QXmlDocument: document = CreateXMLDocument(""MAP_PATH"/meta.xml");

	if (IsValidXMLDocument(document) == 0)
		return 0;

	new QXmlNode: node = CreateXMLNodePointer(document);
	new maxMapID = -1;

	if (IsValidXMLNodePointer(node))
	{
		if (SetNodeFirstChild(node))
		{
			for (new pathFound = SetNodeFirstChild(node); pathFound != 0; pathFound = SetNodeNextSibling(node))
				++maxMapID;
		}

		DestroyXMLNodePointer(node);
	}

	DestroyXMLDocument(document);

	if (maxMapID >= 0)
	{
		minOut = 0;
		maxOut = maxMapID;
	}
#endif

	return 1;
}

stock SetMapName(const mapName[])
{
	strcpy(currentMapName, mapName, sizeof(currentMapName));

	TriggerEventNoSuspend(mapNameChangedEvent, "");
}

stock SetAuthorName(const authorName[])
{
	strcpy(currentAuthorName, authorName, sizeof(currentAuthorName));
}

stock CreateMapObject(modelid, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, transparent = 0)
{
	if (IsValidObjectModel(modelid) == 0)
		return INVALID_OBJECT_ID;
	
	new objectid;
	
#if SAMP_VERSION == SAMP_03d
	objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, .drawdistance = (transparent == 0) ? 200.0 : -200.0);
#else
	// Prevent warning
	if (transparent == 0) {}

	objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, .drawdistance = 200.0);

	for (new i = 0; i < 10; ++i) SetDynamicObjectMaterial(objectid, i, 0, "none", "none", 0x00000000);
#endif

	if (objectid != INVALID_OBJECT_ID && objectid > maxMapObjectID) maxMapObjectID = objectid;

#if DEBUG_MODE >= 3
	printf("[obejct] CreateMapObject(modelid = %d, Float: x = %f, Float: y = %f, Float: z = %f, Float: rx = %f, Float: ry = %f, Float: rz = %f, transparent = %d)",
		modelid, x, y, z, rx, ry, rz, transparent);
#endif

	return objectid;
}

stock CreateMarker(Float: x, Float: y, Float: z, markerType = MARKER_TYPE_CHECKPOINT, Float: size = 4.0, red = 0, green = 0, blue = 255, alpha = 255)
{
	new modelid;
	new Float: ry;

	if (markerType == MARKER_TYPE_CORONA)
	{
	#if SAMP_VERSION == SAMP_03d
		new modelColor;

		if (abs(red - green) < 127 && abs(green - blue) < 127 && abs(blue - red) < 127)
			modelColor = 0;
		else
		{
			if (red >= green && red >= blue)
				modelColor = 1;
			else if (green >= red && green >= blue)
				modelColor = 2;
			else
				modelColor = 3;
		}

		modelid = 19295 + modelColor;
	#else
		modelid = 19295;
	#endif
	}
	else if (markerType == MARKER_TYPE_ARROW)
		modelid = 1559;
	else if (markerType == MARKER_TYPE_CYLINDER)
		modelid = 1317;
	else if (markerType == MARKER_TYPE_CHECKPOINT)
	{
	#if SAMP_VERSION == SAMP_03d
		modelid = 1317;
	#else
		modelid = 19945;
	#endif
	}
	else if (markerType == MARKER_TYPE_RING)
	{
		modelid = 1316;
		ry = 90.0;
	}

	if (modelid != 0)
	{
		new objectid = INVALID_OBJECT_ID;

		if (alpha > 0)
		{
			objectid = CreateMapObject(modelid, x, y, z, 0.0, ry, 0.0);
		#if SAMP_VERSION > SAMP_03d
			new color = GetRGBToInt(red, green, blue) + ((alpha & 0x0FF) << 32); // 0xAARRGGBB

			for (new i = 0; i < 13; ++i)
				SetDynamicObjectMaterial(objectid, i, -1, "none", "none", color);
		#endif
		}

		if (maxMarkerId < sizeof(markers) - 1)
		{
			new i;

			for (i = 0; i < sizeof(markers); ++i)
			{
				if (markers[i][mCreated] == 0)
				{
					markers[i][mCreated] = 1;
					markers[i][mObject] = objectid;
					markers[i][mPosX] = x;
					markers[i][mPosY] = y;
					markers[i][mPosZ] = z;
					markers[i][mSize] = size;

					if (i > maxMarkerId)
						maxMarkerId = i;

					break;
				}
			}

			if (i < sizeof(markers))
				return i + 1;
		}
	}
	
	return 0;
}

stock DestroyMarker(markerid)
{
	if (--markerid < 0 || markerid > sizeof(markers) || markers[markerid][mCreated] == 0)
		return 0;
	
	if (IsValidDynamicObject(markers[markerid][mObject]))
		DestroyDynamicObject(markers[markerid][mObject]);
	
	markers[markerid][mCreated] = 0;
	markers[markerid][mObject] = 0;
	markers[markerid][mPosX] = 0.0;
	markers[markerid][mPosY] = 0.0;
	markers[markerid][mPosZ] = 0.0;
	markers[markerid][mSize] = 0.0;

	for (new i = 0; i < MAX_PLAYERS; ++i)
		markers[markerid][mPlayerHit][i] = 0;

	if (maxMarkerId == markerid)
	{
		new i;

		for (i = maxMarkerId - 1; i >= 0; --i)
		{
			if (markers[i][mCreated] != 0)
			{
				maxMarkerId = i;

				break;
			}
		}

		if (i < 0)
			maxMarkerId = -1;
	}

	return 1;
}

stock CreatePlayerMapObjectForAll(modelid, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz)
{
	for (new objectid = 0; objectid < MAX_PLAYER_MAP_OBJECTS; ++objectid)
	{
		if (playerMapObject[objectid][pmoModelId] != 0)
			continue;

		playerMapObject[objectid][pmoModelId] = modelid;
		playerMapObject[objectid][pmoPosX] = x;
		playerMapObject[objectid][pmoPosY] = y;
		playerMapObject[objectid][pmoPosZ] = z;
		playerMapObject[objectid][pmoRotX] = rx;
		playerMapObject[objectid][pmoRotY] = ry;
		playerMapObject[objectid][pmoRotZ] = rz;

		contloop (new playerid : playerList)
			playerMapObject[objectid][pmoObjectId][playerid] = CreatePlayerObject(playerid, modelid, x, y, z, rx, ry, rz);

		return objectid;
	}

	return INVALID_OBJECT_ID;
}

stock DestroyPlayerMapObjectForAll(objectid)
{
	if (objectid < 0 || objectid >= MAX_PLAYER_MAP_OBJECTS)
		return 0;

	if (playerMapObject[objectid][pmoModelId] == 0)
		return 0;

	playerMapObject[objectid][pmoModelId] = 0;
	playerMapObject[objectid][pmoPosX] = 0.0;
	playerMapObject[objectid][pmoPosY] = 0.0;
	playerMapObject[objectid][pmoPosZ] = 0.0;
	playerMapObject[objectid][pmoRotX] = 0.0;
	playerMapObject[objectid][pmoRotY] = 0.0;
	playerMapObject[objectid][pmoRotZ] = 0.0;
	/*playerMapObject[objectid][pmoMoveX] = 0.0;
	playerMapObject[objectid][pmoMoveY] = 0.0;
	playerMapObject[objectid][pmoMoveZ] = 0.0;*/

	for (new playerid = 0; playerid < MAX_PLAYERS; ++playerid)
	{
		if (playerMapObject[objectid][pmoObjectId][playerid] == INVALID_OBJECT_ID)
			continue;

		if (IsPlayerConnected(playerid))
			DestroyPlayerObject(playerid, playerMapObject[objectid][pmoObjectId][playerid]);

		playerMapObject[objectid][pmoObjectId][playerid] = INVALID_OBJECT_ID;
	}

	return 1;
}

stock MovePlayerMapObject(playerid, objectid, Float: targetX, Float: targetY, Float: targetZ, Float: speed, Float: targetRotX = 0.0, Float: targetRotY = 0.0, Float: targetRotZ = 0.0)
{
	if (objectid < 0 || objectid >= MAX_PLAYER_MAP_OBJECTS)
		return 0;

	if (playerMapObject[objectid][pmoModelId] == 0)
		return 0;
	if (playerMapObject[objectid][pmoObjectId][playerid] == INVALID_OBJECT_ID)
		return 0;
	
	MovePlayerObject(playerid, playerMapObject[objectid][pmoObjectId][playerid], targetX, targetY, targetZ, speed,
		playerMapObject[objectid][pmoRotX] + targetRotX, playerMapObject[objectid][pmoRotY] + targetRotY, playerMapObject[objectid][pmoRotZ] + targetRotZ);
	
	return 1;
}

stock ShowAllPlayerMapObjectForPlayer(playerid)
{
	if (!IsPlayerConnected(playerid))
		return 0;
	
	for (new objectid = 0; objectid < MAX_PLAYER_MAP_OBJECTS; ++objectid)
	{
		if (playerMapObject[objectid][pmoModelId] == 0)
			continue;
		if (playerMapObject[objectid][pmoObjectId] != INVALID_OBJECT_ID)
			continue;
		
		playerMapObject[objectid][pmoObjectId][playerid] = CreatePlayerObject(playerid, playerMapObject[objectid][pmoModelId],
			playerMapObject[objectid][pmoPosX], playerMapObject[objectid][pmoPosY], playerMapObject[objectid][pmoPosZ],
			playerMapObject[objectid][pmoRotX], playerMapObject[objectid][pmoRotY], playerMapObject[objectid][pmoRotZ]);
	}

	return 1;
}

stock GetHexToIntValue(const hex[])
{
	if (IsNull(hex))
		return 0;
	
	new demical = 1;
	new value;

	for (new i = strlen(hex) - 1; i >= 0; --i)
	{
		if (hex[i] >= '0' && hex[i] <= '9')
			value += demical * (hex[i] - '0');
		else if (hex[i] >= 'A' && hex[i] <= 'Z')
			value += demical * ((hex[i] - 'A') + 10);
		else if (hex[i] >= 'a' && hex[i] <= 'z')
			value += demical * ((hex[i] - 'a') + 10);
		
		demical *= 16;
	}

	return value;
}

stock GetIntToRGB(color, &red, &green, &blue)
{
	red = (color >> 16) & 0x0FF;
	green = (color >> 8) & 0x0FF;
	blue = color & 0x0FF;
}

stock GetRGBToInt(red, green, blue)
{
	return (((red & 0x0FF) << 16) | ((green & 0x0FF) << 8) | (blue & 0x0FF));
}

stock abs(value)
{
	if (value >= 0)
		return value;

	return (-value);
}

#endif
