import configparser

cf_obj = configparser.ConfigParser()
cf_obj.read('E:\\tjl\测试工具\\auto\\RF\\config\\setting.ini')


def get(option, item):
    msg = cf_obj.get(option, item)
    return msg


def sec():
    li = cf_obj.sections()
    return li


if __name__ == '__main__':
    print(get('interface', 'baseurl'))

'''
cf=configparser.ConfigParser()
cf.read('setting.ini')

secs=cf.sections()
print(secs,type(secs))

opts=cf.options('db')
print('opts',opts)
kvs=cf.items('db')
print('kvs:',kvs)

db_host=cf.get('db','db_host')
print(db_host)
db_pwd=cf.get('db','db_pwd')
print(db_pwd,type(db_pwd))
'''
