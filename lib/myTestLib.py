import hashlib


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


if __name__ == '__main__':
    tmpdic = {'password': 'e10adc3949ba59abbe56e057f20f883e', 'user_account': '0307', 'ts': '2019-12-03 17:22:44',  'shift_id': '1', 'pos_id': '17', 'uuid': '47fa69c6158155abfb7aba00623b0a04'}
    res = mySign(tmpdic)
    print(res)
#     真实登录
#     password=e10adc3949ba59abbe56e057f20f883e&user_account=0307&ts=2019-12-03%2017%3A22%3A44&sign=143d88bfceb77fc75832ab1d8e234f6f&shift_id=1&pos_id=17&uuid=47fa69c6158155abfb7aba00623b0a04
# password=e10adc3949ba59abbe56e057f20f883e&user_account=0307&ts=2019-12-03 17:22:44&sign=143d88bfceb77fc75832ab1d8e234f6f&shift_id=1&pos_id=17&uuid=47fa69c6158155abfb7aba00623b0a04