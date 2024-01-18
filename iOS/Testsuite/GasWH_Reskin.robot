*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Library             ../../src/RheemCustom.py
Resource            ../Keywords/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameGASWH}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameHPWH}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5

${EndDevice_id}                         ${EMPTY}

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

${emailId}                              automation2@rheem.com
${passwordValue}                        12345678

${maxTempVal}                           125

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice

    # Step 1) Changeing Set Point From remove application
    # Step 2 Verify Set Point in Device Detail Screen, Equipment card and End Device

    ${changeModeValue}    Set Variable    1
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
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile

    # Step 1) Changing temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice

    # Step 1 - Updating set point from application
    # Step 2 - Checking temperature value on End Device
    # Step 3 - Verifying both values

    Go to Temp Detail Screen
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile

    # Step 1) Set temperature from water heater
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice

    # Step 1) Set temperature from mobile and validating it on mobile itself
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on ${followScheduleMsgDashboard}

    Go to Temp Detail Screen
    ${Temperature_Mobile}    Decrement temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment. : EndDevice->Cloud->Mobile

    # Step 1) Set temperature from water heater
    # Step 2) Validating Value of temperature on Rheem Mobile Application.remove application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} - 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max temperature that can be set from App should be 125F. : Mobile->Cloud->EndDevice
    [Documentation]    Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice

    # Step-1)    Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2)    Validating value of temperature on Rheem Water Heater Pump.
    # Step-3)    Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the max temperature    125    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 90F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 110F. : Mobile->Cloud->EndDevice

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the min temperature    90    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max temperature that can be set from Equipment should be 125F. : EndDevice->Cloud->Mobile
    [Documentation]    Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    125
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 90F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 110F. : EndDevice->Cloud->Mobile

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Go to Temp Detail Screen
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}    ### Locator Issue
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 125F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the Max Temperature    125    ${imgBubble}

    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal    ${Temperature_Mobile}    140
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 90F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the min temperature    90    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:Max temperature that can be set from Equipment should be 52C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.    :EndDEevice->Mobile

    # Step-1)    User should be able to set max temp 60C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${result2}    convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 32C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C. :EndDEevice->Mobile

    # Step-1)    User should be able to set min temp 43C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${result1}    Evaluate    (${setpoint_ED} - ${value1}) * (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 52C.
    [Documentation]    Max temperature that can be set from App should be 60C. :Mobile->EndDevice

    # Step-1)    User should be able to set max temp 60C from the Rheem Application.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    52    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 32C.
    [Documentation]    Min temperature that can be set from App should be 43C.    :Mobile->EndDevice

    # Step-1)    User should be able to set min temp 43c from the Rheem Application
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    32    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 52C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App    :Mobile->EndDevice

    # Step-1)    User should not be able to set temperature above 60C (from Mobile Application)
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    52    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    should be equal    ${setpoint_M_DP}    52
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 32C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App :Mobile->EndDevice

    # Step-1) User should not be able to set temperature below 43C (from Mobile Application)
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    32    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    should be equal    ${setpoint_M_DP}    32
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App

    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.

    Go to Temp Detail Screen
    ${Temperature_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    set given min temperature    119
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp}    Get Text    ${currentTemp}
    ${temp_app}    Get current temperature from mobile app
    Should be equal    ${temp_app}    119
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App

    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.

    Go to Temp Detail Screen
    ${Temperature_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    set given max temperature    121
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${message}    Get caution message
    should be equal as strings    ${message}    ${expectedCautionMessage}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-21:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    # Step-1) A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${temp_app}    Get current temperature from mobile app
    Should be equal    ${temp_app}    121
    Page Should Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-22:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device
    ...    119
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen
    ${temp_app}    Get current temperature from mobile app    ## Locator Issue
    Should be equal    ${temp_app}    119
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-23:User should be able to set Away mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App    : Mobile->Cloud->EndDevice

    # Step-1) Configure Away mode in App validate on cloud and vacation end device.

    ${Away_status_M}    Set Away Mode    ${locationNameHPWH}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-24:User should be able to Disable Away from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App: Mobile->Cloud->EndDevice

    # Step-1) Disabling Configure vacation mode in App validate on cloud and end device.

    ${Away_status_M}    Disable Away Mode
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${Away_status_M}

TC-25:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature and mode from App

    # Step-1) Set Schedule from Application
    # Step-2) Verify on Application and End Device

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule    ${locationNameHPWH}
    ${temp}    Get from List    ${status}    0
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

    Should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${mode}

TC-26:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App

    # Step-1) Copy the Scheduled Day slot, temperature and mode from App

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data    ${locationNameHPWH}
    Navigate Back to the Screen
    Navigate to App Dashboard

TC-27:Change the Scheduled temperature from App
    [Documentation]    Change the Scheduled temperature and mode from App

    # Step-1) User must be able to enable schedule from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    verify schedule overridden    ${modeTempBubble}    ${maxTempVal}
    wait until page contains element    ${msgScheduleWaterHeater}    ${defaultWaitTime}
    ${message}    get text    ${msgScheduleWaterHeater}
    ${status}    check    ${message}    Schedule overridden
    ${verifiedStatus}    convert to boolean    True
    should be equal    ${status}    ${verifiedStatus}

    Navigate to App Dashboard

TC-28:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=33495

    # Step-1) Resume schedule temperature and validate
    # Step-2) Validate schedule temperature and mode on app

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${btnResume}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameHPWH}    # Locator issue
    click element    ${btnResume}
    wait until page contains    ${followScheduleMsgDashboard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${schedule_list}[0]
    ${current_mode_M}    Validate and return current Mode    ${schedule_list}[1]
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${dashBoardTemperature}    ${schedule_list}[0]
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    should be equal    ${modeValueDashboard}    ${schedule_list}[1]
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}[0]
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${schedule_list}[1]

