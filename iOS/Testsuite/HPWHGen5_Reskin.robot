*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameHPWHGen5}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameHPWHGen5}

Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4738

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

${emailId}                              %{HPWHGen5_Email}
${passwordValue}                        %{HPWHGen5_Password}

${maxTempVal}                           140

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment
    [Tags]    testrailid=84782

    # Step-1) Validating value of temperature on Rheem Mobile app
    # Step-2) Set water Energy Saver mode from end device
    # Step-3) Validating temperature value on End Device

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value    # Locator issue
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment
    [Tags]    testrailid=84783

    # Step-1) Changing temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating the temperature value on Rheem Mobile Application

    ${Temperature_ED}    Write objvalue From Device    111    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Sleep    2s
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers     ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App
    [Documentation]    User should be able to increment Set Point temperature from App
    [Tags]    testrailid=84784

    # Step-1) Validating value of temperature on Rheem Water Heater Pump.
    # Step-2) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    Sleep    2s
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:User should be able to increment Set Point temperature from Equipment
    [Documentation]    User should be able to increment Set Point temperature from Equipment
    [Tags]    testrailid=84785

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating the temperature value on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED_R}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
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
    [Tags]    testrailid=84786

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Select the Device Location    ${locationNameHPWHGen5}
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
    [Tags]    testrailid=84787
    # Step-1) Set temperature from water heater
    # Step-2) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-3) Validating Value of temperature on Rheem Mobile Application.

    ${Temperature_ED_R}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} - 1
    ${Temperature_ED}    Write objvalue From Device    ${Temperature_ED_W}    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max temperature that can be set from App should be 140F
    [Documentation]    Max temperature that can be set from App should be 140F
    [Tags]    testrailid=84788

    # Step-1) Validating value of temperature on Rheem Water Heater Pump.
    # Step-2) Validating temperature value on End Device
    # Step-3) Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    scroll to the max temperature    140    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 110F
    [Documentation]    Max temperature that can be set from App should be 140F
    [Tags]    testrailid=84789

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating temperature value on End Device
    # Step-3) Validating value of temperature on Rheem Water Heater Pump.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    110    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max temperature that can be set from Equipment should be 140F
    [Documentation]    Max temperature that can be set from Equipment should be 140F
    [Tags]    testrailid=84790
    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 110F
    [Documentation]    Max temperature that can be set from Equipment should be 140F
    [Tags]    testrailid=84791

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating the temperature value on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App
    [Tags]    testrailid=84792

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the max temperature    140    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=84793

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    110    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:Max temperature that can be set from Equipment should be 60C
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=84794

    # Step-1)    User should be able to set max temp 60C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    run keyword and ignore error     Navigate Back to the Screen
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 43C
    [Documentation]    Min temperature that can be set from Equipment should be 43C
    [Tags]    testrailid=84795

    # Step-1)    User should be able to set min temp 43C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    110    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C
    [Documentation]    Max temperature that can be set from App should be 60C
    [Tags]    testrailid=84796

    # Step-1)    User should be able to set max temp 60C from the Rheem Application.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device    139    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    Sleep    2s
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    2s
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 43C
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=84797

    # Step-1)    User should be able to set min temp 43c from the Rheem Application
    # Step-2)    Validating value of temperature on Rheem Water Heater Pump.
    # Step-3)    Validating Temperature Value On End Device

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device    45    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    43    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=84798

    # Step-1) Set Setpoint above Maximum Setpoint limit 60C From Mobile App and Validating it On Mobile App itself
    # Step-2)    User should not be able to set temperature above 60C (from Mobile Application)

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device    139    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    60
    Navigate Back to the Screen
    Sleep    2s
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    Min temperature that can be set from App should be 43C
    [Tags]    testrailid=84799

    # Set Setpoint below Minimum Setpoint limit 43C From Mobile App and Validating it On Mobile App itself
    # Step-1)    User should not be able to set temperature below 43C (from Mobile Application)
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device    111    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    43    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    43
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    [Teardown]    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=84800
    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    3s
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Sleep    5s
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=84801
    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-21:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=84802

    # Step-1) A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    5s
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-22:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=84803

    # Step-1) A Caution message should not appear if user set temperature below 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    121
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard

