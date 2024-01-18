*** Settings ***
Documentation       This is the test file for End to end testing of HPWH

Library             Collections
Library             String
Library             OperatingSystem
Library             AppiumLibrary
Library             ../../src/RheemMqtt.py
Library             ../../src/common/Android_Handler.py
Library             ../../src/RheemMqtt.py
Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            ../Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot

Suite Setup         Run Keywords    Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    HPWH
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Run Keywords    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${Select_HPWH_location}


*** Variables ***
# -->test applince script info

${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4126

# -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

# --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          HeatPumpWaterHeaterGen4

# --> admin cred

${emailId}                               %{HPWH_Email}
${passwordValue}                         %{HPWH_Password}

# --> Select Device Location
${Select_HPWH_location}                 NewECC
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

# --> Setpoint Values
${setpoint_max}                         140
${setpoint_min}                         110
${setpoint_max_C}                       60
${setpoint_min_C}                       44
${value1}                               32
${value2}                               5
${value3}                               9

# --> Sleep Time
${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard, Equipment.
    [Tags]    testrailid=83735

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
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
    [Tags]    testrailid=83736

    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment    Set Point temperature from App.
    [Tags]    testrailid=83737

    Navigate to Detail Page    ${deviceText}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]    testrailid=83738

    ${setpoint_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED_W}    Evaluate    ${setpoint_ED_R} + 1
    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_ED_W}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement    Set Point temperature from App.
    [Tags]    testrailid=83739

    Navigate to Detail Page    ${deviceText}
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

TC-06:User should be able to decrement Set Point temperature from Equipment.
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment.
    [Tags]    testrailid=83740

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
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 140F.
    [Documentation]    Max temperature that can be set from App should be 140F.
    [Tags]    testrailid=83741

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.
    [Tags]    testrailid=83742

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
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
    [Tags]    testrailid=83743

    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 110F.
    [Documentation]    Min temperature that can be set from Equipment should be 110F.
    [Tags]    testrailid=83744

    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App
    [Tags]    testrailid=83745

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    go back
    ${setpoint_M_EC}    Convert to integer    140
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
    [Tags]    testrailid=83746

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
    go back
    Should be equal as integers    110    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    110

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.
    [Tags]    testrailid=83747

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
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
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 43C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C.
    [Tags]    testrailid=83748

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C.
    [Tags]    testrailid=83749

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
    ${result2}    Convert to integer    ${result1}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Convert to integer    60
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 43C.
    [Documentation]    Min temperature that can be set from App should be 43C.
    [Tags]    testrailid=83750

    temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
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
    ${result2}    Convert to integer    ${result1}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Convert to integer    43
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App
    [Tags]    testrailid=83751

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
    ${result2}    Convert to integer    ${result1}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Convert to integer    60
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App
    [Tags]    testrailid=83752

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
    ${result2}    Convert to integer    ${result1}
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    Convert to integer    43
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from App
    [Tags]    testrailid=83753

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
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
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Go back

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=83754

    Navigate to Detail Page    ${deviceText}
    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    page should contain element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    Should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Go back

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=83755

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}

TC-22:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=83756

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    122
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
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Contain Element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    Should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Go back

TC-23:User should be able to set Off mode from App
    [Documentation]    User should be able to set Off mode from App for heat pump Water heater.
    [Tags]    testrailid=83757

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    0
    ${set_mode_M}    WH Set Mode    OFF
    Go Back
    ${cur_mode_M_EC}    Get Disabled mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC}    Disabled
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC}

TC-24:User should be able to set Energy Saver mode from App
    [Documentation]    User should be able to set Automate Savings mode from App for heat pump Water heater.
    [Tags]    testrailid=83758

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    1
    ${set_mode_M}    WH Set Mode    ${HPWH_modes_List}[${changeModeValue}]
    Go Back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC}    ${set_mode_M}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC}

TC-25:User should be able to set Heat Pump mode from App
    [Documentation]    User should be able to set Most Efficient mode from App for heat pump Water heater.
    [Tags]    testrailid=83759

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    WH Set Mode    ${HPWH_modes_List}[${changeModeValue}]
    Go Back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC.strip()}    ${set_mode_M}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC.strip()}

TC-26:User should be able to enable Energy Saver mode after changing another mode from App.
    [Documentation]    User should be able to enable Energy Saver mode after changing another mode from App.
    [Tags]    testrailid=83760

    Navigate to Detail Page    ${deviceText}
    Changing Energy Saver mode from the caution message
    ${cur_mode_M_DP}    WH Get Mode
    go back
    sleep    ${Sleep_5s}
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC}    ${cur_mode_M_DP}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_DP}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC}

TC-27:User should be able to set High Demand mode from App
    [Documentation]    User should be able to set High Demand mode from App for heat pump Water heater.
    [Tags]    testrailid=83761

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    3
    ${set_mode_M}    WH Set Mode    ${HPWH_modes_List}[${changeModeValue}]
    Go Back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC}    ${set_mode_M}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC}

