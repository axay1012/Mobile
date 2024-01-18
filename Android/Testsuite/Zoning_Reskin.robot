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
...                     AND    Select Device Location    ${select_zone_location}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Run Keywords    Open application and Navigate to Dashboard App    AND    Select Device Location    ${select_zone_location}


*** Variables ***
#    -->test applince script info

${Device_Mac_Address}                   F48E38A7F4FE
${Device_Mac_Address_In_Formate}        F4-8E-38-A7-F4-FE
${Main_Zone_EndDevice_id}               896
${Zone_EndDevice_id}                    1664
# ${Zone_EndDevice_id}    1664

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info

${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Zoning

# --> admin cred
${Admin_EMAIL}                          automation@rheem.com
${Admin_PWD}                            Vyom@0212
${emailId}                              automation@rheem.com
${passwordValue}                        Vyom@0212

#    -->    Select Device Location
${select_zone_location}                 Zone
${deviceText}                           //android.widget.FrameLayout[@resource-id='com.rheem.econetconsumerandroid:id/hvacCardView']

#    -->    Zone Mode
@{Zone_Modes_List}                      Heating    Cooling    Auto    Fan Only    Off
@{Zone_fanspeed_List}                   Auto    Low    Med.Lo    Medium    Med.Hi    High

#    -->    Set Point Value
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


*** Test Cases ***
TC-01:Updating Auto Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.
    [Documentation]    Updating Auto Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216102

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    ${Sleep_10s}
    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${changeModeValue}    Set Variable    2
    Sleep    5s
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    10s
    page should contain text    @{Zone_Modes_List}[${changeModeValue}]
    Go back
    Go back
    ${get_mode_EC}    get text    ${HVACMode_EquipmentCard}
    Should be equal as strings    ${get_mode_EC}    Auto
    Sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as strings    ${Zone_Modes_List}[${current_mode_ED}]    ${get_mode_EC}

TC-02:Updating Heating setpoint for Main ECC from App should be reflected on dashboard and Equipment.
    [Documentation]    Updating Heating setpoint for Main ECC from App should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216103

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Sleep    5s
    Click element    ${HeatPlusButton}
    Sleep    ${Sleep_5s}
    Go back
    Go back
    Sleep    4s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-03:Updating Heating setpoint for Main ECC from Equipment should be reflected on App dashboard.
    [Documentation]    Updating Heating setpoint for Main ECC from Equipment should be reflected on App dashboard.    :EndDevice->Mobile
    [Tags]    testrailid=216104
    ${setpoint_ED}    Write objvalue From Device
    ...    60
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    2s

TC-04:Updating Cooling setpoint for Main ECC from App should be reflected on App dashboard and Equipment.
    [Documentation]    Updating Cooling setpoint for Main ECC from App should be reflected on App dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216105

    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page    ${deviceText}
    Sleep    2s
    Navigate To Main Zone Detail Screen
    Sleep    5s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Sleep    5s
    Click element    ${CoolPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Sleep    5s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:Updating Cooling setpoint for Main ECC from Equipment should be reflected on App dashboard.
    [Documentation]    Updating Cooling setpoint for Main ECC from Equipment should be reflected on App dashboard.    :EndDevice->Mobile
    [Tags]    testrailid=216106
    ${setpoint_ED}    Write objvalue From Device
    ...    85
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    2s

TC-06:Min Heating setpoint that can be set for Main ECC from Equipment should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Main ECC from Equipment should be 50F.    :EndDevice->Mobile
    [Tags]    testrailid=216107

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    10s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    2s

TC-07:Max Cooling setpoint that can be set for Main ECC from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Main ECC from Equipment should be 92F.    :EndDevice->Mobile
    [Tags]    testrailid=216108

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Should be equal as integers    ${setpoint_ED}    92
    Should be equal as integers    ${setpoint_M_EC}    92
    Sleep    2s

TC-08:Min Heating setpoint that can be set for Main ECC from App should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Main ECC from App should be 50F.    :Mobile->EndDevice
    [Tags]    testrailid=216109

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen

    Sleep    5s
    ${setPointMDP}    Update Heating Setpoint Using Button    50    ${HeatMinusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}

TC-09:Max Cooling setpoint that can be set for Main ECC from App should be 92F.
    [Documentation]    Max Cooling setpoint that can be set from App should be 92F.    :Mobile->EndDevice
    [Tags]    testrailid=216110

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    92    ${CoolPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from App    :Mobile->EndDevice
    [Tags]    testrailid=216111

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    50    ${HeatMinusButton}
    Click element    ${HeatMinusButton}
    Go back
    Go back
    #

    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-11:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from App
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App    :Mobile->EndDevice
    [Tags]    testrailid=216112

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    92    ${CoolPlusButton}
    Click element    ${CoolPlusButton}
    Go back
    Go back

    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-12:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216113

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    50    ${HeatMinusButton}
    Click element    ${HeatMinusButton}
    Go back
    Go back

    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216114
    ${setpoint_ED}    Write objvalue From Device
    ...    93
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Navigate To Zone Detail Page    ${deviceText}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    Sleep    2s

TC-14:Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment.
    [Documentation]    Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216115

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Sleep    5s
    Click element    ${HeatPlusButton}
    Sleep    ${Sleep_5s}
    Go back
    Go back
    Sleep    4s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-15:Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard.
    [Documentation]    Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard.    :EndDevice->Mobile
    [Tags]    testrailid=216116
    ${setpoint_ED}    Write objvalue From Device
    ...    80
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    wait until page contains element    ${HeatButtonSetPoint}    ${default_timeout}
    ${setPoint}    get text    ${HeatButtonSetPoint}
    Should be equal as integers    ${setPoint}    ${setpoint_ED}

TC-16:Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment.
    [Documentation]    Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216117

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Click element    ${CoolPlusButton}
    Sleep    5s
    wait until page contains element    ${CoolButtonSetPoint}
    ${SetPoint}    Get Text    ${CoolButtonSetPoint}

    Go back
    Go back
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${SetPoint}

TC-17:Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard.
    [Documentation]    Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard.    :EndDevice->Mobile
    [Tags]    testrailid=216118

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Sleep    5s

    ${setpoint_ED}    Write objvalue From Device
    ...    70
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Sleep    5s
    ${SetPoint}    Get Text    ${CoolButtonSetPoint}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${SetPoint}

TC-18:Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F.    :EndDevice->Mobile
    [Tags]    testrailid=216119

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click element    ${SwitchToButton}
    Sleep    5s
    ${SetPoint}    get text    ${HeatButtonSetPoint}
    Should be equal as integers    ${SetPoint}    ${setpoint_ED}

TC-19:Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.    :EndDevice->Mobile
    [Tags]    testrailid=216120

    Navigate To Zone Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='True'    Click element    ${SwitchToButton}
    ${SetPoint}    get text    ${CoolButtonSetPoint}
    Should be equal as integers    ${SetPoint}    ${setpoint_ED}

TC-20:Min Heating setpoint that can be set for Zoned CC from App should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from App should be 50F.    :Mobile->EndDevice
    [Tags]    testrailid=216121

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    50    ${HeatMinusButton}

    Go back
    Go back
    Sleep    5s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-21:Max Cooling setpoint that can be set for Zoned CC from App should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from App should be 92F.    :Mobile->EndDevice
    [Tags]    testrailid=216122

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    92    ${CoolPlusButton}

    Go back
    Go back
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-22:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from App    :Mobile->EndDevice
    [Tags]    testrailid=216123

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    50    ${HeatMinusButton}
    Click element    ${HeatMinusButton}

    Go back
    Go back
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-23:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App    :Mobile->EndDevice
    [Tags]    testrailid=216124

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    92    ${CoolPlusButton}
    Click element    ${CoolPlusButton}

    Go back
    Go back
    Sleep    5s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-24:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216125

    Navigate To Zone Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    49
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}’==‘False’    Click element    ${SwitchToButton}
    Sleep    2s
    ${setpoint_M_DP}    Get Text    ${HeatButtonSetPoint}
    Should not be equal as integers    49    ${setpoint_M_DP}
    Go back
    Go back

TC-25:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216126

    #

    Navigate To Zone Detail Page    ${deviceText}
    ${setpoint_ED}    Write objvalue From Device
    ...    93
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}’==‘False’    Click element    ${SwitchToButton}
    ${setpoint_M_DP}    Get Text    ${CoolButtonSetPoint}

    Should not be equal as integers    93    ${setpoint_M_DP}

    Go back
    Go back

TC-26:Updating Off Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.
    [Documentation]    Updating Off Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216127

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${changeModeValue}    Set Variable    4
    Sleep    5s
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    page should contain text    Off
    Go back
    Navigate To Sub Zone Device Detail Screen
#    wait until page contains    ${deviceText}    10s
#    Go back
    Sleep    5s
    Go back
    Sleep    5s

    Sleep    5s
    page should contain text    OFF
    Sleep    5s

    ${mode_Main_ECC_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Main_ECC_ED}]    OFF
    Sleep    5s
    ${mode_Zone_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Zone_ED}]    OFF

