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
...                     AND    Select Device Location    Eagle
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Run Keywords    Open Application wihout unistall and Navigate to dashboard    ${Select_Eagle_location}


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         4288

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    C0-E4-34-4A-E4-49
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Niagra

# --> admin cred
${Admin_EMAIL}                          automationtest@rheem.com
${Admin_PWD}                            rheem123
${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123

# --> Select Device Location
${Select_Eagle_location}                Eagle
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

# --> Setpoint Values
${setpoint_max}                         120
${setpoint_min}                         100
${setpoint_max_C}                       60
${setpoint_min_C}                       44
${value1}                               32
${value2}                               5
${value3}                               9

# --> Sleep Time
${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s

## --> Tankless WH Mode List
@{Eagle_modes_List}                     Disabled    Enabled
@{AltitudeLevels}                       Sea Level    Low Altitude    Med.Altitude    High Altitude


*** Test Cases ***




TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment.

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
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment.

    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment    Set Point temperature from App.

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
    Sleep    ${Sleep_10s}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement    Set Point temperature from App.

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
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 120F.
    [Documentation]    Max temperature that can be set from App should be 120F.

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
    ${setpoint_M_EC}    Convert to integer    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 100F.
    [Documentation]    Min temperature that can be set from App should be 100F.

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
    ${setpoint_M_EC}    Convert to integer    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-09:Max temperature that can be set from Equipment should be 120F.
    [Documentation]    Max temperature that can be set from Equipment should be 120F.

    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_max}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 100F.
    [Documentation]    Min temperature that can be set from Equipment should be 100F.

    ${setpoint_ED}    Write objvalue From Device
    ...    100
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

TC-11:User should not be able to exceed max setpoint limit i.e. 120F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 120F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=43032

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Increment set point
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    Should be equal as integers    120    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    120

TC-12:User should not be able to exceed min setpoint limit i.e. 100 from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 100F from App

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    100
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Decrement setpoint
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    Convert to integer    120
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-34:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]    User should be able to view the current and historical data of the Current Day from the energy usage data.

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Daily
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Click element    ${Full_Screen_Mode}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Click element    ${Full_Screen_Mode}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-35:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Weekly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-36:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Monthly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-37:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year

    Navigate to Detail Page    ${deviceText}
    Click text    ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data    Yearly
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'true'    Click element    ${HistoricalData_Switch}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    ${status}    get element attribute    ${HistoricalData_Switch}    checked
    IF    '${status}' == 'false'    Click element    ${HistoricalData_Switch}
    Sleep    ${Sleep_5s}
    Wait until page contains element    ${Usage_Chart}    ${Sleep_10s}
    Go back
    Go back

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.

    Navigate to Detail Page    ${deviceText}
    Set Disabled state for Eagle
    Sleep    ${Sleep_5s}
    page should contain text    ${Disabled_text}
    Go back
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_name}    Get From List    ${Eagle_modes_List}    ${mode_ED}

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App

    Navigate to Detail Page    ${deviceText}
    Set Enable state for Eagle
    page should contain text    ${WH_get_SetPointValue}
    Go back
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Convert to integer    ${mode_ED}
    ${mode_name}    Get From List    ${Eagle_modes_List}    ${mode_ED}

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.

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
    ${cur_mode_M_DP}    get text    ${Eagle_Dis/Ena_State}
    Go back
    should be equal as strings    ${Eagle_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.

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
    ${cur_mode_M_DP}    get text    ${Eagle_Dis/Ena_State}
    Go back
    should be equal as strings    ${Eagle_modes_List}[${mode_set_ED}]    ${cur_mode_M_DP}

TC-31:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=4349

    Navigate to Detail Page    ${deviceText}
    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HTRS_ON
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    10s
    page should contain text    1 unit Running
    Go back

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
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

TC-14:Min temperature that can be set from Equipment should be 43C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C.

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    100
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
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

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C.

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
    Go back
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

    temperature unit in celsius
    Navigate to Detail Page
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
    Go back
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

    temperature unit in celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    120
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

    Temperature Unit in Celsius
    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    100
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

TC-27:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater
    [Tags]    testrailid=83772

    Select Device Location    Eagle
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-28:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater
    [Tags]    testrailid=83773

    Select Device Location    Eagle
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0#

TC-40:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature and mode from App

    Navigate to Detail Page    ${deviceText}
    ${get_current_set_point}    ${get_current_mode}    HPWH Follow Schedule Data    Schedule
    Go back
    Wait Until Page Contains    ${deviceText}    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    ${mode_M_DP}    WH Get Mode
    Should be equal as integers    ${setpoint_M_DP}    ${get_current_set_point}
    Should Be Equal As Strings    ${mode_M_DP}    ${get_current_mode}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    ${Mode_M_EC}    get mode from equipment card
    should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    should be equal as strings    ${Mode_M_EC}    ${get_current_mode}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${get_current_set_point}

TC-41:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${get_all_values_of_current_day}    ${get_all_values_of_copied_day}    HPWH Copy Schedule Data    Schedule
    Lists Should Be Equal    ${get_all_values_of_current_day}    ${get_all_values_of_copied_day}
    Go back
    Go back

TC-42:Change the Scheduled temperature and mode from App.
    [Documentation]    Change the Scheduled temperature and mode from App

    Navigate to Detail Page    ${deviceText}
    ${mode_M_DP}    WH Get Mode
    Click element    ${WH_changemode}
    IF    '${mode_M_DP}' == 'OFF'
        Click element    ${Energy_mode}
    ELSE IF    '${mode_M_DP}' == 'ENERGY SAVING'
        Click element    ${Heatpump_mode}
    ELSE IF    '${mode_M_DP}' == 'HEAT PUMP ONLY'
        Click element    ${Highdemand_mode}
    ELSE IF    '${mode_M_DP}' == 'HIGH DEMAND'
        Click element    ${Electric_mode}
    ELSE IF    '${mode_M_DP}' == 'ELECTRIC MODE'
        Click element    ${Off_mode}
    END
    Page Should Contain Text    Schedule overridden
    ${mode_M_DP1}    WH Get Mode
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Contain Text    Schedule overridden
    ${setpoint_M_DP1}    Validate set point Temperature From Mobile
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${setpoint_M_DP1}
    Sleep    ${Sleep_5s}
    Click element    ${Resume_Button}
    Sleep    ${Sleep_5s}
    Go back

TC-43:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App

    Navigate to Detail Page    ${deviceText}
    ${Scheduled_Mode1}    ${Scheduled_Temp1}    HPWH Update Setpoint and Mode From Schedule screen    Schedule
    Wait Until Page Contains    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    ${mode_M_DP}    WH Get Mode
    Should Be Equal As Strings    ${setpoint_M_DP}    ${Scheduled_Temp1}
    should be equal as strings    ${Scheduled_Mode1}    ${mode_M_DP}
    Page Should Contain Text    Following Schedule
    Sleep    ${Sleep_5s}
    Go back
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_ED}    Read int return type objvalue From Device
    ...    WHTRCNFG
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeModeValue}    Set Variable    ${mode_ED}
    Should Be Equal As Strings    ${setpoint_ED}    ${setpoint_M_DP}
    Should Be Equal As Strings    ${HPWH_modes_List}[${changeModeValue}]    ${mode_M_DP}

