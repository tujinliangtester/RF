*** Settings ***
Resource    ../userKeyWord.robot

*** Variables ***
${DrpPrimaryCardCreateUrl}      /DrpPrimaryCard/Create

${top1PrimaryCardNo}    {"SQL":"SELECT${SPACE}top${SPACE}1${SPACE}card_no${SPACE}from${SPACE}${SPACE}pit_fleetcard_primarycard${SPACE}ORDER${SPACE}BY${SPACE}card_no${SPACE}desc;"}

*** Keywords ***
generatePrimaryCardNo
    ${res}=     sql interface post raw      ${DjangoRawSqlFunUrl}      ${top1PrimaryCardNo}
    ${res}=     should match regexp   ${res}    \\d+
    ${res}=     evaluate   int(${res})+1
    return from keyword   ${res}
*** Test Cases ***

createNewPrimaryCard
    ${pcHeader}    read config   PcHeader
    ${card_no}    generatePrimaryCardNo
    ${res}=     pc interface post   ${DrpPrimaryCardCreateUrl}      {"fleet_name": "涂金良玛莎拉蒂车队", "company_name": "涂氏集团", "contact_mobile": "", "discount_type": "1", "fall_value": "", "discount_value": "", "member_user_id": "2145", "card_no": "${card_no}"}    ${pcHeader}
    should contain   ${res}     "code":1