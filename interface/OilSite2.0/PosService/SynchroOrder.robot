
*** Settings ***
Resource  ../userKeyWords.robot
Test Setup     mySetUp
*** Variables ***
${SynchroOrderCSV}  interface/OilSite2.0/PosService/SynchroOrder.csv

*** Test Cases ***
pos_goods_cash_order
    sleep  10
    QueryOnlienUser     ${SynchroOrderCSV}  pos_goods_cash_order_QueryOnlienUser
    oilTradeList     ${SynchroOrderCSV}  pos_goods_cash_order_oilTradeList
    CalcOilCoupon       ${SynchroOrderCSV}  pos_goods_cash_order_CalcOilCoupon
    VerifyCouponOrder   ${SynchroOrderCSV}  pos_goods_cash_order_VerifyCouponOrder
#    todo 对于app，如果app本身有较多、较负责的逻辑和数据库处理时，这时再来做对服务器的接口测试，有点脱离了测试的本质，因为需要自己写代码来实现app的某些功能
#   对于这个问题，目前好像没有特别好的办法，只能做UI自动化了，要不干脆，直接做UI自动化？或者，web(移动端web和pcweb)的可以直接接口，而app的直接UI
#   另外还有个问题就是，我目前是用功能测试的用例来进行自动化用例的编写，其实做接口自动化，最好的还是从接口测试的用例来生成
#    SynchroOrder