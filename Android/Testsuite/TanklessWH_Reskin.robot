*** Settings ***
Documentation       This is the test file for End to end testing of Tankless WH

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

Suite Setup         Run Keywords    Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${select_Tankless_location}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Tankless_location}


*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         4224

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
${Admin_EMAIL}                          automation3@rheem.com
${Admin_PWD}                            12345678
${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

##    --> Select Device Location
${select_Tankless_location}             Niagra
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

## --> Setpoint Value of Tankless WH
${setpoint_max}                         140
${setpoint_min}                         85
${setpoint_max_C}                       60
${setpoint_min_C}                       30
${value1}                               32
${value2}                               5
${value3}                               9

## --> Tankless WH Mode List
@{Niagra_modes_List}                    Disabled    Enabled
@{AltitudeLevels}                       Sea Level    Low Altitude    Med.Altitude    High Altitude
@{RecircPumpModes}                      None    Timer-Perf.    Timer-E-Save    On-Demand    Schedule

${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=89482

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
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

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Tags]    testrailid=89483

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
    [Tags]    testrailid=89484

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
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

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]    testrailid=89485

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
    [Tags]    testrailid=89486

    Navigate to Detail Page    ${deviceText}
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
    [Tags]    testrailid=89487

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
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 140F.
    [Documentation]    Max temperature that can be set from App should be 140F.
    [Tags]    testrailid=89488

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
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 85F.
    [Documentation]    Min temperature that can be set from App should be 85F.
    [Tags]    testrailid=89489

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    86
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
    [Tags]    testrailid=89490
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
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 85F.
    [Documentation]    Min temperature that can be set from Equipment should be 85F.
    [Tags]    testrailid=89491
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

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App
    [Tags]    testrailid=89492

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${sleep_5s}
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

TC-12:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App
    [Tags]    testrailid=89493

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    85
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Decrement setpoint
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    Should be equal as integers    85    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    85

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.
    [Tags]    testrailid=89494

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
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 29C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C.
    [Tags]    testrailid=89495

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
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C.
    [Tags]    testrailid=89496
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

TC-16:Min temperature that can be set from App should be 29C.
    [Documentation]    Min temperature that can be set from App should be 29C.
    [Tags]    testrailid=89497

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    86
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
    ${setpoint_M_EC}    convert to integer    29
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
    [Tags]    testrailid=89498

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

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App
    [Tags]    testrailid=89499

    Temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
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
    Decrement setpoint
    ${setpoint_M_DP}    Get setpoint from details screen
    Go back
    ${setpoint_M_EC}    convert to integer    29
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3}
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user set temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from App
    [Tags]    testrailid=89500
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
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=89501

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    increment set point
    sleep    ${sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    page should contain element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    Get text    ${WH_Temp_WarningMsg}
    should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
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

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=89502
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
    [Tags]    testrailid=89503

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
    ${WarningMsg}    Get text    ${WH_Temp_WarningMsg}
    should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    ${Sleep_5s}

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Tags]    testrailid=89504

    ${changeModeValue}    Set Variable    0
    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    Set Disabled state
    page should contain text    Disabled
    Go back
    page should contain text    Disabled
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal    Disabled    ${Niagra_modes_List}[${mode_ED}]

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=89505

    Navigate to Detail Page    ${deviceText}
    Set Enable state
    sleep    ${Sleep_5s}
    ${Setpoint}    Get setpoint from details screen
    page should contain text    ${Setpoint}
    Sleep    2s
    Go back
    Page should contain element    ${WH_get_EC_SetPointValue}
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_ED}
    ${mode_name}    Get From List    ${Niagra_modes_List}    ${mode_ED}
    Should Be Equal    Enabled    ${Niagra_modes_List}[${mode_ED}]

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.
    [Tags]    testrailid=89506
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Page should contain text    Disabled

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=89507

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Page should contain text    Enabled

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]    testrailid=89508

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    ${status}    Get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    click element    ${Full_Screen_Mode}
    sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-28:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week
    [Tags]    testrailid=89509
    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Weekly
    sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-29:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month
    [Tags]    testrailid=89510
    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-30:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year
    [Tags]    testrailid=89511

    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    sleep    ${Sleep_5s}
    wait until page contains element    ${Usage_Chart}    ${sleep_10s}
    Go back
    Go back

TC-31:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App.
    [Tags]    testrailid=89512
    Select Device Location    ${select_Tankless_location}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_20s}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-32:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App.
    [Tags]    testrailid=89513

    Select Device Location    ${select_Tankless_location}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    sleep    ${Sleep_5s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_20s}
    Should be equal as integers    ${Away_status_M}    ${Away_status_ED}

TC-33:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App
    [Tags]    testrailid=89514
    Navigate to Detail Page    ${deviceText}
    ${get_current_set_point}    Tankless WH Follow Schedule    Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${setpoint_M_DP}    ${get_current_set_point}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${get_current_set_point}

TC-34:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=89515
    Navigate to Detail Page    ${deviceText}
    HPWH Copy Schedule Data    Schedule

TC-35:Change the Scheduled temperature from App.
    [Documentation]    Change the Scheduled temperature from App
    [Tags]    testrailid=89516
    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    Increment set point
    ${setpoint_M_DP}    Get setpoint from details screen
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Schedule overridden
    ${setpoint_M_DP1}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${setpoint_M_DP}

