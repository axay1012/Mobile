*** Settings ***
Documentation       Rheem iOS Niagara Water Heater Test Suite

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
Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}    AND    Open App    AND    Sign in to the application    ${emailId}    ${passwordValue}    AND    Select the Device Location    ${locationNameIkonic}    AND    Temperature Unit in Fahrenheit    AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         4224

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Niagra

${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

${maxTempVal}                           140
${minTempVal}                           85

${maxTempCelsius}                       ${EMPTY}
${minTempCelsius}                       ${EMPTY}

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89640

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END
    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    # Sleep    5s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value

    Navigate to App Dashboard
    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89641

    # Set temperature from water heater
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${Temperature_ED}    Write objvalue From Device
    ...    112
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    # Validating the temperature value on Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-03:User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89642
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    # Set temperature from mobile and validating it on mobile itself

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value

    Navigate to App Dashboard
    # Sleep    5s

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-04:User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to increment Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89643
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    # Set temperature from water heater

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

    # Validating the temperature value on Rheem Mobile Application
    # sleep    6s

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement    Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89644
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END
    # Set temperature from mobile and validating it on mobile itself

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Decrement temperature value
    Sleep    5s
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-06:User should be able to decrement Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to decrement    Set Point temperature from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89645

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    # Set temperature from water heater

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

    # Validating the temperature value on Rheem Mobile Application

    # Sleep    6s

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-07:Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice
    [Documentation]    Max temperature that can be set from App should be 140F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89646

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    # Set Given max temperature    140
    Scroll to the Max Temperature    ${maxTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    ${maxTempVal}
    Navigate to App Dashboard

    # Sleep    5s
    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-08:Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89647
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    # Set Minimum setpoint temperature from mobile and validating it on mobile itself

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # Set Given min temperature    85
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    ${minTempVal}
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-09:Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile
    [Documentation]    Max temperature that can be set from Equipment should be 140F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89648
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${Temperature_ED}    Write objvalue From Device
    ...    ${maxTempVal}
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    # Validating the temperature value on Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-10:Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89649
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${Temperature_ED}    Write objvalue From Device
    ...    85
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    # Validating the temperature value on Rheem Mobile Application

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Get current temperature from mobile app
    Navigate to App Dashboard

    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-11:User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 140F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89650

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    ${maxTempVal}    ${imgBubble}
    ${temp_app}    Increment temperature value
    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    ${maxTempVal}
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-12:User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89651
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself

    ${Temperature_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    # Set Given min temperature    85
    Scroll to the min temperature    ${minTempVal}    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    # Sleep    5s
    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    ${minTempVal}
    Navigate to App Dashboard

    # Validating temperature value on End Device

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${Temperature_Mobile}    ${dashBoardTemperature}

TC-13:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=89658
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    6s
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app
#    should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-14:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=89659
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-15:A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from Equipment
    [Tags]    testrailid=89660
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END
    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ...    below 120F/48C from Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    should be equal as integers    ${temp_app}    121
    Sleep    10s
    wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    wait until page contains element    ${contactskinburn}    ${defaultWaitTime}

    Navigate to App Dashboard

TC-16:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=89661
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ...    above 120F/48C from Equipment

    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
#    should be equal as integers    ${temp_app}    119
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

#################################    Usage Report test cases.    ############################################################

TC-24:User should be able to view the Energy Usage data for the Week
    [Documentation]    User should be able to view the Energy Usage data for the Week
    [Tags]    testrailid=89666
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Weekly
    click element    Weekly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}
    Navigate Back to the Sub Screen

TC-25:User should be able to view the Energy Usage data for the Month
    [Documentation]    User should be able to view the Energy Usage data for the Month
    [Tags]    testrailid=89667
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Monthly
    click element    Monthly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Month, Current Month    ${defaultWaitTime}
    Navigate Back to the Sub Screen

TC-26:User should be able to view the Energy Usage data for the Year
    [Documentation]    User should be able to view the Energy Usage data for the Year
    [Tags]    testrailid=89668
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    5s
    wait until page contains    Yearly
    click element    Yearly
    Sleep    5s
    wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}
    Navigate Back to the Sub Screen

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=89669
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    wait until page contains    Daily
    click element    Daily
    wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}

    [Teardown]    Open Application without uninstall and Navigate to dashboard    ${locationNameIkonic}

