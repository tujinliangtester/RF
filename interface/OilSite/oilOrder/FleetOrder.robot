

*** Settings ***
Resource  ../userKeyWord.robot

*** Variables ***
${OilOrderFleetOrderUrl}      /OilOrder/FleetOrder

${site_id}      35
${gun_id}       14381
${sub_card_id}
${org_amt}      100

*** Test Cases ***

#fleet_order
#    ${pcHeader}    read config   PcHeader
#    ${header}   read config   header
#    ${header_ios}   read config   header_ios
#
#    ${pay_amt}
#    ${pay_password}
#    ${res}      interface post   ${OilOrderFleetOrderUrl}   {"site_id": "${site_id}", "gun_id": "${gun_id}", "sub_card_id": "${sub_card_id}", "coupon_id": "0", "org_amt": "${org_amt}", "coupon_amt": "0", "pay_amt": "${pay_amt}", "pay_password": "${pay_password}", "r": "0.7270126540158686"}     ${header_ios}
#    should contain      ${res}      "code":1,
