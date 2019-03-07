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
    s = 'md%5Busername%5D=19903071333&md%5Bname%5D=%E6%8E%A8%E5%B9%BF%E5%91%9837&md%5Bparter_id%5D=2&md%5Broles%5D=2&md%5Bmobile%5D=19903071333&md%5Bemail%5D=&md%5Bwx_account%5D=&md%5Bpay_account%5D=&md%5Bsettlement_type%5D=1&md%5Breg_user_amount%5D=1.00'
    s2 = str(str2dic(s))
    s2 = url_md_decoder(s2)
    s2 = s2.replace('\'', '\"')
    print(s2)
