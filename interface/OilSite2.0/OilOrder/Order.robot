
*** Settings ***
Resource  E:/tjl/RF/interface/OilSite2.0/userKeyWords.robot

*** Test Cases ***
Class_01
    TicketList
    order
    PayOil


*** Keywords ***
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
    set to dictionary  ${requestData}   org_amt=${org_amt}  real_score_amt=${real_score_amt}    real_coin_amt=${real_coin_amt}
    set to dictionary  ${requestData}   nogas_amt=${nogas_amt}  coupon_nogas_id=${coupon_nogas_id}    coupon_all_id=${coupon_all_id}
    set to dictionary  ${requestData}   real_pay_amt=${real_pay_amt}
    ${res}    post request    gzhSess     /OilOrder/order         data=${requestData}  headers=${headerGZH}

    ${res_list}     deal http response  ${res}      data
    set test variable    ${order_id}  ${res_list}[1][id]
    set test variable    ${pay_method_id}  ${res_list}[1][pay_method_id]

PayOil
    ${requestData}=     read csv test data  interface/OilSite2.0/OilOrder/Order.csv    Class_01_PayOil
    ${gzhSess}    create session  gzhSess     http://testbiz.314pay.net
    set to dictionary  ${requestData}   order_id=${order_id}  pay_method_id=${pay_method_id}
    ${res}    post request    gzhSess     /OilOrder/PayOil         data=${requestData}  headers=${headerGZH}