#########################################    CHANGE MODE TEST CASES    ############################################################

TC-20:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Tags]    testrailid=89662

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

#######################    Set Niagara Disable Mode From Mobile Application    #######################

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${DisableMode}
    Navigate to App Dashboard
########################    Validating Mode on End Device    ########################

    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    convert to integer    ${mode_ED}
    should be equal as strings    ${Niagara_modes}[${mode_ED}]    Disabled

    Element value should be    ${tempDashBoard}    Disabled

TC-21:User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Documentation]    User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Tags]    testrailid=89663

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

#######################    Set Niagara Enable Mode From Mobile Application    #######################

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Enable-Disable Niagara Heater    ${EnableMode}
    Navigate to App Dashboard

########################    Validating Mode on End Device    ########################

    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    convert to integer    ${mode_ED}
    should be equal as strings    ${Niagara_modes}[${mode_ED}]    Enabled

    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    Enabled    ${modeValueDashboard}

TC-22:User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Documentation]    User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Tags]    testrailid=89664

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

##########################    Set Disabled Mode From Equipment    #########################

    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    # Sleep    5s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

#########################    Validate Mode From Mobile Application    ###########################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to App Dashboard
    should be equal as strings    ${Niagara_modes}[${mode_set_ED}]    Disabled

    element value should be    ${tempDashBoard}    Disabled

TC-23:User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Documentation]    User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Tags]    testrailid=89665

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

##########################    Set Disabled Mode From Equipment    #########################

    ${changeModeValue}    Set Variable    1
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_set_ED}

    # Sleep    5s
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${mode_get_ED}

    should be equal as integers    ${mode_set_ED}    ${mode_get_ED}

    # Sleep    5s

#########################    Validate Mode From Mobile Application    ###########################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to App Dashboard
    should be equal as strings    ${Niagara_modes}[${mode_set_ED}]    Enabled

    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    should be equal    Enabled${SPACE}    ${modeValueDashboard}

#########################################    Running Status    ################################

TC-36:User should be able to disable running status of device from EndDevice
    [Documentation]    User should be able to disable running status of device from EndDevice.
    [Tags]    testrailid=89678
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

######################################    Verfiy Running Status of Equipment    ##########################

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HTRS_ON
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    10s
    page should not contain text    Running

    Navigate Back to the Screen

TC-37:User should be able to enable running status of device from EndDevice
    [Documentation]    User should be able to enable running status of device from EndDevice.
    [Tags]    testrailid=89679

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

######################################    Verfiy Running Status of Equipment    ##########################

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    3
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    HTRS_ON
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    10s
    page should contain text    Running
    Navigate Back to the Screen

##############################################    Celcius Unit    ##################################

TC-13:Max temperature that can be set from Equipment should be 60C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C. :EndDEevice->Mobile
    [Tags]    testrailid=89652

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # sleep    10s

    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # sleep    20s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    Navigate Back to the Screen
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}

    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-14:Min temperature that can be set from Equipment should be 29C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C. :EndDEevice->Mobile
    [Tags]    testrailid=89653

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
###############################    Set minimum temp 29C from Equipment    #####################################

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # sleep    10s

    ${setpoint_ED}    Write objvalue From Device
    ...    85
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # sleep    10s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

################################    Verify temperature on Mobile Application    #####################################

    Navigate Back to the Screen
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}

    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-15:Max temperature that can be set from App should be 60C.
    [Documentation]    Max temperature that can be set from App should be 60C. :Mobile->EndDevice
    [Tags]    testrailid=89654

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
##############################    Set maximum temperature 60C from the Mobile Application    #################################

    ${setpoint_ED}    Write objvalue From Device
    ...    181
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

####################    Validating Temperature Value On End Device    ####################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 29C.
    [Documentation]    Min temperature that can be set from App should be 29C. :Mobile->EndDevice
    [Tags]    testrailid=89655

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
##############################    Set minimum temperature 43c from the Mobile Application    #################################

    ${setpoint_ED}    Write objvalue From Device
    ...    31
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    29    ${imgBubble}
    ${setpoint_M_DP}    Get current temperature from mobile app
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

