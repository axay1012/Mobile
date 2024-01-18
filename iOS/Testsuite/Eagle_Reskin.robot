*** Settings ***
Documentation       Rheem iOS Eagle Water Heater Test Suite

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
...                     AND    Select the Device Location    ${locationNameEagle}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without uninstall and Navigate to dashboard    ${locationNameEagle}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         %{Eagle_DeviceID}

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Eagle

${emailId}                              %{Eagle_Email}
${passwordValue}                        %{Eagle_Password}

${maxTempVal}                           120
${minTempVal}                           100

${maxTempCelsius}                       ${EMPTY}
${minTempCelsius}                       ${EMPTY}

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117612

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
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
    [Tags]    testrailid=117613

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

TC-03:User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117614

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

TC-04:User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=117615

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    1s
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
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

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement    Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117616

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

TC-06:User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=117617

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

TC-07:Max temperature that can be set from App should be 120F. : Mobile->Cloud->EndDevice
    [Documentation]    Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117618

    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempVal}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 100F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117619

    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${minTempVal}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max temperature that can be set from Equipment should be 120F. : EndDevice->Cloud->Mobile
    [Documentation]    Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=117620

    ${Temperature_ED}    Write objvalue From Device
    ...    ${maxTempVal}
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

TC-10:Min temperature that can be set from Equipment should be 100F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=117621

    ${Temperature_ED}    Write objvalue From Device
    ...    100
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

TC-11:User should not be able to exceed max setpoint limit i.e. 120F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117622

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Given max temperature    ${maxTempVal}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal    ${Temperature_Mobile}    ${maxTempVal}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 100F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117623

    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${minTempVal}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-48:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=117624

    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    119
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Wait until page contains element    ${setpointDecreaseButton}    ${defaultWaitTime}
    Click element    ${setpointDecreaseButton}
    Sleep    2s
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    118
    Page Should Not Contain Text    ${cautionhotwater}
    [Teardown]    Navigate to App Dashboard

TC-47:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=117625

    # Step-1) A Warning pop up message should appear, if user attempts to update temperature above 119F/48C.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    120
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Wait until page contains element    ${setpointIncreaseButton}    ${defaultWaitTime}
    Click element    ${setpointIncreaseButton}
    Sleep    2s
    ${Temperature_Mobile}    Get current temperature from mobile app
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-49:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=117626

    # Step-1) A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment

    ${Temperature_ED}    Write objvalue From Device
    ...    121
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    121
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    [Teardown]    Navigate to App Dashboard

TC-50:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=117627

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

TC-34:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=83712

    # Step-1) Go to Daily usage report and verify energy usage

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${daily}
    Click element    ${daily}
    Wait until page contains    ${historicDataChartDay}    ${defaultWaitTime}

TC-35:User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Tags]    testrailid=83713

    # Step-1) Go to Daily usage report and verify energy usage
    Wait until element is visible    ${weekly}    ${defaultWaitTime}
    Click element    ${weekly}
    Sleep    5s
    Wait until page contains    ${historicDataChartWeek}    ${defaultWaitTime}

TC-36:User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Tags]    testrailid=83714

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible    ${monthly}    ${defaultWaitTime}
    Click element    ${monthly}
    Sleep    5s
    Wait until page contains    ${historicDataChartMonth}    ${defaultWaitTime}

TC-37:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=83715

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible    ${yearly}    ${defaultWaitTime}
    Click element    ${yearly}
    Sleep    5s
    Wait until page contains    ${historicDataChartYear}    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-19:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Tags]    testrailid=117632

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${DisableMode}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Convert to integer    ${mode_ED}
    Should be equal as strings    ${Niagara_modes}[${mode_ED}]    Disabled

    Element value should be    ${tempDashBoard}    Disabled

TC-20:User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Documentation]    User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Tags]    testrailid=117633

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${EnableMode}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-21:User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Documentation]    User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Tags]    testrailid=117634

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to App Dashboard
    Should be equal as strings    ${Niagara_modes}[${mode_set_ED}]    Disabled
    Element value should be    ${tempDashBoard}    Disabled

TC-22:User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Documentation]    User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Tags]    testrailid=117635

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to App Dashboard
    Should be equal as strings    ${Niagara_modes}[${mode_set_ED}]    Enabled
    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    Should be equal    Enabled${SPACE}    ${modeValueDashboard}

