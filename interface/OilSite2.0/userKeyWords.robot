
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
Library     Collections
Library     ../../lib/myTestLib.py
Library     CSVLib
Library     String

*** Variables ***
${gzhBaseUrl}   http://testbiz.314pay.net
${yypcBaseUrl}  http://b.gas.314pay.net
${yypcLoginCSV}  E:/tjl/RF/interface/OilSite2.0/DrpAccount/login.csv
${loginCSVpath}     interface/OilSite2.0/DrpAccount/login.csv
${posBaseUrl}   http://192.168.10.249:8080
#${posBaseUrl}   http://192.168.10.61:8080
${myUuid}     47fa69c6158155abfb7aba00623b0a04
${BosLoginCSV}   interface/OilSite2.0/BosService/BosLogin.csv
${BosBaseUrl}   http://192.168.10.249:8080


*** Keywords ***
order pos goods cash
    [Arguments]     ${posLoginParam}
    #首先，需要确认环境是否正确
#    change pos env
    pos login   ${posLoginParam}
    return from keyword  111



pos login
    ${posLoginParam}    pos login data
    ${posSess}    create session  posSess    ${posBaseUrl}
    ${res}    post request    posSess     /PosService/PosLogin         data=${posLoginParam}

    ${res_list}     deal http response  ${res}      data
    set test variable  ${poslogin_json}   ${res_list}[0]
    set test variable  ${poslogin_data_json}   ${res_list}[1]
    set test variable  ${postoken}  ${res_list}[1][postoken]
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
    ${password}     my md5  ${toSignDic}[password]
    set to dictionary   ${toSignDic}    password=${password}
    set test variable   ${uuid}       ${myUuid}
    set to dictionary   ${toSignDic}    ts=${ts}
    set to dictionary   ${toSignDic}    uuid=${uuid}
    ${sign}=        mySign  ${toSignDic}
    ${data}=     set to dictionary   ${toSignDic}    sign=${sign}
    return from keyword  ${data}

md5 gzh pay password
    [Arguments]     ${password}    ${password_token}  ${real_coin_amt}  ${order_id}     ${type}
    log many    ${password}    ${password_token}  ${real_coin_amt}  ${order_id}     ${type}
    ${gzh_pay_password_tmp}=    gzh pay password    password=${password}    password_token=${password_token}     real_coin_amt=${real_coin_amt}     order_id=${order_id}     type=${type}
    set test variable  ${gzh_pay_password}  ${gzh_pay_password_tmp}

md5 yypc login
    [Arguments]     ${pwd}  ${mobile}  ${ts}
    log many  ${pwd}  ${mobile}  ${ts}
    ${md5_yypc_login_tmp}=    yypc login password    pwd=${pwd}    mobile=${mobile}     ts=${ts}
    set test variable  ${md5_yypc_login_pwd}  ${md5_yypc_login_tmp}

TicketList
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    read test user info

    ${gzhSess}    create session  gzhSess     ${gzhBaseUrl}
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
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   site_id=${site_id}  gun_id=${gun_id}    platform_activity_id=${platform_activity_id}
    set to dictionary  ${requestData}   coupon_id=${coupon_id}  coin_amt=${coin_amt}
    set to dictionary  ${requestData}   org_amt=${org_amt}  nogas_amt=${nogas_amt}    coupon_nogas_id=${coupon_nogas_id}
    set to dictionary  ${requestData}   coupon_all_id=${coupon_all_id}  app_client_type=${app_client_type}
    ${res}    post request    gzhSess     /OilOrder/ReadyPayMoney         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data
    set test variable  ${coupon_id}    ${res_list}[1][coupon_id]
    set test variable  ${coin_amt}     ${res_list}[1][coin_amt]
    set test variable  ${score_amt}    ${res_list}[1][score_amt]
    #    set test variable  vouchers    ${res_list}[1][ReadyPayMoney][score_amt]
    set test variable  ${org_amt}  ${res_list}[1][org_amt]
    set test variable  ${nogas_amt}    ${res_list}[1][nogas_amt]
    set test variable  ${coupon_nogas_id}  ${res_list}[1][coupon_nogas_id]
    set test variable  ${coupon_all_id }   ${res_list}[1][coupon_all_id]
    set test variable  ${app_client_type}  ${res_list}[1][app_client_type]
    set test variable  ${direct_id}  ${res_list}[1][direct_id]
    set test variable  ${activity_id}  ${res_list}[1][activity_id]
    set test variable  ${real_score_amt}  ${res_list}[1][real_score_amt]
    set test variable  ${real_coin_amt}  ${res_list}[1][real_coin_amt]
    set test variable  ${real_pay_amt}  ${res_list}[1][real_pay_amt]


