*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Gen4 Test Suite

Library             AppiumLibrary
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Library             ../../src/RheemCustom.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameHPWH}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4096

#    -->cloud url and env
${URL}                                  https://rheemstaging.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               cef4eac80bdcd8acfd948ac1b04f
${SECKEY}                               CEF4EAC80BACF6FDFDD0B2FDAF8A01

*** Test Cases ***
afdkh

    Connect    rheemautomation+j21@gmail.com    rheem123    ${SYSKEY}    ${SECKEY}    ${URL}
    ${mode_get_ED}    Test
    ...    WHTRSETP
    ...    F0-03-8C-C3-D1-D7
    ...    0c-16-11-17-0e-02-47-31-01
    ...    4544

    Log to console    ${mode_get_ED}