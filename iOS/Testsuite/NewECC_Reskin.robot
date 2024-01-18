*** Settings ***
Documentation       Rheem iOS New ECC Test Suite

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

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Open App
...                     AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
...                     AND    Select the Device Location    ${locationNameNewECC}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
...                     Open Application and Navigate to Device Detail Page    ${locationNameNewECC}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5

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
${Device_TYPE}                          New Ecc

${emailId}                              %{NewECC_Email}
${passwordValue}                        %{NewECC_Password}

${newECCMinTemperature}                 50
${maxCoolingSetPoint}                   92
${maxHeatingSetPoint}                   90
${minCoolingSetPoint}                   52

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. :Mobile->Cloud->EndDevice
    [Tags]    testrailid=99075

    # Step-1) Updating the Auto mode on the Rheem application
    # Step-2) Validation of mode change on the End Device and in rheem application
    # Step-3) Validating value of mode on Dashboard

    ${deadBandVal}    Set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard
    ${modeValueDashboard}   Get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}

TC-02:Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99076

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${current_temp}    Get text    ${heatBubble}
    ${changedTemp_Mobile}    Change Temperature value    ${heatBubble}
    ${changedTemp_Mobile}    Convert to integer    ${changedTemp_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${changedTemp_Mobile}    ${dashBoardTemperature}
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal    ${changedTemp_Mobile}    ${current_temp_ED}

TC-03:Updating Heating set point from Equipment should be reflected on App and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating set point from Equipment should be reflected on App and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99077

    # Validating Value of temperature on Rheem Mobile Application.

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
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99078

    # Step-1) Changing Heating temperature of New ECC and verify it on mobile and End Device
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${current_temp}    Get text    ${coolBubble}
    ${changedTemp_Mobile}    Change Temperature value    ${coolBubble}
    Navigate Back to the Screen
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
    [Tags]    testrailid=99079

    # Set temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from equipment End device

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
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:Min Heating setpoint that can be set from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Documentation]    Min Heating setpoint that can be set from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99080

    # Set temperature from water heater
    # Step-1) Set temperature as 50f in application
    # Step-2) Validating Value of temperature on Rheem Mobile Application.

    ${Temperature_ED}    Write objvalue From Device
    ...    ${newECCMinTemperature}
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max Cooling setpoint that can be set from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set from Equipment should be 92F.
    [Tags]    testrailid=99081

    # Set temperature from water heater
    # Step-1) Set temperature as 92F in application

    ${Temperature_ED}    Write objvalue From Device
    ...    ${maxCoolingSetPoint}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min Heating set point that can be set from App should be 50F.
    [Documentation]    Min Heating set point that can be set from App should be 50F.
    [Tags]    testrailid=99082

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from Rheem Mobile Application .

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the min temperature new ECC    ${newECCMinTemperature}    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    should be equal    ${Temperature_Mobile}    ${newECCMinTemperature}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-09:Max Cooling setpoint that can be set from App should be 92F. : EndDevice->Cloud->Mobile
    [Documentation]    Max Cooling setpoint that can be set from App should be 92F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99083

    # Step-1) Change temperture value as Max cooling temperature    92F
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature new ECC    ${maxCoolingSetPoint}    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    ${maxCoolingSetPoint}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    # Validating temperature value on End Device
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-10:User should not be able to exceed Min Heating setpoint limit i.e. 50F from App.
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from App.
    [Tags]    testrailid=99084

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from Rheem Mobile Application .
    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the min temperature new ECC    ${newECCMinTemperature}    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    ${newECCMinTemperature}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-11:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App. : EndDevice->Cloud->Mobile
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99085

    # Step-1) Change temperture value as Max cooling temperature    92F
    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature new ECC    ${maxCoolingSetPoint}    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    should be equal    ${Temperature_Mobile}    ${maxcoolingsetpoint}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-12:User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F from Equipment
    [Tags]    testrailid=99086

    # Set temperature from water heater
    # Step-1) Set temperature as 49f in application
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    49
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
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    Should not be equal as integers    49    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F from Equipment
    [Tags]    testrailid=99087

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
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
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    Should not be equal as integers    93    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-14:Updating Off Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Off Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99088

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeOff}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Navigate to App Dashboard

TC-15:Updating Heating Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99089

    # Step-1) Updating the Heating mode on the Rheem application
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeHeatECC}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}

