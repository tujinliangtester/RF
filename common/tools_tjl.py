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
    str = '{"SQL":"' + s + '"}'
    return str


if __name__ == '__main__':
    # 注意，如果参数中有中文，则需要在替换后，手动改成中文
    s = 'id=21&limits%5B0%5D%5Blimit_id%5D=161&limits%5B0%5D%5Blimit_type%5D=1&limits%5B0%5D%5Btext%5D=%E8%BD%A6%E7%89%8C%E5%8F%B7&limits%5B0%5D%5Blimit_value%5D=&limits%5B0%5D%5Bis_limited%5D=0&limits%5B1%5D%5Blimit_id%5D=162&limits%5B1%5D%5Blimit_type%5D=2&limits%5B1%5D%5Btext%5D=%E5%8A%A0%E6%B2%B9%E6%B2%B9%E7%AB%99&limits%5B1%5D%5Blimit_value%5D=35&limits%5B1%5D%5Bis_limited%5D=1&limits%5B2%5D%5Blimit_id%5D=163&limits%5B2%5D%5Blimit_type%5D=3&limits%5B2%5D%5Btext%5D=%E7%87%83%E6%B2%B9%E6%B2%B9%E5%93%81&limits%5B2%5D%5Blimit_value%5D=20&limits%5B2%5D%5Bis_limited%5D=1&limits%5B3%5D%5Blimit_id%5D=164&limits%5B3%5D%5Blimit_type%5D=4&limits%5B3%5D%5Btext%5D=%E5%8D%95%E7%AC%94%E6%94%AF%E4%BB%98%E9%87%91%E9%A2%9D&limits%5B3%5D%5Blimit_value%5D=&limits%5B3%5D%5Bis_limited%5D=0&limits%5B4%5D%5Blimit_id%5D=165&limits%5B4%5D%5Blimit_type%5D=5&limits%5B4%5D%5Btext%5D=%E6%97%A5%E7%B4%AF%E8%AE%A1%E6%94%AF%E4%BB%98%E6%AC%A1%E6%95%B0&limits%5B4%5D%5Blimit_value%5D=&limits%5B4%5D%5Bis_limited%5D=0&limits%5B5%5D%5Blimit_id%5D=166&limits%5B5%5D%5Blimit_type%5D=6&limits%5B5%5D%5Btext%5D=%E6%97%A5%E7%B4%AF%E8%AE%A1%E6%94%AF%E4%BB%98%E9%87%91%E9%A2%9D&limits%5B5%5D%5Blimit_value%5D=&limits%5B5%5D%5Bis_limited%5D=0&limits%5B6%5D%5Blimit_id%5D=167&limits%5B6%5D%5Blimit_type%5D=7&limits%5B6%5D%5Btext%5D=%E6%9C%88%E7%B4%AF%E8%AE%A1%E6%94%AF%E4%BB%98%E6%AC%A1%E6%95%B0&limits%5B6%5D%5Blimit_value%5D=&limits%5B6%5D%5Bis_limited%5D=0&limits%5B7%5D%5Blimit_id%5D=168&limits%5B7%5D%5Blimit_type%5D=8&limits%5B7%5D%5Btext%5D=%E6%9C%88%E7%B4%AF%E8%AE%A1%E6%94%AF%E4%BB%98%E9%87%91%E9%A2%9D&limits%5B7%5D%5Blimit_value%5D=&limits%5B7%5D%5Bis_limited%5D=0'
    s2 = str(str2dic(s))
    s2 = url_parse_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)

    sql = ' SELECT top 1 card_no from  pit_fleetcard_subcard WHERE merchant_id=13 order  BY card_no desc;'
    sqlstr = sqlstr2str(sql)
    print(sqlstr)
