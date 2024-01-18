*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
# Library    TimeSchedule.py
Library             ../../src/RheemMqtt.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

# Resource    ../resource/MqttConfig.robot
Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameThor}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
...                     Open Application without uninstall and Navigate to dashboard    ${locationNameThor}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4736

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          heatpumpWaterHeaterGen4

${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

${maxTempVal}                           140

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment
    [Tags]    testrailid=221901

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment
    [Tags]    testrailid=221902
    ${Temperature_ED}    Write objvalue From Device    111    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App
    [Documentation]    User should be able to increment Set Point temperature from App
    [Tags]    testrailid=221903
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:User should be able to increment Set Point temperature from Equipment
    [Documentation]    User should be able to increment Set Point temperature from Equipment
    [Tags]    testrailid=221904
    ${Temperature_ED_R}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    # Sleep    5s
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device    ${Temperature_ED_W}    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-05:User should be able to decrement Set Point temperature from App
    [Documentation]    User should be able to decrement Set Point temperature from App
    [Tags]    testrailid=221905    the temperature on mobile itself.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Decrement temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:User should be able to decrement Set Point temperature from Equipment
    [Documentation]    User should be able to decrement Set Point temperature from Equipment
    [Tags]    testrailid=221906
    ${Temperature_ED_R}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} - 1
    ${Temperature_ED}    Write objvalue From Device    ${Temperature_ED_W}    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max temperature that can be set from App should be 140F
    [Documentation]    Max temperature that can be set from App should be 140F
    [Tags]    testrailid=221907

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 110F
    [Documentation]    Max temperature that can be set from App should be 140F
    [Tags]    testrailid=221908    on mobile itself.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    2s
    Scroll to the min temperature    110    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max temperature that can be set from Equipment should be 140F
    [Documentation]    Max temperature that can be set from Equipment should be 140F
    [Tags]    testrailid=221909

    ${Temperature_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    # Validating the temperature value on Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 110F
    [Documentation]    Max temperature that can be set from Equipment should be 140F
    [Tags]    testrailid=221910

    ${Temperature_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    # Validating the temperature value on Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App
    [Tags]    testrailid=221911    and validating the temperature on mobile itself.

    Go to Temp Detail Screen    ${tempDashBoard}

    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}

    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]
    ...    testrailid=221912
    ...    and validating the temperature on mobile itself.
    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    2s
    Scroll to the min temperature    110    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:Max temperature that can be set from Equipment should be 60C
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=221913

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set maximum temp 60C from Equipment

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Navigate Back to the Screen
    # Verify temperature on Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 43C
    [Documentation]    Min temperature that can be set from Equipment should be 43C
    [Tags]    testrailid=221914
    Go to Temp Detail Screen    ${tempDashBoard}
    # Set minimum temp 43C from Equipment

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Navigate Back to the Screen
    #    Verify temperature on Mobile Application

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C
    [Documentation]    Max temperature that can be set from App should be 60C
    [Tags]    testrailid=221915
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    # Set maximum temperature 60C from the Mobile Application

    ${setpoint_ED}    Write objvalue From Device    58    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    # Validating Temperature Value On End Device

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 43C
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=221916

    Temperature Unit in Celsius

    ${setpoint_ED}    Write objvalue From Device    45    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set minimum temperature 43C from the Mobile Application

    Scroll to the min temperature    43    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    #    Validating Temperature Value On End Device

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=221917
    Temperature Unit in Celsius

    ${setpoint_ED}    Write objvalue From Device    138    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set Setpoint above Maximum Setpoint limit 60C From Mobile App and Validating it On Mobile App itself

    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    60

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    #    Validating Temperature Value On End Device

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=221918
    #    Set Setpoint below Minimum Setpoint limit 43C From Mobile App and Validating it On Mobile App itself

    Temperature Unit in Celsius

    ${setpoint_ED}    Write objvalue From Device    112    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}

    Scroll to the min temperature    43    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    43

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    # Validating Temperature Value On End Device

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

    [Teardown]    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=221919    above 119f/48c.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    6s
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Sleep    5s
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=221920    temperature above 119f/48c.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    ${Temperature_Mobile}    Get current temperature from mobile app

    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}

    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=221921
    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ...    above 120F/48C from Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    5s
    ${temp_app}    Get current temperature from mobile app
