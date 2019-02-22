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
# -*- coding: utf-8 -*-
import sys
from selenium.webdriver.support.ui import Select
import  time
from ui.pc import start_selenium

driver = start_selenium.start_selenium().driver
class coupon_setting_class(object):

    def test(self):
        print(1)
        return 1

    def add_coupon(self):
        driver.find_element_by_id("10000553").click()
        driver.find_element_by_xpath("//li[7]/a/span").click()
        driver.find_element_by_link_text(u"优惠券设置").click()
        driver.find_element_by_xpath("//li[7]/ul/li[3]/ul/li/a/span").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=1 | ]]
        # driver.find_element_by_link_text(u"添加优惠券").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=0 | ]]
        driver.find_element_by_xpath('/html/body/div[1]/div/div[1]/div[1]/a').click()
        driver.find_element_by_name("md[name]").click()
        driver.find_element_by_name("md[name]").clear()
        driver.find_element_by_name("md[name]").send_keys(u"优惠券auto0220")
        driver.find_element_by_name("md[use_limit_desc]").click()
        driver.find_element_by_name("md[use_limit_desc]").clear()
        driver.find_element_by_name("md[use_limit_desc]").send_keys(u"自动生成优惠券")
        driver.find_element_by_xpath("//div[@id='discount_container']/li/div/div/a/span").click()
        driver.find_element_by_xpath("//div[@id='discount_container']/li/div/div/div/ul/li[2]").click()
        driver.find_element_by_xpath("//div[@id='discount_container']/li[2]/div/div/a/span").click()
        driver.find_element_by_xpath("//div[@id='discount_container']/li[2]/div/div/div/ul/li[2]").click()
        driver.find_element_by_name("md[face_value]").click()
        driver.find_element_by_name("md[face_value]").clear()
        driver.find_element_by_name("md[face_value]").send_keys("100")
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[8]/div/span/div/a/span").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[8]/div/span/div/div/ul/li[2]").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[8]/div/span[2]/div/a/span").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[8]/div/span[2]/div/div/ul/li[2]").click()
        driver.find_element_by_id("dp1550648777154").click()
        driver.find_element_by_link_text("20").click()
        driver.find_element_by_id("end_time").click()
        driver.find_element_by_link_text("28").click()
        driver.find_element_by_name("md[count_max_send]").click()
        driver.find_element_by_name("md[count_max_send]").clear()
        driver.find_element_by_name("md[count_max_send]").send_keys("100")
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[12]/div/div/a/span").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[12]/div/div/div/ul/li[2]").click()
        driver.find_element_by_id("productCategory").click()
        Select(driver.find_element_by_id("productCategory")).select_by_visible_text(u"汽油")
        driver.find_element_by_xpath("(//option[@value='1'])[7]").click()
        driver.find_element_by_id("productTypeId").click()
        Select(driver.find_element_by_id("productTypeId")).select_by_visible_text(u"92#汽油")
        driver.find_element_by_xpath("//option[@value='10']").click()
        driver.find_element_by_id("md_use_model__2").click()
        driver.find_element_by_id("md_use_model__1").click()
        driver.find_element_by_xpath("//span[@id='md_valid_time_type']/span/label").click()
        driver.find_element_by_id("dp1550648777155").click()
        driver.find_element_by_link_text("20").click()
        driver.find_element_by_id("md_valid_end_time").click()
        driver.find_element_by_link_text("28").click()
        driver.find_element_by_xpath("//div[@id='teshuxianzhi_chosen']/a/span").click()
        driver.find_element_by_xpath("//div[@id='teshuxianzhi_chosen']/div/ul/li[2]").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[17]/div/div/a/span").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[17]/div/div/div/ul/li[2]").click()
        driver.find_element_by_id("md_tag_is_enable__0").click()
        driver.find_element_by_xpath("//button[@type='submit']").click()
        print('code:0')
        return 'code:0'


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
    add_coupon()