TC-23:User should be able to set Off mode from App
    [Documentation]    User should be able to set Off mode from App
    [Tags]    testrailid=84804

    # Set heat pump off mode from mobile application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${offModeHPWHG5}
    Sleep    2s
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device    1    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

TC-24:User should be able to set Energy Saver mode from App
    [Documentation]    User should be able to set Energy Saver mode from App
    [Tags]    testrailid=84805

    # Set heat pump Energy Saver mode from mobile application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice
    # Step-3) Validating value of mode on Dashboard

    ${mode_set_ED}    Write objvalue From Device    1    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${energySaverHPWHG5}
    Sleep    2s
    Element value should be    ${waterHeaterModeButton}    Energy Saver
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    Energy Saver
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Energy Saver    ${modeValueDashboard}

TC-25:User should be able to set Heat Pump mode from App
    [Documentation]    User should be able to set Heat Pump mode from App
    [Tags]    testrailid=84806
    # Set heat pump Heat Pump mode from mobile application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice
    # Step-3) Validating value of mode on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${heatPumpModeHPWHG5}
    Sleep    2s
    Element value should be    ${waterHeaterModeButton}    Heat Pump
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    Heat Pump
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    Heat Pump    ${modeValueDashboard}

TC-26:User should be able to enable Energy Saver mode after changing another mode from App
    [Documentation]    User should be able to enable Energy Saver mode after changing another mode from App
    [Tags]    testrailid=84807

    # Step-1) Verify and enable "ENERGY SAVING" msg with Enable tab on Detail page.
    # Step-2) Verify Energy Saving mode on detail screen
    # Step-3) Verify Energy Saving mode on dashboard
    # Step-4) Verify Energy Saving mode on equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    Verify and enable energy saving
    Element value should be    ${waterHeaterModeButton}    Energy Saver
    Navigate Back to the Screen
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    ${energySaverHPWHG5}    ${modeValueDashboard}
    ${mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_ED}]    ${energySaverHPWHG5}

TC-27:User should be able to set High Demand mode from App
    [Documentation]    User should be able to set High Demand mode from App
    [Tags]    testrailid=84808

    # Set heat pump High Demand mode from mobile application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice
    # Step-3) Validating value of mode on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${highDemandModeHPEHG5}
    Sleep    2s
    Element value should be    ${waterHeaterModeButton}    High Demand
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    High Demand
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    High Demand    ${modeValueDashboard}

TC-28:User should be able to set Electric mode from App
    [Documentation]    User should be able to set Electric mode from App
    [Tags]    testrailid=84809

    # Set heat pump Electric mode from mobile application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${electricModeHPEHG5}
    Sleep    2s
    Element value should be    ${waterHeaterModeButton}    Electric
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${current_mode_ED}]    Electric
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Electric    ${modeValueDashboard}

TC-30:Disabling Equipment from App detail page should be reflected on dashboard and Equipment
    [Documentation]    Disabling Equipment from App detail page should be reflected on dashboard and Equipment
    [Tags]    testrailid=84811

    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating Mode on Rheem Water Heater.
    # Step-3) Validating value of mode on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${DisableModeTriton}    catenate    ${DisableMode}
    Wait until page contains    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element    ${waterHeaterStateButton}
    Wait until page contains    Disabled    ${defaultWaitTime}
    Click element    Disabled
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${Triton_modes}[${mode_ED}]    Disabled
    ${disableText}    Get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    Should be equal    ${DisableMode}    ${disableStrippend}

TC-31:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=84812

    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating Mode on Rheem Water Heater.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${EnableModeTriton}    catenate    ${EnableMode}
    Wait until page contains    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element    ${waterHeaterStateButton}
    Wait until page contains    Enabled    ${defaultWaitTime}
    Click element    Enabled
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${Triton_modes}[${mode_ED}]    Enabled
    ${modeValueDashboard}    Get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-32:User should be able to set Off mode from Equipment
    [Documentation]    User should be able to set Off mode from Equipment
    [Tags]    testrailid=84813

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    Off

