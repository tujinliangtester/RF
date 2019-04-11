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
    s = s.replace(' ', '${SPACE}')
    str = '{"SQL":"' + s + '"}'
    return str


if __name__ == '__main__':
    # 注意，如果参数中有中文，则需要在替换后，手动改成中文
    s = 'name=tjl1441&start_time=2019-04-11%2000%3A00%3A00&end_time=2019-04-13%2023%3A59%3A59&discount_type=1&max_count=0&status=1&activity_type=1&activity_item=%5B%7B%22amt%22%3A%22%22%2C%22zs_value%22%3A%22%22%2C%22max_count%22%3A0%7D%5D&coupon_item=%5B%7B%22amt%22%3A%221%22%2C%22coupon_id%22%3A651%2C%22num%22%3A%221%22%7D%2C%7B%22amt%22%3A%222%22%2C%22coupon_id%22%3A652%2C%22num%22%3A%222%22%7D%5D'
    s2 = str(str2dic(s))
    s2 = url_parse_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)

    sql = 'DELETE pit_market_coupon_to_user WHERE user_id=;'
    sqlstr = sqlstr2str(sql)
    print(sqlstr)
