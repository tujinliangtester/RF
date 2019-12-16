
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

md5 gzh pay password
    [Arguments]     ${password}    ${password_token}  ${real_coin_amt}  ${order_id}     ${type}
    log many    ${password}    ${password_token}  ${real_coin_amt}  ${order_id}     ${type}
    ${gzh_pay_password_tmp}=    gzh pay password    password=${password}    password_token=${password_token}     real_coin_amt=${real_coin_amt}     order_id=${order_id}     type=${type}
    set test variable  ${gzh_pay_password}  ${gzh_pay_password_tmp}


TicketList
    ${requestData}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_TicketList
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net

    ${tmp_header}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_TicketList_header
    set to dictionary    ${tmp_header}      Content-Type=application/x-www-form-urlencoded
    set test variable  ${headerGZH}    ${tmp_header}

    ${res}    post request    gzhSess     /OilOrder/TicketList         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data
    should be equal as numbers      ${res_list}[0][code]    1

    set test variable  ${site_id}      ${requestData}[site_id]
    set test variable  ${gun_id}   ${requestData}[gun_id]
    set test variable  ${platform_activity_id}     ${res_list}[1][platform_activity]
    set test variable  ${coupon_id}    ${res_list}[1][ReadyPayMoney][coupon_id]
    set test variable  ${coin_amt}     ${res_list}[1][ReadyPayMoney][coin_amt]
    set test variable  ${score_amt}    ${res_list}[1][ReadyPayMoney][score_amt]
    #    set test variable  vouchers    ${res_list}[1][ReadyPayMoney][score_amt]
    set test variable  ${org_amt}  ${res_list}[1][ReadyPayMoney][org_amt]
    set test variable  ${nogas_amt}    ${res_list}[1][ReadyPayMoney][nogas_amt]
    set test variable  ${coupon_nogas_id}  ${res_list}[1][ReadyPayMoney][coupon_nogas_id]
    set test variable  ${coupon_all_id }   ${res_list}[1][ReadyPayMoney][coupon_all_id]
    set test variable  ${app_client_type}  ${res_list}[1][ReadyPayMoney][app_client_type]
    set test variable  ${direct_id}  ${res_list}[1][ReadyPayMoney][direct_id]
    set test variable  ${activity_id}  ${res_list}[1][ReadyPayMoney][activity_id]
    set test variable  ${real_score_amt}  ${res_list}[1][ReadyPayMoney][real_score_amt]
    set test variable  ${real_coin_amt}  ${res_list}[1][ReadyPayMoney][real_coin_amt]
    set test variable  ${real_pay_amt}  ${res_list}[1][ReadyPayMoney][real_pay_amt]
    set test variable  ${password_token}    ${res_list}[0][ext][password_token]


ReadyPayMoney
    ${requestData}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_ReadyPayMoney
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   site_id=${site_id}  gun_id=${gun_id}    platform_activity_id=${platform_activity_id}
    set to dictionary  ${requestData}   coupon_id=${coupon_id}  coin_amt=${coin_amt}    score_amt=${score_amt}
    set to dictionary  ${requestData}   org_amt=${org_amt}  nogas_amt=${nogas_amt}    coupon_nogas_id=${coupon_nogas_id}
    set to dictionary  ${requestData}   coupon_all_id=${coupon_all_id}  app_client_type=${app_client_type}
    ${res}    post request    gzhSess     /OilOrder/ReadyPayMoney         data=${requestData}  headers=${headerGZH}


order
    ${requestData}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_order
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   site_id=${site_id}  gun_id=${gun_id}    direct_id=${direct_id}
    set to dictionary  ${requestData}   activity_id=${activity_id}  platform_activity_id=${platform_activity_id}    coupon_id=${coupon_id}
    #注意，这里的real_coin_amt=${real_pay_amt} 和real_pay_amt=0 是会员卡支付的时候这样处理的，第三方支付不能这样处理
    set to dictionary  ${requestData}   org_amt=${org_amt}  real_score_amt=${real_score_amt}    real_coin_amt=${real_pay_amt}
    set to dictionary  ${requestData}   real_pay_amt=0
    set to dictionary  ${requestData}   nogas_amt=${nogas_amt}  coupon_nogas_id=${coupon_nogas_id}    coupon_all_id=${coupon_all_id}


    ${userInfo}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    md5 gzh pay password    password=${userInfo}[password]    password_token=${password_token}     real_coin_amt=${real_pay_amt}   order_id=0   type=1

    set to dictionary  ${requestData}   pay_password=${gzh_pay_password}
    ${res}    post request    gzhSess     /OilOrder/order         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data
    set test variable    ${order_id}  ${res_list}[1][id]
    set test variable    ${pay_method_id}  ${res_list}[1][pay_method_id]

PayOil
    ${requestData}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_PayOil
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   order_id=${order_id}    real_coin_amt=${real_pay_amt}

    ${userInfo}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    md5 gzh pay password    password=${userInfo}[password]    password_token=${password_token}     real_coin_amt=${real_pay_amt}    order_id=${order_id}    type=0
    set to dictionary  ${requestData}   pay_password=${gzh_pay_password}

    ${res}    post request    gzhSess     /OilOrder/PayOil         data=${requestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}
    should be equal as numbers  ${res_list}[0][code]   1

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


