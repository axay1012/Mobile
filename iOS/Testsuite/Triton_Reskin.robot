*** Settings ***
Documentation       Rheem iOS Triton Water Heater Test Suite

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
...                     AND    Select the Device Location    Triton
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameTriton}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47

${EndDevice_id}                         %{Triton_DeviceID}
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Triton

${emailId}                              %{Triton_Email}
${passwordValue}                        %{Triton_Password}

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating set point from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89374

    # Step-1) Validating value of temperature on Rheem Mobile app
    # Step-2) Validating value of temperature on Rheem Water Heater Pump
    # Step-3) Validating value of temperature on Dashboard

    Write objvalue from device
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

TC-02:Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating set point from Equipment should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89375

    # Step-1) Changing temperature of Rheem water heater(from Rheem Device Devkit)
    # Step-2) Validating Value of temperature on Rheem Mobile Application.
    # Step-3) Step-3) Validating value of temperature on Dashboard

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

TC-03:User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to increment Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89376

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Water Heater.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Increment temperature value
    Navigate to App Dashboard
    # Validating temperature value on End Device
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
    [Tags]    testrailid=89377

    # Step-1) Increse temperature of Water heater(from Rheem Device Devkit)
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
    Sleep    5s
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

TC-05:User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to decrement Set Point temperature from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89378

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Triton Water Heater.
    # Step-3) Validating value of temperature on Dashboard

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_Mobile}    Decrement temperature value
    Navigate to App Dashboard
    Sleep    2s
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
    [Tags]    testrailid=89379

    # Step-1) Validating Value of temperature on Rheem Mobile Application.
    # Step-2) Validating value of temperature on Dashboard

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

TC-07:Max temperature that can be set from App should be 185F. : Mobile->Cloud->EndDevice
    [Documentation]    Max temperature that can be set from App should be 185F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89380

    # Step-1) Changing temperature from Rheem Mobile Application and Validating the temperature on mobile itself.
    # Step-2) Validating value of temperature on Triton Water Heater.
    # Step-3) Validating value of temperature on Dashboard

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

TC-08:Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Documentation]    Min temperature that can be set from App should be 85F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89381

    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    # Set Maximum setpoint temperature from mobile and validating it on mobile itself

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

TC-09:Max temperature that can be set from Equipment should be 185F. : EndDevice->Cloud->Mobile
    [Documentation]    Max temperature that can be set from Equipment should be 185F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89382

    ${Temperature_ED}    Write objvalue From Device
    ...    180
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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

TC-10:Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Documentation]    Min temperature that can be set from Equipment should be 85F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=89383

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

TC-11:User should not be able to exceed max setpoint limit i.e. 185F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 185F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89384

    ${Temperature_ED}    Write objvalue From Device
    ...    180
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

TC-12:User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 85F from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89385

    ${Temperature_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
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

TC-19:A Caution message should not appear if user sets temperature below 120F/48C from App
    [Documentation]    A Caution message should not appear if user sets temperature below 120F/48C from App
    [Tags]    testrailid=89392

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    120    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Sleep    6s
    ${tempMobile}    Update Setpoint Value Using Button    ${setpointDecreaseButton}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp_app}    Get current temperature from mobile app
    Page Should Not Contain Text    ${cautionhotwater}
    Navigate to App Dashboard

TC-20:A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Documentation]    A Caution message should appear, if user attempts to update temperature above 120F/48C from App
    [Tags]    testrailid=89393

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
    [Tags]    testrailid=89394

    ${Temperature_ED}    Write objvalue From Device    121    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Should be equal as integers    ${temp_app}    121
    Sleep    10s
    Wait until page contains element    ${cautionhotwater}    ${defaultWaitTime}
    Wait until page contains element    ${contactskinburn}    ${defaultWaitTime}
    Navigate to App Dashboard

TC-22:A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Documentation]    A Caution message should not appear if user set temperature below 120F/48C from Equipment
    [Tags]    testrailid=89395

    ${Temperature_ED}    Write objvalue From Device    119    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    ${temp_app}    Get current temperature from mobile app
    Page Should Not Contain Text    ${expectedCautionMessage}
    Navigate to App Dashboard

