*** Settings ***
Documentation       Rheem iOS Dragon Water Heater Test Suite

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
...                     AND    Select the Device Location    ${locationNameDragon}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameDragon}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         %{Dragon_DeviceID}

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Dragon

${emailId}                              %{Dragon_Email}
${passwordValue}                        %{Dragon_Password}

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment.
    [Tags]    testrailid=90908

    # Step-1) Validating value of temperature on Rheem Mobile app
    # Step-2) Validating value of temperature on Rheem Water Heater Pump
    # Step-3) Validating value of temperature on Dashboard

    write objvalue from device
    ...    1
    ...    ${occupied}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment.
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=90909

    # Step-1) Changing temperature of Rheem water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90910

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on    Water Heater.
    # Step-3) Validating value of temperature on Dashboard

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

TC-04:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=90911

    # Step-1) Increse temperature of    Water heater(from Rheem Device Devkit)
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
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-05:User should be able to decrement Set Point temperature from App.
    [Documentation]    User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90912

    # Set temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Dragon Water Heater.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Decrement temperature value
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:User should be able to decrement Set Point temperature from Equipment.
    [Documentation]    User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=90913

    # Set temperature from water heater
    # Step-1) Increse temperature of Dragon Water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
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
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max temperature that can be set from App should be 185F.
    [Documentation]    Max temperature that can be set from App should be 185F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90914

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Dragon Water Heater.

    ${Temperature_ED}    Write objvalue From Device
    ...    183
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    185    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_Mobile}    185
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 85F.
    [Documentation]    Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90915

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Dragon Water Heater.

    ${Temperature_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    85    ${imgBubble}
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

TC-09:Max temperature that can be set from Equipment should be 185F.
    [Documentation]    Max temperature that can be set from Equipment should be 185F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=90916

    # Step-1) Increse temperature of Dragon Water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    185
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 85F.
    [Documentation]    Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=90917

    # Step-1) Decrease temperature of Dragon Water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    85
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 185F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 185F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90918

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Dragon Water heater.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    183
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    185    ${imgBubble}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    185
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90919

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Dragon Water heater.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    85    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    85
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-19:A Caution message should not appear if user sets temperature <=120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature <=120F/48C from App
    [Tags]    testrailid=90926

    # Step-1) A Caution message should not appear if user sets temperature <=120F/48C from App

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Wait until page contains element    ${setpointDecreaseButton}    ${defaultWaitTime}
    Click element    ${setpointDecreaseButton}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app    ## Locator Issue
    Should be equal as integers    ${temp_app}    120
    Page Should Not Contain Text    ${cautionhotwater}
    [Teardown]    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=90927

    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.
    # Validating value of temperature on Rheem Water Heater Pump.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Wait until page contains element    ${setpointIncreaseButton}    ${defaultWaitTime}
    Click element    ${setpointIncreaseButton}
    ${Temperature_Mobile}    Get current temperature from mobile app    ## Locator Issue
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-13:Max temperature that can be set from Equipment should be 85C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C. :EndDEevice->Mobile
    [Tags]    testrailid=90920

    # Set maximum temp 85C from Equipment
    # Step-1)    User should be able to set max temp 60C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Go to Temp Detail Screen    ${tempDashBoard}
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
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 29C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C. :EndDEevice->Mobile
    [Tags]    testrailid=90921

    # Set minimum temp 29C from Equipment
    # Step-1)    User should be able to set min temp 29C from Device.
    # Step-2)    Validate temperature from the Rheem Application.

    Go to Temp Detail Screen    ${tempDashBoard}
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
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 85C.
    [Documentation]    Max temperature that can be set from App should be 85C.    :Mobile->EndDevice
    [Tags]    testrailid=90922

    # Set maximum temperature 85C from the Mobile Application
    # Step-1)    User should be able to set max temp 60C from the Rheem Application.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    183
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    85    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
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
    [Documentation]    Min temperature that can be set from App should be 29C.    :Mobile->EndDevice
    [Tags]    testrailid=90923

    # Set maximum temp 60C from Equipment

    Temperature Unit in Celsius
    ${Temperature_ED}    Write objvalue From Device
    ...    31
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
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
    Should be equal as integers    ${result2}    30
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    30
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    29
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    29
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    29

TC-17:User should not be able to exceed max setpoint limit i.e. 85C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App.    :Mobile->EndDevice
    [Tags]    testrailid=90924

    # Set maximum temp 60C from Equipment
    # Step-1)    Change temperature from device
    # Step-2)    Increase temperature value and verify on mobile
    # Step-3)    Validate temperature on deshboard

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    85
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    85
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    85

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App.    :Mobile->EndDevice
    [Tags]    testrailid=90925

    # Set maximum temp 60C from Equipment
    # Step-1)    Change temperature from device
    # Step-2)    Validate temperature on deshboard
    # Step-3)    Verify temperature on device

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    Should be equal as integers    ${result2}    29
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    29
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    29
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    29
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    29
    Temperature Unit in Fahrenheit

TC-21:A Caution message should not appear if user set temperature <=120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature <=120F/48C from Equipment
    [Tags]    testrailid=90928

    # Step-1) A Caution message should not appear if user set temperature below 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device
    ...    119
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as strings    ${temp_app}    119
    Page Should Not Contain Text    ${cautionhotwater}
    [Teardown]    Navigate to App Dashboard

TC-22:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=90929

    # Step-1) A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    should be equal as integers    ${temp_app}    121
    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    [Teardown]    Navigate to App Dashboard

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Tags]    testrailid=90930

    # Set Dragon Disable Mode From Mobile Application
    # Step-1) Set Specific mode from Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${DisableModeTriton}    catenate    ${DisableMode}
    ${Mode_mobile}    Change Mode for Dragon    ${DisableModeTriton}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${Triton_modes}[${mode_ED}]    Disabled
    Wait until page contains element    ${tempDashBoard}    ${defaultWaitTime}
    ${disableText}    Get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    Should be equal    Disabled    ${disableStrippend}