TC-16:Max Heating setpoint that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint that can be set from App should be 90F.
    [Tags]    testrailid=99090

    # Step-1) change the Value of temperature as 90F from the Application

    ${heatMode}    Set variable    0
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
    ${changed_Temp_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature new ECC    ${maxHeatingSetPoint}    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-17:User should not be able to exceed Max Heating setpoint limit i.e. 90F from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from App
    [Tags]    testrailid=99091

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
    # Changing temperature from Rheem Mobile Application .
    ${changed_Temp_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature new ECC    ${maxHeatingSetPoint}    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    ${maxHeatingSetPoint}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-18:Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Cooling Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99092

    # Step-1) Updating the Cooling mode on the Rheem application

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
    ${mode_mobile}    Change the mode New ECC    ${modeCoolECC}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${mode_mobile}    ${modeValueDashboard}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}

TC-19:Min Cooling Setpoint that can be set from App should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling Setpoint that can be set from App should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99093

    ${changed_Temp_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeCoolECC}
    Scroll to the min temperature new ECC    ${minCoolingSetPoint}    ${modeTempBubble}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    thermostatCardCoolValueIdentifier
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${minCoolingSetPoint}    ${get_temp_ED}
    Should be equal as strings    ${temp_mobile}    ${get_temp_ED}

TC-20:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99094

    # Step-1) Updating the Cooling mode on the Rheem application
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeCoolECC}
    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature new ECC    ${minCoolingSetPoint}    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${temp_app}    Swipe down the bubble    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    should be equal    ${Temperature_Mobile}    ${minCoolingSetPoint}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    thermostatCardCoolValueIdentifier
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${minCoolingSetPoint}    ${get_temp_ED}
    Should be equal as strings    ${Temperature_Mobile}    ${get_temp_ED}

TC-21:Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Only Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99095

    # Updating the Fan Only mode on the Rheem application

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
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeFanECC}
    Navigate Back to the Screen
    ${modeValueDashboard}    get dashboard value from equipment card    ${thermostatCardCurrentValueIdentifier}
    should be equal    ${mode_mobile}    ${modeValueDashboard}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}

TC-23:Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99097

    # Step-1) Updating the Fan speed as Low on the Rheem application

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanLowMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}
    Sleep    1s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanLowMode}

TC-24:Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Med.Lo from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99098

    # Step-1) Updating the Fan speed as Medium Low on the Rheem application
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMed.LoMode}
    Sleep    1s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMed.LoMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-25:Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Medium from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99099

    # Step-1) Updating the Fan speed as Medium on the Rheem application
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMediumMode}
    Sleep    1s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMediumMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-26:Updating Fan Speed to Medium High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Medium High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99100

    # Step-1) Updating the Fan speed as Medium High on the Rheem application

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMedHiMode}
    Sleep    1s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanMedHiMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-27:Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to High from App detail page should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99101

    # Step-1) Updating the Fan speed as High on the Rheem application
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanHighMode}
    Sleep    1s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanHighMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanSpeed_mobile}    ${modeValueDashboard}

