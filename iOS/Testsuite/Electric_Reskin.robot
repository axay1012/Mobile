*** Settings ***
Documentation       Rheem iOS Electric Water Heater Test Suite

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
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
...                     AND    Select the Device Location    ${locationNameElectric}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without uninstall and Navigate to dashboard    ${locationNameElectric}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5
${EndDevice_id}                         704
#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/
#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458
#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Electric
${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123
${maxTempValEnergySaver}                130
${maxTempValPerformance}                140
${maxTempCelsEnergySaver}               54
${maxTempCelsPerformance}               60
${minTempCelsius}                       43
${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=88537

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
    [Tags]    testrailid=88538

    # Step-1) Changing temperature of Rheem Electric water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Step-3) Validating value of temperature on Dashboard

    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    3s
    ${Temperature_ED}    Read int return type objvalue From Device
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
    [Tags]    testrailid=88539

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Electric Water Heater.
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
    [Tags]    testrailid=88540

    # Step-1) Increse temperature of Electric Water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
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

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement    Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=88541

    # Set temperature from mobile and validating it on mobile itself
    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Electric Water Heater.
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
    [Documentation]    User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=88542

    # Set temperature from water heater
    # Step-1) Increse temperature of Electric Water heater(from Rheem Device Devkit)
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
    Sleep    5s
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers       ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.
    [Tags]    testrailid=88543

    ${Temperature_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    110    firstCircleIndicator
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

TC-08:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App
    [Tags]    testrailid=88544
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Scroll to the min Temperature    110    firstCircleIndicator
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

TC-09:User should be able to set Energy Saver mode from App. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Energy Saver mode from App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=88545

    Go to Temp Detail Screen    ${tempDashBoard}
    ${mode_mobile}    Change mode Electric Water Heater    ${energySavingMode}
    Navigate to App Dashboard
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ElectricHeaterMode}[${current_mode_ED}]    Energy Saver
    ${modeValueDashboard}    Get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    Energy Saver    ${modeValueDashboard}

TC-10:Max temperature that can be set for Energy Saver mode from App should be 130F.
    [Documentation]    Max temperature that can be set for Energy Saver mode from App should be 130F.
    [Tags]    testrailid=88546

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    129
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_mobile}    Change mode Electric Water Heater    ${energySavingMode}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValEnergySaver}
    Navigate to App Dashboard
    sleep    5s
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=88547
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempValEnergySaver}    ${imgBubble}
    ${temp_app}    Increment temperature value
    Sleep    4s
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValEnergySaver}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should be able to set Performance mode from App. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Performance mode from App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=88548

    Go to Temp Detail Screen    ${tempDashBoard}
    ${mode_mobile}    Change mode Electric Water Heater    ${performanceMode}
    Navigate to App Dashboard
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${ElectricHeaterMode}[${current_mode_ED}]    Performance
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    Performance    ${modeValueDashboard}

TC-13:Max temperature that can be set for Performance mode from App should be 140F.
    [Documentation]    Max temperature that can be set for Performance mode from App should be 140F.
    [Tags]    testrailid=88549

    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${mode_mobile}    Change mode Electric Water Heater    ${performanceMode}
    Navigate to App Dashboard
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempValPerformance}    ${imgBubble}
    Sleep    4s
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValPerformance}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-14:User should not be able to exceed max setpoint limit i.e. 140F for Performance mode from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F for Performance mode from App
    [Tags]    testrailid=88550

    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempValPerformance}    ${imgBubble}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValPerformance}
    Navigate to App Dashboard
    Sleep    3s
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-15:User should be able to set Energy Saver mode from Equipment : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Energy Saver mode from Equipment : EndDevice->Cloud->Mobile
    [Tags]    testrailid=88551

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
    Navigate to App Dashboard
    Should be equal as strings    ${ElectricHeaterMode}[${mode_set_ED}]    Energy Saver
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    Should be equal    Energy Saver    ${modeValueDashboard}