TC-24:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Tags]    testrailid=90931

    # Set Niagara Enable Mode From Mobile Application
    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating Mode on Rheem Dragon Water heater.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${EnableModeTriton}    catenate    ${EnableMode}
    ${Mode_mobile}    Change Mode for Dragon    ${EnableModeTriton}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${Triton_modes}[${mode_ED}]    Enabled
    ${modeValueDashboard}    Get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-25:User should be able to Disable Equipment from End Device.
    [Documentation]    User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Tags]    testrailid=90932

    # Set Disabled Mode From Equipment
    # Step-1) Set Specific Mode on Rheem device(from devkit)

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
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
    Navigate to App Dashboard
    Should be equal as strings    ${Triton_modes}[${mode_set_ED}]    Disabled

TC-26:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Tags]    testrailid=90933

    # Set Disabled Mode From Equipment

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
    Navigate to App Dashboard
    Should be equal as strings    ${Triton_modes}[${mode_set_ED}]    Enabled
    ${modeValueDashboard}    Get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    Strip String    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-34:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=90934

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    wait until page contains    Daily
    Click element    Daily
    wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}
    Wait until page contains element    usageText    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-35:User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Tags]    testrailid=90935

    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    wait until page contains    Weekly
    Click element    Weekly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-36:User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Tags]    testrailid=90936

    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    wait until page contains    Monthly
    Click element    Monthly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Month, Current Month    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    units of energy

TC-37:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=90937

    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    5s
    wait until page contains    Yearly
    Click element    Yearly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}
    ${text}    get text    usageText
    Check    ${text}    units of energy

TC-31:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Dragon Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90938
    # Step-1) Configure Away mode in App validate on cloud and vacation end device.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Status}    Run keyword and return status    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    IF    ${Status}==True    Enable Away Setting    ${locationNameDragon}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
    Element value should be    ${homeaway}    ${awayModeText}

TC-32:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Dragon Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=90939

    # Step-1) Disabling Configure vacation mode in App validate on cloud and end device.
    # Step-2) Validating temperature value on End Device

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0
    Element value should be    ${homeaway}    ${homemodetext}

TC-33:Schedule the Occupied mode from App .. 0 - button should be off to change the status of mode
    [Documentation]    Schedule the Occupied mode from App .. 0 - button should be off to change the status of mode
    [Tags]    testrailid=89406
    IF    '${PREV TEST STATUS}' == 'PASS'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameDragon}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Schedule Triton    On    ${locationNameDragon}
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${occupied}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${schedule_modes}[${mode_ED}]    Occupied
    Navigate to App Dashboard

TC-35:Copy the Scheduled slot and mode from App
    [Documentation]    Copy the Scheduled slot and mode from App
    [Tags]    testrailid=89408

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data triton    ${locationNameDragon}
    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-34:Schedule the UnOccupied mode from App
    [Documentation]    Schedule the UnOccupied mode from App
    [Tags]    testrailid=89407

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Schedule Triton    Off    ${locationNameDragon}
    sleep    10s
    Element value should be    ${currenttemp}    Unoccupied
    ${mode_ED}    Read int return type objvalue From Device
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${schedule_modes}[${mode_ED}]    Unoccupied
    Navigate to App Dashboard
    Sleep    2s
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    OCCUPIED
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

TC-36:Max temperature that can be set from App should be 185F.
    [Documentation]    Max temperature that can be set from App should be 185F using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90943

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    184    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    184
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    184
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    185
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    185
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    185