TC-33:User should be able to set Energy Saver mode from Equipment
    [Documentation]    User should be able to set Energy Saver mode from Equipment
    [Tags]    testrailid=84814

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Element value should be    ${waterHeaterModeButton}    Energy Saver
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    Energy Saver
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    Energy Saver    ${modeValueDashboard}

TC-34:User should be able to set Heat Pump mode from Equipment
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=84815

    # Step-1) Set Specific Mode on Rheem device(from devkit)/
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Element value should be    ${waterHeaterModeButton}    Heat Pump
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    Heat Pump
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    Heat Pump    ${modeValueDashboard}

TC-35:User should be able to set High Demand mode from Equipment
    [Documentation]    User should be able to set High Demand mode from Equipment
    [Tags]    testrailid=84816

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Element value should be    ${waterHeaterModeButton}    High Demand
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    High Demand
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    High Demand    ${modeValueDashboard}

TC-36:User should be able to set Electric mode from Equipment
    [Documentation]    User should be able to set Electric mode from Equipment
    [Tags]    testrailid=84817

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    4
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Element value should be    ${waterHeaterModeButton}    Electric
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    Electric
    Sleep    2s
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    Electric    ${modeValueDashboard}

TC-38:User should be able to Disable Equipment from End Device
    [Documentation]    User should be able to set Vacation mode from Equipment
    [Tags]    testrailid=84819

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Wait until page contains element    ${tempDashBoard}    ${defaultWaitTime}
    ${disableText}    Get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    Should be equal    ${DisableMode}    ${disableStrippend}

TC-39:User should be able to Enable Equipment from End Device
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=84820

    # Step-1) Set Specific Mode on Rheem device(from devkit)
    # Step-2) Validating mode on Rheem Mobile Application

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrenab}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate Back to the Screen
    Should be equal as strings    ${Triton_modes}[${mode_set_ED}]    Enabled
    ${modeValueDashboard}    Get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    Enabled    ${modeValueDashboard}

TC-40:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=84821

    # Step-1) Go to Daily usage report and verify energy usage

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${daily}
    Click element    ${daily}
    Wait until page contains    ${historicDataChartDay}    ${defaultWaitTime}

TC-41:User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Tags]    testrailid=84822

    Wait until element is visible    ${weekly}    ${defaultWaitTime}
    Click element     ${weekly}
    Sleep    5s
    Wait until page contains    ${historicDataChartWeek}    ${defaultWaitTime}

TC-43:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=84824

    Wait until element is visible     ${yearly}     ${defaultWaitTime}
    Click element    ${yearly}
    Sleep    5s
    Wait until page contains    ${historicDataChartYear}    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-46:Schedule the temperature and mode from App
    [Documentation]    User should be able to Disable Away from App
    [Tags]    testrailid=84827

    # Step-1) User must be able to enable schedule from the app

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
    ${mode}    Get from list    ${status}    1
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-47:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=84828

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameHPWHGen5}
    Navigate Back to the Screen
    run keyword and ignore error    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-48:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=84829

    # Step-1) User must be able to enable schedule from the app
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

    Go to Temp Detail Screen    ${tempDashBoard}
    ${updatedTemp}    Increment temperature value
    Sleep    10s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${updatedTemp}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${updatedTemp}    ${dashBoardTemperature}
    Should be equal as integers    ${updatedTemp}    ${updatedTemp}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to App Dashboard

TC-49:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=84830

    # step-1) Resume schedule temperature and validate
    # step-2) Validate schedule temperature and mode on app
    # step-3) Validate schedule temperature and mode on device

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${btnResume}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameHPWHGen5}
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Sleep    5s
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${schedule_list}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${dashBoardTemperature}    ${schedule_list}
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    Energy Saver