TC-44:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App

    Navigate to Detail Page    ${deviceText}
    Unfollow the schedule    Schedule
    Page should not contain text    Following Schedule

TC-45: Burn Time value Updated from Equipment
    [Documentation]    Burn Time value Updated from Equipment

    ${burntime_ED}    Write objvalue From Device
    ...    20
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${burntime_ED}    Read int return type objvalue From Device
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    [Teardown]    Go back

TC-46: Update maximum burn time value
    [Documentation]    Update maximum burn time value

    ${burntime_ED}    Write objvalue From Device
    ...    8000
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${burntime_ED}    Read int return type objvalue From Device
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    [Teardown]    Go back

TC-47: Update minimum burn time value
    [Documentation]    Update minimum burn time value

    ${burntime_ED}    Write objvalue From Device
    ...    0
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${burntime_ED}    Read int return type objvalue From Device
    ...    BURNTIME
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    [Teardown]    Go back

TC-48: Update Low altitude value from Equipment
    [Documentation]    Update Low altitude value from Equipment
    ${altitude_ED}    Write objvalue From Device
    ...    0
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    page should contain text    Sea Level
    [Teardown]    Go back

TC-49: Update Med. altitude value from Equipment
    [Documentation]    Update Med. altitude value from Equipment
    ${altitude_ED}    Write objvalue From Device
    ...    1
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    page should contain text    Sea Level
    [Teardown]    Go back

TC-50: Update sea altitude value from Equipment
    [Documentation]    Update sea altitude value from Equipment
    ${altitude_ED}    Write objvalue From Device
    ...    2
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Navigate to the Product Settings Screen
    [Teardown]    Go back

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
    Sleep    ${Sleep_10s}
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
    Sleep    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    page should contain element    ${WH_Temp_WarningMsg}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
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
    [Tags]    testrailid=87045

    ${setpoint_ED}    Write objvalue From Device
    ...    119
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    ${Sleep_5s}

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
    should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    Get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

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
    Sleep    ${Sleep_5s}
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

TC-50:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Decrement setpoint
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
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

TC-52:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App

    Navigate to Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
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
