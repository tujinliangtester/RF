# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re


class UntitledTestCase(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "https://www.katalon.com/"
        self.verificationErrors = []
        self.accept_next_alert = True

    def test_untitled_test_case(self):
        driver = self.driver
        driver.get("http://www.ytny.demo/sjytadmin/index.php/index/index")
        driver.find_element_by_id("10000553").click()
        driver.find_element_by_link_text(u"会员营销").click()
        driver.find_element_by_xpath("//li[7]/ul/li[3]/a/span").click()
        driver.find_element_by_xpath("//li[7]/ul/li[3]/ul/li/a/span").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=1 | ]]
        driver.find_element_by_xpath("//b").click()
        driver.find_element_by_xpath("//li[3]").click()
        driver.find_element_by_xpath(u"//input[@value='查询']").click()
        driver.find_element_by_link_text(u"编辑").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=0 | ]]
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[16]/div/div/a/span").click()
        driver.find_element_by_xpath("//form[@id='form']/div/ul/li[16]/div/div/div/ul/li[3]").click()
        driver.find_element_by_xpath("//button[@type='submit']").click()
        driver.find_element_by_xpath("//div[@id='layui-layer2']/span/a").click()
        driver.find_element_by_name("username").click()
        driver.find_element_by_name("username").clear()
        driver.find_element_by_name("username").send_keys("admin")
        driver.find_element_by_xpath("//input[@type='password']").clear()
        driver.find_element_by_xpath("//input[@type='password']").send_keys("123456")
        driver.find_element_by_name("checkcode").clear()
        driver.find_element_by_name("checkcode").send_keys("2596")
        driver.find_element_by_xpath("//button[@type='submit']").click()
        driver.find_element_by_id("10000553").click()
        driver.find_element_by_xpath("//li[7]/a/span").click()
        driver.find_element_by_link_text(u"优惠券设置").click()
        driver.find_element_by_xpath("//li[7]/ul/li[3]/ul/li/a/span").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=1 | ]]
        driver.find_element_by_link_text(u"添加优惠券").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectFrame | index=0 | ]]
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

    def is_element_present(self, how, what):
        try:
            self.driver.find_element(by=how, value=what)
        except NoSuchElementException as e:
            return False
        return True

    def is_alert_present(self):
        try:
            self.driver.switch_to_alert()
        except NoAlertPresentException as e:
            return False
        return True

    def close_alert_and_get_its_text(self):
        try:
            alert = self.driver.switch_to_alert()
            alert_text = alert.text
            if self.accept_next_alert:
                alert.accept()
            else:
                alert.dismiss()
            return alert_text
        finally:
            self.accept_next_alert = True

    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)


if __name__ == "__main__":
    unittest.main()
