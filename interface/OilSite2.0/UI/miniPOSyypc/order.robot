

*** Settings ***
Resource  userKeyWordsMiniPOSyypc.robot
Test Setup  my_test_setup

*** Variables ***
${csv_path}     interface/oilsite2.0/ui/miniPOSyypc/demo.csv
*** Test Cases ***
demo
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    chose gun   ${csv_path}     demo_chose_gun
    input oil amt   ${csv_path}     demo_input_oil_amt
    chose pay method    ${csv_path}     demo_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    continue_to_check_out    ${csv_path}     demo

order_goods_cash
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    not_add_oil   ${csv_path}    demo
    input_goods_amt   ${csv_path}     order_goods_cash_input_goods_amt
    chose pay method    ${csv_path}     order_goods_cash_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    continue_to_check_out    ${csv_path}     demo

order_oil_goods_cash
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    chose gun   ${csv_path}     demo_chose_gun
    input oil amt   ${csv_path}     demo_input_oil_amt
    input_goods_amt   ${csv_path}     order_goods_cash_input_goods_amt
    chose pay method    ${csv_path}     demo_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    continue_to_check_out    ${csv_path}     demo

order_goods_userCard_score
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    not_add_oil   ${csv_path}    demo
    input_user     ${csv_path}    order_oil_userCard_input_user
    input_goods_amt   ${csv_path}     order_goods_cash_input_goods_amt
    chose pay method    ${csv_path}     order_goods_userCard_score_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd
    continue_to_check_out    ${csv_path}     demo

order_oil_userCard
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    chose gun   ${csv_path}     order_oil_userCard_chose_gun
    input_user     ${csv_path}    order_oil_userCard_input_user
    input oil amt   ${csv_path}     order_oil_userCard_input_oil_amt
    chose pay method    ${csv_path}     order_oil_userCard_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd
    continue_to_check_out    ${csv_path}     demo

order_oil_goods_userCard
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    chose gun   ${csv_path}     order_oil_userCard_chose_gun
    input_user     ${csv_path}    order_oil_userCard_input_user
    input oil amt   ${csv_path}     order_oil_userCard_input_oil_amt
    input_goods_amt   ${csv_path}     order_goods_cash_input_goods_amt
    chose pay method    ${csv_path}     order_oil_userCard_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd
    continue_to_check_out    ${csv_path}     demo
#todo 后续用例待完成

order_oil_fleetCard
    open app    ${csv_path}    demo_open_app
    go_into_check_out   ${csv_path}    go_into_check_out
    chose gun   ${csv_path}     order_oil_userCard_chose_gun
    input_user     ${csv_path}    order_oil_fleetCard_input_user
    input oil amt   ${csv_path}     order_oil_fleetCard_input_oil_amt
    chose pay method    ${csv_path}     order_oil_fleetCard_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    chose_fleetCard    ${csv_path}     order_oil_fleetCard_chose_fleetCard
    input_fleetCard_pwd     ${csv_path}    order_oil_fleetCard_input_fleetCard_pwd
    continue_to_check_out    ${csv_path}     demo

