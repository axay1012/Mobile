*** Settings ***
Documentation       This is the test file for End to end testing of NewECC

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
...                     AND    Select Device Location    ${select_NewECC_location}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Close All Apps

*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5
${EndDevice_id}                         896

# -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

# --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Smart Thermostate

# --> admin cred
${Admin_EMAIL}                          automation@rheem.com
${Admin_PWD}                            Vyom@0212
${emailId}                              automation@rheem.com
${passwordValue}                        Vyom@0212

##    --> Select Device Location
${select_NewECC_location}               OldECC
${deviceText}                           //android.widget.FrameLayout[@resource-id='com.rheem.econetconsumerandroid:id/hvacCardView']

## --> NewECC Setpoint Values
${newECC_setpoint_heat_max}             90
${newECC_setpoint_heat_min}             50

${newECC_setpoint_cool_max}             92
${newECC_setpoint_cool_min}             52

${newECC_setpoint_fan_max}              5
${newECC_setpoint_fan_min}              0

${newECC_Celsius_heat_max}              32
${newECC_Celsius_heat_min}              10

${newECC_Celsius_cool_max}              33
${newECC_Celsius_cool_min}              11

${value1}                               32
${value2}                               5
${value3}                               9

# --> NewECC Modes List
@{newECC_modes_List}                    Heating    Cooling    Auto    Fan Only    Off
@{newECC_fanmodes_List}                 Auto    Low    Med.Lo    Medium    Med.Hi    High

${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


*** Test Cases ***
TC-01:Updating Auto Mode from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Auto Mode from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99188

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}

    ${changeUnitValue}    Set Variable    2

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set Auto Mode Of Smart Thermosate
    Go Back
    ${mode_M_EC}    Get mode name from equipment card HVAC
    Sleep    ${Sleep_5s}
    ${mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}

TC-02:Updating Heating set point from App should be reflected on dashboard and Equipment.
    [Documentation]    Updating Heating set point from App should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99189
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Click Element    ${SwitchToButton}
    Sleep    ${Sleep_5s}
    Increment set point
    Go Back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED_heat}    ${setpoint_M_EC_heat}
    Sleep    ${Sleep_5s}
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED_cool}    ${setpoint_M_EC_cool}

TC-03:Updating Heating set point from Equipment should be reflected on App and Equipment.
    [Documentation]    Updating Heating set point from Equipment should be reflected on App and Equipment.
    [Tags]    testrailid=99190
    ${setpoint_ED}    Write objvalue From Device
    ...    61
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_heat}

TC-04:Updating Cooling set point from App should be reflected on Equipment.
    [Documentation]    Updating Cooling set point from App should be reflected on Equipment.
    [Tags]    testrailid=99191

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click Element    ${SwitchToButton}
    Sleep    5s
    click element    ${CoolPlusButton}
    Sleep    ${Sleep_5s}
    Go Back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED_cool}    ${setpoint_M_EC_cool}

TC-05:Updating Cooling set point from Equipment should be reflected on App and Equipment.
    [Documentation]    Updating Cooling set point from Equipment should be reflected on App and Equipment.
    [Tags]    testrailid=99192
    ${setpoint_ED}    Write objvalue From Device
    ...    85
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-06:Min Heating setpoint that can be set from Equipment should be 50F.
    [Documentation]    Min Heating setpoint that can be set from Equipment should be 50F.
    [Tags]    testrailid=99193

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max Cooling setpoint that can be set from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set from Equipment should be 92F.
    [Tags]    testrailid=99194

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min Heating set point that can be set from App should be 50F.
    [Documentation]    Min Heating set point that can be set from App should be 50F.
    [Tags]    testrailid=99195
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click Element    ${SwitchToButton}
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    50    ${HeatPlusButton}
    Sleep    ${Sleep_5s}
    Go Back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_heat}

TC-09:Max Cooling setpoint that can be set from App should be 92F.
    [Documentation]    Max Cooling setpoint that can be set from App should be 92F.
    [Tags]    testrailid=99196
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click Element    ${SwitchToButton}
    Sleep    5s
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    92    ${CoolPlusButton}
    Sleep    ${Sleep_5s}
    Go Back
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_cool}

TC-10:User should not be able to exceed Min Heating setpoint limit i.e. 50F from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from App.
    [Tags]    testrailid=99197
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click Element    ${SwitchToButton}
    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Decrement setpoint
    Sleep    ${Sleep_5s}
    Go Back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_heat}

