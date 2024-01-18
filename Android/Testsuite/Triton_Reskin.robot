*** Settings ***
Documentation       This is the test file for End to end testing of Triton WH

Library             RequestsLibrary
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

Suite Setup         Run Keywords    Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${select_Triton_location}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Triton_location}


*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         4544

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
${Admin_EMAIL}                          automationtest@rheem.com
${Admin_PWD}                            rheem124
${emailId}                              automationtest@rheem.com
${passwordValue}                        12345678

##    --> Select Device Location
${select_Triton_location}               Triton
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

##    --> Setpoint Value
${setpoint_max}                         185
${setpoint_min}                         85
${setpoint_max_C}                       85
${setpoint_min_C}                       29
${value1}                               32
${value2}                               5
${value3}                               9

##    --> Triton WH Mode List
@{GladiatorWH_modes_List}               Disabled    Enabled
@{Schedule_modes_List}                  Unoccupied    Occupied

${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s

*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard, Equipment.
    [Tags]    testrailid=89419

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${OccupiedValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${OccupiedValue}
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Increment set point
    ${setpoint_M_DP}    get setpoint from details screen
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
    [Tags]    testrailid=89420

    ${setpoint_ED}    Write objvalue From Device
    ...    86
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

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment    Set Point temperature from App.
    [Tags]    testrailid=89421

    Navigate to Detail Page    ${deviceText}
    Increment set point
    ${setpoint_M_DP}    get setpoint from details screen
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

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]    testrailid=89422

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
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement    Set Point temperature from App.
    [Tags]    testrailid=89423

    Navigate to Detail Page    ${deviceText}
    Decrement setpoint
    ${setpoint_M_DP}    get setpoint from details screen
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
    [Tags]    testrailid=89424

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
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 185F.
    [Documentation]    Max temperature that can be set from App should be 185F.
    [Tags]    testrailid=89425

    ${setpoint_ED}    Write objvalue From Device
    ...    184
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Increment set point
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    185
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    185
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 85F.
    [Documentation]    Min temperature that can be set from App should be 85F.
    [Tags]    testrailid=89426

    ${setpoint_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Decrement setpoint
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    85
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-09:Max temperature that can be set from Equipment should be 185F.
    [Documentation]    Max temperature that can be set from Equipment should be 185F.
    [Tags]    testrailid=89427

    ${setpoint_ED}    Write objvalue From Device
    ...    185
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 85F.
    [Documentation]    Min temperature that can be set from Equipment should be 85F.
    [Tags]    testrailid=89428

    ${setpoint_ED}    Write objvalue From Device
    ...    85
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-11:User should not be able to exceed max setpoint limit i.e. 185F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 185F from App
    [Tags]    testrailid=89429

    ${setpoint_ED}    Write objvalue From Device
    ...    185
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-12:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App
    [Tags]    testrailid=89430

    ${setpoint_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Decrement setpoint
    Go back
    ${setpoint_ED}    Write objvalue From Device
    ...    84
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    85
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:Max temperature that can be set from Equipment should be 85C.
    [Documentation]    Max temperature that can be set from Equipment should be 85C.
    [Tags]    testrailid=89431

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    185
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
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 29C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C.
    [Tags]    testrailid=89432

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    85
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
    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 85C.
    [Documentation]    Max temperature that can be set from App should be 85C.
    [Tags]    testrailid=89433

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    184
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Increment set point
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    85
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 29C.
    [Documentation]    Min temperature that can be set from App should be 29C.
    [Tags]    testrailid=89434

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    29
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 85C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App
    [Tags]    testrailid=89435

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    184
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    Increment set point
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    85
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App
    [Tags]    testrailid=89436

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    Decrement setpoint
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    29
    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user set temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from App
    [Tags]    testrailid=89437

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Fahrenheit
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
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

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=89438

    Navigate to Detail Page    ${deviceText}
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
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=89439

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
    [Tags]    testrailid=89440

    ${setpoint_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
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
    [Tags]    testrailid=89441

    ${changeModeValue}    Set Variable    0
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set Disabled state
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Disable
    Go back
    page should contain element    //*[contains(@text, 'Disabled')]
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${GladiatorWH_modes_List}    ${mode_ED}
    Should be equal    ${mode_name}    Disabled

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=89442

    Navigate to Detail Page    ${deviceText}
    Set Enable state
    Sleep    ${Sleep_5s}
    ${Setpoint}    get setpoint from details screen
    page should contain text    ${Setpoint}
    page should contain element    ${Increment_Temp}
    Go back
    page should contain element    ${WH_get_EC_SetPointValue}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${GladiatorWH_modes_List}    ${mode_ED}
    should be equal    ${mode_name}    Enabled

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.
    [Tags]    testrailid=89443

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Sleep    ${Sleep_5s}
    ${cur_mode_M_DP}    get text    ${whDisconnectText}
    Go back
    Should be equal as strings    ${GladiatorWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=89444

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    ${cur_mode_M_DP}    get text    ${whStateText}
    Go back
    Should be equal as strings    ${GladiatorWH_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]    testrailid=89445

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Go back
    Go back

TC-28:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week
    [Tags]    testrailid=89446

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Weekly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-29:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month
    [Tags]    testrailid=89447

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-30:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year
    [Tags]    testrailid=89448

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-31:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater
    [Tags]    testrailid=89449

    Select Device Location    ${select_Triton_location}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_10s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-32:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater
    [Tags]    testrailid=89450
    Select Device Location    ${select_Triton_location}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0

TC-33:Schedule the temperature and Occupied mode from App
    [Documentation]    Schedule the temperature and Occupied mode from App
    [Tags]    testrailid=89451

    Navigate to Detail Page    ${deviceText}
    Triton WH Occupied/Unoccupied Schedule    Schedule
    ${Occupied_status_ED}    Read int return type objvalue From Device
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode}    Convert to integer    ${Occupied_status_ED}
    ${mode_name}    Get From List    ${Schedule_modes_List}[${mode}]
    Should be equal as strings    ${mode_name}    Occupied

TC-34:Schedule the temperature and Unoccupied mode from App
    [Documentation]    Schedule the temperature and Unoccupied mode from App
    [Tags]    testrailid=89452

    Navigate to Detail Page    ${deviceText}
    Triton WH Occupied/Unoccupied Schedule    Schedule
    ${Unoccupied_status_ED}    Read int return type objvalue From Device
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode}    Convert to integer    ${Unoccupied_status_ED}
    ${mode_name}    Get From List    ${Schedule_modes_List}[${mode}]
    Should be equal as strings    ${mode_name}    Unoccupied

TC-35:Copy the Scheduled slot and mode from App
    [Documentation]    Copy the Scheduled slot and mode from App
    [Tags]    testrailid=89453

    Navigate to Detail Page    ${deviceText}
    Triton Copy Schedule Data    Schedule
