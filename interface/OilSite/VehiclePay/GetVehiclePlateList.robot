*** Settings ***
Resource  ../userKeyWord.robot


*** Variables ***
${VehiclePayGetVehiclePlateListUrl}     /VehiclePay/GetVehiclePlateList
${VehiclePayDeleteVehiclePlateUrl}      /VehiclePay/DeleteVehiclePlate
*** Test Cases ***
getVehiclePlateList
    ${pcHeader}    read config   PcHeader
    ${header}   read config   header

    ${res}=      interface post  ${VehiclePayGetVehiclePlateListUrl}   {"a":1}    ${header}

    ${dic}      evaluate   json.loads(u'${res}')    json
    @{list}     evaluate   list(${dic}[data])
    ${num}  evaluate   len(@{list})

    :run keyword if  ${num}>0
    :FOR    ${item}    IN   @{list}
    \   ${res}=     interface post    ${VehiclePayDeleteVehiclePlateUrl}    {"id": ${item}[id]}    ${header}
    \   should contain       ${res}  "code":1,

    ${res}=      interface post  ${VehiclePayGetVehiclePlateListUrl}   {"a":1}    ${header}
    #    删除完车牌后，接口返回code 为0
    should contain  ${res}  "code":0,