TC-27:Updating Heating Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.
    [Documentation]    Updating Heating Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216128

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${changeModeValue}    Set Variable    0
    Sleep    5s
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    page should contain text    Heating
    Go back
    Go back
    Sleep    5s
    page should contain text    Heating
    ${mode_Main_ECC_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Main_ECC_ED}]    Heating
    Sleep    5s
    ${mode_Zone_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Zone_ED}]    Heating

TC-28:Max Heating setpoint for Main ECC that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint for Main ECC that can be set from App should be 90F.    :Mobile->EndDevice
    [Tags]    testrailid=216129

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    5s

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    90    ${HeatPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-29:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from App    :Mobile->EndDevice
    [Tags]    testrailid=216130

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    90    ${HeatPlusButton}
    Click element    ${HeatPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-30:Max Heating setpoint for Zoned CC that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from App should be 90F.    :Mobile->EndDevice
    [Tags]    testrailid=216131

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    90    ${HeatPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-31:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App    :Mobile->EndDevice
    [Tags]    testrailid=216132

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    90    ${HeatPlusButton}
    Click element    ${HeatPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-32:Updating Cooling Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.
    [Documentation]    Updating Cooling Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216133

    Navigate To Zone Detail Page    ${deviceText}
    click text    ${deviceText}
    Navigate To Main Zone Detail Screen
    wait until page contains    ${deviceText}    10s
    ${changeModeValue}    Set Variable    1
    Sleep    5s
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    page should contain text    Cooling
    Go back
    Go back

    wait until page contains    ${deviceText}    10s
    Sleep    5s
    page should contain text    Cooling
    Sleep    5s

    ${mode_Main_ECC_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Main_ECC_ED}]    Cooling
    Sleep    5s
    ${mode_Zone_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Zone_ED}]    Cooling

TC-33:Min Cooling setpoint that can be set for Main ECC from App should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Main ECC from App should be 52F.    :Mobile->EndDevice
    [Tags]    testrailid=216134

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    5s

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    52    ${HeatPlusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-34:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from App
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from App    :Mobile->EndDevice
    [Tags]    testrailid=216135

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    52    ${CoolMinusButton}
    Click element    ${CoolMinusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-35:Min Cooling setpoint that can be set for Zoned CC from App should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from App should be 52F.    :Mobile->EndDevice
    [Tags]    testrailid=216136

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    52    ${CoolMinusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-36:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from App
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from App    :Mobile->EndDevice
    [Tags]    testrailid=216137

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    52    ${HeatMinusButton}
    Click element    ${HeatMinusButton}
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-37:Updating Fan Only Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Only Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216138

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${changeModeValue}    Set Variable    3
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    page should contain text    Fan Only
    Go back
    Go back
    Sleep    5s

    Sleep    5s
    page should contain text    Fan Only

    Sleep    5s

    ${mode_Main_ECC_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    @{Zone_Modes_List}[${mode_Main_ECC_ED}]    Fan Only
    Sleep    5s
    ${mode_Zone_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    should be equal    @{Zone_Modes_List}[${mode_Zone_ED}]    Fan Only

TC-38:Updating Fan Speed to Auto from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Auto from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216139

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]

    Set Fan Speed    Auto
    Sleep    5s
    Go back
    Go back

    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    should be equal    ${setpoint_M_EC}    Auto
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    should be equal    ${setpoint_ED}    Auto
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

    Sleep    5s

TC-39:Updating Fan Speed to Low from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Low from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216140

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Set Fan Speed    Low
    Sleep    5s
    Go back
    Go back
    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    Should be equal as strings    ${setpoint_M_EC}    Low
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    Low
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

TC-40:Updating Fan Speed to Med.Lo from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Med.Low from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216141

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Set Fan Speed    Med.Lo
    Sleep    5s
    Go back
    Go back

    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    Should be equal as strings    ${setpoint_M_EC}    Med.Lo
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    Med.Lo
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

    Sleep    5s

TC-41:Updating Fan Speed to Medium from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Medium from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216142

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Set Fan Speed    Medium
    Sleep    5s
    Go back
    Go back

    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    Should be equal as strings    ${setpoint_M_EC}    Medium
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    Medium
    Should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

TC-42:Updating Fan Speed to Med.Hi from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to Medium High from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216143

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Set Fan Speed    Med.Hi
    Sleep    5s
    Go back
    Go back
    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    should be equal    ${setpoint_M_EC}    Med.Hi
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    Med.Hi
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

TC-43:Updating Fan Speed to High from App detail page of Main ECC should be reflected on dashboard and Equipment.
    [Documentation]    Updating Fan Speed to High from App detail page of Main ECC should be reflected on dashboard and Equipment.    :Mobile->EndDevice
    [Tags]    testrailid=216144

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Set Fan Speed    High
    Sleep    5s
    Go back
    Go back
    ${setpoint_M_EC}    Get FanSpeed from equipment card HVAC
    should be equal    ${setpoint_M_EC}    High
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    High
    should be equal    ${Zone_fanspeed_List}[${setpoint_ED}]    ${setpoint_M_EC}

    Sleep    5s

TC-44:Setting Off mode from Equipment for Main ECC applies on Zoned CCs.
    [Documentation]    Setting Off mode from Equipment for Main ECC applies on Zoned CCs.    :EndDevice->Mobile
    [Tags]    testrailid=216145

    ${changeModeValue}    Set Variable    4
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Sleep    4s

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    5s
    page should contain text    Off
    Go back
    Navigate To Sub Zone Device Detail Screen
    page should contain text    Off

    Sleep    5s
    page should contain text    OFF
    Sleep    5s

TC-45:Setting Heating mode from Equipment for Main ECC applies on Zoned CCs.
    [Documentation]    Setting Heating mode from Equipment for Main ECC applies on Zoned CCs.    :EndDevice->Mobile
    [Tags]    testrailid=216146

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Sleep    5s

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    page should contain text    Heating
    Should be equal as strings    @{Zone_Modes_List}[${mode_set_ED}]    Heating
    Go back
    Go back

    page should contain text    Heating

    Sleep    5s

TC-46:Max Heating setpoint for Main ECC that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint for Main ECC that can be set from Equipment should be 90F.    :EndDevice->Mobile
    [Tags]    testrailid=216147

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_heat_max}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}

    Sleep    5s

    Sleep    4s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

    Sleep    5s

TC-47:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.    :EndDevice->Mobile
    [Tags]    testrailid=216148

    ${setpoint_ED_set}    Write objvalue From Device
    ...    91
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    5s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED_set}    evaluate    ${setpoint_ED_set}-1
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

    Sleep    5s

TC-48:Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.    :EndDevice->Mobile
    [Tags]    testrailid=216149

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_heat_max}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Sleep    5s
    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}

    Sleep    5s

TC-49:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment.
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment.    :EndDevice->Mobile
    [Tags]    testrailid=216150

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_heat_max}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Sleep    5s
    ${setvalue}    Evaluate    ${setpoint_ED_set}+1
    ${setpoint_ED_exceed}    Write objvalue From Device
    ...    ${setvalue}
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Should not be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_exceed}

    Sleep    5s

