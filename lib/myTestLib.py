import hashlib
import csv
import simplejson

def mySign(toSignDic):
    toSignStr = ''
    toSignList=sorted(toSignDic.items(),key=lambda toSignDic:toSignDic[0],reverse=False)
    for item in toSignList:
        toSignStr += str(item[0]) + '=' + str(item[1]) + '&'
    #注意，这里的appKey是从数据库中取来写死的
    appKey='sjyt_jg_2017kmkf'
    toSignStr+="key=" + appKey

    print('toSignStr', toSignStr)
    m = hashlib.md5()
    m.update(toSignStr.encode(encoding='UTF-8'))
    sign_md5 = m.hexdigest()

    return sign_md5.lower()

def read_csv_test_data(csv_file, key_word_name, isSql=False):
    '''
    读取csv文件，查找给定的关键字名称对应的参数
    :param csv_file:csv文件名称
    :param key_word_name:关键字名称
    :param isSql:如果去的测试数据是sql语句的，需要单独进行处理，
                当然，如果其他类型的参数中，带有 , 符号的，也会出现，具体遇到了再处理
    :param delimiter:不设置值，默认安装excel的方式来进行读取
    :return:csv文件中，该关键字对应的参数和值的字典
    '''
    print(isSql)
    file = open(csv_file, 'r')
    csvfile = csv.reader(file)
    output = {}
    for row in csvfile:
        if(isSql==False):
            #row的分布为：关键字名称	参数名称	参数值
            if(row[0]==key_word_name):
                output[row[1]]=row[2]
        else:
            inner_row = row[0].split(',')
            if (row[0] == key_word_name):
                tmp_lenth=len(key_word_name)+1+len(row[1])+1
                #注意，csv在处理字符串时，如果字符串本身带有 , ，则会自动加上双引号
                if(row[0][tmp_lenth:][0]=='"'):
                    output[inner_row[1]] = row[0][tmp_lenth:][1:-1]
                else:
                    output[inner_row[1]] = row[0][tmp_lenth:]
    file.close()
    return output

def write_to_csv(fileName,rows):
    '''
    写入到csv文件
    :param fileName:csv文件名称
    :param rows: 需要写入的数据，注意，这里是一个二维数组
    :return: 成功
    '''
    with open(fileName,'a+',newline='') as f:
        csv_writer = csv.writer(f)
        csv_writer.writerows(rows)

def get_response_header(http_response):
    '''
    获取相应头，并返回为字典
    :param http_response: 响应
    :return: 头部字典
    '''
    http_res_header=http_response.headers
    return http_res_header


def deal_http_response(http_response,*kwargs):
    '''
    由于标准库、扩展库及第三方库的处理都不理想，尝试自己写个函数来处理
    :param http_response:http的响应
    :param response_key:响应中，body里要查找的键（因为一次json的变化可能对子json不起作用）
    :return:响应中的body，json格式
    '''
    http_res_text=http_response.text
    http_res_json=simplejson.loads(http_res_text)
    if(len(kwargs)==0):
        tmp_list=[http_res_json]
        return tmp_list
    response_key=kwargs[0]
    http_res_data=http_res_json[response_key]
    print('http_res_data:',http_res_data)
    if(isinstance(http_res_data,dict)):
        return http_res_json,http_res_data
    http_res_data_json=simplejson.loads(http_res_data)
    return http_res_json,http_res_data_json

#todo des加密、解密有问题，登录直接给header算了
def des_decrypt(data ,KEY ):
    from binascii import b2a_hex, a2b_hex
    import base64
    from pyDes import des
    n = len(data) % 8
    if (n != 0):
        data = data + ' ' * n
    k=des(KEY)
    d=k.decrypt(data)
    return b2a_hex(d)

def des_encryption(data ,KEY ):
    from binascii import b2a_hex, a2b_hex
    import base64
    from pyDes import des
    n = len(data) % 8
    if (n != 0):
        data = data + ' ' * n
    k = des(KEY)
    d = k.encrypt(data)
    return b2a_hex(d)