order
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
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

    MyInfo
    set test variable    ${coin_before}  float(${MyInfo}[0][ext][finance][coin_balance])
    set test variable    ${score_before}  float(${MyInfo}[0][ext][finance][score_balance])

    ${res}    post request    gzhSess     /OilOrder/order         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data
    set test variable    ${order_id}  ${res_list}[1][id]
    set test variable    ${pay_method_id}  ${res_list}[1][pay_method_id]

    MyInfo
    set test variable    ${score_after}  float(${MyInfo}[0][ext][finance][score_balance])
    ${score_change_real}     evaluate   ${score_before}-${score_after}
    should be equal as numbers  ${score_change_real}    ${real_score_amt}

PayOil
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   order_id=${order_id}    real_coin_amt=${real_pay_amt}

    ${userInfo}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    md5 gzh pay password    password=${userInfo}[password]    password_token=${password_token}     real_coin_amt=${real_pay_amt}    order_id=${order_id}    type=0
    set to dictionary  ${requestData}   pay_password=${gzh_pay_password}

    ${res}    post request    gzhSess     /OilOrder/PayOil         data=${requestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}
    should be equal as numbers  ${res_list}[0][code]   1

    MyInfo
    set test variable    ${coin_after}  float(${MyInfo}[0][ext][finance][coin_balance])

    ${coin_change_real}     evaluate   ${coin_before}-${coin_after}
    should be equal as numbers  ${coin_change_real}     ${real_pay_amt}

MyInfo
    sleep  1
    ${MyInfoRequestData}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    ${res}    post request    gzhSess     /My/Info         data=${MyInfoRequestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}
    set test variable  ${MyInfo}    ${res_list}

SiteSubFleetList
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    read test user info
    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
    set test variable   ${site_id}  ${requestData}[site_id]

    ${gzhSess}    create session  gzhSess     ${gzhBaseUrl}
    ${res}    post request    gzhSess     /OilSite/SiteSubFleetList      data=${requestData}        headers=${headerGZH}

    ${res_list}     deal http response  ${res}

    should be equal as numbers  ${res_list}[0][code]    1

    #这里直接写死的取返回结果中的第一个子卡
    set test variable  ${sub_card_id}    ${res_list}[0][data][0][id]



FleetReadyPayMoney
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    read test user info
    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
    set test variable   ${gun_id}   ${requestData}[gun_id]
    set test variable   ${org_amt}   ${requestData}[org_amt]

    set to dictionary  ${requestData}   site_id=${site_id}      sub_card_id=${sub_card_id}


    ${gzhSess}    create session  gzhSess     ${gzhBaseUrl}
    ${res}    post request    gzhSess     /OilOrder/FleetReadyPayMoney         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data

    should be equal as numbers  ${res_list}[0][code]    1
    set test variable   ${coupon_id}    ${res_list}[1][coupon_id]
    set test variable   ${coupon_amt}    ${res_list}[1][coupon_amt]
    set test variable   ${pay_amt}    ${res_list}[1][pay_amt]
    set test variable   ${password_token}    ${res_list}[0][ext][password_token]

FleetOrder
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    read test user info

    ${requestData}=     read csv test data  ${csv_path}    ${test_name_kw_name}
    set to dictionary  ${requestData}   site_id=${site_id}      gun_id=${gun_id}    sub_card_id=${sub_card_id}
    set to dictionary  ${requestData}   coupon_id=${coupon_id}      org_amt=${org_amt}    coupon_amt=${coupon_amt}
    set to dictionary  ${requestData}   pay_amt=${pay_amt}

    md5 gzh pay password    password=${fleetPassword}    password_token=${password_token}     real_coin_amt=${pay_amt}    order_id=0    type=2
    set to dictionary  ${requestData}   pay_password=${gzh_pay_password}

    ${gzhSess}    create session  gzhSess     ${gzhBaseUrl}
    ${res}    post request    gzhSess     /OilOrder/FleetOrder         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}
    should be equal as numbers  ${res_list}[0][code]    1



read test user info
    ${MyInfoRequestData}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    ${gzhHeadersRequestData}=     read csv test data  interface/OilSite2.0/userInfo.csv    gzhHeaders
    set test variable  ${headerGZH}     ${gzhHeadersRequestData}
    set test variable  ${password}     ${MyInfoRequestData}[password]
    set test variable  ${fleetPassword}     ${MyInfoRequestData}[fleetPassword]


ProductSettlement
    [Arguments]  ${csv_path}    ${test_name_kw_name}

    read test user info

    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net

    ${res}    post request    gzhSess     /OilOrder/ProductSettlement         data=${requestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}      data
    set test variable  ${site_id}   ${res_list}[1][ReadyPayMoney][site_id]
    set test variable  ${feiyou_amt}   ${res_list}[1][ReadyPayMoney][feiyou_amt]
    set test variable  ${password_token}   ${res_list}[0][ext][password_token]



