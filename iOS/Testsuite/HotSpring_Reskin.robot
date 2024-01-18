*** Settings ***
Documentation       Rheem iOS Hot spring Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
#
Library             ../../src/RheemMqtt.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    Hotspring
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}    AND    Select the Device Location    ${locationNameHotSpring}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without uninstall and Navigate to dashboard    ${locationNameHotSpring}

*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4608

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Hotspring

${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123

${maxTempVal}                           140
${minTempVal}                           110

${maxTempCelsius}                       60
${minTempCelsius}                       43

${value1}                               32
${value2}                               5
${value3}                               9

*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=86977

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
    [Tags]    testrailid=86978

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
    [Tags]    testrailid=86979

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
    [Tags]    testrailid=86980

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
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement    Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=86981

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
    [Tags]    testrailid=86982

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
    [Tags]    testrailid=86983
    ${Temperature_ED}    Write objvalue From Device    138    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempVal}    ${imgBubble}
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

TC-08:Min temperature that can be set from App should be 110F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 110F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=86984

    ${Temperature_ED}    Write objvalue From Device    112    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
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
    [Tags]    testrailid=86985

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

TC-10:Min temperature that can be set from Equipment should be 110F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 110F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=86986

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

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=86987

    ${Temperature_ED}    Write objvalue From Device    138    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempVal}    ${imgBubble}
    ${temp_app}    Increment temperature value
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

TC-12:User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 110F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=86988

    ${Temperature_ED}    Write objvalue From Device    112    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
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

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=86995

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=86996

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

TC-21:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=86997
    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard

TC-22:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=86998
    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-27:User should be able to view the Energy Usage data for the Week of HotSpring Water Heater
    [Documentation]    User should be able to view the Energy Usage data for the Day of HotSpring Water Heater
    [Tags]    testrailid=87003

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${daily}
    Click element    ${daily}
    Wait until page contains    ${historicDataChartDay}    ${defaultWaitTime}

TC-28:User should be able to view the Energy Usage data for the Month of HotSpring Water Heater
    [Documentation]    User should be able to view the Energy Usage data for the Month of HotSpring Water Heater
    [Tags]    testrailid=87004

    Wait until element is visible    ${weekly}    ${defaultWaitTime}
    Click element    ${weekly}
    Sleep    5s
    Wait until page contains    ${historicDataChartWeek}    ${defaultWaitTime}

TC-29:User should be able to view the Energy Usage data for the Year of HotSpring Water Heater
    [Documentation]    User should be able to view the Energy Usage data for the Year of HotSpring Water Heater
    [Tags]    testrailid=87005

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible    ${monthly}    ${defaultWaitTime}
    Click element    ${monthly}
    Sleep    5s
    Wait until page contains    ${historicDataChartMonth}    ${defaultWaitTime}

TC-30:User should be able to view the Energy Usage data for the Day of HotSpring Water Heater
    [Documentation]    User should be able to view the Energy Usage data for the Day of HotSpring Water Heater
    [Tags]    testrailid=87006

    # Step-1) Go to Daily usage report and verify energy usage

    Wait until element is visible    ${yearly}    ${defaultWaitTime}
    Click element    ${yearly}
    Sleep    5s
    Wait until page contains    ${historicDataChartYear}    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Tags]    testrailid=86999

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${DisableMode}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HotSpring_modes}[${mode_ED}]    Disabled

TC-24:User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Documentation]    User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Tags]    testrailid=87000

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${EnableMode}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${HotSpring_modes}[${mode_ED}]    Enabled
    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    Should be equal    Enabled    ${modeValueDashboard}

TC-25:User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Documentation]    User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Tags]    testrailid=87001

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
    Should be equal as strings    ${HotSpring_modes}[${mode_set_ED}]    Disabled

TC-26 :User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Documentation]    User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Tags]    testrailid=87002

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
    Should be equal as strings    ${HotSpring_modes}[${mode_set_ED}]    Enabled

TC-33:Schedule the temperature from App
    [Documentation]    Schedule the temperature from App
    [Tags]    testrailid=87009

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule without mode    ${locationNameHotSpring}
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

TC-34:Copy the Scheduled day slot and temperature from App
    [Documentation]    Copy the Scheduled day slot and temperature from App
    [Tags]    testrailid=87010

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameHotSpring}
    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-35:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=87011

    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen
    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temp}    Increment temperature value
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${temp}    ${dashBoardTemperature}

TC-36:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=87012

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    sleep    10s
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
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
    ${time024}    convert to integer    ${time024}
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
    Click element    ${status}
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}

    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    page should contain element    ${followScheduleMsgDashboard}

    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${tempValSchedule}    get text    ${currentTemp}
    Should be equal as integers    ${tempValSchedule}    ${scheduled_temp}
    Navigate to App Dashboard

TC-37:Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=87013

    Go to Temp Detail Screen    ${tempDashBoard}
    ${status}    Set Schedule without mode    ${locationNameHotSpring}
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

TC-38:Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=87014

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Unfollow the schedule    ${locationNameHotSpring}
    Navigate to App Dashboard


TC-39:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice
    [Tags]    testrailid=87015

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HEATCTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    10s
    Page should not contain text    Running
    Navigate Back to the Screen

TC-40:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice
    [Tags]    testrailid=87016

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HEATCTRL
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate Back to the Screen

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C. :EndDEevice->Mobile
    [Tags]    testrailid=86989
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
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
    Temperature Unit in Celsius
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}   60

