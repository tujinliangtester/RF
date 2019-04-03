*** Settings ***
Library  ../../lib/InterfaceRequest.py
Library  ../../lib/tools.py
*** Variables ***
${OilOrderOrderUrl}  /OilOrder/Order
${TicketListUrl}      /OilOrder/TicketList
${OilOrderPayOilUrl}   /OilOrder/PayOil
${DjangoRawSqlFunUrl}        http://localhost:8000/polls/raw_sql_fun
${DrpMemberCardPayPasswordReSetUrl}  /DrpMemberCard/PayPasswordReSet
${MyInfoUrl}     /My/Info
${DrpMemberOffLineAddCoinOrderUrl}      /DrpMemberOffLine/AddCoinOrder
${MyDrawCouponUrl}   /My/DrawCoupon
${UpdateMerchantSettingURL}     /DrpConfig/UpdateMerchantSetting
${MyPayPasswordInfoUrl}      /My/PayPasswordInfo
${DrpConfigUserLevelListUrl}     /DrpConfig/UserLevelList

${paypwd}   123456
${coupon_id1}   622
${coupon_id2}   623
${coupon_id3}   624
${coupon_id4}   625
*** Keywords ***
UpdateMerchantSetting
    [Arguments]     ${is_allow_superimposed}    ${PcHeader}
    pc_interface_post      ${UpdateMerchantSettingURL}    {"can_add_balance": "1", "can_use_coin": "1", "can_use_carnumber_pay": "1", "can_use_balance_pay": "1","can_use_coin_pay_notoil": "1", "is_allow_superimposed": "${is_allow_superimposed}", "can_use_score_mall": "1","can_use_fleet_card": "1"}     ${PcHeader}

TicketList
    [Arguments]     ${org_amt}      ${header}
    ${res}=     interface post      ${TicketListUrl}     {"site_id": "35", "gun_id": "14403", "org_amt": "${org_amt}", "nogas_amt": "", "app_client_type": "1", "r": "0.6673226578129476"}     ${header}
    return from keyword    ${res}

MyInfo
    [Arguments]     ${header}
    ${res}=     interface post      ${MyInfoUrl}    {"r":"0.3490340368105973"}      ${header}
    return from keyword     ${res}

DrpConfigUserLevelList
    [Arguments]     ${PcHeader}
    ${res}=     pc interface post   ${DrpConfigUserLevelListUrl}    ${EMPTY}    ${PcHeader}
    return from keyword     ${res}

payPassword
    #password = md5(md5(md5(this.passwordToken) + md5(str2)) + md5(parseInt(this.realCoinAmt) + ''))
    #password2 = md5(md5(md5(this.passwordToken) + md5(str2)) + md5(this.order_id + ''))
    [Arguments]     ${str3}     ${header}
    ${res}=   interface post      ${MyPayPasswordInfoUrl}   ${EMPTY}     ${header}
    ${passwordToken}=   should match regexp    ${res}    "password_token":"\\w+
    ${passwordToken}=   should match regexp    ${passwordToken}    :"\\w+
    ${passwordToken}=   should match regexp    ${passwordToken}    \\w+
    ${amt_after_reduce_for_pay}=    evaluate   int(${str3})
    ${res}=     gzh pay password encode     ${passwordToken}    ${paypwd}     ${amt_after_reduce_for_pay}
    return from keyword     ${res}
clearUserCoupon
    ${header}=      read config     header
    ${PcHeader}=    read config     PcHeader
    #清除用户优惠券
    ${res}=     MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${userId}   set variable    ${dic}[data][id]
    sql interface post raw   ${DjangoRawSqlFunUrl}   {"SQL":"DELETE${SPACE}pit_market_coupon_to_user${SPACE}WHERE${SPACE}user_id=${userId};"}


drawCoupon
    [Arguments]     ${coupon_id}
    ${header}=      read config     header
    interface post      ${MyDrawCouponUrl}      {"coupon_id": "${coupon_id}", "r": "0.465362035318329"}      ${header}


