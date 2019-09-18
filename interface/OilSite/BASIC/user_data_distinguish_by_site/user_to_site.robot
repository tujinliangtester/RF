*** Settings ***
Library  ../../../lib/InterfaceRequest.py
Library  ../../../lib/tools.py

Resource    ../../userKeyWord.robot


*** Variables ***
DrpMemberOffline/CreateUser HTTP/1.1


*** Keywords ***

generate_merchant_user_by_yypc
    ${res}=     pc interface post