FeiyouReadyPayMoney
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   site_id=${site_id}      feiyou_amt=${feiyou_amt}

    ${res}    post request    gzhSess     /OilOrder/FeiyouReadyPayMoney         data=${requestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}      data
    set test variable    ${real_score_amt}  ${res_list}[1][real_score_amt]
    set test variable    ${real_pay_amt}  ${res_list}[1][real_pay_amt]

FeiyouOrder
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary   ${requestData}     site_id=${site_id}      real_score_amt=${real_score_amt}     real_coin_amt=${real_pay_amt}
    set to dictionary   ${requestData}      feiyou_amt=${feiyou_amt}      app_client_type=1

    ${userInfo}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    md5 gzh pay password    password=${userInfo}[password]    password_token=${password_token}     real_coin_amt=${real_pay_amt}   order_id=0   type=1
    set to dictionary  ${requestData}   pay_password=${gzh_pay_password}

    MyInfo
    set test variable    ${coin_before}  float(${MyInfo}[0][ext][finance][coin_balance])
    set test variable    ${score_before}  float(${MyInfo}[0][ext][finance][score_balance])

    ${res}    post request    gzhSess     /OilOrder/FeiyouOrder         data=${requestData}  headers=${headerGZH}
    ${res_list}     deal http response  ${res}      data
    set test variable    ${order_id}  ${res_list}[1][id]

yypc login
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${headers}  create dictionary    Content-Type=application/x-www-form-urlencoded

    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    servertimestamp
    set to dictionary   ${requestData}  timestamp=${timestamp}

    md5 yypc login  ${requestData}[password]      ${requestData}[mobile]    ${timestamp}

    set to dictionary  ${requestData}   password=${md5_yypc_login_pwd}

    ${gzhSess}    create session  yypcSess     ${yypcBaseUrl}
    ${res}    post request    yypcSess     /DrpAccount/login       data=${requestData}  headers=${headers}
    ${res_list}     deal http response  ${res}
    check code      ${res_list}

    set cookie  ${res}

servertimestamp
    ${requestData}      create dictionary     mobile=17000000000
    ${headers}  create dictionary    Content-Type=application/x-www-form-urlencoded

    set to dictionary  ${requestData}
    ${gzhSess}    create session  yypcSess     ${yypcBaseUrl}
    ${res}    post request    yypcSess     /DrpAccount/servertimestamp       data=${requestData}    headers=${headers}
    ${res_list}     deal http response  ${res}
    check code  ${res_list}

    set test variable   ${timestamp}    ${res_list}[0][data]

check code
    [Arguments]  ${res_list}
    should be equal as numbers  ${res_list}[0][code]    1

#todo 将这个方法调整一下，改成传四个参数，分别是csv文件路径，名称，键，值
#${res}是http响应
set cookie
    [Arguments]  ${res}
    ${rowTmp}   create list
    ${rowTmps}   create list
    append to list  ${rowTmp}   yypc_header     Cookie      ${res.headers}[Set-Cookie]
    log list  ${rowTmp}
    append to list  ${rowTmps}  ${rowTmp}
    write to csv    ${yypcLoginCSV}     ${rowTmps}


ALLOrders
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    set yypc headers    ${yypcLoginCSV}     yypc_header

    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${yypcSess}    create session  yypcSess     ${yypcBaseUrl}
    ${res}    post request    yypcSess     /GasTradeOrder/ALLOrders      data=${requestData}    headers=${yypcHeaders}

    ${res_list}     deal http response  ${res}
    check code  ${res_list}

set yypc headers
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    set test variable  ${yypcHeaders}   ${requestData}


Login
    yypc login      ${loginCSVpath}     Login_yypc_login


QueryOnlienUser
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${ts}=   Get Current Date   exclude_millis=True
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    set test variable  ${user_mobile}   ${requestData}[mobile]
    set to dictionary  ${requestData}   ts=${ts}    postoken=${postoken}    uuid=${uuid}
    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    ${posSess}    create session  posSess     ${posBaseUrl}
    ${res}    post request    posSess     PosService/QueryOnlienUser       data=${requestData}


CalcOilCoupon
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${ts}=   Get Current Date   exclude_millis=True
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    set test variable  ${goods_amt}     ${requestData}[goods_amt]

    set to dictionary  ${requestData}   ts=${ts}    postoken=${postoken}    uuid=${uuid}
    set to dictionary  ${requestData}   oil_trade_list=${oil_trade_list}    mobile=${user_mobile}

    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    ${posHeaders}   create dictionary  Content-Type=application/x-www-form-urlencoded
    ${posSess}    create session  posSess     ${posBaseUrl}
    ${res}    post request    posSess     PosService/CalcOilCoupon       data=${requestData}    headers=${posHeaders}

    ${res_list}     deal http response  ${res}  data
    check code  ${res_list}
    set test variable  ${CalcOilCouponRes}  ${res_list}[1]