TC-23:Disabling Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Documentation]    Disabling    Equipment from App detail page should be reflected on dashboard, Cloud and Equipment. : Mobile->EndDevice
    [Tags]    testrailid=89396

    Go to Temp Detail Screen    ${tempDashBoard}
    ${DisableModeTriton}    catenate    ${DisableMode}
    ${Mode_mobile}    Change the mode Triton    ${DisableModeTriton}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${Triton_modes}[${mode_ED}]    Disabled
    ${disableText}    get text    ${tempDashBoard}
    ${disableStrippend}    strip string    ${SPACE}${disableText}${SPACE}
    should be equal    ${DisableMode}    ${disableStrippend}

TC-24:User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Documentation]    User should be able to Enable Equipment from App. : Mobile->EndDevice
    [Tags]    testrailid=89397

    Go to Temp Detail Screen    ${tempDashBoard}
    ${EnableModeTriton}    catenate    ${EnableMode}
    ${Mode_mobile}    Change the mode Triton    ${EnableModeTriton}
    Navigate to App Dashboard
    ${mode_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${Triton_modes}[${mode_ED}]    Enabled
    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    ${modeValueDashboard}    strip string    ${modeValueDashboard}
    should be equal    Enabled    ${modeValueDashboard}

TC-25:User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Documentation]    User should be able to Disable Equipment from End Device.. : EndDevice->Mobile
    [Tags]    testrailid=89398

    Go to Temp Detail Screen    ${tempDashBoard}
    ${changeModeValue}    Set Variable    0
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${mode_set_ED}    Convert to integer    ${mode_set_ED}
    ${mode_get_ED}    Read int return type objvalue From Device
    ...    ${whtrcnfg}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${mode_set_ED}    ${mode_get_ED}
    Navigate to App Dashboard
    should be equal as strings    ${Triton_modes}[${mode_set_ED}]    Disabled
    ${modeValueDashboard}    Get dashboard value from equipment card    ${tempDashBoard}
    should be equal    Disabled    ${modeValueDashboard.strip()}

TC-26:User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Documentation]    User should be able to Enable Equipment from End Device... : EndDevice->Mobile
    [Tags]    testrailid=89399

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
    should be equal as strings    ${Triton_modes}[${mode_set_ED}]    Enabled
    ${modeValueDashboard}    get dashboard value from equipment card    waterheaterCardStateValueIdentifier
    should be equal    Enabled    ${modeValueDashboard.strip()}

TC-27:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Documentation]    User should be able to view the Energy Usage data for the Day of Heatpump Water Heater
    [Tags]    testrailid=89400

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    Wait until page contains    Daily
    click element    Daily
    Wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}

TC-28:User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Weekly Day from the energy usage data
    [Tags]    testrailid=89401

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameTriton}
    END
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    Wait until page contains    Weekly
    click element    Weekly
    Sleep    5s
    Wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}

TC-29:User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Monthly Day from the energy usage data
    [Tags]    testrailid=89402

    Wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    2s
    Wait until page contains    Monthly
    click element    Monthly
    Sleep    5s
    Wait until page contains    ${historicDataChartMonth}    ${defaultWaitTime}

TC-30:User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Documentation]    User should be able to view the current and historical data of the Yearly Day from the energy usage data
    [Tags]    testrailid=89403

    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameTriton}
    END

    Wait until page contains    Usage    ${defaultWaitTime}
    click element    Usage
    Sleep    5s
    Wait until page contains    Yearly
    click element    Yearly
    Sleep    5s
    Wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}

TC-33:Schedule the Occupied mode from App .. 0 - button should be off to change the status of mode
    [Documentation]    Schedule the Occupied mode from App .. 0 - button should be off to change the status of mode
    [Tags]    testrailid=89406

    Go to Temp Detail Screen    ${tempDashBoard}
    Set Schedule Triton    Disabled    ${locationNameTriton}

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
    Copy Schedule Data triton    ${locationNameTriton}
    Navigate Back to the Sub Screen
    Navigate to App Dashboard

TC-34:Schedule the UnOccupied mode from App
    [Documentation]    Schedule the UnOccupied mode from App
    [Tags]    testrailid=89407

    Go to Temp Detail Screen    ${tempDashBoard}
    ${modeVal}    Set Schedule Triton    Enabled    ${locationNameTriton}
    Sleep    10s
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

TC-13:Max temperature that can be set from Equipment should be 85C.
    [Documentation]    Max temperature that can be set from Equipment should be 60C. :EndDEevice->Mobile
    [Tags]    testrailid=89386

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

