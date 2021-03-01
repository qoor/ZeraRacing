#if !defined __MYSQL__
#define __MYSQL__

InitModule("MySQL")
{
	mysql_log(ERROR);
	print("[mysql] DB 서버 접속 시도...");
	
	if (CreateMySQLConnection() == 0) return;
}

function CreateMySQLConnection()
{
	new MySQLOpt: DBOption = mysql_init_options();

	mysql_set_option(DBOption, AUTO_RECONNECT, true);
	mysql_set_option(DBOption, POOL_SIZE, 0);

	#if defined MYSQL_PORT
		mysql_set_option(DBOption, SERVER_PORT, MYSQL_PORT);
	#endif

	#if defined MYSQL_USE_SSL
		mysql_set_option(DBOption, SSL_ENABLE, true);
	#endif

	MySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, DBOption);

	new error;

	if (MySQL == MYSQL_INVALID_HANDLE || (error = mysql_errno(MySQL)) != 0)
	{
		ServerLog(LOG_TYPE_MYSQL, "DB 서버 접속을 실패했습니다.", (error != 0) ? error : -1);

		return 0;
	}

	mysql_set_charset("euckr", MySQL);
	print("[mysql] DB 서버 접속 성공.");
	
	AddEventHandler(D_GameModeExit, "MySQL_GameModeExit");

	return 1;
}

public MySQL_GameModeExit()
{
	print("[mysql] 서버의 정보를 저장하는 중입니다..");
	mysql_close(MySQL);

	return 0;
}