#    Should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-22:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above
    ...    120F/48C from Equipment
    [Tags]    testrailid=221922
    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ...    below 120F/48C from Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    121
    Sleep    10s
    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}

    Navigate to App Dashboard

TC-23:User should be able to set Heat Pump mode from App
    [Documentation]    User should be able to set Heat Pump mode from App
    [Tags]    testrailid=221923
    # Set heat pump Heat Pump mode from mobile application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${heatPumpModeHPWHG5}
    Sleep    2s
    Element value should be    waterHeaterModeButton    Heat Pump
    Navigate Back to the Screen

    # Validating Mode on Water Heter Pump

    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    Heat Pump

    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    Heat Pump    ${modeValueDashboard}

TC-24:Disabling Equipment from App detail page should be reflected on dashboard and Equipment
    [Documentation]    Disabling Equipment from App detail page should be reflected on dashboard and Equipment
    [Tags]    testrailid=221925

    Go to Temp Detail Screen    ${tempDashBoard}
    ${DisableModeTriton}    catenate    ${DisableMode}

    wait until page contains    waterHeaterStateButton    ${defaultWaitTime}
    Click Element    waterHeaterStateButton
    Sleep    2s
    ${Status}    run keyword and return status    click element    Disabled
    Navigate to App Dashboard

    ${mode_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    convert to integer    ${mode_ED}
    should be equal as strings    @{Triton_modes}[${mode_ED}]    Disabled

    ${disableText}    get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    should be equal    ${DisableMode}    ${disableStrippend}

TC-25:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=221926

    Go to Temp Detail Screen    ${tempDashBoard}
    ${EnableModeTriton}    catenate    ${EnableMode}
    wait until page contains    waterHeaterStateButton    ${defaultWaitTime}
    Click Element    waterHeaterStateButton
    Sleep    2s
    ${Status}    run keyword and return status    click element    Enabled

    Navigate to App Dashboard

    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    convert to integer    ${mode_ED}
    should be equal as strings    @{Triton_modes}[${mode_ED}]    Enabled

    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    Enabled    ${modeValueDashboard}

TC-26:User should be able to set Heat Pump mode from Equipment
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=221927
    ${changeModeValue}    Set Variable    2

    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    # Validate mode from mobile application

    Go to Temp Detail Screen    ${tempDashBoard}
    Element value should be    waterHeaterModeButton    Heat Pump
    Navigate Back to the Screen
    should be equal as strings    @{HPWH_Gen5_modes}[${mode_set_ED}]    Heat Pump

    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Heat Pump    ${modeValueDashboard}

TC-27:User should be able to Disable Equipment from End Device
    [Documentation]    User should be able to set Vacation mode from Equipment
    [Tags]    testrailid=221929
    ${changeModeValue}    Set Variable    0

    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    # Validate mode from mobile application

    ${disableText}    get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    should be equal    ${DisableMode}    ${disableStrippend}

TC-28:User should be able to Enable Equipment from End Device
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=221930
    ${changeModeValue}    Set Variable    1

    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    # Validate mode from mobile application

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate Back to the Screen
    should be equal as strings    @{Triton_modes}[${mode_set_ED}]    Enabled

    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Enabled    ${modeValueDashboard}

TC-29:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=221931
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    Go to Temp Detail Screen    ${tempDashBoard}

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Daily
    click element    Daily
    wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-30:User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Tags]    testrailid=221932

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    Go to Temp Detail Screen    ${tempDashBoard}

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Weekly
    click element    Weekly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-31:User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Tags]    testrailid=221933

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Monthly
    click element    Monthly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Month, Current Month    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-32:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=221934

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    5s
    wait until page contains    Yearly
    click element    Yearly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-33:Schedule the temperature and mode from App
    [Documentation]    User should be able to Disable Away from App
    [Tags]    testrailid=221937

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule    Heat Pump
    ${temp1}    Get from List    ${status}    0
    ${temp}    Convert to integer    ${temp1}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    ${mode}    Get from list    ${status}    1
    should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-34:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=221938
    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameThor}
    Navigate Back to the Screen
    Navigate to App Dashboard

