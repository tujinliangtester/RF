
*** Settings ***
Resource  ../userKeyWords.robot
Test Setup     Login

*** Test Cases ***

demo
    ALLOrders   ${csv_path}    demo_ALLOrders


*** Variables ***
${csv_path}    interface/OilSite2.0/GasTradeOrder/ALLOrders.csv