TC-28:User should be able to set Electric mode from App
    [Documentation]    User should be able to set Electric mode from App for heat pump Water heater.
    [Tags]    testrailid=83762

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    4
    ${set_mode_M}    WH Set Mode    ${HPWH_modes_List}[${changeModeValue}]
    Go Back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${cur_mode_M_EC}    ${set_mode_M}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes_List}[${mode_ED}]    ${cur_mode_M_EC}

TC-29:User should be able to set Off mode from Equipment
    [Documentation]    User should be able to set Off mode from Equipment for heat pump Water heater.
    [Tags]    testrailid=83763

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    WH Get Mode
    should not be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}
    go back
    ${cur_mode_M_EC}    get Disabled mode from equipment card    ${Disabled_Text}
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_EC}
    Should be equal as strings    Disabled    ${cur_mode_M_EC}

TC-30:User should be able to set Energy Saver mode from Equipment
    [Documentation]    User should be able to set Automate Savings mode from Equipment for heat pump Water heater.
    [Tags]    testrailid=83764

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    WH Get Mode
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}
    Go back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_EC}

TC-31:User should be able to set Heat Pump mode from Equipment
    [Documentation]    User should be able to set Most Efficient mode from Equipment for heat pump Water heater.
    [Tags]    testrailid=83765

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    WH Get Mode
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}
    go back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_EC.strip()}

TC-32:User should be able to set High Demand mode from Equipment
    [Documentation]    User should be able to set High Demand mode from Equipment for heat pump Water heater.
    [Tags]    testrailid=83766

    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    WH Get Mode
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}
    go back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_EC}

TC-33:User should be able to set Electric mode from Equipment
    [Documentation]    User should be able to set Electric mode from Equipment for heat pump Water heater.
    [Tags]    testrailid=83767

    ${changeModeValue}    Set Variable    4
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    WH Get Mode
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}
    Go back
    ${cur_mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${HPWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_EC}

TC-34:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]    testrailid=83768

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    click element    ${Full_Screen_Mode}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    go back
    go back

TC-35:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week
    [Tags]    testrailid=83769

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    Get Energy Usage data    Weekly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    go back
    go back

TC-36:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month
    [Tags]    testrailid=83770

    Navigate to Detail Page    ${deviceText}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-37:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year
    [Tags]    testrailid=83771

    Navigate to Detail Page    ${deviceText}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-38:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater
    [Tags]    testrailid=83772

    Select Device Location    ${Select_HPWH_location}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-39:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater
    [Tags]    testrailid=83773

    Select Device Location    ${Select_HPWH_location}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0

TC-40:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature and mode from App
    [Tags]    testrailid=83774

    Navigate to Detail Page    ${deviceText}
    ${get_current_set_point}    ${get_current_mode}    HPWH Follow Schedule Data    Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    ${mode_M_DP}    WH Get Mode
    Should be equal as integers    ${setpoint_M_DP}    ${get_current_set_point}
    Should be equal as strings    ${mode_M_DP}    ${get_current_mode.strip()}
    Page Should Contain Text    Following Schedule
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    sleep    ${Sleep_10s}
    ${Mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    Should be equal as strings    ${Mode_M_EC}    ${get_current_mode}

############################ Validating Temperature Value and Mode On End Device ####################
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_ED}    ${get_current_set_point}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Convert to integer    ${mode_ED}
    Should be equal as strings    ${HPWHGen5_modes_List}[${mode_ED}]    ${get_current_mode.strip()}

TC-41:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=83775

    Navigate to Detail Page    ${deviceText}
    HPWH Copy Schedule Data    Schedule
    Go Back
    Go Back

TC-42:Change the Scheduled temperature and mode from App.
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=83776

    Navigate to Detail Page    ${deviceText}
    ${mode_M_DP}    WH Get Mode
    sleep    ${Sleep_5s}
    click element    ${WH_changemode}
    IF    '${mode_M_DP}' == 'OFF'
        click element    ${Energy_mode}
    ELSE IF    '${mode_M_DP}' == 'ENERGY SAVING'
        click element    ${Heatpump_mode}
    ELSE IF    '${mode_M_DP}' == 'HEAT PUMP ONLY'
        click element    ${Highdemand_mode}
    ELSE IF    '${mode_M_DP}' == 'HIGH DEMAND'
        click element    ${Electric_mode}
    ELSE IF    '${mode_M_DP}' == 'ELECTRIC MODE'
        click element    ${Off_mode}
    END
    Sleep    ${Sleep_10s}
    Page Should Contain Text    Schedule overridden
    ${mode_M_DP1}    WH Get Mode
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeModeValue}    Set Variable    ${mode_ED}
    Should be equal as strings    ${HPWH_modes_List}[${changeModeValue}]    ${mode_M_DP1}
    click element    ${Resume_Button}
    sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Increment set point
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Schedule overridden
    ${setpoint_M_DP1}    Validate set point Temperature From Mobile
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP1}
    sleep    ${Sleep_5s}
    click element    ${Resume_Button}
    sleep    ${Sleep_5s}
    go back

