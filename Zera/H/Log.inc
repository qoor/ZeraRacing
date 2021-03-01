#if !defined __LOG_H__
#define __LOG_H__

#define MAX_LOG_LENGTH 256

#define LOG_PATH "Zera/logs"

enum E_SERVER_LOG_TYPE
{
	LOG_TYPE_ERROR,
	LOG_TYPE_MYSQL,
	LOG_TYPE_INFO
};

new const logTags[E_SERVER_LOG_TYPE][] = {
	"error",
	"mysql",
	"info"
};

new logSave = -1;

forward ServerLog(E_SERVER_LOG_TYPE: logType, const content[], {Float, _}: ...);
forward WriteLogToFile(E_SERVER_LOG_TYPE: logType, const string[]);

#endif
