from selenium import webdriver
import  time, re

#此文件的目的是提供一个浏览器，给UI自动化脚本进行公用
executable_path='E:\\tjl\\script\\geckodriver.exe'

class start_selenium(object):
    print('请注意手动登录后台')
    driver = webdriver.Firefox(executable_path=executable_path)
    driver.maximize_window()
    driver.implicitly_wait(30)
    accept_next_alert = True
    driver.get("http://www.ytny.demo/sjytadmin/index.php/index/index")

    # python3.7 倒计时
    for i in range(10, -1, -1):
        print('\r', '距离登录结束还有 %s 秒！' % str(i).zfill(2), end='')
        time.sleep(1)
    print('\r', '{:^20}'.format('登录结束！'))


