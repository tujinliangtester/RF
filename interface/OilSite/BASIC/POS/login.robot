

*** Settings ***
Library  ../../../lib/InterfaceRequest.py


*** Variables ***
${pos_login_url}    /PosService/PosLogin

*** Test Cases ***
#login
#    #这里的登录，直接用的是0307这个账号，pos机是本机电脑的模拟器pos id
#    ${res}=     POS_interface_post  ${pos_login_url}    {"password": "e10adc3949ba59abbe56e057f20f883e", "user_account": "0307", "ts": "2019-09-1backspace2015:50:58", "sign": "e5291f8c33a9c4cd3ae54bf3a0f5ab86", "shift_id": "1", "pos_id": "17", "uuid": "47fa69c6158155abfb7aba00623b0a04"}
#    #失败，签名方法不知道
