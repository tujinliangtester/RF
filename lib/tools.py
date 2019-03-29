import time, hashlib
import os, sys
import re
import subprocess


class tools(object):
    def __init__(self):
        self._sheet_name = 'Sheet3'
        self._sheet_max_line = 20
        self._split_char = '%tjl%'

    def gene_mobile(self):
        s = time.strftime("%Y%m%d%H%M", time.localtime())
        s = s[-8:]
        s = '199' + s
        print(s)
        return s

    def reg_draw(self, mom, key):
        reg = '"' + key + '"' + ':\d+'
        try:
            son = re.search(reg, mom).group()
        except:
            print('erro')
            return 'erro'
        res = re.search('\d+', son).group()
        print(res)
        return res

    def reg_draw_str(self, mom, key):
        reg = '"' + key + '"' + ':"\d+'
        try:
            son = re.search(reg, mom).group()
        except:
            print('erro')
            return 'erro'
        res = re.search('\d+', son).group()
        print(res)
        return res

    # 原始的发放，即完全按照正则表达式来提取
    def raw_reg_draw(self, mom, re_str):
        son = re.search(re_str, mom).group()
        res = re.search('\d+', son).group()
        print(res)
        return res

    # 特殊方法，只有当返回值中，有两个相同的key时才会用这个方法去找第二个key对应的val
    def reg_second_draw(self, mom, key):
        reg = '"' + key + '"' + ':\d+'
        pattern = re.compile(reg)
        try:
            son = pattern.findall(mom)
        except:
            print('erro')
            return 'erro'
        try:
            son = son[1]
            res = re.search('\d+', son).group()
        except:
            print('erro')
            return 'erro'
        print(res)
        return res

    def _sub_command(self, sub_command_path, command, *args):
        command = [sys.executable, sub_command_path, command] + list(args)
        print('command:', command)
        process = subprocess.Popen(command, universal_newlines=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        self._subout = process.communicate()[0].strip()

    def read_config(self, key):
        fpath = os.path.join(os.path.dirname(__file__), '../config/config')
        tmp_list = []
        tmp_dic = {}
        with open(fpath) as f:
            tmp_list = f.readlines()
        for line in tmp_list:
            tmp_key_value = line.split('\n')[0]
            tmp_key_value = tmp_key_value.split(self._split_char)
            tmp_key, tmp_value = tmp_key_value[0], tmp_key_value[1]
            tmp_dic[tmp_key] = tmp_value
        return tmp_dic[key]

    def alter(self, key, val):
        '''
        修改文件中的key对应的值
        :param key:需要修改的键
        :param val:需要修改为的值
        :return:成功返回0
        '''
        file = os.path.join(os.path.dirname(__file__), '../config/config')
        file_data = ""
        with open(file=file, mode="r") as f:
            for line in f:
                if key in line:
                    line = key + self._split_char + val
                file_data += line
        with open(file, "w") as f:
            f.write(file_data)
        return 0

    def math_reduce(self, a, b):
        return float(a) - float(b)

    def math_int2float(self, int_a):
        return float(int_a)

    def gzh_pay_password_encode(self, passwordToken, str2, str3):
        # password2 = md5(md5(md5(this.passwordToken) + md5(str2)) + md5(this.order_id + ''))

        passwordToken=str(passwordToken)
        str2=str(str2)
        str3=str(str3)

        passwordToken=passwordToken.encode(encoding='utf-8')
        str2=str2.encode(encoding='utf-8')
        str3=str3.encode(encoding='utf-8')

        m=hashlib.md5()
        m.update(passwordToken)
        passwordTokenMD=m.hexdigest()


        m=hashlib.md5()
        m.update(str2)
        str2MD=m.hexdigest()

        res1=passwordTokenMD+str2MD
        res1=res1.encode(encoding='utf-8')

        m = hashlib.md5()
        m.update(res1)
        res1MD=m.hexdigest()

        m=hashlib.md5()
        m.update(str3)
        str3MD=m.hexdigest()

        res2=res1MD+str3MD
        res2=res2.encode(encoding='utf-8')

        m = hashlib.md5()
        m.update(res2)
        res=m.hexdigest()
        print(res)
        return res


if __name__ == '__main__':
    t = tools()
    mom = '{"code":1,"msg":"","data":{"site_name":"ttp-测试油站2","order_id":126,"order_no":"S1903201419273716871","products_type":0,"mobile":"19903201133","code":"7349"},"ext":null,"subcode":""}'
    # reg='"code":\d+'
    # t.reg_draw(mom=mom,key='id')
    # res=t.read_data("mobile")
    print(11)
    print(t.read_config('PcHeader'))
    reg = '"code":"\d+'
    print(t.raw_reg_draw(mom=mom, re_str=reg))

    t.alter('mobile', '19903281400')
    t.gzh_pay_password_encode(passwordToken='6d59db6e763d1d40', str2='123456', str3='45')
    t.gzh_pay_password_encode(passwordToken='6d59db6e763d1d40', str2='123456', str3='10001405')
