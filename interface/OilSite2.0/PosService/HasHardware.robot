

*** Settings ***
Resource  E:/tjl/RF/interface/OilSite2.0/userKeyWords.robot


*** Test Cases ***
Class_01
    pos login
    HasHardware


*** Keywords ***
HasHardware
    ${ts}=   Get Current Date   exclude_millis=True
    ${HasHardwareData}=     read csv test data  interface/OilSite2.0/PosService/HasHardware.csv    Class_01_HasHardware
    set to dictionary   ${HasHardwareData}    ts=${ts}
    set to dictionary   ${HasHardwareData}    postoken=${postoken}
    ${sign}=        mySign  ${HasHardwareData}
    set to dictionary   ${HasHardwareData}    sign=${sign}
    ${res}    post request    posSess     /PosService/HasHardware         data=${HasHardwareData}

