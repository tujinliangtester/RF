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
    s = s.replace('%2C', ',')
    return s

def sqlstr2str(sql):
    # s='UPDATE pit_oil_site_activity SET activity_status=1 WHERE id in (496,497,498,499,500,501);'
    s=sql
    s=s.replace(' ','${SPACE}')
    str='{"SQL":"'+s+'"}'
    return str


if __name__ == '__main__':
    # 注意，如果参数中有中文，则需要在替换后，手动改成中文
    s = 'order_id=10001364&pay_method_id=1&pay_password=e26c26ab9ce74f8b0980bade0cd42d62&real_coin_amt=0&r=0.778164654777834'
    s2 = str(str2dic(s))
    s2 = url_md_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)

    sql='UPDATE pit_oil_site_activity SET activity_status=1 WHERE id in (496,497,498,499,500,501);'
    sqlstr=sqlstr2str(sql)
    print(sqlstr)