TC-16:Max temperature that can be set for Energy Saver Mode from Equipment should be 130F.
    [Documentation]    Max temperature that can be set for Energy Saver Mode from Equipment should be 130F.
    [Tags]    testrailid=88552

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
    ${Temperature_ED1}    Write objvalue From Device
    ...    130
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED1}    ${Temperature_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValEnergySaver}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-17:User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from Equipment
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from Equipment
    [Tags]    testrailid=88553
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
    ${TempCurGet_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED1}    Write objvalue From Device
    ...    131
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should not be equal as integers    ${Temperature_ED}    131
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${Temperature_Mobile}    Convert To Integer    ${Temperature_Mobile}
    Should be equal as integers    ${Temperature_Mobile}    ${TempCurGet_ED}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-18:User should be able to set Performance mode from Equipment : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Performance mode from Equipment : EndDevice->Cloud->Mobile
    [Tags]    testrailid=88554

    ${changeModeValue}    Set Variable    1
    ${type string}    Evaluate    type(${changeModeValue})
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
    Should be equal as strings    ${ElectricHeaterMode}[${mode_set_ED}]    Performance
    ${modeValueDashboard}    get dashboard value from equipment card    ${modeDashBoard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Performance    ${modeValueDashboard}

TC-19:Max temperature that can be set for Performance Mode from Equipment should be 140F.
    [Documentation]    Max temperature that can be set for Performance Mode from Equipment should be 140F.
    [Tags]    testrailid=88555

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
    ${Temperature_ED1}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED1}    ${Temperature_ED}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    ${maxTempValPerformance}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-20:User should not be able to exceed max setpoint limit i.e. 140F for Performance mode from Equipment
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 141F for Performance    mode from Equipment
    [Tags]    testrailid=88556

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
    ${Temperature_ED1}    Write objvalue From Device
    ...    141
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should not be equal as integers    ${Temperature_ED}    141
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    should not be equal as integers    ${Temperature_Mobile}    141
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-33:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=88569

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-34:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=88570

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    ${Temperature_Mobile}    Get current temperature from mobile app
    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${Temperature_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-35:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=88571

    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-36:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=88572

    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    121
    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard

TC-37:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment.
    [Tags]    testrailid=88573

    Go to Temp Detail Screen    ${tempDashBoard}
    ${mode_mobile}    Enable-Disable Electric Heater    ${DisableMode}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${Electric_modes}[${current_mode_ED}]    Disabled
    Navigate to App Dashboard
    Element value should be    ${tempDashBoard}    Disabled


TC-38:User should be able to Enable Equipment from App
    [Documentation]    User should be able to Enable Equipment from App
    [Tags]    testrailid=88574

    Go to Temp Detail Screen    ${tempDashBoard}
    ${mode_mobile}    Enable-Disable Electric Heater    ${EnableMode}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${Electric_modes}[${current_mode_ED}]    Enabled
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-39:User should be able to disable Equipment from End Device.
    [Documentation]    User should be able to disable Equipment from End Device.
    [Tags]    testrailid=88575
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeValue}    set variable    0
    ${currentSet_mode_ED}    write objvalue from device
    ...    ${modeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${currentSet_mode_ED}    ${current_mode_ED}
    Navigate to App Dashboard
    Element value should be    ${tempDashBoard}    Disabled

TC-40:User should be able to Enable Equipment from End Device.
    [Documentation]    User should be able to Enable Equipment from End Device.
    [Tags]    testrailid=88576

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeValue}    set variable    1
    ${currentSet_mode_ED}    write objvalue from device
    ...    ${modeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers    ${currentSet_mode_ED}    ${current_mode_ED}
    Navigate to App Dashboard
    ${modeValueDashboard}    get dashboard value from equipment card    ${waterHeaterCardStateValueDashboard}
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-43:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App
    [Tags]    testrailid=88579

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule without mode    ${locationNameElectric}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}   ${status}
    Navigate to App Dashboard

TC-44:Copy the Scheduled day slot and temperature from App
    [Documentation]    Copy the Scheduled day slot and temperature from App
    [Tags]    testrailid=88580

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameElectric}
    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-45:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=88581

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temp}    Increment temperature value
    Sleep    10s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${temp}    ${dashBoardTemperature}
    

TC-46:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=88582
    
    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    sleep    10s
    Wait Until Page Contains Element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    time0    ${defaultWaitTime}
    ${time0}    Get Text    time0
    Wait Until Element is Visible    time1    ${defaultWaitTime}
    ${time1}    Get Text    time1
    Wait Until Element is Visible    time2    ${defaultWaitTime}
    ${time2}    Get Text    time2
    Wait Until Element is Visible    time3    ${defaultWaitTime}
    ${time3}    Get Text    time3
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    time0
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    time1
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    time2
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    time3
    ELSE
        set global variable    ${status}    time3
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click Element    ${status}
    Sleep     5s
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    ${status}    run keyword and return status    click element    modalBackButtonIdentifier
    ${Temp}    Increment temperature value
    Sleep    10s
    wait until page contains element    ${btnResume}    ${defaultWaitTime}
    click element    ${btnResume}
    Sleep    10s
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Sleep    4s
    ${tempValSchedule}    get text    ${currentTemp}
    Should be equal as integers    ${tempValSchedule}    ${scheduled_temp}

