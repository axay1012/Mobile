*** Settings ***
Documentation       Rheem iOS Old ECC Water Heater Test Suite

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
...                     AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameOldECC}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameOldECC}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         896
#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/
#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Old ECC

${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103077

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeAutoECC}
    Navigate to App Dashboard
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}

TC-02:Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103078

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${current_temp}    Get text    ${heatBubble}
    ${current_temp}    Get Substring    ${current_temp}    0    -1
    ${changedTemp_Mobile}    Change Temperature value    ${heatBubble}
    ${changedTemp_Mobile}    convert to integer    ${changedTemp_Mobile}
    Navigate to App Dashboard
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${changedTemp_Mobile}    ${dashBoardTemperature}

TC-03:Updating Heating set point from Equipment should be reflected on App and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating set point from Equipment should be reflected on App and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103079

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103080

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${current_temp}    Get text    ${coolBubble}
    ${current_temp}    Get Substring    ${current_temp}    0    -1
    ${changedTemp_Mobile}    Change Temperature value    ${coolBubble}
    Navigate to App Dashboard
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${changedTemp_Mobile}    ${dashBoardTemperature}

TC-05:Updating Cooling set point from Equipment should be reflected on App and Equipment. Equipment->Cloud->App
    [Documentation]    Updating Cooling set point from Equipment should be reflected on App and Equipment. Equipment->Cloud->App
    [Tags]    testrailid=103081
    
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:Min Heating setpoint that can be set from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Documentation]    Min Heating setpoint that can be set from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103082

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max Cooling setpoint that can be set from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set from Equipment should be 92F.
    [Tags]    testrailid=103083
    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min Heating set point that can be set from App should be 50F.
    [Documentation]    Min Heating set point that can be set from App should be 50F.
    [Tags]    testrailid=103084

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeHeatECC}
    Should be equal    ${mode_mobile}    Heating
    ${Temperature_ED}    Write objvalue From Device
    ...    51
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature old ECC    50    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    50
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max Cooling setpoint that can be set from App should be 92F. : EndDevice->Cloud->Mobile
    [Documentation]    Max Cooling setpoint that can be set from App should be 92F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103085
   
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeCoolECC}
    Should be equal    ${mode_mobile}    Cooling
    ${Temperature_ED}    Write objvalue From Device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature old ECC    92    ${modeTempBubble}
    wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    92
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:User should not be able to exceed Min Heating setpoint limit i.e. 50F from App.
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from App.
    [Tags]    testrailid=103086

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeHeatECC}
    ${Temperature_ED}    Write objvalue From Device
    ...    51
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal    ${mode_mobile}    Heating
    Scroll to the min temperature old ECC    50    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    50
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App. : EndDevice->Cloud->Mobile
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103087

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeCoolECC}
    ${Temperature_ED}    Write objvalue From Device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal    ${mode_mobile}    Cooling
    Scroll to the Max Temperature old ECC    92    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    92
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment
    [Tags]    testrailid=103088

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    51
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${TempChange_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeAutoECC}
    Should be equal    ${mode_mobile}    Auto
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    should not be equal as integers    49    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment
    [Tags]    testrailid=103089

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeAutoECC}
    Should be equal    ${mode_mobile}    Auto
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    93
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${TempChange_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    Should not be equal as integers    93    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-14:Updating Off Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Off Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103090

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeOff}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard

TC-15:Updating Heating Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103091

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeHeatECC}
    
    
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}

TC-16:Max Heating setpoint that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint that can be set from App should be 90F.
    [Tags]    testrailid=103092

    ${heatMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${heatMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Heating
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature old ECC    90    ${modeTempBubble}
    wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-17:User should not be able to exceed Max Heating setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from App
    [Tags]    testrailid=103093
    
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature old ECC    90    ${modeTempBubble}
    wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${temp_app}    Swipe Up the bubble    ${modeTempBubble}
    wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-18:Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103094

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeCoolECC}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}

TC-19:Min Cooling Setpoint that can be set from App should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling Setpoint that can be set from App should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103095

    ${coolMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Cooling
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}

    ${mode_mobile}    Change the mode Old ECC    ${modeCoolECC}
    ${Temperature_ED}    Write objvalue From Device
    ...    54
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Scroll to the min temperature old ECC    52    ${modeTempBubble}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${temp_mobile}    0    -1
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${Temperature_Mobile}    ${get_temp_ED}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    52    ${dashBoardTemperature}

