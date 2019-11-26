

*** Settings ***
Resource  ../userKeyWords.robot

*** Test Cases ***
State Transitions User Ticket
    #订单分很多种，公众号、车队卡、小pos、大pos等，应尽量将所有订单都实现
    user order
    user application invoice
    #查询发票列表，验证发票状态，每隔95s查询验证一次
    site ticket queue list
    sleep  95
    site ticket queue list
    sleep  95
    site ticket queue list
    sleep  95
    site ticket queue list