TC-47:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=88583

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule without mode    ${locationNameElectric}
    ${temp}    Convert to integer    ${status}
    Sleep    5s
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard

TC-48:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=88584

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameElectric}
    Navigate to App Dashboard

TC-41:User should be able to set Away mode from App for Electric Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App for Electric Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=88577

    # Step-1) Configure Away mode in App validate on cloud and vacation end device.
    # Step-2) Validating value of temperature on Rheem Water Heater Pump.

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    Sleep    2s
    ${Status}    Run keyword and return status    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    IF    ${Status}==True    Enable Away Setting    ${locationNameHPWH}
    Sleep    2s
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
    Element value should be    ${homeaway}    ${awayModeText}
    

TC-42:User should be able to Disable Away from App for Electric Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for Electric Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=88578

    # Step-1) Disabling Configure vacation mode in App validate on cloud and end device.
    # Step-2) Validating temperature value on End Device

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    Sleep    2s
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0
    Element value should be    ${homeaway}    ${homemodetext}

TC-49:User should be able to disable running status of device from EndDevice.
    [Documentation]    User should be able to disable running status of device from EndDevice
    [Tags]    testrailid=88585

    Go to Temp Detail Screen    ${tempDashBoard}

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${heatCtrl}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
#    page should not contain element    Running
    Navigate to App Dashboard

TC-50:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice
    [Tags]    testrailid=88586

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${heatCtrl}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
#    Wait until page contains element    Running    ${defaultWaitTime}
    Navigate to App Dashboard

TC-21:Max temperature that can be set from Equipment should be 60C for Performance mode.
    [Documentation]    Max temperature that can be set from Equipment should be 60C.    :EndDEevice->Mobile
    [Tags]    testrailid=88557

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
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Select the Device Location  ${locationNameElectric}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}

TC-22:Min temperature that can be set from Equipment should be 43C for Performance mode.
    [Documentation]    Min temperature that can be set from Equipment should be 43C.    :EndDEevice->Mobile
    [Tags]    testrailid=88558

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
    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}    ${setpoint_M_EC}

TC-23:Max temperature that can be set from App should be 60C for Performance mode.
    [Documentation]    Max temperature that can be set from App should be 60C.    :Mobile->EndDevice
    [Tags]    testrailid=88559

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    2s
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempCelsPerformance}    ${imgBubble}
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
    Should be equal as integers    ${result1}    ${setpoint_M_DP}
    Should be equal as integers    ${result1}   ${setpoint_M_EC}
    

TC-24:Min temperature that can be set from App should be 43C for Performance mode.
    [Documentation]    Min temperature that can be set from App should be 43C.    :Mobile->EndDevice
    [Tags]    testrailid=88560

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    ${minTempCelsius}    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

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
    

TC-25:User should not be able to exceed max setpoint limit i.e. 60C from App for Performance mode.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App    :Mobile->EndDevice
    [Tags]    testrailid=88561

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    139
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    ${maxTempCelsPerformance}    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    ${maxTempCelsPerformance}
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

TC-26:User should not be able to exceed min setpoint limit i.e. 43C from App for Performance mode.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App    :Mobile->EndDevice
    [Tags]    testrailid=88562

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    ${minTempCelsius}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    ${minTempCelsius}
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

TC-27:Max temperature that can be set from Equipment should be 54C for Energy Saver mode.
    [Documentation]    Max temperature that can be set from Equipment should be 54C. :EndDEevice->Mobile
    [Tags]    testrailid=88563

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
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    130
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
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

TC-28:Min temperature that can be set from Equipment should be 43C for Energy Saver mode.
    [Documentation]    Min temperature that can be set from Equipment should be 43C. :EndDEevice->Mobile
    [Tags]    testrailid=88564

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
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-29:Max temperature that can be set from App should be 54C for Energy Saver mode.
    [Documentation]    Max temperature that can be set from App should be 60C.    :Mobile->EndDevice
    [Tags]    testrailid=88565

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    130
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers   60   ${setpoint_M_DP}
    Should be equal as integers   60    ${setpoint_M_EC}
    

