'''
由于优惠券被领取使用后，不能再禁用，这可能导致后面的不好处理，暂时的处理方式是：
执行本脚本，设置时会先对优惠券进行备份，然后直接在数据库中将所有优惠券置为禁用，那要不要最后再改为启用呢？什么时候恢复备份？


'''


