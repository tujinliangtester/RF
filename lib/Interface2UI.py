import requests
import os.path
import subprocess
import sys
import json


class Interface2UI(object):
    def coupon_setting(self, command, *args):
        self.__ui_command_path = os.path.join(os.path.dirname(__file__),
                                              '..', 'ui', 'pc', 'operation', 'member_marketing', 'coupon',
                                              'coupon_setting.py')
        print(self.__ui_command_path)
        self._ui_command(command, *args)
        return self._subout

    def _ui_command(self, command, *args):
        command = [sys.executable, self.__ui_command_path, command] + list(args)
        print(command)
        process = subprocess.Popen(command, universal_newlines=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        self._subout = process.communicate()[0].strip()


if __name__ == '__main__':
    in2ui = Interface2UI()
    res = in2ui.coupon_setting('add_coupon')
    print(res)