TC-50:Setting Cooling mode from Equipment for Main ECC applies on Zoned CCs.
    [Documentation]    Setting Cooling mode from Equipment for Main ECC applies on Zoned CCs.    :EndDevice->Mobile
    [Tags]    testrailid=216151

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Sleep    5s

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    page should contain text    Cooling
    Should be equal as strings    @{Zone_Modes_List}[${mode_set_ED}]    Cooling
    Go back
    Go back

    page should contain text    Cooling

    Sleep    5s

TC-51:Min Cooling setpoint that can be set for Main ECC from Equipment should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Main ECC from Equipment should be 52F.    :EndDevice->Mobile
    [Tags]    testrailid=216152

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_cool_min}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}

    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}
    Sleep    5s

    Sleep    4s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

    Sleep    4s

TC-52:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from Equipment
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216153

    ${setpoint_ED_set}    Write objvalue From Device
    ...    51
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Sleep    2s
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    ${setpoint_ED_set}    evaluate    ${setpoint_ED_set}+1
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_M_EC}

    Sleep    4s

TC-53:Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F.    :EndDevice->Mobile
    [Tags]    testrailid=216154

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_cool_min}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Sleep    4s
    ${setpoint_ED_get}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_get}

    Sleep    4s

TC-54:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment.    :EndDevice->Mobile
    [Tags]    testrailid=216155

    ${setpoint_ED_set}    Write objvalue From Device
    ...    ${newECC_setpoint_cool_min}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Sleep    4s
    ${setvalue}    Evaluate    ${setpoint_ED_set}-1
    ${setpoint_ED_exceed}    Write objvalue From Device
    ...    ${setvalue}
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}

    Should not be equal as integers    ${setpoint_ED_set}    ${setpoint_ED_exceed}

    Sleep    4s

