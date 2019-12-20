

*** Settings ***
Resource  userKeyWordsPOS.robot
Test Setup  my_test_setup

*** Variables ***
${csv_path}     ./demo.csv
*** Test Cases ***
demo
    open app    ${csv_path}    demo_open_app
    chose gun   ${csv_path}     demo_chose_gun
    input oil amt   ${csv_path}     demo_input_oil_amt
    chose pay method    ${csv_path}     demo_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    close small change window    ${csv_path}     demo

order_goods_cash
    open app    ${csv_path}    demo_open_app
    chose_goods     ${csv_path}    order_goods_cash_chose_goods
    chose pay method    ${csv_path}     order_goods_cash_chose_pay_method
    commite pay    ${csv_path}     demo_commite_pay
    close small change window    ${csv_path}     demo

order_oil_goods_cash
    open app    ${csv_path}    demo_open_app
    chose_goods     ${csv_path}    order_oil_goods_cash_chose_goods
    chose gun   ${csv_path}     demo_chose_gun
    input oil amt   ${csv_path}     demo_input_oil_amt
    chose pay method    ${csv_path}     demo_chose_pay_method
    commite pay    ${csv_path}     demo
    close small change window    ${csv_path}     demo

order_goods_userCard_score
    open app    ${csv_path}    demo_open_app
    chose_goods     ${csv_path}    order_goods_cash_chose_goods
    input_user     ${csv_path}    order_goods_userCard_score_input_user
    chose_score     ${csv_path}    demo
    chose pay method    ${csv_path}     order_goods_userCard_score_chose_pay_method
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd

order_oil_userCard
    open app    ${csv_path}    demo_open_app
    chose gun   ${csv_path}     order_oil_userCard_chose_gun
    input oil amt   ${csv_path}     order_oil_userCard_input_oil_amt
    input_user     ${csv_path}    order_oil_userCard_input_user
    chose pay method    ${csv_path}     order_oil_userCard_chose_pay_method
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd

order_oil_goods_userCard
    open app    ${csv_path}    demo_open_app
    chose_goods     ${csv_path}    order_oil_goods_cash_chose_goods
    chose gun   ${csv_path}     demo_chose_gun
    input oil amt   ${csv_path}     order_oil_goods_userCard_input_oil_amt
    input_user     ${csv_path}    order_oil_userCard_input_user
    chose pay method    ${csv_path}     order_oil_userCard_chose_pay_method
    input_userCard_pwd     ${csv_path}    order_goods_userCard_score_input_userCard_pwd

order_oil_fleetCard
    open app    ${csv_path}    demo_open_app
    chose gun   ${csv_path}     order_oil_userCard_chose_gun
    input oil amt   ${csv_path}     order_oil_fleetCard_input_oil_amt
    input_user     ${csv_path}    order_oil_fleetCard_input_user
    chose pay method    ${csv_path}     order_oil_fleetCard_chose_pay_method
    chose_fleetCard    ${csv_path}     demo
    input_fleetCard_pwd     ${csv_path}    order_oil_fleetCard_input_fleetCard_pwd
