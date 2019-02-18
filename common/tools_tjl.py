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


if __name__ == '__main__':
    s = 'product_type_id=10&longitude=104.06791687011719&latitude=30.548940658569336&distance=30&orderbyfield=pointdistance&site_id=&site_name=&pageNumber=1&pagesize=10&r=0.2110462989440982'
    s2 = str(str2dic(s))
    s2 = s2.replace('\'', '\"')
    print(s2)
