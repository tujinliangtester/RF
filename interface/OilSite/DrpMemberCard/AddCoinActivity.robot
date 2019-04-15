*** Settings ***
Resource    ../userKeyWord.robot
Library     DateTime

Test Setup  setups

*** Variables ***
${DrpMemberCardAddCoinActivityUrl}      /DrpMemberCard/AddCoinActivity
${MemberCardAddCoinActivityName}   autoTjl
${DrpMemberOffLineAddCoinOrderUrl}     /DrpMemberOffLine/AddCoinOrder
${MyCouponList}   /My/CouponList
${DrpMemberOffLineCalcCoinCouponUrl}    /DrpMemberOffLine/CalcCoinCoupon

${start_time}       2019-04-11 00:00:00
${end_time}       2119-04-11 00:00:00


*** Keywords ***
setups
    forbiddenAllActivity
    enableCoupon

forbiddenAllActivity
    sql interface post raw    ${DjangoRawSqlFunUrl}     {"SQL":"UPDATE${SPACE}pit_member_coin_activity${SPACE}SET${SPACE}status=2;"}

enableCoupon
    sql interface post raw    ${DjangoRawSqlFunUrl}     {"SQL":"UPDATE${SPACE}pit_market_coupon${SPACE}SET${SPACE}is_trade=1${SPACE}WHERE${SPACE}id${SPACE}in${SPACE}(653,652,651);"}




*** Test Cases ***
coupon_01
    ${header}=      read config     header
    ${PcHeader}=    read config     PcHeader
    ${user_id}=     getUserId

    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_before}     set variable    ${dic}[data][coin_balance]

    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_before}    set variable    ${dic}[ext][Coupon]


    #新建充值活动
    ${res}=     pc interface post      ${DrpMemberCardAddCoinActivityUrl}   {"name": "${MemberCardAddCoinActivityName}", "start_time": "${start_time}", "end_time": "${end_time}", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{\\"amt\\":\\"\\",\\"zs_value\\":\\"\\",\\"max_count\\":0}]", "coupon_item": "[{\\"amt\\":\\"1\\",\\"coupon_id\\":651,\\"num\\":\\"1\\"}]"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #卡列表充值
    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "1", "active_id": "0", "note": "", "pay_method_id": "1"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #验证结果
    sleep  2
    #余额
    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_after}     set variable    ${dic}[data][coin_balance]

    ${coin_balance_change}=     evaluate  ${coin_balance_after}-${coin_balance_before}
    should be equal as numbers    ${coin_balance_change}    1

    #优惠券
    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_after}    set variable    ${dic}[ext][Coupon]

    ${coupon_num_change}=   evaluate  ${coupon_num_after}-${coupon_num_before}
    should be equal as numbers      ${coupon_num_change}        1

    #再次充值测试
    ${coin_balance_before}      set variable     ${coin_balance_after}
    ${coupon_num_before}     set variable     ${coupon_num_after}
    #卡列表充值
    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "1", "active_id": "0", "note": "", "pay_method_id": "1"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #验证结果
    sleep  2
    #余额
    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_after}     set variable    ${dic}[data][coin_balance]

    ${coin_balance_change}=     evaluate  ${coin_balance_after}-${coin_balance_before}
    should be equal as numbers    ${coin_balance_change}    1

    #优惠券
    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_after}    set variable    ${dic}[ext][Coupon]

    ${coupon_num_change}=   evaluate  ${coupon_num_after}-${coupon_num_before}
    should be equal as numbers      ${coupon_num_change}        1

coupon_02
    ${header}=      read config     header
    ${PcHeader}=    read config     PcHeader
    ${user_id}=     getUserId

    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_before}     set variable    ${dic}[data][coin_balance]

    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_before}    set variable    ${dic}[ext][Coupon]


    #新建充值活动
    ${res}=     pc interface post      ${DrpMemberCardAddCoinActivityUrl}   {"name": "${MemberCardAddCoinActivityName}", "start_time": "${start_time}", "end_time": "${end_time}", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "1", "activity_item": "[{\\"amt\\":\\"\\",\\"zs_value\\":\\"\\",\\"max_count\\":0}]", "coupon_item": "[{\\"amt\\":\\"1\\",\\"coupon_id\\":651,\\"num\\":\\"1\\"},{\\"amt\\":\\"3\\",\\"coupon_id\\":652,\\"num\\":\\"3\\"}]"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #卡列表充值
    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "3", "active_id": "0", "note": "", "pay_method_id": "1"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #验证结果
    sleep  2
    #余额
    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_after}     set variable    ${dic}[data][coin_balance]

    ${coin_balance_change}=     evaluate  ${coin_balance_after}-${coin_balance_before}
    should be equal as numbers    ${coin_balance_change}    3

    #优惠券
    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_after}    set variable    ${dic}[ext][Coupon]

    ${coupon_num_change}=   evaluate  ${coupon_num_after}-${coupon_num_before}
    should be equal as numbers      ${coupon_num_change}        3


