*** Settings ***
Resource  ../userKeyWord.robot

*** Variables ***
${DrpSubCardConsumeOrderUrl}    /DrpSubCard/ConsumeOrder
${DrpSubCardReadyPayMoneyUrl}     /DrpSubCard/ReadyPayMoney





*** Keywords ***


*** Test Cases ***
ConsumeOrder
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${site_id}  set variable  35
    ${gun_id}  set variable     14404
    ${sub_card_id}      mysubcard_ios
    ${org_amt}      set variable  10

    ${res}=     pc interface post   ${DrpSubCardReadyPayMoneyUrl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "org_amt": "${org_amt}"}  ${pcHeader}
    ${dic}  evaluate   json.loads(u'${res}')    json
    ${pay_amt}      set variable    ${dic}[data][pay_amt]
    ${coupon_id}    set variable    ${dic}[data][coupon_id]
    ${coupon_amt}   set variable    ${dic}[data][coupon_amt]

    ${res}=     pc interface post   ${DrpSubCardConsumeOrderUrl}    {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "org_amt": "${org_amt}", "coupon_id": "${coupon_id}", "coupon_amt": "${coupon_amt}", "pay_amt": "${pay_amt}"}     ${pcHeader}
    should contain     ${res}    "code":1,
