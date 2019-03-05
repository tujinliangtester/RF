# from db import sql_server
# from config import ConfigReader
import sys,subprocess,os

class SqlAPI(object):
    def __init__(self):
        self._sub_command_path = os.path.join(os.path.dirname(__file__),
                                                     'sql_server.py')

    def sql_exec(self, s):
        self._sub_command('ExecQuery',s)
        return self._subout

    def _sub_command(self, command, *args):
        command = [sys.executable, self._sub_command_path, command] + list(args)
        print('command:', command)
        process = subprocess.Popen(command, universal_newlines=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        self._subout = process.communicate()[0].strip()

    def test(self):
        print(111)
        return 111

if __name__=='__main__':
    sa=SqlAPI()
    print(sa.sql_exec('se'))