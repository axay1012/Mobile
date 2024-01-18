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

Suite Setup         Run Keywords    connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${select_Dragon_location}
Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Dragon_location}


*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         4480

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

    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Fahrenheit
    ${OccupiedValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${OccupiedValue}
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
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
    [Tags]    testrailid=90970

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
    [Tags]    testrailid=90971

    Navigate to Detail Page    ${deviceText}
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

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]    testrailid=90972

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
    [Tags]    testrailid=90973

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
    [Tags]    testrailid=90974

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

TC-07:Max temperature that can be set from App should be 185F.
    [Documentation]    Max temperature that can be set from App should be 185F.
    [Tags]    testrailid=90975

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    184
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
    [Tags]    testrailid=90976

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

TC-09:Max temperature that can be set from Equipment should be 185F.
    [Documentation]    Max temperature that can be set from Equipment should be 185F.
    [Tags]    testrailid=90977

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
    [Tags]    testrailid=90978

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
    [Tags]    testrailid=90979

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    185
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
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
    [Tags]    testrailid=90980

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
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:Max temperature that can be set from Equipment should be 85C.
    [Documentation]    Max temperature that can be set from Equipment should be 85C.
    [Tags]    testrailid=90981

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
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
    ${result2}    Convert to integer    ${result1}
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
    [Tags]    testrailid=90982

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
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
    ${result2}    Convert to integer    ${result1}
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
    [Tags]    testrailid=90983

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    184
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
    Go back
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

TC-16:Min temperature that can be set from App should be 29C.
    [Documentation]    Min temperature that can be set from App should be 29C.
    [Tags]    testrailid=90984

    temperature unit in celsius
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
    ${result2}    Convert to integer    ${result1}
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
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 85C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App
    [Tags]    testrailid=90985

    temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
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
    ${result2}    Convert to integer    ${result1}
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
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App
    [Tags]    testrailid=90986

    Temperature Unit in Celsius
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
    ${result2}    Convert to integer    ${result1}
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
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user set temperature <=120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below <=120F/48C from App
    [Tags]    testrailid=90987

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
    Sleep    ${Sleep_10s}
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
    [Tags]    testrailid=90988

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    increment set point
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

