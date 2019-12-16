
*** Settings ***
Resource  ../userKeyWords.robot

*** Variables ***
${orderCsvPath}     interface/OilSite2.0/OilOrder/Order.csv

*** Test Cases ***
Class_01
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     Class_01_TicketList
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil


userCard_oil_score
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     Class_01_TicketList
    ReadyPayMoney   ${orderCsvPath}    Class_01_ReadyPayMoney
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil

userCard_goods_score
    #下单不能过于频繁
    sleep  10
    ProductSettlement   ${orderCsvPath}     userCard_goods_score_ProductSettlement
    FeiyouReadyPayMoney     ${orderCsvPath}     userCard_goods_score_FeiyouReadyPayMoney
    FeiyouOrder     ${orderCsvPath}     userCard_goods_score_FeiyouOrder
    PayOil  ${orderCsvPath}    Class_01_PayOil

userCard_oil_and_goods_score
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     userCard_oil_and_goods_score_TicketList
    ReadyPayMoney   ${orderCsvPath}    Class_01_ReadyPayMoney
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil

#todo 车队卡支付订单，小pos、大pos订单

*** Keywords ***
ProductSettlement
    [Arguments]  ${csv_path}    ${test_name_kw_name}

    ${tmp_header}=     read csv test data  interface/OilSite2.0/userInfo.csv    userInfo
    set to dictionary    ${tmp_header}      Content-Type=application/x-www-form-urlencoded
    set test variable  ${headerGZH}    ${tmp_header}

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