TC-50:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=84831

    # Step-1) Re-Schedule the temperature and mode from App

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
    ${mode}    Get from list    ${status}    1
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-51:User should be able to Resume Schedule when scheduled mode is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled mode is not follow
    [Tags]    testrailid=84832

    # Step-1) Change Mode to unfollow schedule
    # Step-2) Click on Resume button and verfiy following schedule
    # Step-3) Verfiy mode and temperature on App
    # step-4) Validate schedule temperature and mode on device

    Go to Temp Detail Screen    ${tempDashBoard}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameHPWHGen5}
    ${Mode_mobile}    Change Mode    ${heatPumpModeHPWHG5}
    Sleep    6s
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${heatPumpModeHPWHG5}
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${schedule_list}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${dashBoardTemperature}    ${schedule_list}
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    ${modeValueDashboard}    Energy Saver
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}

TC-52:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=84833

    # Step-1) Unfollow the temperature and mode from App

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Unfollow the schedule    ${locationNameHPWHGen5}
    Navigate to App Dashboard

TC-54:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=84834

    # Verfiy Running Status of Equipment
    # Step-1)    User should be able to disable running status.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${comp_rly}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${fan_ctrl}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Wait until page does not contain    Compressor Running    ${defaultWaitTime}
    Navigate Back to the Screen

TC-53:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=84835

    # Verfiy Running Status of Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${comp_rly}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${fan_ctrl}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Navigate Back to the Screen

TC-55:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=84836

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Increment temperature value upto maximum
    # Step-3)    Validate temperature on deshboard
    # Step-4)    Validate temperature on device

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
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    140
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    140

TC-56:Min temperature that can be set from App should be 110F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=84837

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto minium
    # Step-3)    Validate temperature on deshboard
    # Step-4)    Validate temperature on device

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
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    110
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    110

TC-57:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=84838

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Increment temperature value upto minium
    # Step-3)    Validate temperature on deshboard
    # Step-4)    Validate temperature on device

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
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    140
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    140

TC-58:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=84839

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto minium
    # Step-3)    Validate temperature on deshboard
    # Step-4)    Validate temperature on device

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
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    110
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    110

TC-59:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature from app
    [Tags]    testrailid=84840

    # Step-1) User must be able to enable schedule from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule using button    Energy Saver
    ${temp}    Get from List    ${status}    0
    ${temp}    Convert to integer    ${temp}
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode}    Get from list    ${status}    1
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-60:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow
    [Tags]    testrailid=84841

    # step-2) Change the schedule temperature and verfy it on device and app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${schedule_temp_mobile}    Get current temperature from mobile app
    ${schedule_temperature_ed}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${schedule_temp_mobile}    ${schedule_temperature_ed}

    ${current_mode_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${updated_temp_mobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Wait until page contains element    ${followScheduleMsgDashboard}
    ${resume_schedule_temp_mobile}    Get current temperature from mobile app
    Should be equal as integers    ${schedule_temp_mobile}    ${resume_schedule_temp_mobile}
    ${schedule_temperature_ed}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${schedule_temp_mobile}    ${schedule_temperature_ed}
    Navigate Back to the Screen

TC:61:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App
    [Tags]    testrailid=84842

    # Step-1)    Change temperature from App
    # Step-2)    Increase temperature value and verify on mobile

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device    ${changeUnitValue}    ${dispunit}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    run keyword and ignore error    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    60
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    60
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    60
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    60

TC-62:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button
    [Tags]    testrailid=84843

    # Step-1)    Change temperature from App
    # Step-2)    Increase temperature value and verify on mobile

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    43
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    43
    Temperature Unit in Fahrenheit

TC-63:User should be able to see Combustion Health Status
    [Documentation]    User should be able to see Combustion Health Status
    [Tags]    testrailid=84844

    Go to Temp Detail Screen    ${tempDashBoard}
    Verify Device Health Status Page
    Navigate Back to the Sub Screen

TC-64:Verify UI of Network Settings screen
    [Documentation]    Verify UI of Network Settings screen
    [Tags]    testrailid=222037

    run keyword and ignore error     Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    Wait until page contains element    ${ProductSetting}    ${defaultWaitTime}
    Click element    ${ProductSetting}
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${Network}
    IF    ${Status}    Click element    ${Network}
    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    Wait until page contains element    Network SSID
    Wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

#TC-65:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 40.
#    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 40.
#    [Tags]    testrailid=222046
#
#    # Step-1) Update HOTWATER=40 From Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    40    ${HOTWATER}    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${water_status_ED}    Read int return type objvalue From Device
#    ...    ${HOTWATER}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    1/3 Full    ${defaultWaitTime}
#
#TC-66:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
#    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 60.
#    [Tags]    testrailid=222047
#
#    # Step-1) Update HOTWATER=60 From Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    60    ${HOTWATER}    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    ${water_status_ED}    Read int return type objvalue From Device
#    ...    ${HOTWATER}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    2/3 Full    ${defaultWaitTime}
#
#TC-67:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 0.
#    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 0.
#    [Tags]    testrailid=222048
#
#    # Step-1) Update HOTWATER=0 From Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    0    ${HOTWATER}    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    ${water_status_ED}    Read int return type objvalue From Device
#    ...    ${HOTWATER}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    Empty    ${defaultWaitTime}
#
#TC-68:Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 100.
#    [Documentation]    Verify Hot Water Avaibility status in Mobile Application if HOTWATER = 100.
#    [Tags]    testrailid=222049
#
#    # Step-1) Update HOTWATER=100 From Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    100    ${HOTWATER}    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    ${water_status_ED}    Read int return type objvalue From Device
#    ...    ${HOTWATER}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    Full    ${defaultWaitTime}

TC-69:Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Documentation]    Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Tags]    testrailid=222040

    # Step-1) User must be able to set maximun 110 Set Point

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-70:Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Documentation]    Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Tags]    testrailid=222041

    # Step-1) User must be able to set maximun 140 Set Point

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