####################    Validating Temperature Value On End Device    ####################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-17:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App :Mobile->EndDevice
    [Tags]    testrailid=89656

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
#######################    Set Setpoint above Maximum Setpoint limit 60C From Mobile App and Validating it On Mobile App itself    ######################

    ${setpoint_ED}    Write objvalue From Device
    ...    83
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    60    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    # Sleep    5s
    ${setpoint_M_DP}    Get current temperature from mobile app
    should be equal as integers    ${setpoint_M_DP}    60

    Navigate Back to the Screen

    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    # Sleep    5s

####################    Validating Temperature Value On End Device    ####################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 30C from App :Mobile->EndDevice
    [Tags]    testrailid=89657

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${tempDashBoard}
#######################    Set Setpoint below Minimum Setpoint limit 29C From Mobile App and Validating it On Mobile App itself    ######################

    ${setpoint_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature    29    ${imgBubble}
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    ${setpoint_M_DP}    Get current temperature from mobile app
    should be equal as integers    ${setpoint_M_DP}    29

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

####################    Validating Temperature Value On End Device    ####################

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}
    should be equal as integers    ${result2}    ${setpoint_M_DP}
    should be equal as integers    ${result2}    ${setpoint_M_EC}

    Temperature Unit in Fahrenheit

TC-38:Max temperature that can be set from App should be 140F
    [Documentation]    User should be able to set max temperature 140F using button slider
    [Tags]    testrailid=89680

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    139    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    139

    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    139

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    should be equal as integers    ${tempMobile}    140

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    140

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    should be equal as integers    ${setpoint_ED}    140

TC-39:Min temperature that can be set from App should be 85F
    [Documentation]    User should be able to set min temperature 110F using button slider
    [Tags]    testrailid=89681

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    86    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    86

    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    86

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    should be equal as integers    ${tempMobile}    85

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    85

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    should be equal as integers    ${setpoint_ED}    85

TC-40:User should not be able to exceed max setpoint limit i.e. 140F from App
    [Documentation]    User should not be able to exceed max temperature 140F using button slider
    [Tags]    testrailid=89682

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    140    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    140
    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    140

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    should be equal as integers    ${tempMobile}    140

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    140

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    140

TC-41:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    User should not be able to exceed min temperature 110F using button slider
    [Tags]    testrailid=89683

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    85    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    85

    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    85

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    should be equal as integers    ${tempMobile}    85

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    85

    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}
    ...    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    should be equal as integers    ${setpoint_ED}    85

TC-42:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App using button:Mobile->EndDevice
    [Tags]    testrailid=89684

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set maximum temp 60C from Equipment

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
    should be equal as integers    ${Temperature_Mobile}    60

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    60

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    60

TC-43:User should not be able to exceed min setpoint limit i.e. 29C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button:Mobile->EndDevice
    [Tags]    testrailid=89685

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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

    should be equal as integers    ${result2}    29

    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    29

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    29

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    29

TC-44:User should not be able to exceed max setpoint limit i.e. 60C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 60C from App using button:Mobile->EndDevice
    [Tags]    testrailid=89686

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set maximum temp 60C from Equipment

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
    should be equal as integers    ${Temperature_Mobile}    60

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointIncreaseButton}
    should be equal as integers    ${tempMobile}    60

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    60

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    60

TC-45:User should not be able to exceed min setpoint limit i.e. 29C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 43C from App using button:Mobile->EndDevice
    [Tags]    testrailid=89687

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${tempDashBoard}
    #    Set maximum temp 60C from Equipment

    ${changeUnitValue}    Set Variable    1

    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

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

    should be equal as integers    ${result2}    29

    ${Temperature_Mobile}    Get current temperature from mobile app
    should be equal as integers    ${Temperature_Mobile}    29

    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    should be equal as integers    ${tempMobile}    29

    Navigate Back to the Screen
    ${setpoint_mobile}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${setpoint_mobile}    29

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    convert to integer    ${result1}

    should be equal as integers    ${result2}    29

################################    Away mode test cases.    ############################################################

TC-28:User should be able to set Away mode from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89670
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    click element    homeAwayButtonIdentifier

    ${Status}    run keyword and return status    wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    Niagara

    # Validating temperature value on End Device

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${A}    set variable    1
    ${A}    convert to integer    ${A}
    should be equal as integers    ${Away_status_ED}    ${A}

