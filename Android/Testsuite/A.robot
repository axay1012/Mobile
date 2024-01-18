*** Settings ***
Documentation       This is the test file for End to end testing of Dragon WH

Library             Collections
Library             String
Library             OperatingSystem
Library             AppiumLibrary
Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            ../Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot
Library             ../../src/RheemMqtt.py

#Suite Setup         Run Keywords
#...                     AND    Open App
#...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
#...                     AND    Select Device Location    ${select_Dragon_location}
#Suite Teardown      Close All Apps
#Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Dragon_location}
#

*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5
${EndDevice_id}                         16512

# -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

# --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          heatpumpWaterHeaterGen4

# --> admin cred
${Admin_EMAIL}                          jaymala.kumari+888@volansys.com
${Admin_PWD}                            jammi888
${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

##    --> Select Device Location
${select_Dragon_location}               Dragon
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

##    --> Dragon WH Setpoint Value
${setpoint_max}                         185
${setpoint_min}                         85
${setpoint_max_C}                       85
${setpoint_min_C}                       30
${value1}                               32
${value2}                               5
${value3}                               9

##    --> Dragon WH Mode List
@{Dragon_modes_List}                    Disabled    Enabled
@{Schedule_modes_List}                  Unoccupied    Occupied
@{ShutOff_Config}                       Closed if Leak Detected    Closed if Unocc. Leak Detect    Open    Closed
@{RecircPump_Config}                    Off    On    Schedule    Schedule On    On Demand

## --> Sleep Time
${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=90969

    connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLTYPE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    log to console    ${setpoint_ED}