TC-14:Min temperature that can be set from Equipment should be 43C.
    [Documentation]    Min temperature that can be set from Equipment should be 43C.:EndDEevice->Mobile
    [Tags]    testrailid=86990

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
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
    ${result2}    convert to integer    ${result1}
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${tempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    43
    Should be equal as integers    ${result2}    43
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C. :Mobile->EndDevice
    [Tags]    testrailid=86991

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the Max Temperature    ${maxTempCelsius}    ${imgBubble}
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

TC-16:Min temperature that can be set from App should be 43C.
    [Documentation]    Min temperature that can be set from App should be 43C. :Mobile->EndDevice
    [Tags]    testrailid=86992

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
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
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App    :Mobile->EndDevice
    [Tags]    testrailid=86993

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    ${maxTempCelsius}    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    ${maxTempCelsius}
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

TC-18:User should not be able to exceed min setpoint limit i.e. 43C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 43C from App :Mobile->EndDevice
    [Tags]    testrailid=86994

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    112
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
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-41:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=87017

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

TC-42:Min temperature that can be set from App should be 110F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=87018

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

TC-43:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=87019

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

TC-44:User should not be able to exceed min setpoint limit i.e. 110F from App
    [Documentation]    User should not be able to exceed min temperature 110F using button slider
    [Tags]    testrailid=87020

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

TC-47:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App using button:Mobile->EndDevice
    [Tags]    testrailid=87023

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
    ${result2}    convert to integer    ${result1}
    Should be equal as integers    ${result2}    60

TC-48:User should not be able to exceed min setpoint limit i.e. 43C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button:Mobile->EndDevice
    [Tags]    testrailid=87024

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
    ${result2}    convert to integer    ${result1}
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

TC-45:User should be able to Change the temperature value from the Schedule screen.
    [Documentation]    User should be able to Change the temperature value from the Schedule screen.
    [Tags]    testrailid=87021

    Temperature Unit in Fahrenheit
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    ${temperature}    Set Schedule using button without mode    ${locationNameHotSpring}
    ${temp}    Convert to integer    ${temperature}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard

TC-46:User should be able to Resume the Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume the Schedule when scheduled temperature is not follow
    [Tags]    testrailid=87022

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temp}    Increment temperature value
    Sleep    10s
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Sleep    10s
    Navigate Back to the Screen
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    should not be equal as integers    ${temp}    ${dashBoardTemperature}
    Run keyword and ignore error     Navigate Back to the Screen

TC-49:Verify UI of Network Settings screen
    [Tags]    testrailid=222044

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
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-50:Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Tags]    testrailid=222047

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    Navigate to App Dashboard

TC-51:Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Tags]    testrailid=222048
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    ${IncreaseButton}
    Navigate to App Dashboard


TC-54:Verfiy device specific alert on equipment card
    [Tags]    testrailid=222045

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

TC-55:Verfiy device specific alert on detail screen
    [Tags]    testrailid=222046

    Go to Temp Detail Screen    ${tempDashBoard}
    Click element    validateBell
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click element    ${devicenotifications}
        Verify Device Alerts
    END

TC-57:Verify that user can able to Turn ON Historical data
    [Documentation]    Verify that user can able to Turn ON Historical data
    [Tags]    testrailid=222755

    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    Wait until page contains    ${historicalDataSwitcher}    ${defaultWaitTime}
    ${value}    Get Text    ${historicalDataSwitcher}
    IF    '${value}'=='Off'    Click element    ${value}
    page should contain element    ${DailyHistory}    ${defaultWaitTime}

TC-58:Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.
    [Documentation]    Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.
    [Tags]    testrailid=222756

    Page should contain element    ${usageText}    ${defaultWaitTime}
    ${Value}    Get text    ${usageText}
    ${status}    check    ${Value}    ${units of energy}
    should be true    ${status}    True
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-60: Verify if user update LSDETECT=1 then Leak Sensor not connected should be appeared in Product Health
    [Documentation]    Verify if user update LSDETECT=1 then Leak Sensor not connected should be appeared in Product Health
    [Tags]    testrailid=222758

    ${mode_set_ED}    Write objvalue From Device    1    LSDETECT    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Health    ${defaultWaitTime}
    Click element    Health
    Sleep    2s
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-61: Verify if user update SHUTOPEN then should valve Open should be appeared in Product Health
    [Documentation]    Verify if user update SHUTOPEN then should valve Open should be appeared in Product Health
    [Tags]    testrailid=222759
    ${mode_set_ED}    Write objvalue From Device    1    SHUTOFFV    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${mode_set_ED}    Write objvalue From Device    1    SHUTOPEN    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Health    ${defaultWaitTime}
    Click element    Health
    Sleep    2s
    Wait until page contains    Shut-OFF Valve - Open
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-62: Verify if user update SHUTOPEN then should valve Closed should be appeared in Product Health
    [Documentation]    Verify if user update SHUTOPEN then should valve Closed should be appeared in Product Health
    [Tags]    testrailid=222760

    ${mode_set_ED}    Write objvalue From Device    0    SHUTOPEN    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Health    ${defaultWaitTime}
    Click element    Health
    Sleep    2s
    Wait until page contains    Shut-OFF Valve - Closed
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-31:User should be able to set Away mode from App for Hot Spring Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App for Hot Spring Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=87007

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Status}    run keyword and return status    Wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    ${locationNameHotSpring}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-32:User should be able to Disable Away from App for Hot Spring Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for Hot Spring Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=87008

    Wait until page contains element    ${homeaway}    ${defaultWaitTime}
    Click element    ${homeaway}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0