TC-35:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=221939

    Go to Temp Detail Screen    ${tempDashBoard}
    ${updatedTemp}    Increment temperature value

    Sleep    10s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Navigate to App Dashboard
    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${updatedTemp}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${updatedTemp}    ${dashBoardTemperature}

    Should be equal as integers    ${updatedTemp}    ${updatedTemp}
    Go to Temp Detail Screen    ${tempDashBoard}

    Navigate to App Dashboard

TC-36:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=221940
    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${btnResume}

    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameThor}
    click element    ${btnResume}

    Sleep    5s
    wait until page contains element    ${followScheduleMsgDashboard}

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${schedule_list}

    Navigate to App Dashboard

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${dashBoardTemperature}    ${schedule_list}

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}

    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}
    should be equal as strings    @{HPWH_Gen5_modes}[${mode_get_ED}]    Energy Saver

TC-37:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=221941

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule    Energy Saver
    ${temp1}    Get from List    ${status}    0
    ${temp}    Convert to integer    ${temp1}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    ${mode}    Get from list    ${status}    1
#    should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-38:User should be able to Resume Schedule when scheduled mode is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled mode is not follow
    [Tags]    testrailid=221942
    Go to Temp Detail Screen    ${tempDashBoard}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameThor}

    ${Mode_mobile}    Change Mode    ${heatPumpModeHPWHG5}
    Sleep    6s

    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}
    should be equal as strings    @{HPWH_Gen5_modes}[${mode_get_ED}]    ${heatPumpModeHPWHG5}

    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    wait until page contains element    ${btnResume}
    click element    ${btnResume}
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${schedule_list}

    Navigate to App Dashboard

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${dashBoardTemperature}    ${schedule_list}

    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    ${modeValueDashboard}    Energy Saver

    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}

TC-39:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=221943

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameThor}
    Navigate to App Dashboard

TC-40:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=221944
    #    Verfiy Running Status of Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${comp_rly}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${fan_ctrl}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Wait until page does not contain    Compressor Running    ${defaultWaitTime}
    Navigate Back to the Screen

TC-41:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=221945
    #    Verfiy Running Status of Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${comp_rly}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${fan_ctrl}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Sleep    5s
    Wait until page contains element    Compressor Running
    Navigate Back to the Screen

TC-42:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=221946

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    139    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    139

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    139

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    140

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    140

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    140

TC-43:Min temperature that can be set from App should be 110F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=221947

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    111    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    111

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    111

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    110

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    110

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    110

TC-44:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=221948

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    140

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    140

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    140

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    140

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    140

TC-45:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=221949

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    110

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    110

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    110

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    110

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    110

TC-46:Schedule the temperature and mode from App using Button
    [Documentation]    Schedule the temperature and mode from App using Button
    [Tags]    testrailid=221950

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule using button    Energy Saver
    ${temp1}    Get from List    ${status}    0
    ${temp}    Convert to integer    ${temp1}
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}

    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    ${mode}    Get from list    ${status}    1
    should be equal as strings    @{HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-47:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow
    [Tags]    testrailid=221951

    Go to Temp Detail Screen    ${tempDashBoard}

    ${schedule_temp_mobile}    Get current temperature from mobile app
    ${schedule_temperature_ed}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${schedule_temp_mobile}    ${schedule_temperature_ed}

    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${updated_temp_mobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}

    Click element    ${btnResume}
    Wait until page contains element    ${followScheduleMsgDashboard}
    ${resume_schedule_temp_mobile}    Get current temperature from mobile app
    Should be equal as integers    ${schedule_temp_mobile}    ${resume_schedule_temp_mobile}

    ${schedule_temperature_ed}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${schedule_temp_mobile}    ${schedule_temperature_ed}
    Navigate Back to the Screen

TC:48:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App
    [Tags]    testrailid=221952

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set maximum temp 60C from Equipment

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${setpoint_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    60

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    60

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    60

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${result2}    60

TC-49:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button
    [Tags]    testrailid=221953
    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set minimum temp 43C from Equipment

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    43
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    43
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    43
    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    43
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}

    Should be equal as integers    ${result2}    43

TC-50:User should be able to see Combustion Health Status
    [Documentation]    User should be able to see Combustion Health Status
    [Tags]    testrailid=221954
    Go to Temp Detail Screen    ${tempDashBoard}
    Verify Device Health Status Page
    Navigate Back to the Sub Screen

TC-51:Verify UI of Network Settings screen
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221955
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    Wait Until Page Contains Element    Settings
    Click Element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status}    Click Element    Network
    wait until page contains element    MAC Address
    wait until page contains element    WiFi Software Version
    wait until page contains element    Network SSID
    wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-52:Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221956
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END
    Select the Device Location    ${locationNameThor}
    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-53:Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221957
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    Select the Device Location    ${locationNameThor}
    # we will develope keywords for the scroll soon    used button
    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