TC-21:A Caution message should not appear if user set temperature <=120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below <=120F/48C from Equipment.
    [Tags]    testrailid=90989

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
    [Tags]    testrailid=90990

    ${setpoint_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Wait until page contains element    ${WH_Temp_WarningMsg}    ${DefaultTimeout}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    Should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Tags]    testrailid=90991

    Navigate to Detail Page    ${deviceText}
    Set Disabled state
    page should contain text    ${Disabled_text}
    Go back
    page should contain text    ${Disabled_text}
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${Dragon_modes_List}    ${mode_ED}
    Should be equal as integers    0     ${mode_ED}

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=90992

    Navigate to Detail Page    ${deviceText}
    Set Enable state
    Sleep    ${Sleep_5s}
    page should contain element    ${TempInc_Button}
    Go back
    page should contain element    ${WH_get_EC_SetPointValue}
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${Dragon_modes_List}    ${mode_ED}
    Should be equal as integers    1     ${mode_ED}

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.
    [Tags]    testrailid=90993

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    get text    ${Dis/Ena_State}
    Go back
    Should be equal as strings    ${Dragon_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=90994

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
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${cur_mode_M_DP}    get text    ${Dis/Ena_State}
    Go back
    Should be equal as strings    ${DRagon_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]    testrailid=90995

    Navigate to Detail Page    ${deviceText}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    click element    ${Full_Screen_Mode}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-28:User should be able to view the current and historical data of the Week from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Week from the energy usage data.
    [Tags]    testrailid=90996

    Navigate to Detail Page    ${deviceText}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Weekly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-29:User should be able to view the current and historical data of the Month from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Month from the energy usage data.
    [Tags]    testrailid=90997

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-30:User should be able to view the current and historical data of the Year from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Year from the energy usage data.
    [Tags]    testrailid=90998

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    Sleep    ${Sleep_5s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click Element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-31:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App.
    [Tags]    testrailid=90999

    Select Device Location    ${select_Dragon_location}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-32:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App.
    [Tags]    testrailid=91000

    Select Device Location    ${select_Dragon_location}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_M}    ${Away_status_ED}

TC-33:Schedule the temperature and Occupied mode from App
    [Documentation]    Schedule the temperature and Occupied mode from App
    [Tags]    testrailid=91001

    Navigate to Detail Page    ${select_Dragon_location}
    Dragon WH Occupied/Unoccupied Schedule    Schedule
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
    [Tags]    testrailid=91002

    Navigate to Detail Page    ${deviceText}
    Dragon WH Occupied/Unoccupied Schedule    Schedule
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
    [Tags]    testrailid=91003

    Navigate to Detail Page    ${deviceText}
    Triton Copy Schedule Data    Schedule

# TC-42:User should be able to set valve config to'Closed if Leak Detected' from App
#    [Documentation]    User should be able to set valve config to'Closed if Leak Detected' from App
#    [Tags]    testrailid=91010
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Shutoff Valve Config to'Closed if Leak Detected'
#    Go back
#    ${ShutoffValve}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${ShutoffValve}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}

# TC-43:User should be able to set valve config to'Closed if Unocc.Leak Detect' from App
#    [Documentation]    User should be able to set valve config to'Closed if Unocc.Leak Detect' from App
#    [Tags]    testrailid=91011#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Shutoff Valve Config to'Closed if Unocc. Leak Detect'
#    Go back
#    ${ShutoffValve}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${ShutoffValve}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}#
#
# TC-44:User should be able to set valve config to 'Open' from App
#    [Documentation]    User should be able to set valve config to 'Open' from App
#    [Tags]    testrailid=91012
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Shutoff Valve Config to 'Open'
#    Go back
#    ${ShutoffValve}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${ShutoffValve}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}#
#
# TC-45:User should be able to set valve config to 'Closed' from App
#    [Documentation]    User should be able to set valve config to 'Closed' from App
#    [Tags]    testrailid=91013
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Shutoff Valve Config to 'Closed'
#    Go back
#    ${ShutoffValve}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${ShutoffValve}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}
#
# TC-46:User should be able to set valve config to'Closed if Leak Detected' from equipment
#    [Documentation]    User should be able to set valve config to'Closed if Leak Detected' from equipment
#    [Tags]    testrailid=91014
##    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    0
#    ${mode_set_ED}=    Write objvalue From Device    ${changeModeValue}    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get ShutoffValve Config Value from Product Settings screen
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${mode_get_ED}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}
#    Go back