TC-37:Min temperature that can be set from App should be 85F.
    [Documentation]    Max temperature that can be set from App should be 85F using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90944

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    86    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    86
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    86
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    85
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    85
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    85

TC-38:User should not be able to exceed max setpoint limit i.e. 185F from App
    [Documentation]    Max temperature that can be set from App should be 185F using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90945

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    185    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    185
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    185
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    185
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    185
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    185

TC-39:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    Max temperature that can be set from App should be 85F using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90946

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    85    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    85
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    85
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    85
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    85
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    85

TC-40:User should not be able to exceed max setpoint limit i.e. 85C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90947
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    85
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    85
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    85
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    85

TC-41:User should not be able to exceed min setpoint limit i.e. 29C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App using button slider.    :Mobile->EndDevice
    [Tags]    testrailid=90948

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
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
    Should be equal as integers    ${result2}    29
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    29
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    29
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    29
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    29

# TC-42:User should be able to set valve config to 'Closed if Leak Detected'
#    [Documentation]    User should be able to set valve config to 'Closed if Leak Detected'
#    [Tags]    testrailid=52717
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Change shutoff valve configuration    Closed if Leak Detected
#    Navigate Back to the Screen
#    sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    0
#
#
# TC-43:User should be able to set valve config to 'Closed if Unocc. Leak Detect'
#    [Documentation]    User should be able to set valve config to 'Closed if Unocc. Leak Detect'
#    [Tags]    testrailid=52718
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Change shutoff valve configuration    Closed if Unocc. Leak Detect
#    Navigate Back to the Screen
#    sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    1
#
#
# TC-44:User should be able to set valve config to 'Open'
#    [Documentation]    User should be able to set valve config to 'Open'
#    [Tags]    testrailid=52719#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Change shutoff valve configuration    Open
#    Navigate Back to the Screen
#    sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    2
#
#
# TC-45:User should be able to set valve config to 'Closed'
#    [Documentation]    User should be able to set valve config to 'Closed'
#    [Tags]    testrailid=52720
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Change shutoff valve configuration    Closed
#    Navigate Back to the Screen
#    sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    3
#
# TC-46:User should be able to set valve config to 'Closed if Leak Detected' from equipment
#    [Documentation]    User should be able to set valve config to 'Closed if Leak Detected' from equipment
#    [Tags]    testrailid=52721
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    ${cfg_value}=    Write objvalue From Device    0    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    0
#    Click element    ${btnSetting}
#    sleep    5s
#    ${value}=    get element attribute    ${valveMode}    value
#    ${value}=    strip string    ${value}
#    Should be equal as strings    ${value}    Closed if Leak Detected
#    Navigate Back to the Screen
#    Navigate Back to the Screen
#
# TC-47:User should be able to set valve config to 'Closed if Unocc. Leak Detect' from equipment
#    [Documentation]    User should be able to set valve config to 'Closed if Unocc. Leak Detect' from equipment
#    [Tags]    testrailid=52721
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    ${cfg_value}=    Write objvalue From Device    1    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    1
#    Click element    ${btnSetting}
#    sleep    5s
#    ${value}=    get element attribute    ${valveMode}    value
#    ${value}=    strip string    ${value}
#    Should be equal as strings    ${value}    Closed if Unocc. Leak Detect
#    Navigate Back to the Screen
#    Navigate Back to the Screen
#
# TC-48:User should be able to set valve config to 'Open' from equipment
#    [Documentation]    User should be able to set valve config to 'Open' from equipment
#    [Tags]    testrailid=52722
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    ${cfg_value}=    Write objvalue From Device    2    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    2
#    Click element    ${btnSetting}
#    sleep    5s
#    ${value}=    get element attribute    ${valveMode}    value
#    ${value}=    strip string    ${value}
#    Should be equal as strings    ${value}    Open
#    Navigate Back to the Screen
#    Navigate Back to the Screen
#
#
# TC-49:User should be able to set valve config to 'Closed' from equipment
#    [Documentation]    User should be able to set valve config to 'Closed' from equipment
#    [Tags]    testrailid=52723
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    ${cfg_value}=    Write objvalue From Device    3    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Sleep    5s
#    ${Shuttoff_Valve_status_ED}    Read int return type objvalue From Device    SHUTCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Shuttoff_Valve_status_ED}    3
#    Click element    ${btnSetting}
#    sleep    5s
#    ${value}=    get element attribute    ${valveMode}    value
#    ${value}=    strip string    ${value}
#    Should be equal as strings    ${value}    Closed
#    Navigate Back to the Screen
#    Navigate Back to the Screen
#
# TC-50:User should be able to set Recirc pump config to 'Off' from APP
#    [Documentation]    User should be able to set Recirc pump config to 'Off' from APP
#    [Tags]    testrailid=52724
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Recirc Pump Configuration    Off
#    Navigate Back to the Screen
#    sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    0
#    page should contain text    Recirc pump not circulating
#    Navigate Back to the Screen
#
#
# TC-51:User should be able to set Recirc pump config to 'On' from APP
#    [Documentation]    User should be able to set Recirc pump config to 'On' from APP
#    [Tags]    testrailid=52725#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Recirc Pump Configuration    On
#    Navigate Back to the Screen
#    sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    1
#    page should contain text    Recirc pump circulating
#    Navigate Back to the Screen
#
# TC-52:User should be able to set Recirc pump config to 'Schedule' from APP
#    [Documentation]    User should be able to set Recirc pump config to 'Schedule' from APP
#    [Tags]    testrailid=52726
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Recirc Pump Configuration    Schedule
#    Navigate Back to the Screen
#    sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    2
#    page should contain text    Recirc pump circulating
#    Navigate Back to the Screen
#
# TC-53:User should be able to set Recirc pump config to 'Schedule On' from APP
#    [Documentation]    User should be able to set Recirc pump config to 'Schedule On' from APP
#    [Tags]    testrailid=52727
#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Recirc Pump Configuration    Schedule On
#    Navigate Back to the Screen
#    sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    3
#    page should contain text    Recirc pump circulating
#    Navigate Back to the Screen
#
# TC-54:User should be able to set Recirc pump config to 'On Demand' from APP
#    [Documentation]    User should be able to set Recirc pump config to 'On Demand' from APP
#    [Tags]    testrailid=52728#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Recirc Pump Configuration    On Demand
#    Navigate Back to the Screen
#    sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    RCIRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    4
#    page should contain text    Recirc pump circulating
#    Navigate Back to the Screen
#
# TC-55:User should be able to set Leak Detected to Alarm Only from APP
#    [Documentation]    User should be able to set Leak Detected to Alarm Only from APP
#    [Tags]    TC=55#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Click element    ${alarmOnly}
#    Sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    LEAKSHUT    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    0
#    Navigate Back to the Screen
#
# TC-56:User should be able to set Leak Detected to Disable Water Heater from APP
#    [Documentation]    User should be able to set Leak Detected to Disable Water Heater from APP
#    [Tags]    TC=56#
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
#    Click element    ${btnSetting}
#    sleep    2s
#    Click element    ${disableWH}
#    Sleep    5s
#    ${status_ED}    Read int return type objvalue From Device    LEAKSHUT    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${status_ED}    1
#    Navigate Back to the Screen

