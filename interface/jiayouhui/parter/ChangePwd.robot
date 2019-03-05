*** Settings ***
Library  ../../../lib/InterfaceRequest.py
Library  ../../../db/SqlAPI.py

*** Variables ***
${ChangePwd url}    /Parter/ChangePwd
${CheckMobile url}  /Parter/CheckMobile
${mobile}   19903040945

*** Test Cases ***
Class_01
    parter interface post    ${CheckMobile url}  {"mobile": ${mobile}}
    test
    ${res}=    sql exec    "SELECT * FROM pit_member_sms WHERE mobile ='${mobile}' ORDER BY send_time desc "

