
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
*** Keywords ***
order pos goods cash
    [Arguments]     ${posLoginParam}
    #首先，需要确认环境是否正确
    change pos env
    pos login   ${posLoginParam}







pos login
    [Arguments]  ${posLoginParam}
    ${sess}    create session  pos     http://192.168.10.249:8080
    LOG  ${sess}
    post request    pos     /PosService/PosLogin    data=${posLoginParam}






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
    #登录有问题 todo
    ${res}=    order pos goods cash    {"password":"e10adc3949ba59abbe56e057f20f883e","user_account":"0307","ts":"${ts}","sign":"f3baeeb40b8ec277a52a71a8a23bd481","shift_id":"1","pos_id":"17","uuid":"47fa69c6158155abfb7aba00623b0a04"}
    LOG  ${res}