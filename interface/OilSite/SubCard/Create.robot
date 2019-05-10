*** Settings ***
Resource  ../userKeyWord.robot
Test Setup      setups

*** Variables ***
${SubCardCreateUrl}      /SubCard/Create
${OilOrderFleetOrderUrl}      /OilOrder/FleetOrder
${PrimaryCardGetSubCardUrl}     /PrimaryCard/GetSubCard
${OilOrderFleetReadyPayMoneyUrl}      /OilOrder/FleetReadyPayMoney

${subCardNoSQL}     {"SQL":"SELECT${SPACE}top${SPACE}1${SPACE}card_no${SPACE}from${SPACE}${SPACE}pit_fleetcard_subcard${SPACE}WHERE${SPACE}merchant_id=13${SPACE}order${SPACE}${SPACE}BY${SPACE}card_no${SPACE}desc;"}



${license_plate}    川Jno1tjl
${limit_site_id}      36
#油品id：10 对应的是92号汽油

${gun_id_DongGuang}     14467
${site_id}      35
${gun_id}       14381
${org_amt}      100

${limit_oil_type}   10
*** Keywords ***
setups
    #避免下单过于频繁
    sleep  10

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
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,


create_and_fleetOrder
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard

    ${res}       MyInfo      ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${mobile}       set variable   ${dic}[data][mobile]

    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${res}      interface post      ${primarycardgetsubcardurl}     {"primarycard_id": "${primarycard_id}", "pagesize": "1000", "pagenumber": "1", "r": "0.6542966218451949"}   ${header}

    ${sub_card_id}      set variable    0
    ${dic}      evaluate   json.loads(u'${res}')    json
    @{tmp_list}=    evaluate  list(${dic}[data][rows])
    :FOR    ${item}    IN   @{tmp_list}
    \    ${compare_res}     compare str    ${item}[card_no]    ${card_no}
    \    run keyword if     ${compare_res}==True   set test variable  ${sub_card_id}   ${item}[id]

    ${res}      interface post   ${oilorderfleetreadypaymoneyurl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "org_amt": "${org_amt}", "sub_card_id": "${sub_card_id}"}     ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${pay_amt}      set variable   ${dic}[data][pay_amt]

    ${pay_password}     payPassword     ${pay_amt}      ${header_ios}

    ${res}      interface post   ${OilOrderFleetOrderUrl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "coupon_id": "0", "org_amt": "${org_amt}", "coupon_amt": "0", "pay_amt": "${pay_amt}", "pay_password": "${pay_password}", "r": "0.7270126540158686"}     ${header_ios}
    should contain      ${res}      "code":1,



create_manual_allocation
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard
    ${mobile}       gene mobile
    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "2","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,




create_limits_license_plate
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard

    ${res}       MyInfo      ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${mobile}       set variable   ${dic}[data][mobile]

    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "${license_plate}","limits[0][is_limited]": "1","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${res}      interface post      ${primarycardgetsubcardurl}     {"primarycard_id": "${primarycard_id}", "pagesize": "1000", "pagenumber": "1", "r": "0.6542966218451949"}   ${header}

    ${sub_card_id}      set variable    0
    ${dic}      evaluate   json.loads(u'${res}')    json
    @{tmp_list}=    evaluate  list(${dic}[data][rows])
    :FOR    ${item}    IN   @{tmp_list}
    \    ${compare_res}     compare str    ${item}[card_no]    ${card_no}
    \    run keyword if     ${compare_res}==True   set test variable  ${sub_card_id}   ${item}[id]

    ${res}      interface post   ${oilorderfleetreadypaymoneyurl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "org_amt": "${org_amt}", "sub_card_id": "${sub_card_id}"}     ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${pay_amt}      set variable   ${dic}[data][pay_amt]

    ${pay_password}     payPassword     ${pay_amt}      ${header_ios}

    ${res}      interface post   ${OilOrderFleetOrderUrl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "coupon_id": "0", "org_amt": "${org_amt}", "coupon_amt": "0", "pay_amt": "${pay_amt}", "pay_password": "${pay_password}", "r": "0.7270126540158686"}     ${header_ios}
    should contain      ${res}      "code":1,