TC-55:Setting Auto mode from Equipment for Main ECC applies on Zoned CCs.
    [Documentation]    Setting Auto mode from Equipment for Main ECC applies on Zoned CCs.    :EndDevice->Mobile
    [Tags]    testrailid=216156

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Sleep    4s

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    page should contain text    Auto

    Go back
    Go back

    page should contain text    Auto

    Sleep    4s

TC-56:Setting Fan Only mode from Equipment for Main ECC applies on Zoned CCs.
    [Documentation]    Setting Fan Only mode from Equipment for Main ECC applies on Zoned CCs.:EndDevice->Mobile
    [Tags]    testrailid=216157

    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Sleep    4s

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    5s
    page should contain text    Fan Only
    Go back
    Go back
    Sleep    3s
    page should contain text    Fan Only

    Sleep    4s

#

TC-57:Setting Away mode for Main ECC from App applies on Zoned CCs.
    [Documentation]    Setting Away mode for Main ECC from App applies on Zoned CCs.    :Mobile->EndDevice
    [Tags]    testrailid=216158

#

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    ${Sleep_5s}
    ${Away_status_M}    ${HeatSetpoint}    ${CoolSetpoint}    ${FanSpeed}    Set AwayMode for HVAC device
    ...    ${select_zone_location}
    wait until page contains element    ${Location_Away_icon}
    Click element    ${Location_Away_icon}
    Sleep    ${Sleep_5s}
    ${FanSpeed_EC}    Get FanSpeed from equipment card HVAC
    ${HeatSetpoint_EC}    Get Heat Setpoint from equipmet card HVAC
    ${CoolSetpoint_EC}    Get Cool Setpoint from equipmet card HVAC

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACAENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0

