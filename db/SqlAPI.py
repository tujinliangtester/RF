from db import sql_server
from config import ConfigReader


class SqlAPI(object):
    def __init__(self):
        self.db_host = ConfigReader.get('db', 'db_host')
        self.db_pwd = ConfigReader.get('db', 'db_pwd')
        self.db_user = ConfigReader.get('db', 'db_user')
        self.db_name = ConfigReader.get('db', 'db_name')

    def sql_exec(self, s):
        ms = sql_server.MSSQL(host=self.db_host, user=self.db_user, pwd=self.db_pwd, db=self.db_name)
        reslist = ms.ExecQuery(s)
        return reslist

    def test(self):
        print(111)
        return 111
