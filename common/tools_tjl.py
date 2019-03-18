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
    s = 'ts=2019-03-13T01%3A58%3A21.555Z&t=timing&sid=jt6k1lfv1f1&px=360x720&rf=http%3A%2F%2F192.168.10.236%3A8025%2FCreditcardPingan%2FPackage&v=1&ua=Chrome&evt=pageview&wx=1&sit=openh5&t1=%E5%B9%B3%E5%AE%89%E9%93%B6%E8%A1%8C%E6%B4%BB%E5%8A%A8%E8%90%BD%E5%9C%B0%E9%A1%B5&t2=%E4%B8%AD%E5%9B%BD%E5%B9%B3%E5%AE%89-%E9%A2%86%E5%8F%96%E4%BC%98%E6%83%A0%E5%88%B8&t3=%E9%A1%B5%E9%9D%A2%E5%8A%A0%E8%BD%BD&mrt=pakdyh_activty'
    s2 = str(str2dic(s))
    s2 = url_md_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)
