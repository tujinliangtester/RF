*** Settings ***
Resource    ../userKeyWord.robot

*** Variables ***
${DrpPrimaryCardCreateUrl}      /DrpPrimaryCard/Create
${DrpPrimaryCardGetUserByMobileUrl}      /DrpPrimaryCard/GetUserByMobile

${top1PrimaryCardNo}    {"SQL":"${SPACE}SELECT${SPACE}top${SPACE}1${SPACE}card_no${SPACE}from${SPACE}${SPACE}pit_fleetcard_primarycard${SPACE}WHERE${SPACE}card_no${SPACE}like${SPACE}'0013%'${SPACE}order${SPACE}${SPACE}BY${SPACE}card_no${SPACE}desc"}


*** Keywords ***
generatePrimaryCardNo
    ${res}=     sql interface post raw      ${DjangoRawSqlFunUrl}      ${top1PrimaryCardNo}
    ${old_cardNo}=     should match regexp   ${res}    \\d+
    ${new_cardNo}=      generate cardNo tool     ${old_cardNo}
    return from keyword   ${new_cardNo}

*** Test Cases ***

createNewPrimaryCard_no_preferential
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${card_no}    generatePrimaryCardNo
    ${myInfo}   MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${myInfo}')   json
    ${member_user_id}   set variable    ${dic}[data][id]
    ${res}=     pc interface post   ${DrpPrimaryCardCreateUrl}      {"fleet_name": "涂金良玛莎拉蒂车队", "company_name": "涂氏集团", "contact_mobile": "", "discount_type": "1", "fall_value": "", "discount_value": "", "member_user_id": "${member_user_id}", "card_no": "${card_no}"}    ${pcHeader}
    should contain   ${res}     "code":1


createNewPrimaryCard_InvalidMobile
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${mobile}   gene mobile
    ${res}=     pc interface post   ${DrpPrimaryCardGetUserByMobileUrl}    {"mobile": "${mobile}"}     ${pcHeader}
    should not contain  ${res}     "code":1


createNewPrimaryCard_fall_value
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${card_no}    generatePrimaryCardNo
    ${myInfo}   MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${myInfo}')   json
    ${member_user_id}   set variable    ${dic}[data][id]
    ${res}=     pc interface post   ${DrpPrimaryCardCreateUrl}      {"fleet_name": "涂金良玛莎拉蒂车队", "company_name": "涂氏集团", "contact_mobile": "", "discount_type": "2", "fall_value": "1.11", "discount_value": "", "member_user_id": "${member_user_id}", "card_no": "${card_no}"}    ${pcHeader}
    should contain   ${res}     "code":1

createNewPrimaryCard_discount_value
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${card_no}    generatePrimaryCardNo
    ${myInfo}   MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${myInfo}')   json
    ${member_user_id}   set variable    ${dic}[data][id]
    ${res}=     pc interface post   ${DrpPrimaryCardCreateUrl}      {"fleet_name": "涂金良玛莎拉蒂车队", "company_name": "涂氏集团", "contact_mobile": "", "discount_type": "3", "fall_value": "", "discount_value": "8.8", "member_user_id": "${member_user_id}", "card_no": "${card_no}"}    ${pcHeader}
    should contain   ${res}     "code":1