TC-43:User should be able to Resume Schedule when scheduled temperature is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow.
    [Tags]    testrailid=83777
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Schedule overridden
    click Text    Resume
    sleep    ${Sleep_5s}
    page should contain text    Following Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_DP}    ${setpoint_M_EC}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    Should be equal as strings    ${setpoint_M_DP}    ${setpoint_ED}
    Should be equal as strings    ${setpoint_M_EC}    ${setpoint_ED}

TC-44:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=83778

    Navigate to Detail Page    ${deviceText}
    ${Scheduled_Mode1}    ${Scheduled_Temp1}    HPWH Update Setpoint and Mode From Schedule screen    Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    ${mode_M_DP}    WH Get Mode
    Should be equal as strings    ${setpoint_M_DP}    ${Scheduled_Temp1}
    Should be equal as strings    ${Scheduled_Mode1}    ${mode_M_DP}
    Page Should Contain Text    Following Schedule    go back
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeModeValue}    Set Variable    ${mode_ED}
    Should be equal as strings    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as strings    ${HPWH_modes_List}[${changeModeValue}]    ${mode_M_DP}

TC-45:User should be able to Resume Schedule when scheduled mode is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled mode is not follow.
    [Tags]    testrailid=83779

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    3
    ${set_mode_M}    WH Set Mode    ${HPWH_modes_List}[${changeModeValue}]
    sleep    ${Sleep_5s}
    page should contain text    Schedule overridden
    click text    Resume
    sleep    ${Sleep_5s}
    page should contain text    Following Schedule
    ${mode_M_DP}    WH Get Mode
    sleep    ${Sleep_5s}
    go back
    ${mode_M_EC}    Get mode from equipment card    ${deviceText}
    Should be equal as strings    ${mode_M_DP}    ${mode_M_EC}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeModeValue}    Set Variable    ${mode_ED}
    Should be equal as strings    ${mode_M_DP}    ${HPWH_modes_List}[${changeModeValue}]

TC-46:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=83780

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    Unfollow the schedule    Schedule
    page should not contain text    Following Schedule

TC-47:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=83781

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    COMP_RLY
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    FAN_CTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}
    page should contain text    Running
    go back

TC-48:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=83782

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    COMP_RLY
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    FAN_CTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_10s}
    Swipe    994    2058    937    1537    1000
    page should not contain text    Running
    Go back

TC-49:Max temperature that can be set from App should be 140F.
    [Documentation]    Max temperature that can be set from App should be 140F.

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Increment set point
    sleep    ${sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-50:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-51:User should not be able to exceed max setpoint limit i.e. 140F from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-52:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    Decrement setpoint
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-53:User should be able to Change the temperature value from the Schedule screen.
    [Documentation]    User should be able to Change the temperature value from the Schedule screen.

    Navigate to Detail Page    ${deviceText}
    ${Scheduled_Temp1}    Change Schedule Temperature Using Inc/Dec Button HPWH    Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Following Schedule
    Should be equal as strings    ${setpoint_M_DP}    ${Scheduled_Temp1}
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_EC}    ${Scheduled_Temp1}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_ED}    ${Scheduled_Temp1}

TC-54:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow

    Navigate to Detail Page    ${deviceText}
    click element    ${Increment_Temp}
    sleep    ${Sleep_5s}
    page should contain text    Schedule overridden
    click element    ${Resume_Button}
    sleep    ${Sleep_5s}
    page should contain text    Following Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    sleep    ${Sleep_5s}
    go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as strings    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setpoint_M_DP}    ${setpoint_ED}
    Should be equal as strings    ${setpoint_M_EC}    ${setpoint_ED}

TC-55:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App.

    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-56:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go Back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpointED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

Verify UI of Network Settings screen
    [Documentation]    Verify UI of Network Settings screen

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    Click Element    ${Settings_Details}
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status}    Click Element    Network
    sleep    ${Sleep_5s}
    ${MAC}    Get Text    ${MAC_Address}
    Should Be Equal    ${MAC}    MAC Address
    ${Network_Name}    Get Text    ${Network_SSID}
    Should Be Equal    ${Network_Name}    Network SSID
    Sleep    ${Sleep_5s}
    ${IP_Add}    Get Text    ${IP_Address}
    Should Be Equal    ${IP_Add}    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    Navigate to Detail Page    ${deviceText}
    wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${modeVal}    Set Schedule in Screen Maximum temp    140    ${Increment_Temp}
    Navigate to Detail Page    ${deviceText}

Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    Navigate to Detail Page    ${deviceText}
    wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${modeVal}    Set Schedule in Screen Maximum temp    140    ${Increment_Temp}
    Navigate to Detail Page    ${deviceText}

Verfiy device specific alert on equipment card
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${device notification}
    IF    ${Status}
        Click Element    ${device notification}
        Verify Device Alerts
    END

Verfiy device specific alert on detail screen
    Navigate to Detail Page    ${deviceText}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${notification_icon}
    IF    ${Status}
        Click Element    ${notification_icon}
        Verify Device Alerts
    END