TC-13:Max temperature that can be set from Equipment should be 49C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C. :EndDEevice->Mobile
    [Tags]    testrailid=117636

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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
    ${result2}    Evaluate    ${result2}+1
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 38C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C. :EndDEevice->Mobile
    [Tags]    testrailid=117637

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    38
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
    ${result2}    Evaluate    ${result2}+1
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 49C.
    [Documentation]    Max temperature that can be set from App should be 60C. :Mobile->EndDevice
    [Tags]    testrailid=117638

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    49    ${imgBubble}
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
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 38C.
    [Documentation]    Min temperature that can be set from App should be 29C. :Mobile->EndDevice
    [Tags]    testrailid=117639

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    38    ${imgBubble}
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
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 49C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App :Mobile->EndDevice
    [Tags]    testrailid=117640

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    49    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal    ${setpoint_M_DP}    49
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 38C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 30C from App :Mobile->EndDevice
    [Tags]    testrailid=117641

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    38    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal    ${setpoint_M_DP}    38
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-29:Max temperature that can be set from App should be 120F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=117642

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    119
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    119
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    120
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    120
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    120

TC-30:Min temperature that can be set from App should be 100F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=117643

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    101    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    101
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    101
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    100
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    100
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    100

TC-31:User should not be able to exceed max setpoint limit i.e. 120F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=117644

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    120
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    120
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    120
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    120
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    120

TC-32:User should not be able to exceed min setpoint limit i.e. 100F from App
    [Documentation]    User should not be able to exceed min temperature 110F using button slider
    [Tags]    testrailid=117645

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    100    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    100
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    100
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    100
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    100
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    100

TC-33:User should not be able to exceed max setpoint limit i.e. 49C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 49C from App using button:Mobile->EndDevice
    [Tags]    testrailid=117646

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
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    49
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    49
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    49

TC-34:User should not be able to exceed min setpoint limit i.e. 38C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button:Mobile->EndDevice
    [Tags]    testrailid=117647

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
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    38
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    38
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    38
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    38

TC-27:User should be able to set Away mode from App for Eagle Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=117648

    # Step-1) Configure Away mode in App validate on cloud and vacation end device.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Status}    Run keyword and return status    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    IF    ${Status}==True    Enable Away Setting    ${locationNameHPWH}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
    Element value should be    ${homeaway}    ${awayModeText}

TC-28:User should be able to Disable Away from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=43045

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

TC-35:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App
    [Tags]    testrailid=117649

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule without mode    ${locationNameEagle}
    ${temp}    Convert to integer    ${status}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${temp}    ${dashBoardTemperature}

TC-36:Copy the Scheduled day slot and temperature from App
    [Documentation]    Copy the Scheduled day slot and temperature from App
    [Tags]    testrailid=4275

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameEagle}
    Navigate Back to the Screen
    Navigate to App Dashboard

TC-3:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=4276

    Go to Temp Detail Screen    ${tempDashBoard}
    verify schedule overridden    ${modeTempBubble}    ${maxTempVal}
    Wait until page contains element    ${msgScheduleWaterHeater}    ${defaultWaitTime}
    ${message}    Get text    ${msgScheduleWaterHeater}
    ${status}    check    ${message}    Schedule overridden
    ${verifiedStatus}    convert to boolean    True
    Should be equal    ${status}    ${verifiedStatus}
    Navigate to App Dashboard

TC-48:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=33506
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${msgScheduleWaterHeater}    ${defaultWaitTime}
    ${message}    Get text    ${msgScheduleWaterHeater}
    ${status}    check    ${message}    Schedule overridden
    ${verifiedStatus}    convert to boolean    True
    Should be equal    ${status}    ${verifiedStatus}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${overRiddenTemp}    Get text    ${modeTempBubble}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    ${scheduled_temp}    Get text    ${tempSliderButton}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${saveSchedule}    ${defaultWaitTime}
    Tap    ${saveSchedule}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    Page should contain text    ${followScheduleMsgDashboard}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${tempValSchedule}    Get text    ${modeTempBubble}
    Should be equal    ${tempValSchedule}    ${scheduled_temp}
    Should Not Be Equal    ${overRiddenTemp}    ${tempValSchedule}
    Navigate to App Dashboard

TC-27:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=4277

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Verify schedule with changes in timeslot, temperature    ${locationNameEagle}
    ${temp}    Convert to integer    ${status}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard

