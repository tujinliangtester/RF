
*** Settings ***
Resource  ../userKeyWords.robot


*** Test Cases ***

demo
    ALLOrders   ${csv_path}    demo_ALLOrders


*** Variables ***
${csv_path}    interface/OilSite2.0/GasTradeOrder/ALLOrders.csv
