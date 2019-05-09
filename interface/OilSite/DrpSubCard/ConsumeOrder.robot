*** Settings ***
Resource  ../userKeyWord.robot

*** Variables ***
${DrpSubCardConsumeOrderUrl}    /DrpSubCard/ConsumeOrder
${DrpSubCardReadyPayMoneyUrl}     /DrpSubCard/ReadyPayMoney





*** Keywords ***
ReadyPayMoney
    [Arguments]     ${site_id}    ${gun_id}    ${sub_card_id}   ${org_amt}

    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${res}=     pc interface post   ${DrpSubCardReadyPayMoneyUrl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "org_amt": "${org_amt}"}  ${pcHeader}
    ${dic}  evaluate   json.loads(u'${res}')    json
    ${pay_amt}      set variable    ${dic}[data][pay_amt]
    return from keyword     ${pay_amt}

*** Test Cases ***
ConsumeOrder
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${site_id}  set variable  35
    ${gun_id}  set variable     14404
    ${sub_card_id}      mysubcard_ios
    ${org_amt}      set variable  10

    ${pay_amt}      ReadyPayMoney       ${site_id}    ${gun_id}    ${sub_card_id}   ${org_amt}
    ${res}=     pc interface post   ${DrpSubCardConsumeOrderUrl}    {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "org_amt": "${org_amt}", "coupon_id": "0", "coupon_amt": "0", "pay_amt": "${pay_amt}"}     ${pcHeader}
    should contain     ${res}    "code":1,
