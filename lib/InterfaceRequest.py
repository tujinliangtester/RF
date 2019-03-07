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
    # params = '{"product_type_id": "10", "longitude": "104.06791687011719", "latitude": "30.548940658569336", "distance": "30", "orderbyfield": "pointdistance", "site_id": "", "site_name": "", "pageNumber": "1", "pagesize": "10", "r": "0.2110462989440982"}'
    # IR.interface_get(url='/v2transapi', headers=None, params=params)
    # IR.interface_post(url='/OilSite/NearbyDiscountList', params=params)
    IR.sql_interface_post('http://localhost:8000/polls/sql_fun/18703070908')