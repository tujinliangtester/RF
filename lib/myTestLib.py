import hashlib


def mySign(toSignDic):
    # todo 加密与c#程序中结果不一致，后续跟进
    toSignStr = ''
    for itemKey in toSignDic:
        toSignStr += itemKey + '=' + toSignDic[itemKey] + '&'
    appKey='sjyt_jg_2017kmkf'
    toSignStr+="key=" + appKey

    print('toSignStr', toSignStr)
    m = hashlib.md5()
    m.update(toSignStr.encode(encoding='UTF-8'))
    sign_md5 = m.hexdigest()
    print('sign_md5', sign_md5)

    sign = ''
    for i in sign_md5:
        tmp_i = hex(ord(i))
        if (len(tmp_i) < 4):
            tmp_i = tmp_i[:2] + '0' + tmp_i[2]
        else:
            tmp_i = tmp_i[:4]
        sign += tmp_i
    return sign_md5.lower()


if __name__ == '__main__':
    tmpdic = {'a': '2'}
    res = mySign(tmpdic)
    print(res)