create_limits_oilsite
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard

    ${res}       MyInfo      ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${mobile}       set variable   ${dic}[data][mobile]

    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "${limit_site_id}","limits[1][is_limited]": "1","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "","limits[2][is_limited]": "0","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${res}      interface post      ${primarycardgetsubcardurl}     {"primarycard_id": "${primarycard_id}", "pagesize": "1000", "pagenumber": "1", "r": "0.6542966218451949"}   ${header}

    ${sub_card_id}      set variable    0
    ${dic}      evaluate   json.loads(u'${res}')    json
    @{tmp_list}=    evaluate  list(${dic}[data][rows])
    :FOR    ${item}    IN   @{tmp_list}
    \    ${compare_res}     compare str    ${item}[card_no]    ${card_no}
    \    run keyword if     ${compare_res}==True   set test variable  ${sub_card_id}   ${item}[id]

    ${res}      interface post   ${oilorderfleetreadypaymoneyurl}   {"site_id": "${limit_site_id}", "gun_id": "${gun_id_DongGuang}", "org_amt": "${org_amt}", "sub_card_id": "${sub_card_id}"}     ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${pay_amt}      set variable   ${dic}[data][pay_amt]

    ${pay_password}     payPassword     ${pay_amt}      ${header_ios}

    ${res}      interface post   ${OilOrderFleetOrderUrl}   {"site_id": "${limit_site_id}", "gun_id": "${gun_id_DongGuang}", "sub_card_id": "${sub_card_id}", "coupon_id": "0", "org_amt": "${org_amt}", "coupon_amt": "0", "pay_amt": "${pay_amt}", "pay_password": "${pay_password}", "r": "0.7270126540158686"}     ${header_ios}
    should not contain      ${res}      "code":1,



create_limits_oilType
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header
    ${header_ios}   read config   header_ios

    ${card_no}      generateSubCardNo
    ${primarycard_id}   MyPrimaryCard

    ${res}       MyInfo      ${header_ios}
    ${dic}      evaluate   json.loads(u'${res}')    json
    ${mobile}       set variable   ${dic}[data][mobile]

    ${res}=     interface post      ${SubCardCreateUrl}     {"card_no": "${card_no}","primarycard_id": "${primarycard_id}","card_alias": "auto${mobile}","mobile": "${mobile}","balance_type": "1","is_disable": "0","limits[0][limit_id]": "0","limits[0][limit_type]": "1","limits[0][text]":"车牌号","limits[0][limit_value]": "","limits[0][is_limited]": "0","limits[1][limit_id]": "0","limits[1][limit_type]": "2","limits[1][text]": "加油油站","limits[1][limit_value]": "","limits[1][is_limited]": "0","limits[2][limit_id]": "0","limits[2][limit_type]": "3","limits[2][text]": "燃油油品","limits[2][limit_value]": "${limit_oil_type}","limits[2][is_limited]": "1","limits[3][limit_id]": "0","limits[3][limit_type]": "4","limits[3][text]": "单笔支付金额","limits[3][limit_value]": "","limits[3][is_limited]": "0","limits[4][limit_id]": "0","limits[4][limit_type]": "5","limits[4][text]": "日累计支付次数","limits[4][limit_value]": "","limits[4][is_limited]": "0","limits[5][limit_id]": "0","limits[5][limit_type]": "6","limits[5][text]": "日累计支付金额","limits[5][limit_value]": "","limits[5][is_limited]": "0","limits[6][limit_id]": "0","limits[6][limit_type]": "7","limits[6][text]": "月累计支付次数","limits[6][limit_value]": "","limits[6][is_limited]": "0","limits[7][limit_id]": "0","limits[7][limit_type]": "8","limits[7][text]": "月累计支付金额","limits[7][limit_value]": "","limits[7][is_limited]": "0"}      ${header}
    should contain      ${res}      "code":1,

    ${res}      interface post      ${primarycardgetsubcardurl}     {"primarycard_id": "${primarycard_id}", "pagesize": "1000", "pagenumber": "1", "r": "0.6542966218451949"}   ${header}

    ${sub_card_id}      set variable    0
    ${dic}      evaluate   json.loads(u'${res}')    json
    @{tmp_list}=    evaluate  list(${dic}[data][rows])
    :FOR    ${item}    IN   @{tmp_list}
    \    ${compare_res}     compare str    ${item}[card_no]    ${card_no}
    \    run keyword if     ${compare_res}==True   set test variable  ${sub_card_id}   ${item}[id]

    ${res}      interface post   ${oilorderfleetreadypaymoneyurl}   {"site_id": "${site_id}", "gun_id": "14406", "org_amt": "${org_amt}", "sub_card_id": "${sub_card_id}"}     ${header_ios}
    should not contain      ${res}      "code":1,
#开发在油品限制的处理判定提前到readypaymoney了
#    ${dic}      evaluate   json.loads(u'${res}')    json
#    ${pay_amt}      set variable   ${dic}[data][pay_amt]
#
#    ${pay_password}     payPassword     ${pay_amt}      ${header_ios}
#
#    ${res}      interface post   ${OilOrderFleetOrderUrl}   {"site_id": "${site_id}", "gun_id": "14406", "sub_card_id": "${sub_card_id}", "coupon_id": "0", "org_amt": "${org_amt}", "coupon_amt": "0", "pay_amt": "${pay_amt}", "pay_password": "${pay_password}", "r": "0.7270126540158686"}     ${header_ios}
#    should not contain      ${res}      "code":1,





