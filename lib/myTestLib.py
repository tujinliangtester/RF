import hashlib
import csv
import simplejson

def mySign(toSignDic):
    toSignStr = ''
    toSignList=sorted(toSignDic.items(),key=lambda toSignDic:toSignDic[0],reverse=False)
    for item in toSignList:
        toSignStr += item[0] + '=' + item[1] + '&'
    #注意，这里的appKey是从数据库中取来写死的
    appKey='sjyt_jg_2017kmkf'
    toSignStr+="key=" + appKey

    print('toSignStr', toSignStr)
    m = hashlib.md5()
    m.update(toSignStr.encode(encoding='UTF-8'))
    sign_md5 = m.hexdigest()

    return sign_md5.lower()

def read_csv_test_data(csv_file, key_word_name, isSql=False, delimiter='\n'):
    '''
    读取csv文件，查找给定的关键字名称对应的参数
    :param csv_file:csv文件名称
    :param key_word_name:关键字名称
    :param isSql:如果去的测试数据是sql语句的，需要单独进行处理，
                当然，如果其他类型的参数中，带有 , 符号的，也会出现，具体遇到了再处理
    :param delimiter:对csv文件的分隔符，默认是换行符，即一行一行的分割
    :return:csv文件中，该关键字对应的参数和值的字典
    '''
    print(isSql)
    file = open(csv_file, 'r')
    csvfile = csv.reader(file, delimiter=delimiter)
    output = {}
    for row in csvfile:
        if(isSql==False):
            #row的分布为：关键字名称	参数名称	参数值
            inner_row=row[0].split(',')
            if(inner_row[0]==key_word_name):
                output[inner_row[1]]=inner_row[2]
        else:
            inner_row = row[0].split(',')
            if (inner_row[0] == key_word_name):
                tmp_lenth=len(key_word_name)+1+len(inner_row[1])+1
                #注意，csv在处理字符串时，如果字符串本身带有 , ，则会自动加上双引号
                if(row[0][tmp_lenth:][0]=='"'):
                    output[inner_row[1]] = row[0][tmp_lenth:][1:-1]
                else:
                    output[inner_row[1]] = row[0][tmp_lenth:]
    file.close()
    return output

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


#todo
def gzh_pay_password(password,password_token,real_coin_amt):
    '''
    支付密码 = md5(md5(md5(password_token)+md5(password))+md5((int)real_coin_amt))
    :param pwd: 明文密码
    :return: 加密后的密码
    '''


if __name__ == '__main__':
    data='wuYhYatkiuo='

    key='sjyt_des'
    d=des_decrypt(data,key)
    print(d)
    res_encrypt=des_encryption(data=d,KEY=key)
    print(res_encrypt)