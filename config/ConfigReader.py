import configparser

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