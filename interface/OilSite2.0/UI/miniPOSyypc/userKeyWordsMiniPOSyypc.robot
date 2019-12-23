
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
Library     Collections
Library     ../../../../lib/myTestLib.py
Library     CSVLib
Library     String
#Library     SeleniumLibrary    5
Library     AppiumLibrary   10
*** Variables ***


*** Keywords ***
my_test_setup
    sleep   3
open app
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    open application  http://localhost:4723/wd/hub      miniPOSapp    platformName=${requestData}[platformName]     platformVersion=${requestData}[platformVersion]     deviceName=${requestData}[deviceName]     appPackage=${requestData}[appPackage]     appActivity=${requestData}[appActivity]     noReset=${requestData}[noReset]
    sleep  2
chose gun
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${els}     get webelements     id=com.ytny.youhuiduo.oilmanager:id/tv_num
    ${el}      my find el from els by text  ${els}     ${requestData}[gunNum]
    click element  ${el}

input oil amt
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    #浮窗无法定位，目前只能用位置定位
    sleep  1
    click a point   742     1365

    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/et_add_oil_money
    input text  ${el}   ${requestData}[oil_amt]

input_goods_amt
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    #关闭数字键盘浮窗
    sleep  1
    click a point   742     1365

    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/et_goods_money
    input text  ${el}   ${requestData}[goods_amt]








chose pay method
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    sleep  2
    go_to_pay   ${csv_path}     demo

    ${els}     get webelements     id=com.ytny.youhuiduo.oilmanager:id/tv
    ${el}      my find el from els by text  ${els}     ${requestData}[pay_method]
    click element  ${el}

commite pay
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/btn_receivables
    click element  ${el}

#继续收银
continue_to_check_out
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    sleep  1
    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/btn_continue
    click element  ${el}

chose_goods
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_store
    click element  ${el}

    sleep  1
    @{goods_code_list}  pos numeric keypad change  ${requestData}[goods_code]
    :FOR    ${goods_code_item}  in  @{goods_code_list}
    \   log     ${goods_code_item}
    \   ${el}     get webelement     id=com.ytny.os.pos:id/btn${goods_code_item}
    \   click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/btn15
    click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/rl_back
    click element  ${el}



#商品挂单交易
pending_goods_order
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_store
    click element  ${el}

    @{goods_code_list}  pos numeric keypad change  ${requestData}[goods_code]
    :FOR    ${goods_code_item}  in  @{goods_code_list}
    \   log     ${goods_code_item}
    \   ${el}     get webelement     id=com.ytny.os.pos:id/btn${goods_code_item}
    \   click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/btn15
    click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/tv_my_hangon
    click element  ${el}

input_user
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/et_phone
    ${last4_mobile}     get substring  ${requestData}[mobile]   -4
    input text      ${el}       ${last4_mobile}

    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/iv_serach
    click element  ${el}

    ${els}     get webelements     id=com.ytny.youhuiduo.oilmanager:id/tv_phone
    ${el}  my find el from els by text  ${els}     ${requestData}[mobile]
    click element  ${el}


input_userCard_pwd
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    @{userCard_pwd_list}    convert to list  ${requestData}[userCard_pwd]
    sleep  1
    ${els}     get webelements     id=com.ytny.youhuiduo.oilmanager:id/btNumber
    ${tmp_indx}     set variable    0
    :FOR    ${userCard_pwd_item}  in  @{userCard_pwd_list}
    \   ${tmp_index}    evaluate  ${userCard_pwd_item}-1
    \   run keyword if  ${userCard_pwd_item}==0  click element  ${els}[10]
    \   run keyword unless  ${userCard_pwd_item}==0  click element  ${els}[${tmp_index}]


chose_score
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${el}     get webelement     id=com.ytny.os.pos:id/cv_discount4
    click element  ${el}

chose_fleetCard
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    sleep  1
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_card
    click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/btn_confirm
    click element  ${el}


input_fleetCard_pwd
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    sleep  1
    ${el}     get webelement     id=com.ytny.os.pos:id/et_password
    input text      ${el}   ${requestData}[fleetCard_pwd]

go_into_check_out
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/btn_cashier
    click element  ${el}
    sleep  1


go_to_pay
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/btn_to_pay
    click element  ${el}

not_add_oil
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.youhuiduo.oilmanager:id/btn_not_add_oil
    click element  ${el}