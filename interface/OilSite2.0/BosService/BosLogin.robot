
*** Settings ***
Resource  ../userKeyWords.robot

*** Variables ***
${BosLoginCSV}   interface/OilSite2.0/BosService/BosLogin.csv
*** Test Cases ***
#BosLogin
#    BosLogin    ${BosLoginCSV}  BosLogin_BosLogin
#    GetOilPriceList