TC-11:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App.
    [Tags]    testrailid=99198

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    91
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click Element    ${SwitchToButton}
    click element    ${CoolPlusButton}
    Sleep    ${Sleep_5s}
    Go Back
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_cool}

TC-12:User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment.
    [Tags]    testrailid=99199
    ${setpoint_ED}    Write objvalue From Device
    ...    49
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment.
    [Tags]    testrailid=99200

    ${coolMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device
    ...    93
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-14:Updating Off Mode from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Off Mode from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99201

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set OFF Mode Of Smart Thermosate
    Go Back
    ${mode_M_EC}    Get text    ${HVACOffText_Equipmentcard}
    ${mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}

TC-15:Updating Heating Mode from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Heating Mode from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99202
    ${coolMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set Heating Mode Of Smart Thermosate
    Go Back
    ${mode_M_EC}    Get mode name from equipment card HVAC
    ${mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}

TC-16:Max Heating setpoint that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint that can be set from App should be 90F.
    [Tags]    testrailid=99203

    ${coolMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    89
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Increment set point
    go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-17:User should not be able to exceed Max Heating setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from App.
    [Tags]    testrailid=99204
    ${coolMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Increment set point
    go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-18:Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99205

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    Set Cooling Mode Of Smart Thermosate
    Go Back
    ${mode_M_EC}    Get mode name from equipment card HVAC
    ${mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}

TC-19:Min Cooling Setpoint that can be set from App should be 52F.
    [Documentation]    Min Cooling Setpoint that can be set from App should be 52F.
    [Tags]    testrailid=99206
    ${coolMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    53
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Decrement setpoint
    Go Back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-20:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App.
    [Tags]    testrailid=99207
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Decrement setpoint
    Go Back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-21:Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99208
    Go back
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set FanOnly Mode Of Smart Thermosate
    Go Back
    ${mode_M_EC}    get text    ${HVACOffText_Equipmentcard}
    should be equal as strings    Fan Only    ${mode_M_EC}
    ${mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    Fan Only

TC-23:Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99210
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Fan Speed    Low
    Go Back
    ${changeModeValue}    Set Variable    0
    ${setMode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${setMode_ED}]    ${FanSpeed_EC}

TC-24:Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99211
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Fan Speed    Med.Lo
    Go Back
    ${changeModeValue}    Set Variable    0
    ${setMode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${setMode_ED}]    ${FanSpeed_EC}

TC-25:Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99212
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Fan Speed    Medium
    Go Back
    ${changeModeValue}    Set Variable    0
    ${setMode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${setMode_ED}]    ${FanSpeed_EC}

TC-26:Updating Fan Speed to Med.Hi from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Med.Hi from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99213
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Fan Speed    Med.Hi
    ${changeModeValue}    Set Variable    0
    ${setMode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go Back
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${setMode_ED}]    ${FanSpeed_EC}

TC-27:Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=99214
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Fan Speed    High
    ${changeModeValue}    Set Variable    0
    ${setMode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Go Back
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${setMode_ED}]    ${FanSpeed_EC}

TC-28:User should be able to set Off mode from Equipment
    [Documentation]    User should be able to set Off mode from Equipment.
    [Tags]    testrailid=99215
    ${changeModeValue}    Set Variable    4
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_DP}    get text    ${WH_get_SetPointValue}
    go back
    Sleep    ${Sleep_5s}
    ${mode_M_EC}    get text    ${HVACOffText_Equipmentcard}
    should be equal as strings    ${newECC_modes_List}[${mode_set_ED}]    ${set_mode_DP}

TC-29:User should be able to set Heating mode from Equipment
    [Documentation]    User should be able to set Heating mode from Equipment.
    [Tags]    testrailid=99216
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    go back
    Sleep    ${Sleep_5s}
    ${mode_M_EC}    Get mode name from equipment card HVAC
    should be equal as strings    ${newECC_modes_List}[${mode_set_ED}]    ${mode_M_EC}

TC-30:Max Heating setpoint that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint that can be set from Equipment should be 90F.
    [Tags]    testrailid=99217

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_heat_max}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}
    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

TC-31:User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment.
    [Tags]    testrailid=99218

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_heat_max}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${setvalue}    Evaluate    ${setpoint_ED_set}+1
    ${setpoint_ED_exceed}    Write objvalue From Device
    ...    ${setvalue}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should not be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_exceed}
    Navigate to Detail Page    ${deviceText}
    go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

TC-32:User should be able to set Cooling mode from Equipment
    [Documentation]    User should be able to set Cooling mode from Equipment.
    [Tags]    testrailid=99219

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    go back
    Sleep    ${Sleep_5s}
    ${mode_M_EC}    Get mode name from equipment card HVAC
    should be equal as strings    ${newECC_modes_List}[${mode_set_ED}]    ${mode_M_EC}

TC-33:Min Cooling setpoint that can be set from Equipment should be 52F.
    [Documentation]    Min Cooling setpoint that can be set from Equipment should be 52F.
    [Tags]    testrailid=99220

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_cool_min}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}
    Navigate to Detail Page    ${deviceText}
    go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

