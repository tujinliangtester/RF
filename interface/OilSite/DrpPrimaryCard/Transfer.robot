*** Settings ***
Resource  ../userKeyWord.robot
Suite Setup  ManualRecharge
*** Variables ***
${DrpPrimaryCardTransferUrl}  /DrpPrimaryCard/Transfer
${DrpPrimaryCardGetTransferCardsInfoUrl}  /DrpPrimaryCard/GetTransferCardsInfo
${DrpRechargeManualRechargeUrl}      /DrpRecharge/ManualRecharge
${SubCardCreateUrl}      /SubCard/Create


${fleetcards_amts_val}      10
${fleetcards_amts_val_1}       11

${subCardNoSQL}     {"SQL":"SELECT${SPACE}top${SPACE}1${SPACE}card_no${SPACE}from${SPACE}${SPACE}pit_fleetcard_subcard${SPACE}WHERE${SPACE}merchant_id=13${SPACE}order${SPACE}${SPACE}BY${SPACE}card_no${SPACE}desc;"}

*** Keywords ***
ManualRecharge
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${primarycard_id}   myprimarycard

    ${res}=     pc interface post    ${DrpRechargeManualRechargeUrl}        {"primarycard_id": "${primarycard_id}", "recharge_amt": "1000", "gift_amt": "100", "recharge_method": "1", "note": ""}     ${pcHeader}
    should contain   ${res}     "code":1

generateSubCardNo
    ${res}=     sql interface post raw      ${DjangoRawSqlFunUrl}   ${subCardNoSQL}
    ${old_cardNo}=     should match regexp   ${res}    \\d+
    ${new_cardNo}=      generate cardNo tool     ${old_cardNo}
    return from keyword   ${new_cardNo}

*** Test Cases ***

Transfer
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    #create_manual_allocation 创建两个手动分配的子卡
    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,


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

    #create_manual_allocation 创建两个手动分配的子卡
    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

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