TC-28:User should be able to set Off mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Off mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99102

    # Step-1) Change the mode Off from the equipment.
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${offMode}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${offMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    1s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    ${modeOff}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    thermostatCardCurrentValueIdentifier
    should be equal    OFF    ${modeValueDashboard}

TC-29:User should be able to set Heating mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Heating mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99103

    # Step-1) Change the mode Heating from the equipment.
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${heatMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${heatMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    1s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    ${modeHeatECC}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${modeHeatECC}    ${modeValueDashboard}

TC-30:Max Heating setpoint that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint that can be set from Equipment should be 90F.
    [Tags]    testrailid=99104

    # Step-1) change the Value of temperature as 90F from the Equipment.

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    ${maxHeatingSetPoint}
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
    Wait until element is visible    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${text}    Get Substring    ${temp_mobile}    0    -1
    ${temp_mobile}    convert to integer    ${text}
    Should be equal as integers    ${temp_mobile}    ${maxHeatingSetPoint}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-31:User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F from Equipment
    [Tags]    testrailid=99105

    # Step-1) change the Value of temperature as 91F from the Equipment.
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
    Should not be equal as integers    91    ${get_Temp_ED}
    Wait until element is visible    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should not be equal as integers    ${temp_mobile}    91
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-32:User should be able to set Cooling mode from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Cooling mode from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99106

    # Step-1) Change the mode cooling from the equipment.

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${coolMode}    Set variable    1
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
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    ${modeCoolECC}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${modeCoolECC}    ${modeValueDashboard}

TC-33:Min Cooling setpoint that can be set from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99107

    # Step-1) change the Value of temperature as 52f from equipment.

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${set_Temp_ED}    write objvalue from device
    ...    ${minCoolingSetPoint}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${minCoolingSetPoint}    ${get_Temp_ED}
    Wait until element is visible    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    ${minCoolingSetPoint}
    Navigate to App Dashboard
    ${modeValueDashboard}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${modeValueDashboard}    ${minCoolingSetPoint}

TC-34:User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99108

    # Step-1) change the Value of temperature as 51F from the Application

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
    Should not be equal as integers    51    ${get_Temp_ED}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    Get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should not be equal as integers    ${temp_mobile}    51
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${temp_mobile}    ${dashBoardTemperature}

TC-35:User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99109

    # Change the mode Auto from the equipment.

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
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    ${fanAutoMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
    Should be equal    ${fanAutoMode}    ${modeValueDashboard}

TC-36:User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99110

    # Step-1) Change the mode fan Only from the equipment.

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
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    ${modeFanECC}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${thermostatCardCurrentValueIdentifier}
    Should be equal    ${modeFanECC}    ${modeValueDashboard}

TC-37:Updating Fan Speed to Auto from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Auto from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99111

    # Step-1) Change the fan speed as Auto from Equipment for Fan Only mode.

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
    ${fanOnlyMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${fanOnlyMode}
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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanAutoMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanAutoMode}    ${modeValueDashboard}

TC-38:Updating Fan Speed to Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99112

    # Step-1) Change the fan speed as Low from Equipment for Fan Only mode.

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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanLowMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanLowMode}    ${modeValueDashboard}

TC-39:Updating Fan Speed to Med.Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Med.Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99113
    # Updating Fan Speed to Med.Low from Equipment should be reflected on App. : EndDevice->Cloud->Mobileep-1) Change the fan speed as Med.Low from Equipment for Fan Only mode.
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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanMed.LoMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanMed.LoMode}    ${modeValueDashboard}

TC-40:Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99114
    # Step-1) Change the fan speed as Medium from Equipment for Fan Only mode.
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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanMediumMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanMediumMode}    ${modeValueDashboard}

TC-41:Updating Fan Speed to Med.High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99115

    # Step-1) Change the fan speed as Medium High from Equipment for Fan Only mode.

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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanMedHiMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${fanMedHiMode}    ${modeValueDashboard}

TC-42:Updating Fan Speed to High from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Fan Speed to Medium from Equipment should be reflected on App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99116
    # Step-1) Change the fan speed as Medium from Equipment for Fan Only mode.
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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${fanHighMode}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    should be equal    ${fanHighMode}    ${modeValueDashboard}

TC-50:Deadband of 0 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99128

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
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
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
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    52    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    52    ${dashBoardTemperature}

#TC-51:Deadband of 0 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 0 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99129
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    0
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    Navigate to App Dashboard
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    90    ${dashBoardTemperature}
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
#    Should be equal as integers    90    ${dashBoardTemperature}

TC-52:Deadband of 1 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99130

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
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
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
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    90    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    91    ${dashBoardTemperature}

#TC-53:Deadband of 1 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99131
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    51
#    ...    HEATSETP
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    Navigate to App Dashboard
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    51    ${dashBoardTemperature}
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
#    Should be equal as integers    52    ${dashBoardTemperature}

#TC-54:Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99132
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
#    ${difference}    Evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

#TC-55:Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 1 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99133
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

TC-56:Deadband of 2 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 2 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99134

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

#TC-57:Deadband of 2 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 2 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99135
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-58:Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99136
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-59:Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 2 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99137
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTmp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

TC-60:Deadband of 3 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 3 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99138

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
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-61:Deadband of 3 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 3 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99139
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    3
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    89
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    Evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-62:Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99140
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    3
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    Evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-63:Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 3 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99141
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    3
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

TC-64:Deadband of 4 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 4 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99142

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
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${difference}    Evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-65:Deadband of 4 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 4 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99143
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    4
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    88
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-66:Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99144
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    4
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    Evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-67:Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 4 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99145
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    4
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
