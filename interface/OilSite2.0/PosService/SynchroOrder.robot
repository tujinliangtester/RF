
*** Settings ***
Resource  interface/OilSite2.0/userKeyWords.robot
*** Test Cases ***
pos goods cash order
    QueryOnlienUser
    CalcOilCoupon
    VerifyCouponOrder
    SynchroOrder