TC-54:Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221958
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    Select the Device Location    ${locationNameThor}
    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-55:Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221959
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END

    Select the Device Location    ${locationNameThor}
    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}

    Navigate to App Dashboard

TC-56:Verfiy device specific alert on equipment card
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=221960
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END
    Select the Device Location    ${locationNameThor}
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts    //XCUIElementTypeNavigationBar[@name="Heat Pump Water Heater Gen 4"]
    END

TC-57:Verfiy device specific alert on detail screen
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=2219561
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameThor}
    END
    Select the Device Location    ${locationNameThor}
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    validateBell
    IF    ${Status}==True
        Click Element    validateBell
        Verify Device Alerts    //XCUIElementTypeNavigationBar[@name="Heat Pump Water Heater Gen 4"]
    END

TC-58:TC-29:User should be able to set Vacation mode from App
    [Documentation]    User should be able to set Vacation mode from App
    [Tags]    testrailid=221924
    # Set heat pump Electric mode from mobile application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${vacationModeHPWHG5}

    Sleep    5s

    Page should contain text    Local Away
    Element value should be    ${homeaway}    I'm Away

    # Validating Mode on Water Heter Pump
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    convert to integer    ${current_mode_ED}
    should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    Vacation

    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Vacation    ${modeValueDashboard}

TC-59:User should be able to set Vacation mode from Equipment
    [Documentation]    User should be able to set Vacation mode from Equipment
    [Tags]    testrailid=221928
    ${changeModeValue}    Set Variable    5
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    should be equal as strings    @{HPWH_Gen5_modes}[${mode_set_ED}]    Vacation
    Page should contain text    Local Away
    Element value should be    ${homeaway}    I'm Away

TC-60:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App
    [Tags]    testrailid=221935

    Click element    ${awayText}

    ${Status}    Run keyword and return status    wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    Thor

    # Validating temperature value on End Device

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${A}    set variable    1
    ${A}    convert to integer    ${A}
    Should be equal as integers    ${Away_status_ED}    ${A}
    Element value should be    ${homeaway}    I'm Away

TC-61:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App
    [Tags]    testrailid=221936

    Click element    homeAwayButtonIdentifier
    # Validating temperature value on End Device
    ${A}    set variable    0
    ${A}    convert to integer    ${A}

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${A}
    Element value should be    ${homeaway}    I'm Home

TC-62:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 40.
    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 40.
    [Tags]    testrailid=222735

    ${mode_set_ED}    Write objvalue From Device    40    HOTWATER    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${water_status_ED}    Read int return type objvalue From Device
    ...    HOTWATER
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Page should contain element    1/3 Full
    Navigate Back to the Screen

TC-63:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
    [Tags]    testrailid=222736

    ${mode_set_ED}    Write objvalue From Device    60    HOTWATER    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${water_status_ED}    Read int return type objvalue From Device
    ...    HOTWATER
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Page should contain element    2/3 Full
    Navigate Back to the Screen

TC-64:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
    [Tags]    testrailid=222737
    ${mode_set_ED}    Write objvalue From Device    0    HOTWATER    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${water_status_ED}    Read int return type objvalue From Device
    ...    HOTWATER
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Page should contain element    Empty
    Navigate Back to the Screen

TC-65:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 100.
    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 100.
    [Tags]    testrailid=222738
    ${mode_set_ED}    Write objvalue From Device    100    HOTWATER    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${water_status_ED}    Read int return type objvalue From Device
    ...    HOTWATER
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Page should contain element    Full
    Navigate Back to the Screen