Verify UI of Network Settings screen
    [Tags]    testrailid=222072
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Settings
    IF    ${Status}    Click element    Settings

    ${Status1}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status1}    Click element    Network

    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    Wait until page contains element    Network SSID
    Wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

Water Usage Graph - water Usage
    Go to Temp Detail Screen    ${tempDashBoard}

    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    Click element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]
    wait until page contains    Water
    Click element    Water
    wait until page contains    Daily
    wait until page contains    Monthly
    wait until page contains    Weekly
    wait until page contains    Yearly
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Water Usage report should be shown for mentioned time periods - daily water Usage
    [Tags]    testrailid=222764
    Go to Temp Detail Screen    ${tempDashBoard}

    wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    wait until page contains    Daily
    Click element    Daily
    wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}
    Wait until page contains element    usageText    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    Gal of water
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Water Usage report should be shown for mentioned time periods - weekly water Usage
    [Tags]    testrailid=222765
    Sleep    2s
    wait until page contains    Weekly
    Click element    Weekly
    wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}
    Wait until page contains element    usageText    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    Gal of water
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Water Usage report should be shown for mentioned time periods - monthly water Usage
    [Tags]    testrailid=222766
    Sleep    2s
    wait until page contains    Monthly
    Click element    Monthly
    wait until page contains    . 2 datasets. Previous Month, Current Month    ${defaultWaitTime}
    Wait until page contains element    usageText    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    Gal of water
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Water Usage report should be shown for mentioned time periods - yearly water Usage
    [Tags]    testrailid=222767
    wait until page contains    Yearly
    Click element    Yearly
    wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}
    Wait until page contains element    usageText    ${defaultWaitTime}
    ${text}    get text    usageText
    check    ${text}    Gal of water
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

Verfiy device specific alert on equipment card
    [Tags]    testrailid=222074
    Select the Device Location    ${locationNameDragon}
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

Verfiy device specific alert on detail screen
    [Tags]    testrailid=222075
    Select the Device Location    ${locationNameDragon}
    Go to Temp Detail Screen    ${tempDashBoard}
    Click element    validateBell
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END