give_coin_unlimited_times
    ${header}=      read config     header
    ${PcHeader}=    read config     PcHeader
    ${user_id}=     getUserId

    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_before}     set variable    ${dic}[data][coin_balance]

    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_before}    set variable    ${dic}[ext][Coupon]


    #新建充值活动
    ${res}=     pc interface post      ${DrpMemberCardAddCoinActivityUrl}   {"name": "${MemberCardAddCoinActivityName}", "start_time": "${start_time}", "end_time": "${end_time}", "discount_type": "1", "max_count": "0", "status": "1", "activity_type": "0", "activity_item": "[{\\"amt\\":\\"1\\",\\"zs_value\\":\\"1\\",\\"max_count\\":0}]", "coupon_item": "[{\\"amt\\":\\"\\",\\"coupon_id\\":\\"\\",\\"num\\":\\"\\"}]"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #卡列表充值
    ${org_amt}=     evaluate  1
    ${res}=     pc interface post      ${DrpMemberOffLineCalcCoinCouponUrl}   {"user_id": "${user_id}", "org_amt": "${org_amt}"}   ${PcHeader}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${active_id}    set variable    ${dic}[data][item][activity_id]
    ${give_amt}     set variable    ${dic}[data][item][zs_value]

    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "${org_amt}", "give_amt": "${give_amt}", "active_id": "${active_id}", "note": "", "pay_method_id": "1"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #验证结果
    sleep  2
    #余额
    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_after}     set variable    ${dic}[data][coin_balance]

    ${coin_balance_change}=     evaluate  ${coin_balance_after}-${coin_balance_before}
    ${coin_balance_change_exp}=     evaluate  ${org_amt}+${give_amt}
    should be equal as numbers    ${coin_balance_change}    ${coin_balance_change_exp}

    #优惠券
    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_after}    set variable    ${dic}[ext][Coupon]

    ${coupon_num_change}=   evaluate  ${coupon_num_after}-${coupon_num_before}
    should be equal as numbers      ${coupon_num_change}        0


    #再次充值
    ${coin_balance_before}     set variable     ${coin_balance_after}
    ${coupon_num_before}      set variable     ${coupon_num_after}
    #卡列表充值
    ${org_amt}=     evaluate  1
    ${res}=     pc interface post      ${DrpMemberOffLineCalcCoinCouponUrl}   {"user_id": "${user_id}", "org_amt": "${org_amt}"}   ${PcHeader}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${active_id}    set variable    ${dic}[data][item][activity_id]
    ${give_amt}     set variable    ${dic}[data][item][zs_value]

    ${res}=     pc interface post      ${DrpMemberOffLineAddCoinOrderUrl}   {"user_id": "${user_id}", "org_amt": "${org_amt}", "give_amt": "${give_amt}", "active_id": "${active_id}", "note": "", "pay_method_id": "1"}   ${PcHeader}
    should contain      ${res}      "code":1,

    #验证结果
    sleep  2
    #余额
    ${MyInfo}=      MyInfo      ${header}
    ${dic}=     evaluate  json.loads(u'${MyInfo}')   json
    ${coin_balance_after}     set variable    ${dic}[data][coin_balance]

    ${coin_balance_change}=     evaluate  ${coin_balance_after}-${coin_balance_before}
    ${coin_balance_change_exp}=     evaluate  ${org_amt}+${give_amt}
    should be equal as numbers    ${coin_balance_change}    ${coin_balance_change_exp}

    #优惠券
    ${res}=     interface post      ${MyCouponList}     {"pagesize": "100", "pagenumber": "1", "is_use": "0", "is_expire": "0", "packID": "0", "r": "0.42419922061968296"}  ${header}
    ${dic}=     evaluate  json.loads(u'${res}')   json
    ${coupon_num_after}    set variable    ${dic}[ext][Coupon]

    ${coupon_num_change}=   evaluate  ${coupon_num_after}-${coupon_num_before}
    should be equal as numbers      ${coupon_num_change}        0



