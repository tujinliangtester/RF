*** Settings ***
Resource  ../userKeyWord.robot
Suite Setup  ManualRecharge
*** Variables ***
${DrpPrimaryCardTransferUrl}  /DrpPrimaryCard/Transfer
${DrpPrimaryCardGetTransferCardsInfoUrl}  /DrpPrimaryCard/GetTransferCardsInfo
${DrpRechargeManualRechargeUrl}      /DrpRecharge/ManualRecharge

${fleetcards_amts_val}      10
${fleetcards_amts_val_1}       11

*** Keywords ***
ManualRecharge
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${primarycard_id}   myprimarycard

    ${res}=     pc interface post    ${DrpRechargeManualRechargeUrl}        {"primarycard_id": "${primarycard_id}", "recharge_amt": "1000", "gift_amt": "100", "recharge_method": "1", "note": ""}     ${pcHeader}
    should contain   ${res}     "code":1

*** Test Cases ***

Transfer
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${primarycard_id}   MyPrimaryCard

    ${res}=     pc interface post   ${DrpPrimaryCardGetTransferCardsInfoUrl}    {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${subcard_id_0}   set variable  ${dic}[data][fleetCards][0][id]
    ${balance_before}   set variable  ${dic}[data][balance]
    ${balance_sub_before}   set variable  ${dic}[data][fleetCards][0][balance]

    ${res}=     pc interface post      ${DrpPrimaryCardTransferUrl}    {"fleetcards_amts[0][key]": "${subcard_id_0}", "fleetcards_amts[0][value]": "${fleetcards_amts_val}"}    ${pcHeader}
    should contain      ${res}      "code":1,

    sleep  1
    ${res}=     pc interface post   ${DrpPrimaryCardGetTransferCardsInfoUrl}    {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${balance_after}   set variable  ${dic}[data][balance]

    @{tmp_list}=    evaluate  list(${dic}[data][fleetCards])
    ${balance_sub_after}    set variable  0
    :FOR    ${fleetCard}    IN   @{tmp_list}
    \    run keyword if     ${fleetCard}[id]==${subcard_id_0}   set test variable    ${balance_sub_after}    ${fleetCard}[balance]

    ${balance_change}   evaluate   ${balance_before}-${balance_after}
    ${balance_sub_change}   evaluate   ${balance_sub_after}-${balance_sub_before}
    should be equal as numbers      ${balance_change}     ${fleetcards_amts_val}
    should be equal as numbers      ${balance_sub_change}   ${fleetcards_amts_val}


Transfer_batch
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${primarycard_id}   MyPrimaryCard

    ${res}=     pc interface post   ${DrpPrimaryCardGetTransferCardsInfoUrl}    {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${subcard_id_0}   set variable  ${dic}[data][fleetCards][0][id]
    ${subcard_id_1}   set variable  ${dic}[data][fleetCards][1][id]
    ${balance_before}   set variable  ${dic}[data][balance]
    ${balance_sub_before}   set variable  ${dic}[data][fleetCards][0][balance]
    ${balance_sub_before_1}   set variable  ${dic}[data][fleetCards][1][balance]

    ${res}=     pc interface post      ${DrpPrimaryCardTransferUrl}    {"fleetcards_amts[0][key]": "${subcard_id_0}", "fleetcards_amts[0][value]": "${fleetcards_amts_val}","fleetcards_amts[1][key]": "${subcard_id_1}", "fleetcards_amts[1][value]": "${fleetcards_amts_val_1}"}    ${pcHeader}
    should contain      ${res}      "code":1,

    sleep  1
    ${res}=     pc interface post   ${DrpPrimaryCardGetTransferCardsInfoUrl}    {"primarycard_id": "${primarycard_id}"}     ${pcHeader}
    ${dic}      evaluate   json.loads(u'${res}')    json

    @{tmp_list}=    evaluate  list(${dic}[data][fleetCards])
    ${balance_sub_after}    set variable  0
    ${balance_sub_after_1}    set variable  0
    :FOR    ${fleetCard}    IN   @{tmp_list}
    \    run keyword if     ${fleetCard}[id]==${subcard_id_0}   set test variable    ${balance_sub_after}    ${fleetCard}[balance]
    \    run keyword if     ${fleetCard}[id]==${subcard_id_1}   set test variable    ${balance_sub_after_1}    ${fleetCard}[balance]

    ${balance_after}   set variable  ${dic}[data][balance]

    ${balance_change}   evaluate   ${balance_before}-${balance_after}
    ${balance_sub_change}   evaluate   ${balance_sub_after}-${balance_sub_before}
    ${balance_sub_change_1}   evaluate   ${balance_sub_after_1}-${balance_sub_before_1}
    ${fleetcards_amts_val_sum}      evaluate     ${fleetcards_amts_val}+${fleetcards_amts_val_1}

    should be equal as numbers      ${balance_change}     ${fleetcards_amts_val_sum}
    should be equal as numbers      ${balance_sub_change}   ${fleetcards_amts_val}
    should be equal as numbers      ${balance_sub_change_1}   ${fleetcards_amts_val_1}



