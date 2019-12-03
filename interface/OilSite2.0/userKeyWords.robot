
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
Library     Collections
Library     ../../lib/myTestLib.py
*** Keywords ***
order pos goods cash
    [Arguments]     ${posLoginParam}
    #首先，需要确认环境是否正确
    change pos env
    pos login   ${posLoginParam}
    return from keyword  111



pos login
    [Arguments]  ${posLoginParam}
    ${sess}    create session  pos     http://192.168.10.249:8080
    LOG  ${sess},${posLoginParam}
    ${res}    post request    pos     /PosService/PosLogin         data=${posLoginParam}
    Log Many  ${res.json()}
    ${res}  evaluate    str(${res.json()})
    should not contain  ${res}  'code': -2



change pos env
    #这里必须写绝对路径，否则会报错
    Connect To Database    dbConfigFile=E:\\tjl\\RF\\config\\retailDB.cfg
    #变成类生产环境
    Execute Sql String    UPDATE base_config set config_value='http://b.gas.314pay.net' WHERE config_key in ('yyxt_drp_site_spare_url','yyxt_drp_site_url');
    Disconnect from Database

*** Test Cases ***
demo
    ${ts}=   Get Current Date   exclude_millis=True
    LOG  ${ts}
    #登录有问题 todo 签名还有错误，需要根据具体的逻辑，通过创建自己的测试库进行处理
    #    今天整了好久，还是不对。。。  c#中的ToMd5（）和签名字符串的拼接都经过验证已经正确了，目前找到的原因，可能是在发起请求时，对参数的url编码不正确，可能需要进行指定
    ${toSign}=      Create Dictionary   password=e10adc3949ba59abbe56e057f20f883e   user_account=0307   ts=2019-12-03 16:29:33  sign=362fdd8c40dec02f4249cf261adf4c73   shift_id=1  pos_id=17   uuid=47fa69c6158155abfb7aba00623b0a04
    log many  ${toSign}
    ${sign}=        mySign  ${toSign}
    ${data}=     Create Dictionary   password=e10adc3949ba59abbe56e057f20f883e   user_account=0307   ts=${ts}   sign=${sign}   shift_id=1  pos_id=17   uuid=47fa69c6158155abfb7aba00623b0a04
    ${res}=    order pos goods cash    ${data}
