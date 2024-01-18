*** Settings ***
Documentation       This is the test file for End to end testing of Gladiator WH

Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             AppiumLibrary
Library             ../../src/RheemMqtt.py
Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            ../Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot

Suite Setup         Run Keywords    connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Open App
...                     AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${select_Gladiator_location}
...                     AND    Temperature Unit in Fahrenheit
Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Gladiator_location}


*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         4608

# -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

# --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Gladiator Water Heater

# --> admin cred
${Admin_EMAIL}                          automation3@rheem.com
${Admin_PWD}                            12345678
${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

##    --> Select Device Location
${select_Gladiator_location}            Gladiator
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

##    --> Setpoint Values
${setpoint_max}                         140
${setpoint_min}                         110
${setpoint_max_C}                       60
${setpoint_min_C}                       44
${value1}                               32
${value2}                               5
${value3}                               9

## --> Gladiator WH Mode List
@{GladiatorWH_modes_List}               Disabled    Enabled

# --> Sleep Time
${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard, Equipment.
    [Tags]    testrailid=87025

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Tags]    testrailid=87026

    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment    Set Point temperature from App.
    [Tags]    testrailid=87027

    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]    testrailid=87028

    ${setpoint_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED_W}    Evaluate    ${setpoint_ED_R} + 1
    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_ED_W}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement    Set Point temperature from App.
    [Tags]    testrailid=87029

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-06:User should be able to decrement Set Point temperature from Equipment.
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment.
    [Tags]    testrailid=87030

    ${setpoint_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED_W}    Evaluate    ${setpoint_ED_R} - 1
    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_ED_W}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 140F.
    [Documentation]    Max temperature that can be set from App should be 140F.
    [Tags]    testrailid=87031

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.
    [Tags]    testrailid=87032
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-09:Max temperature that can be set from Equipment should be 140F.
    [Documentation]    Max temperature that can be set from Equipment should be 140F.
    [Tags]    testrailid=87033

    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 110F.
    [Documentation]    Min temperature that can be set from Equipment should be 110F.
    [Tags]    testrailid=87034
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App
    [Tags]    testrailid=87035

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-12:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=87036

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Decrement setpoint
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.
    [Tags]    testrailid=87037

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 43C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C.
    [Tags]    testrailid=87038

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C.
    [Tags]    testrailid=87039

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    convert to integer    60
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 43C.
    [Documentation]    Min temperature that can be set from App should be 43C.
    [Tags]    testrailid=87040

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    convert to integer    43
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App
    [Tags]    testrailid=87041

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App
    [Tags]    testrailid=87042

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    convert to integer    43
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user set temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from App
    [Tags]    testrailid=87043

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Fahrenheit
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${sleep_10s}
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=87044

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    Sleep    ${sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    page should contain element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    Should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Go back

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=87045

    ${setpoint_ED}    Write objvalue From Device
    ...    119
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-22:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=87046

    ${setpoint_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    page should contain element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    Should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Tags]    testrailid=87047

    ${changeModeValue}    Set Variable    0
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set Disabled state
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Disable
    Go back
    page should contain element    //*[contains(@text, 'Disabled')]
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${GladiatorWH_modes_List}    ${mode_ED}

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=87048
    Navigate to Detail Page    ${deviceText}
    Set Enable state
    Sleep    ${Sleep_5s}
    ${Setpoint}    Get setpoint from details screen
    page should contain text    ${Setpoint}
    page should contain element    ${Increment_Temp}
    Go back
    page should contain element    ${WH_get_EC_SetPointValue}
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_ED}
    ${mode_name}    Get From List    ${GladiatorWH_modes_List}    ${mode_ED}
    Should be equal    ${mode_name}    Enabled

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.
    [Tags]    testrailid=87049

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Sleep    ${Sleep_5s}
    Page should contain text    Disabled
    Should be equal as strings    ${GladiatorWH_modes_List}[${mode_set_ED}]    Disabled

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=87050

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Sleep    ${Sleep_5s}
    page should contain text    Enabled
    Go back
    Should be equal as strings    ${GladiatorWH_modes_List}[${mode_set_ED}]    Enabled

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]    testrailid=87051

    Run keyword and ignore error    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    click element    ${Full_Screen_Mode}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Go back
    Go back

TC-28:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week
    [Tags]    testrailid=87052

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Weekly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-29:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month
    [Tags]    testrailid=87053

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-30:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year
    [Tags]    testrailid=87054

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-31:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater
    [Tags]    testrailid=87055

    Select Device Location    ${select_Gladiator_location}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_10s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Away_status_ED}    1

TC-32:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater
    [Tags]    testrailid=87056

    Select Device Location    ${select_Gladiator_location}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_10s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Away_status_ED}    0

TC-33:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App
    [Tags]    testrailid=87057

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${get_current_set_point}    Gladiator WH Follow Schedule Data    Schedule
    Go back
    Wait Until Page Contains    ${deviceText}    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${setpoint_M_DP}    ${get_current_set_point}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_ED}    ${get_current_set_point}

TC-34:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=87058

    Navigate to detail page    ${deviceText}
    Sleep    ${Sleep_5s}
    Gladiator WH COPY Schedule Data    Schedule
    Go back
    Go back

TC-35:Change the Scheduled temperature from App
    [Documentation]    Change the Scheduled temperature from App
    [Tags]    testrailid=87059

    Navigate to Detail Page    ${deviceText}
    wait until page contains element    ${WH_product_setting}    ${Default_Timeout}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Increment set point
    Sleep    ${Sleep_5s}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    ${Sleep_10s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as strings    ${setpoint_ED}    ${setpoint_M_EC}

TC-36:User should be able to Resume Schedule when scheduled temperature is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow.
    [Tags]    testrailid=87060

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click Text    Resume
    Sleep    15s
    page should contain text    Following Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_DP}    ${setpoint_M_EC}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as strings    ${setpoint_M_DP}    ${setpoint_ED}
    Should be equal as strings    ${setpoint_M_EC}    ${setpoint_ED}

TC-37:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=87061

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Scheduled_Temp1}    Gladiator WH Update Setpoint From Schedule screen    Schedule
    Wait Until Page Contains    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as strings    ${setpoint_M_DP}    ${Scheduled_Temp1}
    Page Should Contain Text    Following Schedule
    Sleep    ${Sleep_5s}
    Go back
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_ED}    ${setpoint_M_DP}

TC-38:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=87062

    Navigate to Detail Page    ${deviceText}
    Unfollow the schedule    Schedule
    Sleep    10s
    page should not contain text    Following Schedule

TC-39:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice
    [Tags]    testrailid=87063

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HEATCTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    60s
    Page should not contain text    Running
    Go back
    [Teardown]    Start Appium Server

TC-40:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice
    [Tags]    testrailid=87064

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HEATCTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    Go back
    Page should contain text    Running
