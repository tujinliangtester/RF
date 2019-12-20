
*** Settings ***
Library     DatabaseLibrary
Library     RequestsLibrary
Library     DateTime
Library     Collections
Library     ../../../../lib/myTestLib.py
Library     CSVLib
Library     String
#Library     SeleniumLibrary
Library     AppiumLibrary
*** Variables ***


*** Keywords ***
my_test_setup
    sleep   3
open app
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    open application  http://localhost:4723/wd/hub      POSapp    platformName=${requestData}[platformName]     platformVersion=${requestData}[platformVersion]     deviceName=${requestData}[deviceName]     appPackage=${requestData}[appPackage]     appActivity=${requestData}[appActivity]     noReset=${requestData}[noReset]
    sleep  2
chose gun
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${els}     get webelements     id=com.ytny.os.pos:id/tv_number
    ${el}      my find el from els by text  ${els}     ${requestData}[gunNum]
    click element  ${el}

input oil amt
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_money
    input text  ${el}   ${requestData}[oil_amt]

    ${el}     get webelement     id=com.ytny.os.pos:id/tv_sure
    click element  ${el}

chose pay method
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${el}     get webelement     id=com.ytny.os.pos:id/tv_all
    click element  ${el}

    ${els}     get webelements     id=com.ytny.os.pos:id/tv_name
    ${el}      my find el from els by text  ${els}     ${requestData}[pay_method]
    click element  ${el}

commite pay
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_sumit
    click element  ${el}

close small change window
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}
    ${el}     get webelement     id=com.ytny.os.pos:id/tv_back
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

    ${el}     get webelement     id=com.ytny.os.pos:id/tv_all
    click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/rl_about_member
    click element  ${el}

    ${el}     get webelement     id=com.ytny.os.pos:id/mInputPassword
    input text      ${el}   ${requestData}[mobile]

    ${el}     get webelement     id=com.ytny.os.pos:id/notice_dialog_confirm
    click element  ${el}

input_userCard_pwd
    [Arguments]  ${csv_path}    ${test_name_kw_name}
    ${requestData}=     read csv test data      ${csv_path}    ${test_name_kw_name}

    ${el}     get webelement     id=com.ytny.os.pos:id/et_member_pwd
    input text      ${el}   ${requestData}[userCard_pwd]


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