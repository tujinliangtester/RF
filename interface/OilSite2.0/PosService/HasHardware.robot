

*** Settings ***
Resource  E:/tjl/RF/interface/OilSite2.0/userKeyWords.robot


*** Test Cases ***
#Class_01
#    pos login
#    ${res_list}=    HasHardware
#    should be equal as numbers  ${res_list}[0][code]  1

*** Keywords ***
HasHardware
    ${ts}=   Get Current Date   exclude_millis=True
    ${requestData}=     read csv test data  interface/OilSite2.0/PosService/HasHardware.csv    Class_01_HasHardware
    set to dictionary   ${requestData}    ts=${ts}
    set to dictionary   ${requestData}    postoken=${poslogin_data_json}[postoken]
    ${sign}=        mySign  ${requestData}
    set to dictionary   ${requestData}    sign=${sign}

    ${res}    post request    posSess     /PosService/HasHardware         data=${requestData}
    ${res_list}     deal http response  ${res}      data
    return from keyword  ${res_list}

