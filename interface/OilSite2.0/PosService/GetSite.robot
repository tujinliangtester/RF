*** Settings ***
Resource  E:/tjl/RF/interface/OilSite2.0/userKeyWords.robot

*** Test Cases ***
Class_01
    pos login
    ${res_list}=    GetSite
    should be equal as numbers  ${res_list}[0][code]  1

*** Keywords ***
GetSite
    ${requestData}=     read csv test data  interface/OilSite2.0/PosService/GetSite.csv    Class_01_GetSite
    ${ts}=   Get Current Date   exclude_millis=True
    set to dictionary   ${requestData}    ts=${ts}
    set to dictionary   ${requestData}    postoken=${poslogin_data_json}[postoken]
    ${sign}=        mySign  ${requestData}
    set to dictionary   ${requestData}    sign=${sign}

    ${res}    post request    posSess     /PosService/GetSite         data=${requestData}
    ${res_list}     deal http response  ${res}
    return from keyword  ${res_list}
