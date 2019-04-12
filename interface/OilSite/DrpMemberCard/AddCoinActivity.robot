*** Settings ***
Resource    ../userKeyWord.robot
Library     DateTime

Test Setup  setups
*** Variables ***
${DrpMemberCardAddCoinActivityUrl}      /DrpMemberCard/AddCoinActivity
${MemberCardAddCoinActivityName}   autoTjl
${DrpMemberOffLineAddCoinOrderUrl}     /DrpMemberOffLine/AddCoinOrder

*** Keywords ***
setups
    forbiddenAllActivity

forbiddenAllActivity
    sql interface post raw    ${DjangoRawSqlFunUrl}     {"SQL":"UPDATE${SPACE}pit_member_coin_activity${SPACE}SET${SPACE}status=2;"}



*** Test Cases ***
class_01
    ${header}=      read config     header
    ${PcHeader}=    read config     PcHeader
    ${mobile}=      read config     mobile
    ${user_id}=     getUserId

    ${start_time}=    GetCurrentMonth
    log   ${start_time}
    #新建充值活动
    ${res}=     pc interface post      ${DrpMemberCardAddCoinActivityUrl}   {"name": "${MemberCardAddCoinActivityName}", "start_time": "2019-04-11 00:00:00", "end_time": "2019-04-13 23:59:59", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{\\"amt\\":\\"\\",\\"zs_value\\":\\"\\",\\"max_count\\":0}]", "coupon_item": "[{\\"amt\\":\\"1\\",\\"coupon_id\\":651,\\"num\\":\\"1\\"}]"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #卡列表充值
    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "1", "active_id": "0", "note": "", "pay_method_id": "1"}   ${PcHeader}

