
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
Library     Collections
Library     ../../lib/myTestLib.py
Library     CSVLib
Library     String
*** Keywords ***
order pos goods cash
    [Arguments]     ${posLoginParam}
    #首先，需要确认环境是否正确
#    change pos env
    pos login   ${posLoginParam}
    return from keyword  111



pos login
    ${posLoginParam}    pos login data
    ${posSess}    create session  posSess     http://192.168.10.249:8080
    ${res}    post request    posSess     /PosService/PosLogin         data=${posLoginParam}

    ${res_list}     deal http response  ${res}      data
    set test variable  ${poslogin_json}   ${res_list}[0]
    set test variable  ${poslogin_data_json}   ${res_list}[1]
    should be equal as numbers  ${res.json()['code']}  -3



change pos env
    #这里必须写绝对路径，否则会报错
    Connect To Database    dbConfigFile=E:\\tjl\\RF\\config\\retailDB.cfg
    #变成类生产环境
    ${csvDic}=   read csv test data  interface/OilSite2.0/demo.csv    change pos env    isSql=True
    Execute Sql String    ${csvDic}[sql_str]
    Disconnect from Database

pos login data
    ${ts}=   Get Current Date   exclude_millis=True
    #    终于成功了，其实在这里浪费的时间有点多了，在做了c#的单元测试之后，应该一步一步的进行校验，理清一个思路出来，其实也是一种测试思想
    #注意，下面参数中的password是123456加密之后的，这一块暂时不实现加密了，等以后需要了再进行
    ${toSignDic}=   read csv test data  interface/OilSite2.0/demo.csv    pos login
    set to dictionary   ${toSignDic}    ts=${ts}
    ${sign}=        mySign  ${toSignDic}
    ${data}=     set to dictionary   ${toSignDic}    sign=${sign}
    return from keyword  ${data}



#*** Test Cases ***
#demo
#    ${ts}=   Get Current Date   exclude_millis=True
#    #    终于成功了，其实在这里浪费的时间有点多了，在做了c#的单元测试之后，应该一步一步的进行校验，理清一个思路出来，其实也是一种测试思想
#    #注意，下面参数中的password是123456加密之后的，这一块暂时不实现加密了，等以后需要了再进行
#    ${toSignDic}=   read csv test data  interface/OilSite2.0/demo.csv    pos login
#    set to dictionary   ${toSignDic}    ts=${ts}
#    ${sign}=        mySign  ${toSignDic}
#    ${data}=     set to dictionary   ${toSignDic}    sign=${sign}
#    ${res}=    order pos goods cash    ${data}