TC-71:Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Documentation]    Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Tags]    testrailid=222042

    # Step-1) User must be able to set maximun 110 Set Point

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-72:Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Documentation]    Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Tags]    testrailid=222043

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

TC-73:Verfiy device specific alert on equipment card
    [Documentation]    Verfiy device specific alert on equipment card
    [Tags]    testrailid=222038

    # Step-1) device specific alert on equipment card

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

TC-74:Verfiy device specific alert on detail screen
    [Documentation]    Verfiy device specific alert on equipment card
    [Tags]    testrailid=222039

    # Step-1) Device specific alert on detail screen

    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${iconNotification}
    IF    ${Status}==True
        Click element    ${iconNotification}
        Verify Device Alerts
    END

    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

#TC-79:Verify that the user can able to set usage report on full-screen landscape mode.
#    [Documentation]    Verify that the user can able to set usage report on full-screen landscape mode.
#    [Tags]    testrailid=222739
#
#    # Step-1) user can able to set usage report on full-screen landscape mode.
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    ${usageReport}    ${defaultWaitTime}
#    Click element    ${usageReport}
#    Sleep    2s
#    Wait until page contains    ${usageIncrease}    ${defaultWaitTime}
#    Click element    ${usageIncrease}
#    Page should not contain element    ${Historicaldatarepo}
#    Sleep    5s
#    Navigate Back to the Sub Screen
#    Navigate Back to the Screen
#    Navigate Back to the Screen

TC-80:Verify that user can able to Turn ON Historical data
    [Documentation]    Verify that user can able to Turn ON Historical data
    [Tags]    testrailid=222740

    # Step-1) Verify that user can able to Turn ON Historical data

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Wait until page contains    ${historicalDataSwitcher}    ${defaultWaitTime}
    ${value}    Get text    ${historicalDataSwitcher}
    IF    '${value}'=='Off'    Click element    ${value}
    Page should contain element    ${DailyHistory}    ${defaultWaitTime}

TC-81:Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.
    [Documentation]    Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh ${units of energy}.
    [Tags]    testrailid=222741

    # Step-1) Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.

    page should contain element    ${usageText}    ${defaultWaitTime}
    ${Value}    Get text    ${usageText}
    ${status}    check    ${Value}    ${units of energy}
    should be true    ${status}    True
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Navigate Back to the Screen

