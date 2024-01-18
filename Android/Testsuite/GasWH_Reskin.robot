*** Settings ***
Documentation       This is the test file for End to end testing of Gas WH

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
...                     AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${select_Gas_location}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Run Keywords    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Gas_location}
Test Teardown       Run keyword if test failed    Save screenshot with timestamp


*** Variables ***
# -->test applince script info
${Device_Mac_Address}                   F48E38A7F48E
${Device_Mac_Address_In_Formate}        F4-8E-38-A7-F4-8E
${EndDevice_id}                         4102

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
${Admin_EMAIL}                          automation@rheem.com
${Admin_PWD}                            87654321
${emailId}                              automation@rheem.com
${passwordValue}                        87654321

# --> Select Device Location
${select_Gas_location}                  Gas WH
${deviceText}                           Gas Water Heater

# --> Setpoint Values
${setpoint_max}                         125
${setpoint_min}                         90
${setpoint_max_C}                       52
${setpoint_min_C}                       32
${value1}                               35
${value2}                               5
${value3}                               9

# --> Eagle WH Mode list

@{Gas_modes_List}                       Disabled    Enabled
# --> Sleep Time
${Sleep_5s}                             5s
${Sleep_10s}                            10s
${Sleep_20s}                            20s


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
    Navigate to Detail Page    ${select_Gas_location}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-02:Updating set point from Equipment should be reflected on dashboard and App.
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and App.

    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment    Set Point temperature from App.


    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}+1
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

############################ Validating Temperature Value on EndDevice ############################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.

    ${setpoint_ED_R}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED_W}    Evaluate    ${setpoint_ED_R} + 1
    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_ED_W}
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

############################ Validating Temperature Value On Rheem Mobile Application ############################

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement    Set Point temperature from App.


    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    ${setpoint_M_DP}    evaluate    ${setpoint_M_DP}-1
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-06:User should be able to decrement Set Point temperature from Equipment.
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment.

    ${setpoint_ED_R}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED_W}    Evaluate    ${setpoint_ED_R} - 1
    ${setpoint_ED}    Write objvalue From Device
    ...    ${setpoint_ED_W}
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile

    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-07:Max temperature that can be set from App should be 125F.
    [Documentation]    Max temperature that can be set from App should be 125F.

 
    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    set variable
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-08:Min temperature that can be set from App should be 90F.
    [Documentation]    Min temperature that can be set from App should be 90F.

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    set variable
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-09:Max temperature that can be set from Equipment should be 125F.
    [Documentation]    Max temperature that can be set from Equipment should be 125F.

    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-10:Min temperature that can be set from Equipment should be 90F.
    [Documentation]    Min temperature that can be set from Equipment should be 90F.
    
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-11:User should not be able to exceed max setpoint limit i.e. 125F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 125F from App

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

############################ Validating Temperature Value On Equipment ############################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-12:User should not be able to exceed min setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 90F from App

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    Sleep    ${Sleep_5s}
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-13:Max temperature that can be set from Equipment should be 52C.
    [Documentation]    Max temperature that can be set from Equipment should be 52C.

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Temperature Unit in Celsius
    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 32C.
    [Documentation]    Min temperature that can be set from Equipment should be 32C.

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Temperature Unit in Celsius
    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 52C.
    [Documentation]    Max temperature that can be set from App should be 52C.

    Navigate to Detail Page    ${select_Gas_location}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 32C.
    [Documentation]    Min temperature that can be set from App should be 32C.
    Navigate to Detail Page    ${select_Gas_location}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 52C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 52C from App

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    ${result3}    evaluate    ${result2}+1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 32C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 32C from App

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    ${result3}    evaluate    ${result2}+1
    Should be equal as integers    ${result3}    ${setpoint_M_DP}
    Should be equal as integers    ${result3}    ${setpoint_M_EC}

    Temperature Unit in Fahrenheit

TC-19:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App.

    Select Device Location    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${Away_status_M}    Set Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_5s}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_20s}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-20:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App.

    Select Device Location    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${Away_status_M}    Disable Away mode from mobile application    ${deviceText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    VACA_NET
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_20s}
    Should be equal as integers    ${Away_status_M}    ${Away_status_ED}

