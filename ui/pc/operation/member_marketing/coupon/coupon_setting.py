'''
由于优惠券被领取使用后，不能再禁用，这可能导致后面的不好处理，暂时的处理方式是：
调用执行本脚本之前，setup需要在数据库中将所有优惠券置为禁用，然后在teardown中将所有优惠券职位启用

'''

'''
需要进行测试相关的字段有：

优惠券基本信息：
优惠券类型
折扣方式
接入商

发放相关：
发放方式    发放条件
发放数量
会员标签
是否启用



'''
import sys



def add_coupon():
    print('1')
    return 1


if __name__ == '__main__':
    actions = {'add_coupon': add_coupon,  'help': help}
    try:
        action = sys.argv[1]
    except IndexError:
        action = 'help'
    args = sys.argv[2:]
    try:
        actions[action](*args)
    except (KeyError, TypeError):
        help()

