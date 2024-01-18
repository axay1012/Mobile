*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Gen4 Test Suite

Library             AppiumLibrary
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Library             ../../src/RheemCustom.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameHPWH}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameHPWH}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4096

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

${emailId}                              %{HPWH_Email}
${passwordValue}                        %{HPWH_Password}

${maxTempVal}                           140

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***

TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83679

    # Step-1) Validating value of temperature on Rheem Mobile app
    # Step-2) Validating value of temperature on Rheem Water Heater Pump
    # Step-3) Validating value of temperature on Dashboard

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
    [Tags]    testrailid=83680

    # Step-1) Changing temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    115
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # Validating the temperature value on Rheem Mobile Application
    Sleep    3s
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    Sleep    2s
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83681

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
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

TC-04:User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83682

    # Step-1) Increase temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 3
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
    [Documentation]    User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83683

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
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

TC-06:User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83684

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
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

TC-07:Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice
    [Documentation]    Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83685

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    137
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}
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

TC-09:Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile
    [Documentation]    Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83687

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    140
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

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83689

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
    Scroll to the Max Temperature    140    ${imgBubble}
    Scroll Up    ${imgBubble}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    140
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 110F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 110F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83686

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

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
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 110F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 110F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83688

    # Step-1) Increse temperature of Rheem Water heater pump(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application
    # Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    110
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

TC-12:User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83690

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.
    # Step-3) Validating value of temperature on Dashboard

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
    ${temp_app}    Decrement temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    110
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=83697

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

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=83698

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

TC-21:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=83699

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
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    [Teardown]    Navigate to App Dashboard

TC-22:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=83700

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

TC-23:User should be able to set Off mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Off mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83701

    # Step-1) Set Specific mode from Rheem Mobile Application

    ${changeModeValue}    Set Variable    0
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${offMode}
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${current_mode_ED}]    OFF

TC-24:User should be able to set energy Saving Mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set automate Saving mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83702

    # Step-1) Set Specific mode from Rheem Mobile Application

    ${changeModeValue}    Set Variable    1
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${energySaverHPWHMode}
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${current_mode_ED}]    ENERGY SAVING
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    ENERGY SAVING    ${modeValueDashboard}

TC-25:User should be able to set heat pump only mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set most efficient mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83703

    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    2
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${heatPumpOnlyMode}
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${current_mode_ED}]    HEAT PUMP ONLY
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    HEAT PUMP ONLY    ${modeValueDashboard}

TC-27:User should be able to set High Demand mode from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set High Demand mode from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83705

    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Validating value of mode on EndDevice

    ${changeModeValue}    Set Variable    3
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${highDemandMode}
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${current_mode_ED}]    HIGH DEMAND
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    HIGH DEMAND    ${modeValueDashboard}

TC-28:User should be able to set Electric mode from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Electric mode from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83706

    # Step-1) Set Specific mode from Rheem Mobile Application
    # Step-2) Set heat pump Electric mode from mobile application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    4
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${electricMode}
    Navigate Back to the Screen
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${current_mode_ED}]    ELECTRIC MODE
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    ELECTRIC MODE    ${modeValueDashboard}

TC-29:User should be able to set Off mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Off mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83707

    # Step-1) Set water off mode from end device
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

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
    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_modes}[${mode_set_ED}]    OFF

TC-30:User should be able toset Energy Saver mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Energy Saver mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83708

    # Step-1) Set water Energy Saver mode from end device
    # Step-2) Validating mode on Rheem Mobile Application
    # Step-3) Validating value of mode on Dashboard

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
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_modes}[${mode_set_ED}]    ENERGY SAVING
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    ENERGY SAVING    ${modeValueDashboard}

TC-31:User should be able to set Heat Pump mode from Equipment : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Heat Pump mode from Equipment : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83709

    # Step-1) Set water Heat Pump mode from end device
    # Step-2) Validate mode from mobile application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    2
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
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_modes}[${mode_set_ED}]    HEAT PUMP ONLY
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    HEAT PUMP ONLY    ${modeValueDashboard}

TC-32:User should be able to set High Demand mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set High Demand mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83710

    # Step-1) Set water High Demand mode from end device
    # Step-2) Validate mode from mobile application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    3
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
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_modes}[${mode_set_ED}]    HIGH DEMAND
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    HIGH DEMAND    ${modeValueDashboard}

TC-33:User should be able to set Electric mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Electric mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=83711

    # Step-1) Set water Electric mode from end device
    # Step-2) Validate mode from mobile application
    # Step-3) Validating value of mode on Dashboard

    ${changeModeValue}    Set Variable    4
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
    Navigate Back to the Screen
    Should be equal as strings    ${HPWH_modes}[${mode_set_ED}]    ELECTRIC MODE
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    ELECTRIC MODE    ${modeValueDashboard}

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
    Click element     ${weekly}
    Sleep    5s
    Wait until page contains    ${historicDataChartWeek}    ${defaultWaitTime}