# TC-47:User should be able to set valve config to'Closed if Unocc. Leak Detected' from equipment
#    [Documentation]    User should be able to set valve config to'Closed if Unocc. Leak Detected' from equipment
#    [Tags]    testrailid=91015
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    1
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get ShutoffValve Config Value from Product Settings screen
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${mode_get_ED}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}
#    Go back
#
# TC-48:User should be able to set valve config to 'Open' from equipment
#    [Documentation]    User should be able to set valve config to 'Open' from equipment
#    [Tags]    testrailid=91016
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}=    Set Variable    2
#    ${mode_set_ED}=    Write objvalue From Device    ${changeModeValue}    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get ShutoffValve Config Value from Product Settings screen
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${mode_get_ED}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}
#    Go back
#
# TC-49:User should be able to set valve config to 'Closed' from equipment
#    [Documentation]    User should be able to set valve config to 'Closed' from equipment
#    [Tags]    testrailid=91017
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    3
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${mode_get_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
##    ${Mode_Text}    Get ShutoffValve Config Value from Product Settings screen
#    ${ValveConfig}    Get From List    ${ShutOff_Config}[${mode_get_ED}]
#    Should be equal as strings    ${ValveConfig}    ${Mode_Text}
#    Go back

# TC-50:User should be able to set Recirc pump config to 'off' from App
#    [Documentation]    User should be able to set Recirc pump config to 'off' from App
#    [Tags]    testrailid=91018
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Recirc Pump Config to'Off'
#    Go back
#    ${RecircPumpConfig}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${RecircPumpConfig}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#
# TC-51:User should be able to set Recirc pump config to 'On' from App
#    [Documentation]    User should be able to set Recirc pump config to 'On' from App
#    [Tags]    testrailid=91019
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Recirc Pump Config to'On'
#    Go back
#    ${RecircPumpConfig}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${RecircPumpConfig}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#
# TC-52:User should be able to set Recirc pump config to 'Schedule' from App
#    [Documentation]    User should be able to set Recirc pump config to 'Schedule' from App
#    [Tags]    testrailid=91020
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Recirc Pump Config to'Schedule'
#    Go back
#    ${RecircPumpConfig}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${RecircPumpConfig}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#
# TC-53:User should be able to set Recirc pump config to 'Schedule On' from App
#    [Documentation]    User should be able to set Recirc pump config to 'Schedule On' from App
#    [Tags]    testrailid=91021
#
#    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Recirc Pump Config to'Schedule On'
#    Go back
#    ${RecircPumpConfig}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${RecircPumpConfig}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#
# TC-54:User should be able to set Recirc pump config to 'On Demand' from App
#    [Documentation]    User should be able to set Recirc pump config to 'On Demand' from App
#    [Tags]    testrailid=91022
##    Navigate to Detail Page    ${deviceText}
#    Navigate to Dragon WH Product Settings Screen    Product Settings
#    ${Mode_Text}    Set Recirc Pump Config to'On Demand'
#    Go back
#    ${RecircPumpConfig}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${RecircPumpConfig}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#
# TC-55:User should be able to set Recirc Pump config to 'Off' from equipment
#    [Documentation]    User should be able to set Recirc Pump config to 'Off' from equipment
#    [Tags]    testrailid=91023
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    0
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get Recirc Pump Config Value from Product Settings screen
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${mode_get_ED}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#    Go back
#
# TC-56:User should be able to set Recirc Pump config to 'On' from equipment
#    [Documentation]    User should be able to set Recirc Pump config to 'On' from equipment
#    [Tags]    testrailid=91024

#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}=    Set Variable    1
#    ${mode_set_ED}=    Write objvalue From Device    ${changeModeValue}    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Convert to integer    ${mode_set_ED}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
##    ${Mode_Text}    Get Recirc Pump Config Value from Product Settings screen
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${mode_get_ED}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#    Go back
#
# TC-57:User should be able to set Recirc Pump config to 'Schedule' from equipment
#    [Documentation]    User should be able to set Recirc Pump config to 'Schedule' from equipment
#    [Tags]    testrailid=91025
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    2
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${mode_get_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get Recirc Pump Config Value from Product Settings screen
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${mode_get_ED}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#    Go back
#
# TC-58:User should be able to set Recirc Pump config to 'Schedule On' from equipment
#    [Documentation]    User should be able to set Recirc Pump config to 'Schedule On' from equipment
#    [Tags]    testrailid=91026
#    Navigate to Detail Page    ${deviceText}
#    Sleep    ${Sleep_5s}
#    ${changeModeValue}    Set Variable    3
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get Recirc Pump Config Value from Product Settings screen
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${mode_get_ED}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#    Go back
#
#
# TC-59:User should be able to set Recirc Pump config to 'On Demand' from equipment
#    [Documentation]    User should be able to set Recirc Pump config to 'On Demand' from equipment
#    [Tags]    testrailid=91027
#
#    Navigate to Detail Page    ${deviceText}
#    ${changeModeValue}    Set Variable    4
#    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    ${Sleep_5s}
#    ${mode_get_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
#    ${Mode_Text}    Get Recirc Pump Config Value from Product Settings screen
#    ${PumpConfig}    Get From List    ${RecircPump_Config}[${mode_get_ED}]
#    Should be equal as strings    ${PumpConfig}    ${Mode_Text}
#    Go back
#
# TC-60:User should be able to set Leak Detected to Alarm Only from APP
#    [Documentation]    User should be able to set Leak Detected to Alarm Only from APP
#    [Tags]    testrailid=91028#
#    Navigate to Detail Page    ${deviceText}
#    Set Leak Detection to Alarm Only
#    Go back

# TC-61:User should be able to set Leak Detected to Disable Water Heater from APP
#    [Documentation]    User should be able to set Leak Detected to Disable Water Heater from APP
#    [Tags]    testrailid=91029

#    Navigate to Detail Page    ${deviceText}
#    Set Leak Detection to Disable Water Heater
