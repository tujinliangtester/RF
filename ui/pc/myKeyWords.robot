*** Settings ***
Library  SeleniumLibrary
Library  browsermanagement



*** Keywords ***
打开浏览器访问百度首页
    set browser implicit wait  30
    open browser  http://www.baidu.com

#关闭浏览器
#    close all browsers