TC-34:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment.
    [Tags]    testrailid=99221

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_cool_min}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setvalue}    Evaluate    ${setpoint_ED_set}-1
    ${setpoint_ED_exceed}    Write objvalue From Device
    ...    ${setvalue}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should not be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_exceed}
    Navigate to Detail Page    ${deviceText}
    go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

TC-35:User should be able to set Auto mode from Equipment
    [Documentation]    User should be able to set Auto mode from Equipment.
    [Tags]    testrailid=99222
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    go back
    Sleep    ${Sleep_5s}
    ${mode_M_EC}    Get mode name from equipment card HVAC
    should be equal as strings    ${newECC_modes_List}[${mode_set_ED}]    ${mode_M_EC}

TC-36:User should be able to set Fan Only mode from Equipment
    [Documentation]    User should be able to set Fan Only mode from Equipment.
    [Tags]    testrailid=99223
    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    go back
    Sleep    ${Sleep_5s}
    ${mode_M_EC}    get text    ${HVACOffText_Equipmentcard}
    should be equal as strings    ${newECC_modes_List}[${mode_set_ED}]    ${mode_M_EC}

TC-38:Updating Fan Speed to Low from Equipment should be reflected on App.
    [Documentation]    Updating Fan Speed to Low from Equipment should be reflected on App.
    [Tags]    testrailid=99225

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${mode_set_ED}]    ${FanSpeed_EC}

TC-39:Updating Fan Speed to Med.Lo from Equipment should be reflected on App.
    [Documentation]    Updating Fan Speed to Med.Lo from Equipment should be reflected on App.
    [Tags]    testrailid=99226
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${mode_set_ED}]    ${FanSpeed_EC}

TC-40:Updating Fan Speed to Medium from Equipment should be reflected on App.
    [Documentation]    Updating Fan Speed to Medium from Equipment should be reflected on App.
    [Tags]    testrailid=99227

    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${mode_set_ED}]    ${FanSpeed_EC}

TC-41:Updating Fan Speed to Med.Hi from Equipment should be reflected on App.
    [Documentation]    Updating Fan Speed to Med.Hi from Equipment should be reflected on App.
    [Tags]    testrailid=99228
    Go back

############################ Set Mode From Equipment ############################

    ${changeModeValue}    Set Variable    4
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${mode_set_ED}]    ${FanSpeed_EC}

TC-42:Updating Fan Speed to High from Equipment should be reflected on App.
    [Documentation]    Updating Fan Speed to High from Equipment should be reflected on App.
    [Tags]    testrailid=99229
    ${changeModeValue}    Set Variable    5
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    should be equal as strings    ${newECC_fanmodes_List}[${mode_set_ED}]    ${FanSpeed_EC}

