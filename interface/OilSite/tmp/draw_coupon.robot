#2019年5月30日10:39:45
#为测试非油券，临时增加

*** Settings ***

Resource    ../userKeyWord.robot

*** Test Cases ***
哈哈
    log  1111
#类生产
#class
#    @{activity_id_list}   evaluate   list(${activity_id_str})
#    :FOR    ${activity_id}    IN   @{activity_id_list}
#    \    handdleActivity     ${activity_id}      0
#    sql interface post raw     ${DjangoRawSqlFunUrl}     {"SQL":"DELETE${SPACE}from${SPACE}${SPACE}pit_market_coupon_to_user${SPACE}WHERE${SPACE}user_id${SPACE}in${SPACE}(3784)"}
#

#    drawCoupon  722
#    drawCoupon  721
#    drawCoupon  720
#    drawCoupon  719
#    drawCoupon  718
#    drawCoupon  717
#    drawCoupon  716
#    drawCoupon  715
#    drawCoupon  714
#    drawCoupon  713
#    drawCoupon  712
#    drawCoupon  711

#    测试环境
#class
##    sql interface post raw     ${DjangoRawSqlFunUrl}     {"SQL":"DELETE${SPACE}from${SPACE}${SPACE}pit_market_coupon_to_user${SPACE}WHERE${SPACE}user_id${SPACE}in${SPACE}(SELECT${SPACE}id${SPACE}FROM${SPACE}pit_member_user${SPACE}WHERE${SPACE}mobile${SPACE}='19905301024');"}
#
##    @{activity_id_list}   evaluate   list(${activity_id_str})
##    :FOR    ${activity_id}    IN   @{activity_id_list}
##    \    handdleActivity     ${activity_id}      1
#
#    drawCoupon  850
#    drawCoupon  849
#    drawCoupon  848
#    drawCoupon  847
#    drawCoupon  846
#    drawCoupon  845
#    drawCoupon  844
#    drawCoupon  843
#    drawCoupon  842
#    drawCoupon  841
#    drawCoupon  840
#    drawCoupon  839


#prepare_activity
#
#    @{activity_id_list}   evaluate   list(${activity_id_str})
#    :FOR    ${activity_id}    IN   @{activity_id_list}
#    \    handdleActivity     ${activity_id}      0