TC-36:User should be able to Resume Schedule when scheduled temperature is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow.
    [Tags]    testrailid=89517
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    Resume
    page should contain text    Following Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_DP}    ${setpoint_M_EC}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${setpoint_M_DP}    ${setpoint_ED}
    should be equal as strings    ${setpoint_M_EC}    ${setpoint_ED}

TC-37:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=89518
    Navigate to Detail Page    ${deviceText}
    sleep    ${Sleep_5s}
    ${get_current_set_point}    Tankless WH Follow Schedule    Schedule
    Wait Until Page Contains    ${deviceText}    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${setpoint_M_DP}    ${get_current_set_point}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${get_current_set_point}

TC-38:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=89519
    Navigate to Detail Page    ${deviceText}
    Unfollow the schedule    Schedule
    page should not contain text    Following Schedule

TC-39:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice
    [Tags]    testrailid=89520

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HTRS__ON
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${running_status_text}    Get text    ${running_sts_label}
    ${running_text}    Remove String    ${running_status_text}    3    units
    sleep    ${Sleep_5s}
    page should contain text    Running
    Go back

TC-40:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=89521
    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HTRS__ON
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    Page should not contain text    Running
    Go back

TC-49:User should be able to Enable/Disable Water Save from the product Settings screen.
    [Documentation]    User should be able to Enable/Disable Water Save from the product Settings screen.
    [Tags]    testrailid=89530
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen    ${deviceText}
    Enable/Disable Water Save From Product Settings
    Sleep    2s
    Go back

TC-50:User should be able to change Sea Level Altitude from the product Setting screen.
    [Documentation]    User should be able to change Sea Level Altitude from the product Setting screen.
    [Tags]    testrailid=89531
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Sleep    1s
    Set Alitude To Sea Level From Product Settings Screen
    Sleep    4s
    Go back
    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Sea Level    ${AltitudeLevels}[${AltitudeLevel}]

TC-51:User should be able to change Low Altitude from the product Setting screen.
    [Documentation]    User should be able to change Low Altitude from the product Setting screen.
    [Tags]    testrailid=89532

    Navigate to Detail Page    ${deviceText}
    sleep    5s
    Navigate to the Product Settings Screen
    Set Alitude To Low Altitude From Product Settings Screen
    Go back
    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Low Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-52:User should be able to change Med. Altitude from the product Setting screen.
    [Documentation]    User should be able to change Med. Altitude from the product Setting screen.
    [Tags]    testrailid=89533
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Alitude To Med. Altitude From Product Settings Screen
    Go back
    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Med.Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-53:User should be able to change High Altitude from the product Setting screen.
    [Documentation]    User should be able to change Low Altitude from the product Setting screen.
    [Tags]    testrailid=89534

    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Alitude To High Altitude From Product Settings Screen
    Go back
    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    High Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-54:User should be able to set Recirc Pump mode as None form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as None form the product Setting acreen.
    [Tags]    testrailid=89535
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations None From the Product Settings Screen
    Go back
    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${RecircPumpModes}[${RecircMode}]    None

TC-55:User should be able to set Recirc Pump mode as Timer-Perf. form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as Timer-Perf. form the product Setting acreen.
    [Tags]    testrailid=89536

    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations Timer-Perf From the Product Settings Screen
    Go back
    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Timer-Perf.

TC-56:User should be able to set Recirc Pump mode as Timer-E-Save form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as Timer-E-Save form the product Setting acreen.
    [Tags]    testrailid=894537
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations Timer-E-Save From the Product Settings Screen
    Go back
    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Timer-E-Save

TC-57:User should be able to set Recirc Pump mode as On-Demand form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as On-Demand form the product Setting acreen.
    [Tags]    testrailid=89538

    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations On Demand From the Product Settings Screen
    Go back
    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${RecircPumpModes}[${RecircMode}]    On-Demand

TC-58:User should be able to set Recirc Pump mode as Schedule form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode asSchedule form the product Setting acreen.
    [Tags]    testrailid=89539
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations Schedule From the Product Settings Screen
    Go back
    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Schedule

Verify that if User Update Water Saving mode to OFF from End Device than its should be reflected on App
    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    WATRSAVE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    WATRSAVE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    wait until page contains element    ${FollowSchedule_button}    ${defaultwaittime}
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    Should be Equal    Off    ${Status}
    Navigate Back to the Sub Screen

Verify that if User Update Water Saving mode to ON from End Device than its should be reflected on App
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    WATRSAVE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    WATRSAVE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    1
    sleep    5s
    Navigate to the Product Settings Screen
    wait until page contains element    ${FollowSchedule_button}    ${defaultwaittime}
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    Should be Equal    On    ${Status}
    Navigate Back to the Sub Screen

Verify that Changed RPUMPMOD = 0 From End Device and its value None/Disabled should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    Page should contain text    None
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed RPUMPMOD = 1 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    1
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-Perf.
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed RPUMPMOD = 2 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    2
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    2
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-E-Save
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed RPUMPMOD = 3 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    3
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    3
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    On-Demand
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed RPUMPMOD = 4 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    4
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Should be equal as integers    ${WaterSaverLevel}    4
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Schedule
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