TC-58:Away mode should get disabled for Main ECC as well as Zoned CCs.
    [Documentation]    Away mode should get disabled from Cloud for Main ECC as well as Zoned CCs.    :Mobile->EndDevice
    [Tags]    testrailid=216159

#

    Navigate To Zone Detail Page    ${deviceText}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    Sleep    4s

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACAENAB
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

#

TC-59:Schedule the temperature and Fan speed from App for Main ECC.
    [Documentation]    Schedule the temperature and Fan speed from App for Main ECC.    :Mobile->EndDevice
    [Tags]    testrailid=216160

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    ${Schedule_current_set_point_heat}
    ...    ${Schedule_current_set_point_cool}
    ...    ${Schedule_current_mode}
    ...    Set Schedule For HVAC Device
    ...    Schedule
    Go back
    Sleep    20s

    Verify Followed Schedule Changes like Set Point and Mode on Detail Page
    Navigate To Main Zone Detail Screen
    Page Should Contain Text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as strings    ${setpoint_M_EC_heat}    ${Schedule_current_set_point_heat}
    Should be equal as strings    ${setpoint_M_EC_cool}    ${Schedule_current_set_point_cool}

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${Schedule_current_set_point_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${Schedule_current_set_point_cool}

TC-60:Copy the Scheduled Day slot, temperature and fan speed from App for Main ECC.
    [Documentation]    Copy the Scheduled Day slot, temperature and fan speed from App for Main ECC.    :Mobile->EndDevice
    [Tags]    testrailid=216161

#
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s

    Sleep    ${Sleep_5s}
    Copy HVAC Schedule Data    Schedule
    Go back

TC-61:Change the Scheduled temperature and Fan Speed from App for Main ECC.
    [Documentation]    Change the Scheduled temperature and Fan Speed from App for Main ECC.    :Mobile->EndDevice
    [Tags]    testrailid=216162

#

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    5s
    Set Fan Speed    Auto
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click element    ${SwitchToButton}
    Click element    ${CoolPlusButton}
    Sleep    15s
    page should contain text    Resume
    Go back
    Sleep    5s
    Go back
    Sleep    5s

TC-62:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=216163

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    click text    ${Resume_Button}
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${setpoint_M_EC_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${setpoint_M_EC_cool}

TC-63:User should be able to Resume Schedule when scheduled heat temperature is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled heat temperature is not follow.
    [Tags]    testrailid=216164

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click element    ${SwitchToButton}
    Click element    ${HeatPlusButton}
    Sleep    15s
    page should contain text    Resume
    Sleep    4s
    click text    ${Resume_Button}
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    5s

TC-64:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=216165

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click element    ${SwitchToButton}
    Click element    ${CoolPlusButton}
    Sleep    15s
    page should contain text    Resume
    Sleep    4s
    click text    ${Resume_Button}
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC

    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${get_temp}

TC-65:User should be able to Resume Schedule when scheduled Fan Speed is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled Fan Speed is not follow
    [Tags]    testrailid=216166

    ${FanSpeed_text}    Get FanSpeed from equipment card HVAC

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen

    click text    Fan Speed
    IF    '${FanSpeed_text}'=='Auto'
        click text    Low
    ELSE IF    '${FanSpeed_text}'=='Low'
        click text    Med.Lo
    ELSE IF    '${FanSpeed_text}'=='Med.Lo'
        click text    Medium
    ELSE IF    '${FanSpeed_text}'=='Medium'
        click text    Med.Hi
    ELSE IF    '${FanSpeed_text}'=='Med.Hi'
        click text    High
    END

    Sleep    10s
    page should contain text    Schedule overridden
    click text    Resume
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    10s

    ${mode_ED}    Read int return type objvalue From Device
    ...    STATNFAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Should be equal as strings    @{Zone_fanspeed_List}[${mode_ED}]    ${FanSpeed_text}

TC-66:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=216167

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click element    ${SwitchToButton}
    Click element    ${CoolPlusButton}
    Sleep    15s
    page should contain text    Resume
    Sleep    4s
    click text    ${Resume_Button}
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC

    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${get_temp}

TC-67:Re-Schedule the temperature and Fan speed from App for Main ECC.
    [Documentation]    Re-Schedule the temperature and Fan speed from App for Main ECC.    :Mobile->EndDevice
    [Tags]    testrailid=216168

#

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    Zone Set Mode    @{Zone_Modes_List}[${changeModeValue}]
    Sleep    4s
    ${Schedule_current_set_point_heat}
    ...    ${Schedule_current_set_point_cool}
    ...    ${Schedule_current_mode}
    ...    Set Schedule For HVAC Device
    ...    Schedule
    Go back
    Sleep    20s

    Verify Followed Schedule Changes like Set Point and Mode on Detail Page
    Navigate To Main Zone Detail Screen
    Page Should Contain Text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as strings    ${setpoint_M_EC_heat}    ${Schedule_current_set_point_heat}
    Should be equal as strings    ${setpoint_M_EC_cool}    ${Schedule_current_set_point_cool}

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${Schedule_current_set_point_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${Schedule_current_set_point_cool}

TC-68:Unfollow the scheduled temperature and Fan speed from App for Main ECC.
    [Documentation]    Unfollow the scheduled temperature and Fan speed from App for Main ECC.    :Mobile->EndDevice
    [Tags]    testrailid=216169

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    Unfollow the schedule    Schedule
    Go back

TC-69:Schedule the temperature and Fan speed from App for Zoned CC.
    [Documentation]    Schedule the temperature and Fan speed from App for Zoned CC.    :Mobile->EndDevice
    [Tags]    testrailid=216170

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    4s
    ${changeModeValue}    Set Variable    2
    ${Schedule_current_set_point_heat}
    ...    ${Schedule_current_set_point_cool}
    ...    ${Schedule_current_mode}
    ...    Set Schedule For HVAC Device
    ...    Schedule
    Go back
    Sleep    20s
    Navigate To Sub Zone Device Detail Screen
    Page Should Contain Text    Following Schedule
    Go back
    Go back
    Sleep    5s

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${Schedule_current_set_point_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${Schedule_current_set_point_cool}

TC-70:Copy the Scheduled Day slot, temperature and fan speed from App for Zoned CC.
    [Documentation]    Copy the Scheduled Day slot, temperature and fan speed from App for Zoned CC.    :Mobile->EndDevice
    [Tags]    testrailid=216171

#
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    4s

    Sleep    ${Sleep_5s}
    Copy HVAC Schedule Data    Schedule
    Go back

TC-71:Change the Scheduled temperature and Fan Speed from App for Zoned CC.
    [Documentation]    Change the Scheduled temperature and Fan Speed from App for Zoned CC.    :Mobile->EndDevice
    [Tags]    testrailid=216172

#

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    5s
    Set Fan Speed    Auto
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click element    ${SwitchToButton}
    Click element    ${CoolPlusButton}
    Sleep    15s
    page should contain text    Resume
    Go back
    Go back
    Sleep    5s

TC-72:User should be able to Resume Schedule when scheduled temperature is not follow for Sub Zone device.
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow for Sub Zone device.
    [Tags]    testrailid=216173

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    Sleep    4s
    click text    ${Resume_Button}
    Sleep    15s
    page should contain text    Following Schedule
    Go back
    Go back
    Sleep    5s
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${setpoint_M_EC_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${setpoint_M_EC_cool}

TC-73:Re-Schedule the temperature and Fan speed from App for Zoned CC.
    [Documentation]    Re-Schedule the temperature and Fan speed from App for Zoned CC.    :Mobile->EndDevice
    [Tags]    testrailid=216174

#

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    4s
    ${changeModeValue}    Set Variable    2
    ${Schedule_current_set_point_heat}
    ...    ${Schedule_current_set_point_cool}
    ...    ${Schedule_current_mode}
    ...    Set Schedule For HVAC Device
    ...    Schedule
    Go back
    Sleep    20s
    Navigate To Sub Zone Device Detail Screen
    Page Should Contain Text    Following Schedule
    Go back
    Go back
    Sleep    5s

    ${setpoint_ED_heat}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_heat}    ${Schedule_current_set_point_heat}
    Sleep    4s
    ${setpoint_ED_cool}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Should be equal as strings    ${setpoint_ED_cool}    ${Schedule_current_set_point_cool}

TC-74:Unfollow the scheduled temperature and Fan speed from App for Zoned CC.
    [Documentation]    Unfollow the scheduled temperature and Fan speed from App for Zoned CC.    :Mobile->EndDevice
    [Tags]    testrailid=216175

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    click text    ${deviceText}
    Navigate To Sub Zone Device Detail Screen
    Sleep    4s
    Unfollow the schedule    Schedule
    Go back

TC-75:Deadband of 0 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment for Zoned CC.    :EndDevice->Mobile
    [Tags]    testrailid=216176

    Sleep    2s
#    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    0

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-76:Deadband of 0 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 0 should be maintained for max setpoint limit from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216177

    Sleep    2s
#    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Sleep    4s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-77:Deadband of 1 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216178

    Sleep    2s
#    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    1

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    51
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Sleep    4s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-78:Deadband of 1 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 1 should be maintained for max setpoint limit from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216179

    Sleep    2s
#    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    1

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    91
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-79:Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216180

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    1

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-80:Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment    :EndDevice->Mobile
    [Tags]    testrailid=216181

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    1

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    4s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC    ${HAVCCoolTemp_Equipmentcard}

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-81:Deadband of 2 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 2 should be maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216182

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    2

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-82:Deadband of 2 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 2 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216183
    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    2

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-83:Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216184

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    2

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-84:Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216185

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    2

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-85:Deadband of 3 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 3 should be maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216186

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    3

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    53
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-86:Deadband of 3 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 3 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216187

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    3

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    89
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-87:Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216188

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    3

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-88:Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216189

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    3

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-89:Deadband of 4 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 4 should be maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216190

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    4

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    54
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-90:Deadband of 4 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 4 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216191

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    4

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    88
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-91:Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216192

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    4

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-92:Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216193

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    4

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-93:Deadband of 5 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 5 should be maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216194

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    5

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4
    ${cool_set_ED}    Write objvalue From Device
    ...    55
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-94:Deadband of 5 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 5 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216195

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    5

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    87
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-95:Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216196

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    5
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-96:Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216197

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    5

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-97:Deadband of 6 should be maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 6 should be maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216198

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    6

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${cool_set_ED}    Write objvalue From Device
    ...    56
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Go back
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-98:Deadband of 6 should be maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Deadband of 6 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216199

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    6

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    86
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-99:Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment
    [Tags]    testrailid=216200

    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    6

    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}
    ${heat_set_ED}    Write objvalue From Device
    ...    52
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-100:Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment for Zoned CC.
    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment
    [Tags]    testrailid=216201

    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    ${DeadbandValue}    Set Variable    6
    ${mode_set_ED}    Write objvalue From Device
    ...    2
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${Deadband_get_ED}    Read int return type objvalue From Device
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Should be equal as integers    ${Deadband_set_ED}    ${Deadband_get_ED}

    ${heat_set_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${cool_set_ED}    Write objvalue From Device
    ...    90
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    Go back
    Sleep    10s
    ${setpoint_M_EC_heat}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_EC_cool}    Get Cool Setpoint from equipmet card HVAC

    Should not be equal as integers    ${heat_set_ED}    ${setpoint_M_EC_heat}
    Should be equal as integers    ${cool_set_ED}    ${setpoint_M_EC_cool}

TC-101:Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Main Zone.
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Main Zone.    :EndDevice->Mobile
    [Tags]    testrailid=216201

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Sleep    2s
    Temperature Unit in Celsius
    Select Device Location    ${select_zone_location}
    Sleep    2s
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Sleep    5s

TC-102:Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Main Zone
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=216202

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC

    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-103:Max temperature of heating that can be set from App should be 32C for Auto mode in Main Zone.
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=216203

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    2s
    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}

TC-104:Min temperature of heating that can be set from App should be 10C for Auto mode in Main Zone
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=216204

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}

TC-105:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Main Zone.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=216205

    Navigate To Zone Detail Page    ${deviceText}
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Click element    ${HeatPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}

    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s

    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}
    Should be equal as integers    ${setpoint_ED}    ${setPointMDP}

