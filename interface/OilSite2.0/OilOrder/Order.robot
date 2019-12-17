
*** Settings ***
Resource  ../userKeyWords.robot

*** Variables ***
${orderCsvPath}     interface/OilSite2.0/OilOrder/Order.csv

*** Test Cases ***

Class_01
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     Class_01_TicketList
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil


userCard_oil_score
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     Class_01_TicketList
    ReadyPayMoney   ${orderCsvPath}    Class_01_ReadyPayMoney
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil

userCard_goods_score
    #下单不能过于频繁
    sleep  10
    ProductSettlement   ${orderCsvPath}     userCard_goods_score_ProductSettlement
    FeiyouReadyPayMoney     ${orderCsvPath}     userCard_goods_score_FeiyouReadyPayMoney
    FeiyouOrder     ${orderCsvPath}     userCard_goods_score_FeiyouOrder
    PayOil  ${orderCsvPath}    Class_01_PayOil

userCard_oil_and_goods_score
    #下单不能过于频繁
    sleep  10
    TicketList  ${orderCsvPath}     userCard_oil_and_goods_score_TicketList
    ReadyPayMoney   ${orderCsvPath}    Class_01_ReadyPayMoney
    order   ${orderCsvPath}    Class_01_order
    PayOil  ${orderCsvPath}    Class_01_PayOil

#todo 车队卡支付订单，小pos、大pos订单
FleetOrder
    #下单不能过于频繁
    sleep  10
    SiteSubFleetList   ${orderCsvPath}     FleetOrder_SiteSubFleetList
    FleetReadyPayMoney  ${orderCsvPath}     FleetOrder_FleetReadyPayMoney
    FleetOrder  ${orderCsvPath}     FleetOrder_FleetOrder







