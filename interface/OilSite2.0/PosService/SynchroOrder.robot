
*** Settings ***
Resource  ../userKeyWords.robot
Test Setup     mySetUp
*** Variables ***
${SynchroOrderCSV}  interface/OilSite2.0/PosService/SynchroOrder.csv

*** Test Cases ***
pos goods cash order
    QueryOnlienUser     ${SynchroOrderCSV}  pos_goods_cash_order_QueryOnlienUser
    oilTradeList     ${SynchroOrderCSV}  pos_goods_cash_order_oilTradeList
    CalcOilCoupon       ${SynchroOrderCSV}  pos_goods_cash_order_CalcOilCoupon
#    VerifyCouponOrder
#    SynchroOrder