TC-37:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=4278
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}
    Click element    ${scheduleButton}
    Unfollow the schedule    ${locationNameEagle}
    Navigate to App Dashboard

TC-41: Burn Time value Updated from Equipment
    [Documentation]    Burn Time value Updated from Equipment

    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    Wait until page contains element    ${slotSwitcherIdentifier}    ${defaultWaitTime}
    ${Status}    Get text    ${slotSwitcherIdentifier}
    Should be equal    Off    ${Status}
    Navigate Back to the Sub Screen

Verify that if User Update Water Saving mode to ON from End Device than its should be reflected on App
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    1
    Navigate to the Product Settings Screen
    Wait until page contains element    ${slotSwitcherIdentifier}    ${defaultWaitTime}
    ${Status}    Get text    ${slotSwitcherIdentifier}
    Should be equal    On    ${Status}
    Navigate Back to the Sub Screen

Verify that Changed RPUMPMOD = 0 From End Device and its value None/Disabled should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    Sleep    2s
    Page should contain text    None
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed RPUMPMOD = 1 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${RPUMPMOD}
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
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${RPUMPMOD}
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
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${RPUMPMOD}
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
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${RPUMPMOD}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Should be equal as integers    ${WaterSaverLevel}    4
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Schedule
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify UI of Network Settings screen
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Settings
    IF    ${Status}    Click element    Settings
    ${Status1}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status1}    Click element    Network
    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    Wait until page contains element    Network SSID
    Wait until page contains element    IP Address
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

Verfiy device specific alert on equipment card
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

Verfiy device specific alert on detail screen
    Go to Temp Detail Screen    ${tempDashBoard}
    Click element    validateBell
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

TC-42: Update maximum burn time value
    [Documentation]    Update maximum burn time value
    ${burntime_ED}    Write objvalue From Device
    ...    8000
    ...    ${burntime}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${burntime_ED}    Read int return type objvalue From Device
    ...    ${burntime}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Verify Burn Time Value    ${burntime_ED}
    [Teardown]    Navigate Back to the Screen

TC-43: Update minimum burn time value
    [Documentation]    Update minimum burn time value
    ${burntime_ED}    Write objvalue From Device
    ...    0
    ...    ${burntime}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${burntime_ED}    Read int return type objvalue From Device
    ...    ${burntime}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Verify Burn Time Value    ${burntime_ED}
    [Teardown]    Navigate Back to the Screen

TC-44: Update Low altitude value from Equipment
    [Documentation]    Update Low altitude value from Equipment

    ${altitude_ED}    Write objvalue From Device
    ...    0
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Wait until page contains element    ${AltitudeValue}[${altitude_ED}]    ${defaultWaitTime}
    [Teardown]    Navigate Back to the Screen

TC-45: Update Med. altitude value from Equipment
    [Documentation]    Update Med. altitude value from Equipment
    ${altitude_ED}    Write objvalue From Device
    ...    1
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Wait until page contains element    ${AltitudeValue}[${altitude_ED}]    ${defaultWaitTime}
    [Teardown]    Navigate Back to the Screen

TC-46: Update sea altitude value from Equipment
    [Documentation]    Update sea altitude value from Equipment
    ${altitude_ED}    Write objvalue From Device
    ...    2
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${altitude_ED}    Read int return type objvalue From Device
    ...    ${altitude}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Wait until page contains element    ${AltitudeValue}[${altitude_ED}]    ${defaultWaitTime}
    [Teardown]    Navigate Back to the Screen

Verify that if User Update Water Saving mode to ON from End Device than its should be reflected on App
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    1
    sleep    5s
    Navigate to the Product Settings Screen
    Wait until page contains element    ${slotSwitcherIdentifier}    ${defaultWaitTime}
    ${Status}    Get text    ${slotSwitcherIdentifier}
    Should be equal    On    ${Status}
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed DPSWSTAT = 0 From End Device and its value None/Disabled should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    Sleep    2s
    Page should contain text    None
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed DPSWSTAT = 1 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    1
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-Perf.
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed DPSWSTAT = 2 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    2
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    2
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-E-Save
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed DPSWSTAT = 3 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    3
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${WaterSaverLevel}    3
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    On-Demand
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Changed DPSWSTAT = 4 From Portal and its value should reflect on End Device
    ${TempUnit_ED}    Write objvalue From Device
    ...    4
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    DPSWSTAT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Should be equal as integers    ${WaterSaverLevel}    4
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Schedule
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
