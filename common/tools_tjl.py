from urllib import parse


def parse_decode(s):
    res = parse.unquote(s)
    print(res)
    return res


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


# 将截包中的%5B等url编码替换还原
def url_parse_decoder(s):
    url_encode_path = '../other/url_encode.txt'
    with open(url_encode_path) as f:
        lines = f.readlines()
    for line in lines:
        line_no_return = line.split('\n')[0]
        key_val = line_no_return.split('\t')
        key, val = key_val[0], key_val[1]
        if (key == 'space'): key = ' '
        s = s.replace(val, key)
    return s


def sqlstr2str(sql):
    # s='UPDATE pit_oil_site_activity SET activity_status=1 WHERE id in (496,497,498,499,500,501);'
    s = sql
    s=s.replace('\t','')
    s = s.replace(' ', '${SPACE}')
    #去掉中括号，去掉 dbo.
    s = s.replace('[dbo].', '')
    s = s.replace('[', '')
    s = s.replace(']', '')
    str = '{"SQL":"' + s + '"}'

    return str


if __name__ == '__main__':
    # 注意，如果参数中有中文，则需要在替换后，手动改成中文
    s = 'money=&finance_id=1&account_address=%E6%B6%82%E6%B0%8F%E4%B8%AD%E5%A4%AE%E9%93%B6%E8%A1%8C&account_name=%E5%B0%B1%E6%98%AF%E6%9C%89%E9%92%B1&account_id=8888&actionPath=%2Fapi%2FActivity%2FOrderForBank'
    s2 = str(str2dic(s))
    s2 = url_parse_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)

    sql = "SELECT TOP 1 code  from pit_member_sms ORDER BY id desc ;"
    sqlstr = sqlstr2str(sql)
    print(sqlstr)
