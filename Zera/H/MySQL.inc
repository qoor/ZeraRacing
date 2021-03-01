#if !defined __MYSQL_H__
#define __MYSQL_H__

#define MYSQL_HOST "localhost"
#define MYSQL_USER "zerarace"
#define MYSQL_PASSWORD "ZeR@Rac3!"
#define MYSQL_DATABASE "zera"
//#define MYSQL_PORT 1202
//#define MYSQL_USE_SSL

#define MySQLInt(%0,%1,"%2",%3) format(%0, %1, "%s,"#%2"=%d", %0, %3)
#define MySQLFloat(%0,%1,"%2",%3) format(%0, %1, "%s,"#%2"=%.4f", %0, %3)
#define MySQLString(%0,%1,"%2",%3) mysql_format(MySQL, %0, %1, "%s,"#%2"='%e'", %0, %3)

new MySQL: MySQL;

forward CreateMySQLConnection();

forward MySQL_GameModeExit();

#endif