TC-43:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App.
    [Tags]    testrailid=99230
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    ${HeatSetpoint}    ${CoolSetpoint}    ${FanSpeed}    Set AwayMode for HVAC device
    ...    ${select_NewECC_location}
    Navigate to Detail Page    ${deviceText}
    go back
    wait until page contains element    ${Location_Away_icon}
    click element    ${Location_Away_icon}
    Sleep    ${Sleep_5s}
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    ${HeatSetpoint_EC}    Get Heat Setpoint from equipmet card HVAC
    ${CoolSetpoint_EC}    Get Cool Setpoint from equipmet card HVAC

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    AWAYMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-44:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App.
    [Tags]    testrailid=99231
    Select Device Location    ${select_NewECC_location}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    Disable Away mode from mobile application    ${select_NewECC_location}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-45:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature and mode from App.
    [Tags]    testrailid=99232

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${HeatTemp}    ${CoolTemp}    ${FanSpeed}    Set Schedule For HVAC Device    Schedule
    Sleep    5s
    Page Should Contain Text    Following Schedule
    go back
    Sleep    10s
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    ${HeatSetpoint_EC}    Get Heat Setpoint from equipmet card HVAC
    ${CoolSetpoint_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${HeatTemp}    ${HeatSetpoint_EC}
    Should be equal as integers    ${CoolTemp}    ${CoolSetpoint_EC}
    should be equal as strings    ${FanSpeed}    ${FanSpeed_EC}
    ${HeatTemp_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${HeatTemp_ED}    ${HeatTemp}
    ${CoolTemp_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${CoolTemp_ED}    ${CoolTemp}
    ${FanSpeed_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_fanmodes_List}[${FanSpeed_ED}]    ${FanSpeed}

TC-46:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App.
    [Tags]    testrailid=99233
    Navigate to Detail Page    ${select_NewECC_location}
    Sleep    ${Sleep_5s}
    Copy HVAC Schedule Data    Schedule
    Go back

TC-47:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App.
    [Tags]    testrailid=99234
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${select_NewECC_location}
    Sleep    10s

    page should contain text    Resume
    Go Back

TC-48:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=99235
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    click text    Resume
    Sleep    ${Sleep_10s}
    page should contain text    Following Schedule
    go back
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED_heat}    ${setpoint_M_EC_heat}
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED_cool}    ${setpoint_M_EC_cool}

TC-49:User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Tags]    testrailid=99236
    Navigate to Detail Page    ${select_NewECC_location}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}’==‘False’    Click Element    ${SwitchToButton}
    click element    ${HeatPlusButton}

    Sleep    ${Sleep_5s}
    page should contain text    Resume
    click text    Resume
    Sleep    ${Sleep_10s}
    page should contain text    Following Schedule
    Go Back
    ${setpoint_M_DP}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-50:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=99237
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${select_NewECC_location}
    Sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}’==‘False’    Click Element    ${SwitchToButton}
    click element    ${CoolPlusButton}
    Sleep    ${Sleep_5s}
    page should contain text    Resume
    click text    Resume
    Sleep    ${Sleep_10s}
    page should contain text    Following Schedule
    Go Back
    ${setpoint_M_EC_cool1}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC_cool}    ${setpoint_M_EC_cool1}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC_cool1}

TC-51:User should be able to Resume Schedule when scheduled cool temperature is not follow for cooling mode.
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow for cooling mode.
    [Tags]    testrailid=99238

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${set_mode_M}    Set Cooling Mode Of Smart Thermosate
    go back
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${deviceText}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    ' ${Status}'=='False'    Click Element    ${SwitchToButton}
    click element    ${CoolPlusButton}
    Sleep    ${Sleep_5s}
    page should contain text    Resume
    click text    Resume
    Sleep    ${Sleep_10s}
    page should contain text    Following Schedule
    Go Back
    ${setpoint_M_EC_cool1}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED_cool}    ${setpoint_M_EC_cool1}