TC-29:User should be able to Disable Away from App for : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89671
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    click element    homeAwayButtonIdentifier
    # Validating temperature value on End Device
    ${A}    set variable    0
    ${A}    convert to integer    ${A}

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${Away_status_ED}    ${A}

Schedule the temperature from App
    [Documentation]    Schedule the temperature and mode from App
    [Tags]    testrailid=89672    [tags]    tc_id_38
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    ${time024}    convert to integer    ${time024}

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
    Scroll Up    ${heatBubble}
    Sleep    2s
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click Element    Save
    wait until page contains element    //XCUIElementTypeButton[@name="btnSave"]    ${defaultWaitTime}
    Click Element    //XCUIElementTypeButton[@name="btnSave"]
    Navigate Back to the Sub Screen
    sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}

    should be equal    ${scheduled_temp}    ${tempDashboard}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to App Dashboard

Copy the Scheduled Day slot, temperature from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=89673
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    Copy Schedule Data without mode    ${locationNameIkonic}
    ${abc}    run keyword and return status    click element    modalBackButtonIdentifier
    Navigate to App Dashboard

Change the Scheduled temperature from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=89674
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temp}    Increment temperature value
    wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Verify Schedule Overridden Message    ${scheduleoverriddentext}

    Navigate to App Dashboard

    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
    should be equal as integers    ${temp}    ${dashBoardTemperature}

User should be able to Resume Schedule
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=89675
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    Click Element    ${status}
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}

    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen

    wait until page contains element    ${btnResume}    ${defaultWaitTime}
    click element    ${btnResume}
    Sleep    5s
    page should contain element    ${followScheduleMsgDashboard}

    wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${tempValSchedule}    get text    ${currentTemp}

    should be equal as integers    ${tempValSchedule}    ${scheduled_temp}

    Navigate to App Dashboard

Re-Schedule the temperature from App
    [Documentation]    Re-Schedule the temperature from App
    [Tags]    testrailid=89676
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    2m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    ${time024}    convert to integer    ${time024}

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
    Scroll Up    ${heatBubble}
    Sleep    2s
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click Element    Save
    wait until page contains element    //XCUIElementTypeButton[@name="btnSave"]    ${defaultWaitTime}
    Click Element    //XCUIElementTypeButton[@name="btnSave"]
    ${abc}    run keyword and return status    click element    modalBackButtonIdentifier
    sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}

    should be equal    ${scheduled_temp}    ${tempDashboard}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Navigate to App Dashboard

Unfollow the scheduled temperature from App
    [Documentation]    Unfollow the scheduled temperature from App
    [Tags]    testrailid=89677

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameIkonic}
    Navigate to App Dashboard

TC-49:User should be able to Enable Water Save from the product Settings screen.
    [Documentation]    User should be able to Enable/Disable Water Save from the product Settings screen.
    [Tags]    testrailid=89688
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Enable/Diasbale Water Save From product settings ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen
    Enable/Disable Water Save From Product Settings    On
    Sleep    2s
    ${WaterSaver_status_ED}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${WaterSaver_status_ED}    0

    Navigate Back to the Screen

TC-49:User should be able to Disable Water Save from the product Settings screen.
    [Documentation]    User should be able to Enable/Disable Water Save from the product Settings screen.
    [Tags]    testrailid=123
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Enable/Diasbale Water Save From product settings ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen
    Enable/Disable Water Save From Product Settings    Off
    Sleep    2s
    ${WaterSaver_status_ED}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${WaterSaver_status_ED}    1

    Navigate Back to the Screen

Verify that if User Update Water Saving mode to OFF from End Device than its should be reflected on App
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen

    ${Status}    Get Text    ${slotSwitcherIdentifier}
    Should be Equal    Disabled    ${Status}

    Navigate Back to the Sub Screen

Verify that if User Update Water Saving mode to ON from End Device than its should be reflected on App
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${TempUnit_ED}    Write objvalue From Device
    ...    1
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen

    ${Status}    Get Text    ${slotSwitcherIdentifier}
    Should be Equal    Enabled    ${Status}

    Navigate Back to the Sub Screen

TC-50:User should be able to change Sea Level Altitude from the product Setting screen.
    [Documentation]    User should be able to change Sea Level Altitude from the product Setting screen.
    [Tags]    testrailid=89689
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Med. Altitude From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    wait until page contains element    Altitude    ${defaultWaitTime}
    Click Element    Altitude
    Sleep    1s
    Select element using coordinate    SeaLevel
    Sleep    4s

    wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