TC-36:User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Tags]    testrailid=83714

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible     ${monthly}     ${defaultWaitTime}
    Click element    ${monthly}
    Sleep    2s
    Wait until page contains    ${historicDataChartMonth}    ${defaultWaitTime}

TC-37:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=83715

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible     ${yearly}     ${defaultWaitTime}
    Click element    ${yearly}
    Sleep    5s
    Wait until page contains    ${historicDataChartYear}    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-40:Schedule the temperature and mode from App
    [Documentation]    Schedule the temperature and mode from App
    [Tags]    testrailid=83718    [tags]    tc_id_38

    # Step-1) User must be able to enable schedule from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule    ENERGY SAVING
    ${temp1}  Get from List    ${status}    0
    ${temp}   Convert to integer    ${temp1}
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

TC-41:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=83719

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameHPWH}
    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-42:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=83720

    # Step-1) User must be able to enable schedule from the app
    # Step-2) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${updatedTemp}    Increment temperature value
    Sleep    3s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${updatedTemp}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${updatedTemp}    ${dashBoardTemperature}

TC-43:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=83721

    # Step-1) Resume schedule temperature and validate
    # Step-2) Validate schedule temperature and mode on app
    # Step-3) Validate schedule temperature and mode on device

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${btnResume}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameHPWH}
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Sleep    2s
    Click element    ${btnResume}
    Wait until page contains element    ${followScheduleMsgDashboard}    20s
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
    Should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ENERGY SAVING

TC-44:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=83722

    # Step-1) Re-Schedule the temperature and mode from App

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule    ENERGY SAVING
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
    Should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${mode}

TC-54:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow
    [Tags]    testrailid=83732

    # Step-1) Change the schedule temperature and verfy it on device and app
    # Step-2) Resume schedule temperature and validate

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
    Wait until page contains element    ${followScheduleMsgDashboard}    20s
    ${resume_schedule_temp_mobile}    Get current temperature from mobile app
    Should be equal as integers    ${schedule_temp_mobile}    ${resume_schedule_temp_mobile}
    ${schedule_temperature_ed}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${schedule_temp_mobile}    ${schedule_temperature_ed}
    Navigate Back to the Screen

TC-45:User should be able to Resume Schedule when scheduled mode is not follow
    [Documentation]    Resume-Schedule when scheduled mode is not follow
    [Tags]    testrailid=83723

    # Step-1) Change Mode to unfollow schedule
    # Step-2) Click on Resume button and verfiy following schedule
    # Step-3) Verfiy mode and temperature on App

    Go to Temp Detail Screen    ${tempDashBoard}
    ${schedule_list}    Get Temperature And Mode From Current Schedule Slot    ${locationNameHPWH}
    ${Mode_mobile}    Change Mode    ${heatPumpOnlyMode}
    Sleep    3s
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${heatPumpOnlyMode}
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
    should be equal    ${modeValueDashboard}    ENERGY SAVING
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${schedule_list}

TC-46:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=83724

    # Step-1) Unfollow the temperature and mode from App

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameHPWH}
    Navigate to App Dashboard

TC-38:User should be able to set Away mode from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83716

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

TC-39:User should be able to Disable Away from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=83717

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

TC-47:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=83725

    # Step-1)    User should be able to disable running status.

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${comp_rly}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${fan_ctrl}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Page should contain element    Running
    Navigate Back to the Screen
    Page should contain element    Running

TC-48:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=83726

    # Step-1)    User should be able to disable running status.
    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${comp_rly}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${fan_ctrl}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    Page should not contain element    ${RunningStatus}
    Navigate Back to the Screen
    Page should not contain element    ${RunningStatus}

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.    :EndDEevice->Mobile
    [Tags]    testrailid=83691

    # Step-1) Set maximum temp 60C from Equipmp 60C from Equipment
    # Step-2)    Validate temperature from the Rheem Application.
    Run keyword and ignore error    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    60    ${setpoint_M_DP}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C. :Mobile->EndDevice
    [Tags]    testrailid=83693

    # Step-1) Set maximum temperature 60C from the Mobile Application

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    60    ${imgBubble}
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
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App    :Mobile->EndDevice
    [Tags]    testrailid=83695

    # Step-1) Set Setpoint above Maximum Setpoint limit 60C From Mobile App and Validating it On Mobile App itself
    Temperature Unit in Celsius
    ${Temperature_ED}    Write objvalue From Device    138    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    60
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
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-55:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App using button:Mobile->EndDevice
    [Tags]    testrailid=83733

    # Step-1)    Set maximum temp 60C from Equipment
    # Step-4)    Verify temperature on device

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
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    60
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    60
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    60
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    Should be equal as integers    ${result1}    60

