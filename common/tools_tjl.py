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
    s = 'md%5Bname%5D=tjl03011102&md%5Buse_limit_desc%5D=tjl03011102&md%5Bcoupon_type%5D=1&md%5Bdiscount_type%5D=1&md%5Bface_value%5D=1&md%5Bparter_id%5D=0&md%5Bsend_method%5D=1&md%5Bsend_condition%5D=0&md%5Bsend_start_time%5D=2019-03-01&md%5Bsend_end_time%5D=2019-03-02&md%5Bcount_max_send%5D=1&md%5Bapp_client_type%5D=0&md%5Boil_product_category%5D=&md%5Boil_product_type_id%5D=&md%5Buse_model%5D=1&md%5Bvalid_time_type%5D=1&md%5Bvalid_start_time%5D=2019-03-01&md%5Bvalid_end_time%5D=2019-03-01&md%5Blimit_min_spend_money%5D=0.00&md%5Blimit_province_id%5D=&md%5Blimit_city_id%5D=&md%5Buse_condition%5D=0&md%5Bis_trade%5D=1&md%5Btag_is_enable%5D=0'
    s2 = str(str2dic(s))
    s2 = url_md_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)
