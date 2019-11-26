import configparser
import sys,os

cf_obj = configparser.ConfigParser()

# 这个地方使用相对路径时，会报找不到section的错误，具体什么原因也不知道，网上只找到使用绝对路径的
# fpath=os.path.abspath('.')+'\\setting.ini'
fpath='E:\\tjl\\RF\\config\\setting.ini'
cf_obj.read(fpath,encoding='UTF-8')


def get(option, item):
    msg = cf_obj.get(option, item)
    print(msg)
    return msg


def sec():
    li = cf_obj.sections()
    print(li)
    return li

if __name__ == '__main__':
    actions = {'get': get, 'help': help}
    try:
        action = sys.argv[1]
    except IndexError:
        action = 'help'
    args = sys.argv[2:]
    try:
        actions[action](*args)
    except (KeyError, TypeError):
        help()


    cf=configparser.ConfigParser()
    cf.read('setting.ini')
    '''
    cf=cf_obj

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

    base_url=cf.get('interface','baseurl')
    print('base_url',base_url)
    '''