*** Settings ***
Resource  ../userKeyWord.robot


*** Variables ***
${SubCardCreateUrl}      /SubCard/Create
${subCardNoSQL}     {"SQL":"SELECT${SPACE}top${SPACE}1${SPACE}card_no${SPACE}from${SPACE}${SPACE}pit_fleetcard_subcard${SPACE}WHERE${SPACE}merchant_id=13${SPACE}order${SPACE}${SPACE}BY${SPACE}card_no${SPACE}desc;"}

*** Keywords ***
generateSubCardNo
    ${res}=     sql interface post raw      ${DjangoRawSqlFunUrl}   ${subCardNoSQL}
    ${old_cardNo}=     should match regexp   ${res}    \\d+
    ${new_cardNo}=      generate cardNo tool     ${old_cardNo}
    return from keyword   ${new_cardNo}





*** Test Cases ***
create
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,


create_manual_allocation
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