TC-52:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App.
    [Tags]    testrailid=99239
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Navigate to Detail Page    ${deviceText}
    ${HeatTemp}    ${CoolTemp}    ${FanSpeed}    Set Schedule For HVAC Device    Schedule
    Sleep    5s
    Page Should Contain Text    Following Schedule
    go back
    Sleep    10s
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    ${HeatSetpoint_EC}    Get Heat Setpoint from equipmet card HVAC
    ${CoolSetpoint_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${HeatTemp}    ${HeatSetpoint_EC}
    Should be equal as integers    ${CoolTemp}    ${CoolSetpoint_EC}
    should be equal as strings    ${FanSpeed}    ${FanSpeed_EC}
    ${HeatTemp_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${HeatTemp_ED}    ${HeatTemp}
    ${CoolTemp_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${CoolTemp_ED}    ${CoolTemp}
    ${FanSpeed_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${newECC_fanmodes_List}[${FanSpeed_ED}]    ${FanSpeed}

TC-53:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App.
    [Tags]    testrailid=99240
    Navigate to Detail Page    ${deviceText}
    Unfollow the schedule    Schedule
    page should not contain text    Following Schedule
    go back

TC-54:Deadband of 0 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99241
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-55:Deadband of 0 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 0 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99242

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-56:Deadband of 1 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99243

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    51
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-57:Deadband of 1 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 1 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99244
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    91
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-58:Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment.    :EndDevice->Mobile
    [Tags]    testrailid=99245
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-59:Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment.    :EndDevice->Mobile
    [Tags]    testrailid=99246
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

TC-60:Deadband of 2 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 2 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99247
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    2
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-61:Deadband of 2 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 2 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99248
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    2
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-62:Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99249

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    2
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-63:Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99250
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    2
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

TC-64:Deadband of 3 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 3 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99251
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    3
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    53
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-65:Deadband of 3 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 3 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99252
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    3
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    89
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-66:Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99253
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    3
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-67:Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99254

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    3
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

TC-68:Deadband of 4 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 4 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99255
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    4
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    54
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-69:Deadband of 4 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 4 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99256
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    4
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    88
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-70:Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99257

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    4
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-71:Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99258
    Go back
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    4
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

TC-72:Deadband of 5 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 5 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99259
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    5
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    55
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-73:Deadband of 5 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 5 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99260
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    5
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    87
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-74:Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99261
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    5
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-75:Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99262

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    5
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    5s
    go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

TC-76:Deadband of 6 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 6 should be maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99263
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    6
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    56
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-77:Deadband of 6 should be maintained for max setpoint limit from Equipment
    [Documentation]    Deadband of 6 should be maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99264
    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    6
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    86
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-78:Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment.
    [Tags]    testrailid=99265

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${DeadbandValue}    Set Variable    6
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    10s
    go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-79:Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment
    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment.
    [Tags]    testrailid=99266

    Navigate to Detail Page    ${deviceText}
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${DeadbandValue}    Set Variable    6
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-86:Max temperature of heating that can be set from Equipment should be 32C for Auto mode.
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode.
    [Tags]    testrailid=99273

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-87:Min temperature of heating that can be set from Equipment should be 10C for Auto mode.
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode.
    [Tags]    testrailid=99274

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_10s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Select Device Location    ${select_NewECC_location}
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-88:Max temperature of heating that can be set from App should be 32C for Auto mode.
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode.
    [Tags]    testrailid=99275

    Temperature Unit in Celsius
    ${get_temp}    Get Heat Setpoint From Equipmet Card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Go Back
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})+1
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-89:Min temperature of heating that can be set from App should be 10C for Auto mode.
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode.
    [Tags]    testrailid=99276

    Temperature Unit in Celsius
    ${get_temp}    Get Heat Setpoint From Equipmet Card HVAC
    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Go Back
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-90:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode.
    [Tags]    testrailid=99277

    Temperature Unit in Celsius
    ${get_temp}    Get Heat Setpoint From Equipmet Card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Go Back
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})+1
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-91:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.
    [Tags]    testrailid=99278

    Temperature Unit in Celsius
    ${get_temp}    Get Heat Setpoint From Equipmet Card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Sleep    10s
    Go Back
    ${setpoint_M_EC}    Get Heat Setpoint From Equipmet Card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-92:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode.
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode.
    [Tags]    testrailid=99279

    ${setMode_ED}    write objvalue from device
    ...    1
    ...    STATNMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-93:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode.
    [Tags]    testrailid=99280

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1}) * (${value2}/${value3})
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-94:Max temperature of cooling that can be set from App should be 33C for Auto mode.
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode.
    [Tags]    testrailid=99281

    Temperature Unit in Celsius
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    33    ${CoolPlusButton}
    Sleep    ${Sleep_10s}
    Go Back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-95:Min temperature of cooling that can be set from App should be 11C for Auto mode.
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode.
    [Tags]    testrailid=99282

    Navigate to Detail Page    ${deviceText}
    Sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    11    ${CoolMinusButton}
    Go Back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-96:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode.
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode.
    [Tags]    testrailid=99283

    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    33    ${CoolPlusButton}
    Go Back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}-1
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-97:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.
    [Tags]    testrailid=99284

    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate to Detail Page    ${deviceText}
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    11    ${CoolMinusButton}
    Go Back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-113:User should be able to change the Humidity value from App.
    [Documentation]    User should be able to change the Humidity value from App.

    Navigate to Detail Page    ${select_NewECC_location}
    click element    ${HVAC_Humidity}
    Change Humidity Value in HVAC Device
    ${HumidityPer}    get text    ${HumidityValue}
    go back
    ${HumidityValue_DP}    get text    ${HumidityValue_Detail}
    should be equal as strings    ${HumidityPer}    ${HumidityValue_DP}
