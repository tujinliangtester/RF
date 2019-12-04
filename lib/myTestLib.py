import hashlib
import csv

def mySign(toSignDic):
    toSignStr = ''
    toSignList=sorted(toSignDic.items(),key=lambda toSignDic:toSignDic[0],reverse=False)
    for item in toSignList:
        toSignStr += item[0] + '=' + item[1] + '&'
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

if __name__ == '__main__':
    csv_file='E:\\tjl\\RF\\interface\\OilSite2.0\\demo.csv'
    key_word_name='change pos env'
    res=read_csv_test_data(csv_file, key_word_name, isSql=True)
    print(res)