TC-106:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Main Zone.
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=216206

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Sleep    4s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Heat Setpoint from equipmet card HVAC
    Click Text    ${deviceText}
    Sleep    2s
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setPointMDP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    ${result3}    evaluate    ${result2}-1
    Should be equal as integers    ${result3}    ${setPointMDP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-107:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Main Zone
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=216207

    ${DeadbandValue}    Set Variable    0
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    convert to integer    ${Deadband_set_ED}

    Sleep    4s

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Sleep    2s
    Temperature Unit in Celsius
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-108:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Main Zone.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=216208

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Sleep    2s
    Temperature Unit in Celsius
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC

    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-109:Max temperature of cooling that can be set from App should be 33C for Auto mode in Main Zone.
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=216209

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    33    ${CoolPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-110:Min temperature of cooling that can be set from App should be 11C for Auto mode in Main Zone
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=216210

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Click Text    ${deviceText}
    Sleep    2s
    Navigate To Main Zone Detail Screen
    ${setPointMDP}    Update Cooling Setpoint Using Button    11    ${CoolMinusButton}
    Go back
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-111:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Main Zone
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=216211

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Main Zone Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    33    ${CoolPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-112:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Main Zone
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=216212

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Main Zone Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    11    ${CoolMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP} +1
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-113:Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Zone CC
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=216213

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    STATMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Main_Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Sleep    2s
    Temperature Unit in Celsius
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers     ${setpoint_M_EC}     ${setpoint_ED}

TC-114:Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Zone CC.
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Zone CC    :EndDevice->Mobile
    [Tags]    testrailid=216214

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Should be equal as integers     ${setpoint_M_EC}     ${setpoint_ED}

TC-115:Max temperature of heating that can be set from App should be 32C for Auto mode in Zone CC
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=216215
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    DEADBAND
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Heat Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Navigate To Sub Zone Device Detail Screen
    Sleep    4s
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Go back
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Sleep    20s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+8
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-116:Min temperature of heating that can be set from App should be 10C for Auto mode in Zone CC
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=216216

    Temperature Unit in Celsius
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Heat Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    5s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}-2
    Sleep    3s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    ${result3}    evaluate    ${result2}-1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}

TC-117:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=216217

    Temperature Unit in Celsius
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Heat Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    32    ${HeatPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}-1
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-118:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Zone CC
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=216218

    Temperature Unit in Celsius
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Heat Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Heating Setpoint Using Button    10    ${HeatMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Heat Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}+1
    Sleep    4s

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    HEATSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}

TC-119:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Zone CC.
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=216219

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Sleep    5s
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-120:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Zone CC.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=216220

    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Sleep    5s
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-121:Max temperature of cooling that can be set from App should be 33C for Auto mode in Zone CC
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=216221

    Temperature Unit in Celsius
    Sleep    2s
    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    32    ${coolplusbutton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-122:Min temperature of cooling that can be set from App should be 11C for Auto mode in Zone CC.
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=216222

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Click Text    ${deviceText}
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    11    ${HeatMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    Sleep    4s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-123:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=216223

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Navigate To Zone Detail Page
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    33    ${CoolPlusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}-1
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-124:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=216224

    Select Device Location    ${select_zone_location}
    ${get_temp}    Get Cool Setpoint from equipmet card HVAC
    Click Text    ${deviceText}
    Sleep    2s
    Navigate To Sub Zone Device Detail Screen
    ${setpoint_M_DP}    Update Cooling Setpoint Using Button    11    ${CoolMinusButton}
    Go back
    Sleep    2s
    Go back
    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}+1
    Sleep    4s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    COOLSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${Zone_EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Temperature Unit in Fahrenheit