############################ Verfiy Altitude Level Value on EndDevice ###########################

    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Med.Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-51:User should be able to change Low Altitude from the product Setting screen.
    [Documentation]    User should be able to change Low Altitude from the product Setting screen.
    [Tags]    testrailid=89690
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Low Altitude From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen
    Set Altitude From Product Settings Screen    LowAltitude

############################ Verfiy Altitude Level Value on EndDevice ###########################

    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Low Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-52:User should be able to change Med. Altitude from the product Setting screen.
    [Documentation]    User should be able to change Med. Altitude from the product Setting screen.
    [Tags]    testrailid=89691
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Med. Altitude From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Altitude From Product Settings Screen    Med.Altitude

############################ Verfiy Altitude Level Value on EndDevice ###########################

    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    Med.Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-53:User should be able to change High Altitude from the product Setting screen.
    [Documentation]    User should be able to change Low Altitude from the product Setting screen.
    [Tags]    testrailid=89692
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set High Altitude From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Altitude From Product Settings Screen    High Altitude

############################ Verfiy Altitude Level Value on EndDevice ###########################

    ${AltitudeLevel}    Read int return type objvalue From Device
    ...    ALTITUDE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    High Altitude    ${AltitudeLevels}[${AltitudeLevel}]

TC-54:User should be able to set Recirc Pump mode as None form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as None form the product Setting acreen.
    [Tags]    testrailid=89693
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set None Mode From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations From the Product Settings Screen    None

############################ Verfiy Mode Value on EndDevice ###########################

    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${RecircMode}

    should be equal as strings    ${RecircPumpModes}[${RecircMode}]    None

TC-55:User should be able to set Recirc Pump mode as Timer-Perf. form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as Timer-Perf. form the product Setting acreen.
    [Tags]    testrailid=89694
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Timer-Perf. Mode From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations From the Product Settings Screen    Timer-Perf.

############################ Verfiy Mode Value on EndDevice ###########################

    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${RecircMode}

    should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Timer-Perf.

TC-56:User should be able to set Recirc Pump mode as Timer-E-Save form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as Timer-E-Save form the product Setting acreen.
    [Tags]    testrailid=89695
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Timer-E-Save Mode From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations From the Product Settings Screen    Timer-E-Save

############################ Verfiy Mode Value on EndDevice ###########################

    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${RecircMode}

    should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Timer-E-Save

TC-57:User should be able to set Recirc Pump mode as On-Demand form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode as On-Demand form the product Setting acreen.
    [Tags]    testrailid=89696
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set On-Demand Mode From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations From the Product Settings Screen    On-Demand

############################ Verfiy Mode Value on EndDevice ###########################

    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${RecircMode}

    should be equal as strings    ${RecircPumpModes}[${RecircMode}]    On-Demand

TC-58:User should be able to set Recirc Pump mode as Schedule form the product Setting acreen.
    [Documentation]    User should be able to set Recirc Pump mode asSchedule form the product Setting acreen.
    [Tags]    testrailid=89697
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

############################# Set Schedule Mode From the App ############################

    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    Navigate to the Product Settings Screen
    Set Recirc Pump Operations From the Product Settings Screen    Schedule

############################ Verfiy Mode Value on EndDevice ###########################

    ${RecircMode}    Read int return type objvalue From Device
    ...    RPUMPMOD
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    convert to integer    ${RecircMode}

    should be equal as strings    ${RecircPumpModes}[${RecircMode}]    Schedule

TC-59:Verify that if User Update Water Saving mode to OFF from End Device than its should be reflected on App
    [Tags]    testrailid=222100
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${TempUnit_ED}    Write objvalue From Device
    ...    0
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    5s
    ${WaterSaverLevel}    Read int return type objvalue From Device
    ...    ${watersave}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    wait until page contains element    ${slotSwitcherIdentifier}    ${defaultWaitTime}
    ${Status}    Get Text    ${slotSwitcherIdentifier}
    Should be Equal    Off    ${Status}

    Navigate Back to the Sub Screen

