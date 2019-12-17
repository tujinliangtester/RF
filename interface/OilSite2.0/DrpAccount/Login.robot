
*** Settings ***
Resource  ../userKeyWords.robot
*** Variables ***
${loginCSVpath}     interface/OilSite2.0/DrpAccount/login.csv
*** Test Cases ***
Login
    yypc login      ${loginCSVpath}     Login_yypc_login