#TC-82: Verify if user update LSDETECT=0 then Leak Sensor connected should be appeared in Product Health
#    [Documentation]    Verify if user update LSDETECT=0 then Leak Sensor connected should be appeared in Product Health
#    [Tags]    testrailid=222742
#
#    # Step-1) Update LSDETECT from Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    0    LSDETECT    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    ${deviceHealth}    ${defaultWaitTime}
#    Click element    ${deviceHealth}
#    Sleep    2s
#    Wait until page contains    Leak Sensor Connected
#    Navigate Back to the Sub Screen
#    Navigate Back to the Screen
#
#TC-83: Verify if user update LSDETECT=1 then Leak Sensor not connected should be appeared in Product Health
#    [Documentation]    Verify if user update LSDETECT=1 then Leak Sensor not connected should be appeared in Product Health
#    [Tags]    testrailid=222743
#
#    # Step-1) Update LSDETECT from Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    1    LSDETECT    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    ${deviceHealth}    ${defaultWaitTime}
#    Click element    ${deviceHealth}
#    Sleep    2s
#    Navigate Back to the Sub Screen
#    Navigate Back to the Screen
#
#TC-84: Verify if user update SHUTOPEN then should valve Open should be appeared in Product Health
#    [Documentation]    Verify if user update SHUTOPEN then should valve Open should be appeared in Product Health
#    [Tags]    testrailid=222744
#
#    # Step-1) Update SHUTOPEN From Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    1    SHUTOFFV    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    ${mode_set_ED}    Write objvalue From Device    1    SHUTOPEN    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    ${deviceHealth}    ${defaultWaitTime}
#    Click element    ${deviceHealth}
#    Sleep    2s
#    Wait until page contains    Shut-OFF Valve - Open
#    Navigate Back to the Sub Screen
#    Navigate Back to the Screen

#TC-85: Verify if user update SHUTOPEN then should valve Closed should be appeared in Product Health
#    [Documentation]    Verify if user update SHUTOPEN then should valve Closed should be appeared in Product Health
#    [Tags]    testrailid=222745
#
#    # Step-1) Update SHUTOPEN from Cloud
#    # Step-2) Verify in App
#
#    ${mode_set_ED}    Write objvalue From Device    0    SHUTOPEN    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    ${deviceHealth}    ${defaultWaitTime}
#    Click element    ${deviceHealth}
#    Sleep    2s
#    Wait until page contains    Shut-OFF Valve - Closed
#    Navigate Back to the Sub Screen
#    Navigate Back to the Screen

TC-77:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App
    [Tags]    testrailid=84825

    # Step-1) Configure Away mode in App validate on cloud and vacation end device.

    Wait until element is visible    ${awayText}    ${defaultWaitTime}
    Click element    ${awayText}
    ${Status}    Run keyword and return status    Wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    ${locationNameHPWHGen5}

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
    Element value should be    ${homeaway}    ${awayModeText}

TC-78:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App
    [Tags]    testrailid=84826

    # Step-1) Disabling Configure vacation mode in App validate on cloud and end device.

    Wait until element is visible    ${awayText}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0
    Element value should be    ${homeaway}    ${homeModeText}

TC-75:User should be able to set Vacation mode from App
    [Documentation]    User should be able to set Vacation mode from App
    [Tags]    testrailid=84810

    # Set heat pump Electric mode from mobile application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${vacationModeHPWHG5}
    Sleep    2s
    # Validating Mode on Water Heter Pump
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-76:User should be able to set Vacation mode from Equipment
    [Documentation]    User should be able to set Vacation mode from Equipment
    [Tags]    testrailid=84818

    # Step-1) Set Specific Mode on Rheem device(from devkit)

    ${changeModeValue}    Set Variable    5
    ${mode_set_ED}    Write objvalue From Device    ${changeModeValue}    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Should be equal as strings    ${HPWH_Gen5_modes}[${mode_set_ED}]    Vacation
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    Vacation    ${modeValueDashboard}
    Wait until element is visible    ${awayText}    ${defaultWaitTime}
    Click element    ${homeaway}