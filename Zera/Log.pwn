#if !defined __LOG__
#define __LOG__

function ToggleServerLogSave(toggle)
{
	if (toggle > 0) logSave = 1;
	else logSave = 0;
}

function ServerLog(E_SERVER_LOG_TYPE: logType, const content[], {Float, _}: ...)
{
	new string[MAX_LOG_LENGTH];

	format(string, sizeof(string), "[%s] ", logTags[logType]);

	strcat(string, content, MAX_LOG_LENGTH);

	if (logType == LOG_TYPE_MYSQL)
	{
		if (numargs() > 2) format(string, sizeof(string), "%s (�����ڵ�: %d)", string, getarg(2));
	}

	print(string);

	return (logSave == 1) ? WriteLogToFile(logType, string) : 1;
}

function WriteLogToFile(E_SERVER_LOG_TYPE: logType, const string[])
{
	if (logSave != 1) return 0;

	new filePath[64];

	format(filePath, sizeof(filePath), ""LOG_PATH"/%s.log", logTags[logType]);

	new File: file = fopen(filePath, io_append);

	if (!file)
	{
		print("[server] �α׸� �����ϴ� ������ ���� ������ �ʽ��ϴ�.");
		print("[server] scriptfiles ������ "LOG_PATH" ��θ� ������ �ּ���.");

		return 0;
	}

	fwrite(file, string);
	fwrite(file, "\r\n");

	fclose(file);

	return 1;
}

#endif