TC-20:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103096

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeCoolECC}
    ${Temperature_ED}    Write objvalue From Device
    ...    54
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature old ECC    52    ${modeTempBubble}
    scroll up    ${modeTempBubble}
    wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${change_temp_mobile}    Get text    ${modeTempBubble}
    ${change_temp_mobile}    Get Substring    ${change_temp_mobile}    0    -1
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${change_temp_mobile}    ${get_temp_ED}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${change_temp_mobile}    ${dashBoardTemperature}

TC-21:Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103097

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode Old ECC    ${modeFanECC}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${thermostatCardCurrentValueIdentifier}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}

TC-22:Updating Fan Speed to Auto from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Auto from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103098

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
    Scroll to the lowest mode    ${fanAutoMode}
    Navigate to App Dashboard
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${stat_fan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    Auto
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Auto    ${modeValueDashboard}

TC-23:Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103099

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanLowMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanLowMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-24:Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103100

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMed.LoMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMed.LoMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-25:Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103101

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMediumMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMediumMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-26:Updating Fan Speed to Medium High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Medium High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103102

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMedHiMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMedHiMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-27:Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103103

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanHighMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanHighMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-28:User should be able to set Off mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Off mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103104

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${offMode}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${offMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Off
    Navigate to App Dashboard

TC-29:User should be able to set Heating mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Heating mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103105

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${heatMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${heatMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Heating
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Heating    ${modeValueDashboard}

TC-30:Max Heating setpoint that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint that can be set from Equipment should be 90F.
    [Tags]    testrailid=103106

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${set_Temp_ED}    ${get_Temp_ED}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    90
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-31:User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment
    [Tags]    testrailid=103107

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    91
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should not be equal as integers    91    ${get_Temp_ED}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    should not be equal as integers    ${temp_mobile}    91
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-32:User should be able to set Cooling mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Cooling mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103108

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${coolMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Cooling
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Cooling    ${modeValueDashboard}

TC-33:Min Cooling setpoint that can be set from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103109

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    52    ${get_Temp_ED}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    52
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Cooling    ${modeValueDashboard}

TC-34:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103110

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    51
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should not be equal as integers    51    ${get_Temp_ED}
    wait until page contains element    ${modeTempBubble}    20s
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    should not be equal as integers    ${temp_mobile}    51
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-35:User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103111

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Auto
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Auto    ${modeValueDashboard}

TC-36:User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103112

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanOnlyMode}    set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${fanOnlyMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Fan Only
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    Fan Only    ${modeValueDashboard}

TC-38:Updating Fan Speed to Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103114

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${lowMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${lowMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    Low
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    Low    ${modeValueDashboard}

TC-39:Updating Fan Speed to Med.Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Med.Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103115

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${medLowMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${medLowMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    Med.Lo
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    Med.Lo    ${modeValueDashboard}

TC-40:Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103116

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mediumMode}    set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${mediumMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    Medium
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    Medium    ${modeValueDashboard}

TC-41:Updating Fan Speed to Med.High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103117

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${medHiMode}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${medHiMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    Med.Hi
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    Med.Hi    ${modeValueDashboard}

TC-42:Updating Fan Speed to High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103118

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mediumMode}    set variable    5
    ${setMode_ED}    write objvalue from device
    ...    ${mediumMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    High
    Navigate to App Dashboard
    ${modeValueDashboard}    Get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    High    ${modeValueDashboard}

TC-50:Deadband of 0 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103119

    

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    Sleep    5s
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1

    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}

    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    

    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}

    Navigate to App Dashboard

TC-52:Deadband of 1 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103121

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    Sleep    5s
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1

    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}

    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    

    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}

    Navigate to App Dashboard

TC-56:Deadband of 2 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 2 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103125

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Sleep    5s
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

TC-60:Deadband of 3 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 3 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103129

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${autoMode}    Set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    Set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

TC-62:Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103131

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate Back to the Screen

TC-64:Deadband of 4 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 4 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103133

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    54
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    Sleep    5s
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1

    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}

    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    

    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}

    Navigate to App Dashboard

TC-68:Deadband of 5 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 5 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103137

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    5
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    55
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Sleep    5s
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}

    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}

    Navigate to App Dashboard

    