TC-14:Min temperature that can be set from Equipment should be 43C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C. :EndDEevice->Mobile
    [Tags]    testrailid=83692

    # Step-1) # Set minimum temp 43C from Equipment

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate Back to the Screen
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 43C.
    [Documentation]    Min temperature that can be set from App should be 43C.    :Mobile->EndDevice
    [Tags]    testrailid=83694

    #    Step-1) Set minimum temperature 43c from the Mobile Application
    #    Step-2) Validating Temperature Value On End Device

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    43    ${imgBubble}
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
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App :Mobile->EndDevice
    [Tags]    testrailid=83696

    # Step-1) Set Setpoint below Minimum Setpoint limit 43C From Mobile App and Validating it On Mobile App itself

    Temperature Unit in Celsius
    ${Temperature_ED}    Write objvalue From Device    112    ${whtrsetp}    ${Device_Mac_Address}
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

TC-56:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button:Mobile->EndDevice
    [Tags]    testrailid=83734

    # Step-1)    Change temperature from device
    # Step-2)    Decrease temperature value and verify on mobile
    # Step-3)    Verify temperature on device

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
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    43
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    43
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Should be equal as integers    ${tempMobile}    43
    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    43
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    43

TC-49:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=83727

    # Step-1)    Increment temperature value upto maximum
    # Step-2)    Validate temperature on deshboard
    # Step-3)    Validate temperature on device

    Temperature Unit in Fahrenheit
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

TC-51:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=83729

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Increment temperature value upto maximum

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

TC-50:Min temperature that can be set from App should be 110F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=83728

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto mininum
    # Step-3)    Validate temperature on deshboard

    Temperature Unit in Fahrenheit
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

TC-52:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min temperature 110F using button slider
    [Tags]    testrailid=83730

    # Step-1)    Select Button press option from Setpoint Control feature
    # Step-2)    Decrease temperature value upto minium
    # Step-3)    Validate temperature on deshboard

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

TC-26:User should be able to enable Energy Saver mode after changing another mode from App
    [Documentation]    User should be able to enable energy saver mode.
    [Tags]    testrailid=83704

    # Step-1)    Verify and enable "ENERGY SAVING" msg with Enable tab on Detail page.
    # Step-2) Verify Energy Saving mode on dashboard
    # Step-3) Verify Energy Saving mode on equipment
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${heatPumpOnlyMode}
    Verify and enable energy saving
    Navigate Back to the Screen
    element value should be    ${modeDashBoard}    Energy Saving
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_ED}    1

TC-53:User should be able to Change the temperature value from the Schedule screen.
    [Documentation]    User should be able to Change the temperature value from the Schedule screen.
    [Tags]    testrailid=83731

    # Step-1) User must be able to enable schedule from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule using button    ENERGY SAVING
    ${temp1}    Get from List    ${status}    0
    ${temp}    Convert to integer    ${temp1}
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${mode_get_ED}    Read int return type objvalue From Device    ${whtrcnfg}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${mode}    Get from list    ${status}    1
    Should be equal as strings    ${HPWH_modes}[${mode_get_ED}]    ${mode}

TC-54:Verify UI of Network Settings screen
    [Tags]    testrailid=222030

    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    Wait Until Page Contains Element    ${ProductSetting}
    Click Element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${Network}
    IF    ${Status}    Click Element    ${Network}
    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    Wait until page contains element    Network SSID
    Wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-55:Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Tags]    testrailid=222031

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-56:Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Tags]    testrailid=222032

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

TC-57:Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Tags]    testrailid=222033

    # Step-1) User must be able to schedule Occupied mode from the app

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-58:Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Tags]    testrailid=222034

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard

TC-59:Verfiy device specific alert on equipment card
    [Tags]    testrailid=222035

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element           ${devicenotifications}
        Verify Device Alerts    ${HPWH_Notification}
    END

TC-60:Verfiy device specific alert on detail screen
    [Tags]    testrailid=222036

    Go to Temp Detail Screen      ${tempDashBoard}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${iconNotification}
    IF    ${Status}==True
        Click Element    ${iconNotification}
        Verify Device Alerts    ${HPWH_Notification}
    END

TC-62:Verify that user can able to Turn ON Historical data
    [Tags]    testrailid=222751

    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${historicalDataSwitcher}    ${defaultWaitTime}
    ${value}    Get Text    ${historicalDataSwitcher}
    IF    '${value}'=='Off'    Click Element    ${value}
    Page should contain element    ${DailyHistory}    ${defaultWaitTime}

TC-63:Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.
    [Tags]    testrailid=222752

    Run keyword and ignore error     Go to Temp Detail Screen    ${tempDashBoard}
    Run keyword and ignore error    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Run keyword and ignore error    Click element    ${usageReport}
    Sleep    2s
    Page should contain element    ${usageText}    ${defaultWaitTime}
    ${Value}    Get Text    ${usageText}
    ${status}    Check    ${Value}    ${units of energy}
    Should be true    ${status}