TC-14:Min temperature that can be set from Equipment should be 29C.
    [Documentation]    Min temperature that can be set from Equipment should be 29C. :EndDEevice->Mobile
    [Tags]    testrailid=89387

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

TC-15:Max temperature that can be set from App should be 85C.
    [Documentation]    Max temperature that can be set from App should be 85C.    :Mobile->EndDevice
    [Tags]    testrailid=89388

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    83
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
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-16:Min temperature that can be set from App should be 29C.
    [Documentation]    Min temperature that can be set from App should be 29C.    :Mobile->EndDevice
    [Tags]    testrailid=89389

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    87
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    29    ${imgBubble}
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

TC-17:User should not be able to exceed max setpoint limit i.e. 85C from App.
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App    :Mobile->EndDevice
    [Tags]    testrailid=89390

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${tempDashBoard}
    ${setpoint_ED}    Write objvalue From Device
    ...    138
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature    85    ${imgBubble}
    ${setpoint_M_DP}    Increment temperature value
    Sleep    5s
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    85
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

TC-18:User should not be able to exceed min setpoint limit i.e. 29C from App.
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App    :Mobile->EndDevice
    [Tags]    testrailid=89391

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    86
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${tempDashBoard}
    Scroll to the min temperature    29    ${imgBubble}
    Sleep    5s
    ${Temperature_Mobile}    Get current temperature from mobile app
    ${temp_app}    Decrement temperature value
    Sleep    5s
    ${setpoint_M_DP}    Get current temperature from mobile app
    Should be equal as integers    ${setpoint_M_DP}    29
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

TC-44:User should not be able to exceed max setpoint limit i.e. 85C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 85C from App.    :Mobile->EndDevice
    [Tags]    testrailid=89417

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
    ${result2}    Convert to integer    ${result1}
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
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    85

TC-45:User should not be able to exceed min setpoint limit i.e. 29C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 29C from App.    :Mobile->EndDevice
    [Tags]    testrailid=89418

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
    ${result2}    Convert to integer    ${result1}
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
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    29

