import requests
import os.path
import subprocess
import sys
import json
import re

class InterfaceRequest(object):

    def __init__(self):
        self._config_reader_path = os.path.join(os.path.dirname(__file__),
                                                '..', 'config', 'ConfigReader.py')

    def interface_get(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.get(url, data=params, headers=header)
        print(response.text)
        return response.text

    def interface_post(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        print(response.text)
        return response.text

    def pc_interface_get(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'pc_baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.get(url, data=params, headers=header)
        print(response.text)
        return response.text

    def pc_interface_post(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'pc_baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        print(response.text)
        return response.text

    def parter_interface_post(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'parter_baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        print(response.text)
        return response.text

    #这里的sql目前只支持查看手机验证码，且调用的是Django的本机服务
    def sql_interface_post(self, url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        s=response.text
        res=re.search('\d+',s).group()
        print(res)
        return res

    #这里的sql调用的是Django的本机服务，调用时需要将完整的sql语句填写到url中
    def sql_interface_post_raw(self, url='', params='', header=''):
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        print('response',response)
        s=response.text
        res=s
        print(res)
        return res

    def POS_interface_post(self,url='', params='', header=''):
        print('_config_reader_path', self._config_reader_path)

        self._config_reader_command('get', 'interface', 'POS_baseurl')
        url = self._subout + url
        params = self._str2json(params)
        header = self._str2json(header)
        response = requests.post(url, data=params, headers=header)
        print(response.text)
        return response.text

    def _config_reader_command(self, command, *args):
        command = [sys.executable, self._config_reader_path, command] + list(args)
        print('command:', command)
        process = subprocess.Popen(command, universal_newlines=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        self._subout = process.communicate()[0].strip()

    def _str2json(self, s):
        if (len(s) == 0):
            return ''
        return json.loads(s)


if __name__ == '__main__':
    IR = InterfaceRequest()
    # IR.sql_interface_post_raw(url='http://localhost:8000/polls/raw_sql_fun',params='{"SQL":"SELECT * from pit_member_score_balance WHERE user_id in (SELECT id FROM pit_member_user WHERE mobile =\'19903260905\') ORDER BY id desc;"}')

    for i in range(1000):
        mobile=18809231000+i
        params_str='{"site_id": "", "mobile": "'+str(mobile)+'", "score": "1", "level": "0", "note": "1"}'
        IR.pc_interface_post(url='/DrpMemberOffline/CreateUser',
                             params=params_str,
                             header='{"Cookie": "ASP.NET_SessionId=1cjtiwyhwxnhus3r0mdnuyu2; bizweb_UserMember=userID=hqbk2gPbDbU="}')

