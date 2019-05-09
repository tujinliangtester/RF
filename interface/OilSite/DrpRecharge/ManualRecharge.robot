*** Settings ***
Resource    ../userKeyWord.robot


*** Variables ***
${DrpRechargeManualRechargeUrl}      /DrpRecharge/ManualRecharge
${DrpPrimaryCardGetRechargeCardsInfoUrl}     /DrpPrimaryCard/GetRechargeCardsInfo


*** Test Cases ***
ManualRecharge
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${primarycard_id}   myprimarycard

    ${res}=     pc interface post    ${DrpPrimaryCardGetRechargeCardsInfoUrl}        {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')   json
    ${balance_before}      set variable   ${dic}[data][0][balance]

    ${res}=     pc interface post    ${DrpRechargeManualRechargeUrl}        {"primarycard_id": "${primarycard_id}", "recharge_amt": "1000", "gift_amt": "100", "recharge_method": "1", "note": ""}     ${pcHeader}
    should contain   ${res}     "code":1

    sleep   1
    ${res}=     pc interface post    ${DrpPrimaryCardGetRechargeCardsInfoUrl}        {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')   json
    ${balance_after}      set variable   ${dic}[data][0][balance]

    ${balance_change}       evaluate   round(${balance_after}-${balance_before},2)
    should be equal as numbers      ${balance_change}   1100