TC-30:Min temperature that can be set from App should be 43C for Energy Saver mode.
    [Documentation]    Min temperature that can be set from App should be 43C.    :Mobile->EndDevice
    [Tags]    testrailid=88566

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    ${minTempCelsius}    ${imgBubble}
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
    

TC-31:User should not be able to exceed max setpoint limit i.e. 54C from App for Energy Saver mode.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 54C from App    :Mobile->EndDevice
    [Tags]    testrailid=88567

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    129
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    ${maxTempCelsEnergySaver}    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    ${maxTempCelsEnergySaver}
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers   54    ${setpoint_M_DP}
    Should be equal as integers   54    ${setpoint_M_EC}

TC-32:User should not be able to exceed min setpoint limit i.e. 43C from App for Energy Saver mode.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App    :Mobile->EndDevice
    [Tags]    testrailid=88568

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    111
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${temp_app}    Decrement temperature value
    Sleep    5s
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    ${minTempCelsius}
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be equal as integers   43    ${setpoint_M_DP}
    Should be equal as integers   43    ${setpoint_M_EC}

    Temperature Unit in Fahrenheit

TC-51:Max temperature that can be set for Energy Saver mode from App should be 130F.
    [Documentation]    Max temperature that can be set for Energy Saver mode from App should be 130F.
    [Tags]    testrailid=88587

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
    ${Temperature_ED}    Write objvalue From Device    129    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    129

    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    129

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    130

    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    130
    
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    130

TC-52:Min temperature that can be set for Energy Saver mode from App should be 110F.
    [Documentation]    Min temperature that can be set for Energy Saver mode from App should be 110F.
    [Tags]    testrailid=88588
    
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

TC-53:User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 130F for Energy Saver mode from App
    [Tags]    testrailid=88589

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    130    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    130
    ${Temperature_Mobile}    Get current temperature from mobile app
    Should be equal as integers    ${Temperature_Mobile}    130

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    Should be equal as integers    ${tempMobile}    130

    Navigate Back to the Screen
    ${setpoint_mobile}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_mobile}    130
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Should be equal as integers    ${setpoint_ED}    130

TC-54:User should not be able to exceed min setpoint limit i.e. 110F for Energy Saver mode from App
    [Documentation]    Min temperature that can be set for Energy Saver mode from App should be 110F.
    [Tags]    testrailid=88590

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

TC-58:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App
    [Tags]    testrailid=88594

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

TC-55:User should be able to Change the temperature value from the Schedule screen.
    [Documentation]    Schedule the temperature and mode from App using button
    [Tags]    testrailid=88591

    Temperature Unit in Fahrenheit
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
    ${temperature}    Set Schedule using button without mode    ${locationNameElectric}
    ${temp}    Convert to integer    ${temperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard

TC-56:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow
    [Tags]    testrailid=88592

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    sleep    10s
    Wait Until Page Contains Element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    time0    ${defaultWaitTime}
    ${time0}    Get Text    time0
    Wait Until Element is Visible    time1    ${defaultWaitTime}
    ${time1}    Get Text    time1
    Wait Until Element is Visible    time2    ${defaultWaitTime}
    ${time2}    Get Text    time2
    Wait Until Element is Visible    time3    ${defaultWaitTime}
    ${time3}    Get Text    time3
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    time0
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    time1
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    time2
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    time3
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click Element    ${status}
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}

    ${abc}    Run keyword and return status    click element    modalBackButtonIdentifier
    sleep    5s
    ${abc}    Run keyword and return status    click element    modalBackButtonIdentifier
    sleep    5s
    ${TEMP}    INCREMENT TEMPERATURE VALUE
    SLEEP    2S
    wait until page contains element    ${btnResume}    ${defaultWaitTime}
    click element    ${btnResume}
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${tempValSchedule}    get text    ${currentTemp}
    Should be equal as integers    ${tempValSchedule}    ${scheduled_temp}
    Navigate Back to the Screen

Verify UI of Network Settings screen
    [Tags]    testrailid=88592
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

Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Tags]    testrailid=88592

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}

    Navigate to App Dashboard

Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Tags]    testrailid=88592

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    130    ${IncreaseButton}
    Navigate to App Dashboard

Verfiy device specific alert on equipment card
    [Tags]    testrailid=88592

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts
    END

Verfiy device specific alert on detail screen
    [Tags]    testrailid=88592

    Go to Temp Detail Screen    ${tempDashBoard}
    Click Element    ${iconNotification}
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts
    END