oilTradeList
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${trade_log_id}     evaluate   int(${requestData}[trade_log_id])
    set to dictionary  ${requestData}  trade_log_id=${trade_log_id}

    ${ori_amt}     evaluate   int(${requestData}[ori_amt])
    set to dictionary  ${requestData}  ori_amt=${ori_amt}

    GetOilGunList
    ${oilTradeDic}     get dict from list   ${GunList}   gun_number   ${requestData}[gun_number]
    set to dictionary  ${requestData}  oil_id=${oilTradeDic}[oil_id]

    GetOilPriceList
    ${OilPriceDic}     get dict from list  ${bosOilPriceList}  oil_id  ${oilTradeDic}[oil_id]
    set to dictionary  ${requestData}  price=${OilPriceDic}[price]

    ${litre}    cal litre  ${requestData}[ori_amt]    ${requestData}[price]
    set to dictionary  ${requestData}  litre=${litre}

    pop from dictionary     ${requestData}      gun_number
    ${myOilTradeList}   create list
    append to list  ${myOilTradeList}   ${requestData}
    set test variable  ${oil_trade_list}    ${myOilTradeList}
    log    ${oil_trade_list}

GetOilGunList
    ${requestData}  create dictionary
    ${ts}=   Get Current Date   exclude_millis=True
    set to dictionary  ${requestData}   ts=${ts}    postoken=${postoken}    uuid=${uuid}

    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    ${posSess}    create session  posSess     ${posBaseUrl}
    ${res}    post request    posSess     PosService/GetOilGunList       data=${requestData}

    ${res_list}     deal http response  ${res}  data
    check code  ${res_list}
    set test variable  ${GunList}   ${res_list}[1]


BosLogin
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${password}     my md5  ${requestData}[password]
    set to dictionary   ${requestData}    password=${password}

    ${ts}=   Get Current Date   exclude_millis=True
    set to dictionary  ${requestData}   ts=${ts}
    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    bosHeaders  ${BosLoginCSV}  bos_header

    ${bosSess}    create session  bosSess     ${BosBaseUrl}
    ${res}    post request    bosSess     BosService/BosLogin       data=${requestData}     headers=${bosHeaders}
    ${res_list}     deal http response  ${res}  data
    check code  ${res_list}

    set test variable  ${bosToken}  ${res_list}[1][token]

bosHeaders
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    set test variable  ${bosHeaders}    ${requestData}


GetOilPriceList
    ${requestData}      create dictionary
    ${ts}=   Get Current Date   exclude_millis=True
    set to dictionary  ${requestData}   ts=${ts}
    set to dictionary  ${requestData}   token=${bosToken}

    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    ${bosSess}    create session  bosSess     ${BosBaseUrl}
    ${res}    post request    bosSess     BosService/GetOilPriceList       data=${requestData}     headers=${bosHeaders}

    ${res_list}     deal http response  ${res}  data
    check code  ${res_list}
    set test variable  ${bosOilPriceList}   ${res_list}[1]


mySetUp
    pos login
    boslogin    ${BosLoginCSV}  BosLogin_BosLogin
    yypc login  ${loginCSVpath}     Login_yypc_login


VerifyCouponOrder
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${ts}=   Get Current Date   exclude_millis=True
    set to dictionary  ${requestData}   ts=${ts}    postoken=${postoken}    uuid=${uuid}

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    goods_coupon_amt
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   goods_coupon_amt=${CalcOilCouponRes}[goods_coupon_amt]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    direct_amt
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   direct_amt=${CalcOilCouponRes}[direct_amt]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    discount_amt
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   discount_amt=${CalcOilCouponRes}[discount_amt]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    goods_coupon_id
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   goods_coupon_id=${CalcOilCouponRes}[goods_coupon_id]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    full_amt
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   full_amt=${CalcOilCouponRes}[full_amt]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    coupon_amt
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   coupon_amt=${CalcOilCouponRes}[coupon_amt]

    ${tmp_bool}     dic has key  ${CalcOilCouponRes}    coupon_id
    run keyword if  ${tmp_bool}     set to dictionary  ${requestData}   coupon_id=${CalcOilCouponRes}[coupon_id]

    set to dictionary  ${requestData}   oil_trade_list=${oil_trade_list}    mobile=${user_mobile}     goods_amt=${goods_amt}

    ${sign}=     mySign  ${requestData}
    set to dictionary  ${requestData}   sign=${sign}

    ${posSess}    create session  posSess     ${posBaseUrl}
    ${res}    post request    posSess     PosService/VerifyCouponOrder       data=${requestData}

    ${res_list}     deal http response  ${res}  data
    check code  ${res_list}

