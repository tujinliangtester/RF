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
    s = 'ts=2019-10-17%2010%3A00%3A14&sign=66136ffdf0dd65d94dbde65a60254713&goods_amt=0.0&oil_trade_list=%5B%7B%22trade_log_id%22%3A0%2C%22oil_id%22%3A13%2C%22price%22%3A6.78%2C%22litre%22%3A14.75%2C%22ori_amt%22%3A100%7D%5D&mobile=18708126627&uuid=47fa69c6158155abfb7aba00623b0a04&postoken=2a80223d-e1ed-43e4-9b53-f22101fb061a&coupon_code='
    s2 = str(str2dic(s))
    s2 = url_parse_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)

    sql = "SELECT TOP 1 code  from pit_member_sms ORDER BY id desc ;"
    sqlstr = sqlstr2str(sql)
    print(sqlstr)
