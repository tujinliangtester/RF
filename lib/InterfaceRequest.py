import requests
import os.path
import subprocess
import sys
import json


class InterfaceRequest(object):

    def __init__(self):
        self._config_reader_path = os.path.join(os.path.dirname(__file__),
                                                '..', 'config', 'ConfigReader.py')

    def interface_get(self, url='', headers='', params=''):
        self._config_reader_command('get', 'interface', 'baseurl')
        url = self._subout + url
        headers = self._str2json(headers)
        params = self._str2json(params)
        response = requests.get(url, headers=headers, params=params)
        print(response.status_code)
        return response.text

    def interface_post(self, url='', params=''):
        self._config_reader_command('get', 'interface', 'baseurl')
        url = self._subout + url
        params = self._str2json(params)
        response = requests.post(url, data=params)
        print(response.text)
        return response.text

    def _config_reader_command(self, command, *args):
        command = [sys.executable, self._config_reader_path, command] + list(args)
        process = subprocess.Popen(command, universal_newlines=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        self._subout = process.communicate()[0].strip()

    def _str2json(self, s):
        if (len(s) == 0):
            return ''
        return json.loads(s)


if __name__ == '__main__':
    IR = InterfaceRequest()
    params = 'product_type_id=10&longitude=104.06791687011719&latitude=30.548940658569336&distance=30&orderbyfield=pointdistance&site_id=&site_name=&pageNumber=1&pagesize=10&r=0.2110462989440982'
    # IR.interface_get(url='/v2transapi', headers=None, params=params)
    IR.interface_post(url='/OilSite/NearbyDiscountList', headers='', params=params)
