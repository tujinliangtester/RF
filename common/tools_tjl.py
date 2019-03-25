# 形如product_type_id=10&longitude=104.06791687011719
# 这样的字符串转换为字典
def str2dic(s):
    dic = {}
    # s='product_type_id=10&longitude=104.06791687011719'
    li = s.split('&')
    for item in li:
        li_tmp = item.split('=')
        if (len(li_tmp) > 0):
            dic[li_tmp[0]] = li_tmp[1]
    return dic


# 将截包中的%5B等替换还原
def url_md_decoder(s):
    # s='md%5Bname%5D=tjl03011102&md%5Bu'
    s = s.replace('%5B', '[')
    s = s.replace('%5D', ']')
    return s



if __name__ == '__main__':
    # 注意，如果参数中有中文，则需要在替换后，手动改成中文
    s = 'ts=2019-03-21%2014%3A40%3A37&order_id=240&postoken=79724e7b-bfba-45bf-8a97-a0f555ae8c44&sign=01fc97f80bbd9c3b5b8870fc90f406ba&code=6375&uuid=c76b57733faeccd9d514e2ab1787f46d&writeoff_user_id=47'
    s2 = str(str2dic(s))
    s2 = url_md_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)