TC-21:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${get_current_set_point}    Tankless Follow Schedule Data    Schedule
    Wait Until Page Contains    ${deviceText}    ${Sleep_10s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Sleep    ${Sleep_5s}
    Should be equal as integers    ${setpoint_M_DP}    ${Scheduled_Temp}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${Scheduled_Temp}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${Scheduled_Temp}

TC-22:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App

    Navigate to Detail Page    ${select_Gas_location}
    ${get_all_values_of_current_day}    ${get_all_values_of_copied_day}    HPWH Copy Schedule Data    Schedule
    Lists Should Be Equal    ${get_all_values_of_current_day}    ${get_all_values_of_copied_day}

TC-23:Change the Scheduled temperature from App.
    [Documentation]    Change the Scheduled temperature from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    Page Should Contain Text    Schedule overridden
    ${setpoint_M_DP1}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${setpoint_M_DP}

TC-24:User should be able to Resume Schedule when scheduled temperature is not follow.
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow.

    Navigate to Detail Page    ${select_Gas_location}
    Sleep    ${Sleep_5s}
    Page Should Contain Text    Schedule overridden
    click element    ${Resume_Button}
    sleep    ${Sleep_5s}
    page should contain text    Following Schedule
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_DP}    ${setpoint_M_EC}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    ${Sleep_5s}
    should be equal as strings    ${setpoint_M_DP}    ${setpoint_ED}
    should be equal as strings    ${setpoint_M_EC}    ${setpoint_ED}

TC-25:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App

  
    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${Scheduled_Temp1}    Gladiator WH Update Setpoint From Schedule screen    Schedule
    Wait Until Page Contains    ${deviceText}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Should Be Equal As Strings    ${setpoint_M_DP}    ${Scheduled_Temp1}
    Page Should Contain Text    Following Schedule
    Go back
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should Be Equal As Strings    ${setpoint_ED}    ${setpoint_M_DP}

TC-26:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    Unfollow the schedule    Schedule
    Page should not contain text    Following Schedule

TC-27:Max temperature that can be set from App should be 125F.
    [Documentation]    Max temperature that can be set from App should be 125F.

    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_ED}    Write objvalue From Device
    ...    124
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    click element    ${TempInc_Button}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-28:Min temperature that can be set from App should be 90F.
    [Documentation]    Min temperature that can be set from App should be 90F.

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    91
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    click element    ${TempDec_Button}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-29:User should not be able to exceed max setpoint limit i.e. 125F from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 125F from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    click element    ${TempInc_Button}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-30:User should not be able to exceed min setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 90F from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    sleep    ${Sleep_5s}
    click element    ${TempDec_Button}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-31:User should not be able to exceed max setpoint limit i.e. 52C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 52C from App.

    ${setpoint_ED}    Write objvalue From Device
    ...    125
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius
    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    click element    ${TempInc_Button}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile

    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-32:User should not be able to exceed min setpoint limit i.e. 32C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 32C from App

    Navigate to Detail Page    ${select_Gas_location}
    sleep    ${Sleep_5s}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    click element    ${TempDec_Button}
    sleep    ${Sleep_5s}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-33:A Caution message should not appear if user set temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from App
   
    Navigate to Detail Page    ${select_Gas_location}
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-34:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
 
    Navigate to Detail Page    ${select_Gas_location}
    wait until page contains element    ${WH_Temp_WarningMsg}    ${DefaultTimeout}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-35:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment.

    ${setpoint_ED}    Write objvalue From Device
    ...    119
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Page Should Not Contain Element    ${WH_Temp_WarningMsg}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}

TC-36:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    ${setpoint_ED}    Write objvalue From Device
    ...    121
    ...    WHTRSETP
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to Detail Page    ${select_Gas_location}
    ${setpoint_M_DP}    Validate set point Temperature From Mobile
    Wait Until Page Contains Element    ${WH_Temp_WarningMsg}    ${DefaultTimeout}
    ${WarningMsg}    get text    ${WH_Temp_WarningMsg}
    should be equal as strings    ${WarningMsg}    ${WarningMsgExpected}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    Go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