TC-60:Verify that if User Update Water Saving mode to ON from End Device than its should be reflected on App
    [Tags]    testrailid=222101
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    1
    sleep    5s
    Navigate to the Product Settings Screen
    wait until page contains element    ${slotSwitcherIdentifier}    ${defaultWaitTime}
    ${Status}    Get Text    ${slotSwitcherIdentifier}
    Should be Equal    On    ${Status}

    Navigate Back to the Sub Screen

TC-61:Verify that Changed RPUMPMOD = 0 From End Device and its value None/Disabled should reflect on End Device
    [Tags]    testrailid=222102
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    0
    Navigate to the Product Settings Screen
    Sleep    2s
    Page should contain text    None
    Navigate Back to the Sub Screen
    Click Element    Schedule
    Click Element    ${schedule_firstrow_time}
    Page Should Not Contain Element    ${scheduleToggle}
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-62:Verify that Changed RPUMPMOD = 1 From Portal and its value should reflect on End Device
    [Tags]    testrailid=222103
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    1
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-Perf.

    Navigate Back to the Sub Screen
    Click Element    Schedule
    Click Element    ${schedule_firstrow_time}
    Page Should Not Contain Element    Recirc Pump Function
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-63:Verify that Changed RPUMPMOD = 2 From Portal and its value should reflect on End Device
    [Tags]    testrailid=222104
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    2
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Timer-E-Save
    Navigate Back to the Sub Screen
    Click Element    Schedule
    Click Element    ${schedule_firstrow_time}
    Page Should Not Contain Element    Recirc Pump Function
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-64:Verify that Changed RPUMPMOD = 3 From Portal and its value should reflect on End Device
    [Tags]    testrailid=222105
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    3
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    On-Demand

    Navigate Back to the Sub Screen
    Click Element    Schedule
    Click Element    ${schedule_firstrow_time}
    Page Should Not Contain Element    Recirc Pump Function
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-65:Verify that Changed RPUMPMOD = 4 From Portal and its value should reflect on End Device
    [Tags]    testrailid=222106
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

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
    should be equal as integers    ${WaterSaverLevel}    4
    Navigate to the Product Settings Screen
    Sleep    5s
    Page should contain text    Schedule

    Navigate Back to the Sub Screen
    Click Element    Schedule
    Click Element    ${schedule_firstrow_time}
    Page Should Contain Element    Recirc Pump Function
    Navigate Back to the Screen

TC-66:Verify UI of Network Settings screen
    [Tags]    testrailid=222051
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait Until Page Contains Element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Settings
    IF    ${Status}    Click Element    Settings

    ${Status1}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status1}    Click Element    Network

    wait until page contains element    MAC Address
    wait until page contains element    WiFi Software Version
    wait until page contains element    Network SSID
    wait until page contains element    IP Address
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-67:Verfiy that the user can set the minimum temperature of the time slot set point value for schedule.
    [Tags]    testrailid=222052
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameDragon}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}
    # we will develope keywords for the scroll soon    used button
    Navigate to App Dashboard

TC-68:Verfiy that the user can set the maximum temperature of the time slot set point value for scheduling.
    [Tags]    testrailid=222053
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameDragon}
    END

    # we will develope keywords for the scroll soon    used button
    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    //XCUIElementTypeButton[@name="increaseButton"][1]

    Navigate to App Dashboard

TC-69:Verfiy that the user can set the minimum temperature of the time slot set point value using button.
    [Tags]    testrailid=222054
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameDragon}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    110    ${DecreaseButton}

    Navigate to App Dashboard

TC-70:Verfiy that the user can set the maximum temperature of the time slot set point value using button.
    [Tags]    testrailid=222055
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameDragon}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Point in Schedule Screen    140    //XCUIElementTypeButton[@name="increaseButton"][1]

    Navigate to App Dashboard

TC-71:Verfiy device specific alert on equipment card
    [Tags]    testrailid=222056
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts    Gas Water Heater
    END

TC-72:Verfiy device specific alert on detail screen
    [Tags]    testrailid=222057
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameIkonic}
    END

    Go to Temp Detail Screen    ${tempDashBoard}
    Click Element    validateBell
    Sleep    5s
    ${Status}    Run Keyword and Return Status    Wait until page contains element    ${devicenotifications}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts    Gas Water Heater
    END