TC-29:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=4239

    # Step-1) Re-Schedule the temperature and mode from App
    # Step-2) Verify from eqiupment end

    Go to Temp Detail Screen    ${tempDashBoard}
    click element    ${btnResume}
    ${status}    Verify schedule with changes in timeslot, mode and temperature    ${locationNameHPWH}
    ${temp}    Get from List    ${status}    0
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp1}
    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}
    ${mode}    Get from list    ${stat us}    1
    should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${mode}

TC-30:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App

    # Step-1) Unfollow the temperature and mode from App

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameHPWH}
    Navigate to App Dashboard

TC-31:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider

    # Step-1)    Select Button press option from Setpoint Control feature

    Temperature Unit in Fahrenheit

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    139    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    124
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    124
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    125
    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    125

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    125

TC-32:Min temperature that can be set from App should be 110F
    [Documentation]    User should be able to set min temperature 110F using button slider

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto mininum
    # Step-3)    Validate temperature on deshboard

    Temperature Unit in Fahrenheit
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    111    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    111
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    91
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    90
    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    90
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    90

TC-33:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Increment temperature value upto maximum
    # Step-3)    Validate temperature on deshboard
    # Step-4)    Validate temperature on device

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    125    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    125
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    125
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    125
    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    125

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    125

TC-34:User should not be able to exceed min setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed min temperature 110F using button slider

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto minium
    # Step-3)    Validate temperature on deshboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    90    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    90
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    90
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    90
    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    90
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    90

TC-35:User should not be able to exceed max setpoint limit i.e. 52F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the Max Temperature    125    ${imgBubble}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal    ${Temperature_Mobile}    125
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-36:User should not be able to exceed min setpoint limit i.e. 32F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen
    Scroll to the min temperature    32    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal    ${Temperature_Mobile}    32
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

Verify UI of Network Settings screen
    [Documentation]    Verify UI of Network Settings screen

    # Step-1)    Verify UI of Network Settings screen : Wifi Name, Mac Address, WIFI Software Version

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait Until Page Contains Element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Settings
    IF    ${Status}    Click Element    Settings
    ${Status1}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status1}    Click Element    Network
    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    wait until page contains element    Network SSID
    wait until page contains element    IP Address
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Documentation]    Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Documentation]    Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.

    # Step-1) User must be able to schedule Occupied mode from the app
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Documentation]    Verfiy that the user can set the minimum temperature of the time slot set point value using button.

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Documentation]    Verfiy that the user can set the maximum temperature of the time slot set point value using button.

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

Verfiy device specific alert on equipment card
    [Documentation]    Verfiy device specific alert on equipment card

    # Step-1) Verify Alert Notification on Equipment card

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Wait until element is visible    ${devicenotifications}     ${defaultWaitTime}
        Click Element    ${devicenotifications}
        Verify Device Alerts    Gas Water Heater
    END

Verfiy device specific alert on detail screen
    [Documentation]    Verfiy device specific alert on detail screen

    # Step-1) Verify Alert Notification on Device Detail Screen.

    Go to Temp Detail Screen    ${tempDashBoard}
    Click Element    ${iconNotification}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Wait until element is visible    ${devicenotifications}     ${defaultWaitTime}
        Click Element    ${devicenotifications}
        Verify Device Alerts    Gas Water Heater
    END