def gzh_pay_password(password,password_token,real_coin_amt,order_id,type):
    '''
    支付密码加密 md5(md5(md5(password_token)+md5(password))+md5((int)real_coin_amt))
    :param password: 明文密码
    :param password_token: 服务器接口tickelist中的password_token
    :param real_coin_amt: 会员卡实付金额
    :param order_id: 订单id，order接口中返回
    :param type: 为非0时，代表是提交订单，用实付金额加密；0代表支付订单，用订单id加密
    :return: 支付密码加密之后的密文
    '''
    m1=hashlib.md5()
    m2=hashlib.md5()
    m3=hashlib.md5()
    m4=hashlib.md5()
    m6=hashlib.md5()

    m1.update(password_token.encode('utf-8'))
    tmp1=m1.hexdigest()

    m2.update(password.encode('utf-8'))
    tmp2=m2.hexdigest()
    if(str(type)!='0'):
        print('为0时，代表是提交订单，用实付金额加密')
        m3.update(str(int(real_coin_amt)).encode('utf-8'))
        tmp3=m3.hexdigest()
    else:
        m3.update(str(order_id).encode('utf-8'))
        tmp3 = m3.hexdigest()
    tmp4=tmp1+tmp2
    m4.update(tmp4.encode('utf-8'))
    tmp5=m4.hexdigest()


    tmp6=tmp5+tmp3
    m6.update(tmp6.encode('utf-8'))
    tmp7=m6.hexdigest()
    return tmp7


def yypc_login_password(pwd,mobile,ts):
    '''
    #md5(md5(md5(pwd)+ md5(mobile))+ md5(ts + mobile))
    :param pwd:明文密码
    :param mobile:登录手机号
    :param ts:时间戳
    :return:登录加密后的密码
    '''
    m1=hashlib.md5()
    m1.update(str(pwd).encode('utf-8'))
    md5_pwd=m1.hexdigest()

    m2=hashlib.md5()
    m2.update(str(mobile).encode('utf-8'))
    md5_mobile=m2.hexdigest()

    m3=hashlib.md5()
    m3.update((str(ts)+str(mobile)).encode('utf-8'))
    md5_mobile_ts=m3.hexdigest()

    m4 = hashlib.md5()
    m4.update((md5_pwd+md5_mobile).encode('utf-8'))
    md5_1 = m4.hexdigest()
    print('md5_1:',md5_1)
    m5 = hashlib.md5()
    m5.update((md5_1 + md5_mobile_ts).encode('utf-8'))
    md5_res = m5.hexdigest()

    return md5_res

def my_md5(pwd):
    '''
    对字符串md5加密
    :param pwd:明文字符串
    :return: md5加密后的字符串
    '''
    m1 = hashlib.md5()
    m1.update(str(pwd).encode('utf-8'))
    md5_pwd = m1.hexdigest()
    return md5_pwd

def get_dict_from_list(my_list,my_key,my_val):
    '''
    从多个字典组成的列表中，查找给定键和值匹配的字典，并返回
    :param my_list: 查找的列表
    :param my_key: 目标键
    :param my_val: 目标值
    :return: 找到的字典
    '''
    for l in list(my_list):
        if(str(l[my_key])==str(my_val)):
            return l

def cal_litre(ori_amt,price):
    '''
    专门为计算升数实现的函数
    :param ori_amt: 加油金额
    :param price: 油品价格
    :return: 加油升数，业务上的逻辑是保留两位小数并直接舍掉第三位
    '''
    ori_amt=float(ori_amt)
    price=float(price)
    ori_amt=100*ori_amt
    res=round(ori_amt/price,0)
    return res/100

def dic_has_key(my_dic,my_key):
    '''
    判定字典是否有给定的key，ps，官方的字典函数中只有should 不好使用
    :param my_dic:
    :param my_key:
    :return: 有key，则返回true，否则返回false
    '''
    return my_key in my_dic

if __name__ == '__main__':
    tmp_list=[{"oil_gun_id":50,"oil_machine_id":1,"oil_id":13,"oil_tank_id":3,"gun_number":2,"auth_method":1,"gun_name":"2号油枪","gun_code":"2","status":1,"third_code":None,"machine_name":"1号加油机","machine_number":"JYJ001","oil_code":"92","oil_name":"92#","oil_short_name":"92#汽油","oil_type_code":"92","oil_type_name":"92#号汽油"}]
    l=get_dict_from_list(tmp_list,'gun_number',2)
    print(l)