TC-40:Max temperature that can be set from App should be 185F
    [Documentation]    Max temperature that can be set from App should be 185F.    :Mobile->EndDevice
    [Tags]    testrailid=89413

    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature_ED}    Write objvalue From Device    184    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device    ${whtrsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${setpoint_ED}    184
    Sleep    5s
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

TC-41:Min temperature that can be set from App should be 85F
    [Documentation]    Max temperature that can be set from App should be 85F.    :Mobile->EndDevice
    [Tags]    testrailid=89414

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

TC-42:User should not be able to exceed max setpoint limit i.e. 185F from App
    [Documentation]    Max temperature that can be set from App should be 185F.    :Mobile->EndDevice
    [Tags]    testrailid=89415

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

TC-43:User should not be able to exceed min setpoint limit i.e. 85F from App
    [Documentation]    Max temperature that can be set from App should be 85F.    :Mobile->EndDevice
    [Tags]    testrailid=89416

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

Verify UI of Network Settings screen
    [Tags]    testrailid=222065

    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains element    Settings
    Click Element    Settings
    Wait until page contains element    	Network
    ${location}    get element location       Network
    Click element at coordinates      ${location}[x]     ${location}[y]
    Sleep    1s
    Wait until page contains element    MAC Address
    Wait until page contains element    WiFi Software Version
    Wait until page contains element    Network SSID
    Wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

#Water Usage Graph - water Usage
#    [Tags]    testrailid=222065
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    Usage    ${defaultWaitTime}
#    click element    Usage
#    Sleep    2s
#    Click Element
#    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]
#    Wait until page contains    Water    ${defaultWaitTime}
#    Click ELement    Water
#    Wait until page contains    Daily      ${defaultWaitTime}
#    Wait until page contains    Monthly    ${defaultWaitTime}
#    Wait until page contains    Weekly     ${defaultWaitTime}
#    Wait until page contains    Yearly     ${defaultWaitTime}
#    Navigate Back to the Sub Screen
#    Navigate Back to the Sub Screen
#
#Water Usage report should be shown for mentioned time periods - water Usage
#    [Tags]    testrailid=
#    Go to Temp Detail Screen    ${tempDashBoard}
#    Wait until page contains    Usage    ${defaultWaitTime}
#    Click element    Usage
#    Sleep    2s
#    Wait until page contains    Daily
#    Click element    Daily
#    Wait until page contains    . 2 datasets. Previous Day, Current Day    ${defaultWaitTime}
#    Wait until page contains element    usageText    ${defaultWaitTime}
#    ${text}    get text    usageText
#    Check    ${text}    Gal of water
#    Navigate Back to the Sub Screen
#    Navigate Back to the Sub Screen
#
#Water Usage report should be shown for mentioned time periods - water Usage
#    [Tags]    testrailid=
#    Sleep    2s
#    Wait until page contains    Weekly
#    Click element    Weekly
#    Wait until page contains    . 2 datasets. Previous Week, Current Week    ${defaultWaitTime}
#    Wait until page contains element    usageText    ${defaultWaitTime}
#    ${text}    Get text    usageText
#    Check    ${text}    Gal of water
#    Navigate Back to the Sub Screen
#    Navigate Back to the Sub Screen
#
#Water Usage report should be shown for mentioned time periods - water Usage
#    [Tags]    testrailid=
#
#    Sleep    2s
#    Wait until page contains    Monthly
#    Click element    Monthly
#    Wait until page contains    . 2 datasets. Previous Month, Current Month    ${defaultWaitTime}
#    Wait until page contains element    usageText    ${defaultWaitTime}
#    ${text}    get text    usageText
#    Check    ${text}    Gal of water
#    Navigate Back to the Sub Screen
#    Navigate Back to the Sub Screen
#
#Water Usage report should be shown for mentioned time periods - water Usage
#    [Tags]    testrailid=
#    Wait until page contains    Yearly
#    Click element    Yearly
#    Wait until page contains    . 2 datasets. Previous Year, Current Year    ${defaultWaitTime}
#    Wait until page contains element    usageText    ${defaultWaitTime}
#    ${text}    get text    usageText
#    Check    ${text}    Gal of water
#    Navigate Back to the Sub Screen
#    Navigate Back to the Sub Screen

Verfiy device specific alert on equipment card
    [Tags]    testrailid=222066
    Select the Device Location    ${locationNameTriton}
    ${Status}    Run Keyword and Return Status
    ...    Wait until page contains element
    ...    ${devicenotifications}
    ...    ${defaultWaitTime}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts
    END

Verfiy device specific alert on detail screen
    [Tags]    testrailid=222067
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen    ${tempDashBoard}
    Click Element    ${iconNotification}
    Sleep    5s
    ${Status}    Run Keyword and Return Status
    ...    Wait until page contains element
    ...    ${devicenotifications}
    ...    ${defaultWaitTime}
    IF    ${Status}
        Click Element    ${devicenotifications}
        Verify Device Alerts
    END

Verify that the user can able to set usage report on full-screen landscape mode.
    [Tags]    testrailid=222761
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${usageIncrease}    ${defaultWaitTime}
    click element    ${usageIncrease}
    page should not contain element    Historical data
    Sleep    5s
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that user can able to Turn ON Historical data
    [Tags]    testrailid=222762
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    click element    ${usageReport}
    Sleep    2s
    Wait until page contains    ${historicalDataSwitcher}    ${defaultWaitTime}
    ${value}    Get Text    ${historicalDataSwitcher}
    IF    '${value}'=='Off'    Click Element    ${value}
    Page should contain element    ${DailyHistory}    ${defaultWaitTime}
    Sleep    5s
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

Verify that Energy Icon will be different on Bottom Text Line "You've used 0 kWh units of energy.
    [Tags]    testrailid=222763
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until page contains    ${usageReport}    ${defaultWaitTime}
    Click element    ${usageReport}
    Sleep    2s
    Wait until page contains   ${usageText}    ${defaultWaitTime}
    ${Value}    Get Text    ${usageText}
    ${status}    Check    ${Value}    ${units of energy}
    Should be true    ${status}    True
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-31:User should be able to set Away mode from App for Triton Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App for Triton Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89404

    Wait until page contains     ${awayText}    ${defaultWaitTime}
    Click element    ${awayText}
    ${Status}    Run keyword and return status    Wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    ${locationNameTriton}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1

TC-32:User should be able to Disable Away from App for Triton Water Heater : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App for Triton Water Heater : Mobile->Cloud->EndDevice
    [Tags]    testrailid=89405

    Wait until page contains     ${awayText}    ${defaultWaitTime}
    Click element    ${awayText}
    ${temp}    Set variable    0
    ${temp}    Convert to integer    ${temp}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    ${temp}