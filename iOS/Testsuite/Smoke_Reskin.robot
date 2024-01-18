*** Settings ***
Documentation    Rheem iOS Smoke Test Suite
Library          AppiumLibrary      run_on_failure=No Operation
Library          RequestsLibrary
Library          Collections
Library          String
Library          OperatingSystem
Library          DateTime
Library          ../../src/RheemMqtt.py
Library          ../../src/RheemCustom.py

Resource         ../Locators/iOSConfig.robot
Resource         ../Locators/iOSLocators.robot
Resource         ../Locators/iOSLabels.robot
Resource         ../Keywords/iOSMobileKeywords.robot
Resource         ../Keywords/MQttKeywords.robot


Suite Setup      Wait Until Keyword Succeeds    2x    2m    Run Keywords    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...      AND     Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}     ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
...      AND     Open App
...      AND     Sign in to the application    ${emailId}    ${passwordValue}
...      AND     Select the Device Location    HPWHGen5



Suite Teardown    Run Keywords    Capture Screenshot    AND    Close All Apps
Test Teardown     Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***

${Device_Mac_Address}               40490F9E4947
${Device_Mac_Address_In_Formate}    40-49-0F-9E-49-47

${EndDevice_id}                     4737

#  -->cloud url and env
${URL}                              https://rheemdev.clearblade.com
${URL_Cloud}                        https://rheemdev.clearblade.com/api/v/1/

#  --> test env
${SYSKEY}                           f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                           F280E3C80B8CA1FB8FE292DDE458

#  --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}                D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}                       econetWiFiTranslator
${Device_TYPE}                                      heatpumpWaterHeaterGen4


${emailId}				            automationtest2@rheem.com
${passwordValue}			        12345678

${LocationemailId}				            akshay.suthar@volansys.com
${LocationpasswordValue}			        rheem123


${maxTempVal}                       140

${value1}     32
${value2}     5
${value3}     9

*** Test Cases ***


TC-04:Validate the dashboard screen UI Components
    [Tags]      testrailid=237223

    Wait until page contains element    ${tempDashBoard}
    Wait until page contains element    ${homeaway}
    Wait until page contains element    ${rightarrow}
    Wait until page contains element    ${DashboardLocationIcon}


TC-06:Verify Menu UI of reskin application
    [Tags]      testrailid=237224
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    wait until page contains    General     ${defaultWaitTime}
    wait until page contains    Notifications     ${defaultWaitTime}
    wait until page contains    Profile     ${defaultWaitTime}
    wait until page contains    Sign Out     ${defaultWaitTime}
    wait until page contains    Zone Settings     ${defaultWaitTime}
    wait until page contains    Away Settings     ${defaultWaitTime}
    wait until page contains    Scheduled Away/Vacation     ${defaultWaitTime}
    wait until page contains    Ask Alexa     ${defaultWaitTime}

TC-07:Verify the user should be able to navigate to the Change name screen.
    [Tags]      testrailid=237225

    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    wait until page contains    Profile     ${defaultWaitTime}
    Click element   Profile
    wait until page contains    Name     ${defaultWaitTime}
    wait until page contains    Phone Number     ${defaultWaitTime}
    Navigate Back to the Screen

TC-08:Verify that the user should be navigated to the notiifcation settings screen.
    [Tags]      testrailid=237226
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    wait until page contains    Notifications     ${defaultWaitTime}
    Click element    Notifications
    Sleep  5s
    wait until page contains    Product Alert Emails     ${defaultWaitTime}
    wait until page contains    Special Offer Emails     ${defaultWaitTime}
    Navigate Back to the Screen

TC-09:Verify that the user should be able to navigated to the General Settings submenu.
    [Tags]      testrailid=237227

    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    General     ${defaultWaitTime}
    Click element    General
    wait until page contains    EcoNet WiFi Connections    ${defaultWaitTime}
    Navigate Back to the Screen

TC-10:Verify that the user should be able to navigate to the Location & Products screen.
    [Tags]      testrailid=237228

    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Locations & Products     ${defaultWaitTime}
    Click element    Locations & Products
    wait until page contains    Add New Location    ${defaultWaitTime}
    Sleep    2s
    Wait until page contains element    ${BackButtonic}    ${defaultWaitTime}
    Click element    ${BackButtonic}
    Sleep    3s    # Wait for Loader get disappeasr    ${BackButton}

TC-11:Verify the the Zone name screen should be displayed.
    [Tags]      testrailid=237229
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Zone Settings     ${defaultWaitTime}
    Click element    Zone Settings
    Wait until page contains element   //XCUIElementTypeStaticText[@name="Zone Settings"]    ${defaultWaitTime}
    Navigate Back to the Screen

TC-12:Validate Away Settings sub menu while no location
    [Tags]      testrailid=237230
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Away Settings     ${defaultWaitTime}
    Click element    Away Settings
    Wait until page contains element   HPWHGen5    ${defaultWaitTime}
    Navigate Back to the Screen

TC-13:validate schedule Away / Vacation Setting sub menu
    [Tags]      testrailid=237231
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Scheduled Away/Vacation     ${defaultWaitTime}
    Click element    Scheduled Away/Vacation
    Wait until page contains element   HPWHGen5    ${defaultWaitTime}
    Navigate Back to the Screen

TC-14:Verify that the user should be navigated to the Installation & Service contact screen.
    [Tags]      testrailid=237232
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Contacts     ${defaultWaitTime}
    Click element    Contacts
    Wait until page contains element   Add Contractor    ${defaultWaitTime}
    Navigate Back to the Screen

TC-15:User should be able to set energy Saving Mode from App for HPWHGen5 : Mobile->Cloud->EndDevice
    [Tags]      testrailid=237233
    # Set heat pump Energy Saver mode from mobile application
    Go to Temp Detail Screen  ${tempDashBoard}
    ${Mode_mobile}=    Change Mode    ${energySaverHPWHG5}
    Sleep    2s
    Element value should be   waterHeaterModeButton  Energy Saver
    Navigate Back to the Screen
    ${current_mode_ED}=      Read int return type objvalue From Device       ${whtrcnfg}
                                ...     ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as strings    @{HPWH_Gen5_modes}[${current_mode_ED}]    Energy Saver
    ${modeValueDashboard}    get dashboard value from equipment card     ${modeDashBoard}
#    ${current_mode_M}   Strip string    ${current_mode_M}
    ${modeValueDashboard}   Strip String    ${modeValueDashboard}
#    should be equal    Energy Saver     ${modeValueDashboard}

TC-16:Min temperature that can be set from App should be 110F for HPWHGen4. : Mobile->Cloud->EndDevice
    [Tags]      testrailid=237234

    Go to Temp Detail Screen   ${tempDashBoard}

    ${Temperature_ED}=    Write objvalue From Device    112    ${whtrsetp}      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Sleep    2s
    Scroll to the min temperature    110    ${imgBubble}
    ${Temperature_Mobile}=    Get current temperature from mobile app
    Navigate to App Dashboard

    # Validating temperature value on End Device
    ${Temperature_ED}      Read int return type objvalue From Device       ${whtrsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
#    should be equal as integers    ${Temperature_Mobile}     ${dashBoardTemperature}


TC-17:Max temperature that can be set from App should be 140F for HPWHGen4. : Mobile->Cloud->EndDevice
    [Tags]      testrailid=237235
    Go to Temp Detail Screen   ${tempDashBoard}
    ${Temperature_ED}=    Write objvalue From Device    137    ${whtrsetp}      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}
    ${Temperature_Mobile}=    Get current temperature from mobile app
    Navigate to App Dashboard
    # Validating temperature value on End Device
    ${Temperature_ED}      Read int return type objvalue From Device       ${whtrsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
#    should be equal as integers    ${Temperature_ED}    140
    ${dashBoardTemperature}    get setpoint from equipmet card    ${tempDashBoard}
#    should be equal as integers    ${Temperature_Mobile}     ${dashBoardTemperature}

TC-18:Schedule the temperature from App for HPWHGen5
    [Documentation]     Schedule the temperature and mode from App
    [Tags]      testrailid=237236
    Go to Temp Detail Screen  ${tempDashBoard}
    ${status}    Set Schedule     Energy Saver
    ${temp1}=     Get from List   ${status}    0
    ${temp}=    Convert to integer    ${temp1}
    ${Temperature_ED}      Read int return type objvalue From Device       ${whtrsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as integers    ${Temperature_ED}    ${temp}
    Navigate to App Dashboard
    ${mode_get_ED}      Read int return type objvalue From Device       ${whtrcnfg}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer      ${mode_get_ED}
    ${mode}=    Get from list    ${status}    1
#    should be equal as strings    ${HPWH_Gen5_modes}[${mode_get_ED}]    ${mode}

TC-19:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]     Copy the Scheduled Day slot, temperature and mode from App
    [Tags]      testrailid=237237
    Go to Temp Detail Screen  ${tempDashBoard}
    Copy Schedule Data without mode     ${locationNameHPWH}
    ${abc}    run keyword and return status    Click element    modalBackButtonIdentifier
    sleep     5s
    Navigate to App Dashboard

TC-20:Change the Scheduled temperature from App for HPWHGen4
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]      testrailid=237238

    Go to Temp Detail Screen  ${tempDashBoard}
    ${Temp}    Increment temperature value
    Sleep    10s
#    Wait until page contains element    ${btnResume}   ${defaultWaitTime}
    Navigate to App Dashboard

TC-21:User should be able to Resume Schedule for HPWHGen4
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]      testrailid=237239

    Go to Temp Detail Screen  ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    sleep    10s
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    time0     ${defaultWaitTime}
    ${time0}    Get Text    time0
    Wait Until Element is Visible    time1     ${defaultWaitTime}
    ${time1}    Get Text    time1
    Wait Until Element is Visible    time2     ${defaultWaitTime}
    ${time2}    Get Text    time2
    Wait Until Element is Visible    time3     ${defaultWaitTime}
    ${time3}    Get Text    time3
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    convert to integer  ${time024}
    RUN KEYWORD IF   ${time024} <= ${currenttime024} < ${time124}     set global variable    ${status}    time0
    ...    ELSE IF   ${time124} <= ${currenttime024} < ${time224}     set global variable    ${status}    time1
    ...    ELSE IF    ${time224} <= ${currenttime024} < ${time324}    set global variable    ${status}    time2
    ...    ELSE IF    ${time324} <= ${currenttime024} < ${time024}    set global variable    ${status}    time3


    Wait Until Element Is Visible    ${status}     ${defaultWaitTime}
    Click element    ${status}
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}

    ${abc}    run keyword and return status    Click element    modalBackButtonIdentifier
    sleep     5s
    ${abc}   run keyword and return status     Click element    modalBackButtonIdentifier
    sleep     5s
    Wait until page contains element    ${btnResume}     ${defaultWaitTime}
    Click element    ${btnResume}
    Sleep    5s
    Wait until page contains element    ${followScheduleMsgDashboard}
    Wait until page contains element   ${currentTemp}    ${defaultWaitTime}
    ${tempValSchedule}    get text    ${currentTemp}

#    should be equal as integers   ${tempValSchedule}    ${scheduled_temp}

    Navigate to App Dashboard

TC-22: Unfollow the scheduled temperature and mode from App
    [Tags]      testrailid=237240
    Go to Temp Detail Screen  ${tempDashBoard}
    Wait until page contains element    ${scheduleButton}   ${defaultWaitTime}
    Click element    ${scheduleButton}
    Unfollow the schedule     ${locationNameHPWH}
    Navigate to App Dashboard

TC-23:User should be able to set Away mode from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]      testrailid=237241
    Click element    homeAwayButtonIdentifier
    ${Status}    run keyword and return status    Wait until page contains element    Ok
    Run keyword if    ${Status}==True     Enable Away Setting    HPWH

    # Validating temperature value on End Device
    ${Away_status_ED}=      Read int return type objvalue From Device       ${vaca_net}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${A}    set variable     1
    ${A}    convert to integer     ${A}
#    Should be equal as integers    ${Away_status_ED}    ${A}

TC-24:User should be able to Disable Away from App for Heat Pump Water Heater : Mobile->Cloud->EndDevice
    [Tags]      testrailid=237242
    Click element    homeAwayButtonIdentifier
    # Validating temperature value on End Device
    ${A}    set variable     0
    ${A}    convert to integer     ${A}
    ${Away_status_ED}      Read int return type objvalue From Device       ${vaca_net}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Should be equal as integers    ${Away_status_ED}    ${A}


TC-25:Verify UI of Network Settings screen
    [Tags]      testrailid=237243

    Go to Temp Detail Screen  ${tempDashBoard}
    Wait until page contains element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Settings
    Run Keyword if    ${Status}    Click element    Settings

    ${Status1}    Run Keyword and Return Status    Wait until page contains element    Network
    Run Keyword if    ${Status1}    Click element    Network

    Wait until page contains element     MAC Address
    Wait until page contains element     WiFi Software Version
    Wait until page contains element     Network SSID
    Wait until page contains element     IP Address
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen

TC-26:User should be able to view the current and historical data of the Current Day from the energy usage data
    [Tags]      testrailid=237244

    ${status}    Run keyword and return status    Go to Temp Detail Screen    ${tempDashBoard}
    Run keyword and ignore error    Go to Temp Detail Screen  ${tempDashBoard}
    Wait until page contains    Usage    ${defaultWaitTime}
    Click element    Usage
    Sleep    2s
    wait until page contains     Daily
    wait until page contains     Weekly
    wait until page contains     Monthly
    wait until page contains     Yearly
    ${status}    Run keyword and return status    Navigate Back to the Sub Screen
    ${Status}    Run keyword and return status    Navigate Back to the Screen


#TC-01:Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
#    [Documentation]    Updating Auto Mode from App detail page should be reflected on dashboard and Equipment. :Mobile->Cloud->EndDevice
#    [Tags]    testrailid=99075
#    ${deadBandVal}    set variable    0
#    ${setMode_ED}    write objvalue from device    ${deadBandVal}    ${deadband}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
#    ${current_mode_ED}    Read int return type objvalue From Device    ${statmode}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
#    Navigate to App Dashboard
#    ${modeValueDashboard}    get dashboard value from equipment card    ${modeEccDashBard}
#    should be equal    ${mode_mobile}     ${modeValueDashboard}
#
#TC-02:Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Updating Heating set point from App should be reflected on dashboard and Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99076
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
#                ...     Open Application and Navigate to Device Detail Page    ${locationNameNewECC}
#    # Set temperature from water heater
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${current_temp}    get text    ${heatBubble}
#    ${changedTemp_Mobile}     Change Temperature value     ${heatBubble}
#    ${changedTemp_Mobile}     convert to integer     ${changedTemp_Mobile}
#    Navigate to App Dashboard
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
#    should be equal as integers    ${changedTemp_Mobile}     ${dashBoardTemperature}
#
#    ${current_temp_ED}    Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal  ${changedTemp_Mobile}    ${current_temp_ED}
#
#
#
#TC-04:Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Updating Cooling set point from App should be reflected on Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99078
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Wait until page contains element     ${coolBubble}     ${defaultWaitTime}
#    ${current_temp}     get text     ${coolBubble}
#    ${changedTemp_Mobile}    Change Temperature value    ${coolBubble}
#    Navigate Back to the Screen
#
#    ${current_temp_ED}    Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
#    should be equal as integers    ${changedTemp_Mobile}     ${dashBoardTemperature}
#
#TC-07:Max Cooling setpoint that can be set from Equipment should be 92F.
#    [Documentation]    Max Cooling setpoint that can be set from Equipment should be 92F.
#    [Tags]    testrailid=99081
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
#                ...     Open Application and Navigate to Device Detail Page    ${locationNameNewECC}
#    # Set temperature from water heater
#
#    ${Temperature_ED}=    Write objvalue From Device    ${maxCoolingSetPoint}    ${coolsetp}      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    # Validating the temperature value on Rheem Mobile Application
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    get text    ${coolBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}     0    -1
#    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
#
#    Navigate to App Dashboard
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
#    should be equal as integers    ${Temperature_Mobile}     ${dashBoardTemperature}
#
#
#
#TC-08:Min Heating set point that can be set from App should be 50F.
#    [Documentation]    Min Heating set point that can be set from App should be 50F.
#    [Tags]    testrailid=99082
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
#                ...     Open Application and Navigate to Device Detail Page    ${locationNameNewECC}
#    # Set Maximum setpoint temperature from mobile and validating it on mobile itself
#    ${Temperature_ED}=    Write objvalue From Device    52    ${heatsetp}      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Scroll to the min temperature new ECC    ${newECCMinTemperature}    ${heatBubble}
#    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}     0    -1
#    ${temp_app}    Swipe down the bubble    ${heatBubble}
#    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}     0    -1
#    should be equal    ${Temperature_Mobile}    ${newECCMinTemperature}
#    Navigate to App Dashboard
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
#    should be equal as integers    ${Temperature_Mobile}     ${dashBoardTemperature}
#
#    # Validating temperature value on End Device
#    ${Temperature_ED}      Read int return type objvalue From Device       ${heatsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
#
#
#TC-45:Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
#    [Documentation]    Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
#    [Tags]    testrailid=99119
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
#                ...     Open Application without uninstall and Navigate to dashboard    ${locationNameNewECC}
#
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device    ${autoMode}    ${statmode}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
##    sleep    4  s
#    ${current_mode_ED}    Read int return type objvalue From Device    ${statmode}     ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#    should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#
#    ${status}=    set schedule New ECC     ${locationNameNewECC}
#    ${tempHeat}=     Get from List   ${status}    0
#    ${tempCool}=     Get from List   ${status}    1
#
#    ${tempHeat}=    Convert to integer    ${tempHeat}
#    ${tempCool}=    Convert to integer    ${tempCool}

##    sleep    5s
#    ${TempHeat_ED}      Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    ${TempCool_ED}      Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#    ${current_mode_ED}    Read int return type objvalue From Device    STAT_FAN    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
##    should be equal as integers    ${tempHeat}    ${TempHeat_ED}
##    should be equal as integers    ${tempCool}    ${TempCool_ED}
#
#    Navigate to App Dashboard
#    convert to integer      ${current_mode_ED}
##    Sleep    2s
##    should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_mode}
#
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
##    should be equal as integers    ${tempHeat}     ${dashBoardTemperature}
#    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
##    should be equal as integers    ${tempCool}     ${dashBoardTemperature}

TC-13:Add new contractor in the application.
    [Documentation]    Add new contractor in the application.
    [Tags]    testrailid=192492

    Open Application without device detail page
    Go To Menu
    scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click element    ${txtContacts}
    Sleep  5s
    Wait until page contains element     ${btnAddNewContractor}     ${defaultWaitTime}
    Click element    ${btnAddNewContractor}
    ${email}     Generate the random Email
    ${phoneNumber}     generate the random number
    Set global variable    ${email}

    Wait until page contains element    	${waterHeaterCheckbox}       ${defaultWaitTime}
    Click element   ${waterHeaterCheckbox}
    sleep    10s
    Input text    nameTextField      ${email}
    Input text    phoneTextField     ${phoneNumber}
    Input text    emailTextField     ${email}

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element     ${keyboardDoneButton}

    Click element    //XCUIElementTypeButton[@name="Save"]
    Sleep    5s
    Wait until page contains element    ${btnAddNewContractor}    ${defaultWaitTime}
    Navigate Back to the Screen


TC-14:Edit the Contractor in the Application.
    [Documentation]    Edit the Contractor in the Application.
    [Tags]    testrailid=192493

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click element    ${txtContacts}
    Wait until page contains element     //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[4]   ${defaultWaitTime}
    Click element                     	//XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[4]
    sleep    2s

    Wait until page contains element   contractorEdit  ${defaultWaitTime}
    Click element    contractorEdit
    ${status}    run keyword and return status    Wait until page contains element    //XCUIElementTypeButton[@name="checkbox"][1]
    run keyword if    ${status}    Click element   //XCUIElementTypeButton[@name="checkbox"][1]

    ${status}    run keyword and return status    Wait until page contains element    	//XCUIElementTypeButton[@name="redCheckBox"][2]
    run keyword if    ${status}    Click element   //XCUIElementTypeButton[@name="redCheckBox"][2]
    Wait until page contains element   	nameTextField    ${defaultWaitTime}
    ${string}    generate random string    4    [LOWER]
    Input text    nameTextField      ${string}
    Click element    ${btnSavechanges}
    sleep   3s
    Navigate Back to the Screen
    go back

TC-15:Delete the Contractor in the Application
    [Documentation]    Delete the Contractor in the Application
    [Tags]    testrailid=192494

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Wait until page contains element    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[5]     ${defaultWaitTime}
    click Text  	//XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[5]
    Wait until page contains element   contractorBin  ${defaultWaitTime}
    Click element    contractorBin
    Sleep    5s
    Wait until page contains element     ${btnAddNewContractor}     ${defaultWaitTime}
    Navigate Back to the Screen

TC-27:User should be able to Sign Out from Application
    [Tags]      testrailid=192495

    Open Application without uninstall and Navigate to dashboard    HPWHGen5
    Sleep    5s
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element     ${btnMenu}
    Wait until page contains element    Sign Out     ${defaultWaitTime}
    Click element    Sign Out
    Sleep    2s
    Wait until page contains element    Ok     ${defaultWaitTime}
    Click element    Ok
    Sleep    5s

TC-28:Create an Account
    [Tags]      testrailid=192496

    Run keyword and ignore error    Sign Out From the Application
    ${emailID}      Generate the random email
    ${number}       Generate the random Number
    ${password}     Generate random string   10      [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${firstName}    Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz
    ${lastName}     Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz
    Set global variable    ${randEmailId}    ${emailID}
    Set global variable    ${randPasswordValue}    ${password}
    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Click element    ${btnCreateAccount}
    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}
    Input text    ${txtBxFirstName}       ${firstName}
    Input text    ${txtBxLastName}        ${lastName}
    Input text    ${txtBxPhoneNumber}     ${number}
    Input text    ${txtBxEmailAddress}    ${emailID}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click element    ${keyboardDoneButton}
    Sleep    4s
    Click element    ${txtBxCnfrmPasswrd}
    Input Text   ${txtBxCnfrmPasswrd}    ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click element    ${keyboardDoneButton}
    Input Text      ${txtBxPassword}        ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click element    ${keyboardDoneButton}


    Click element    ${btnAddress}
#    Sleep    15s
#    ${Status}    run keyword and return status    Click element    Your current location?
#    run keyword if    ${Status}==False   Run Keywords  Click element    ${BackButton}        AND    Click element    ${btnAddress}    AND  Sleep    10s  AND   Click element    Your current location?
#    Sleep    4s
#    Wait until page contains element     ${agreeCheckBox}    ${defaultWaitTime}
#    Click element    ${agreeCheckBox}
#    Sleep    2s
#    Swipe    60     461     60    250   5000
#    Swipe    60     461     60    250   5000
#    Click element    	Create Account
#    Sleep    5s
#    Click element   ${SubmitButtonXpath}
#    Sleep    10s
#    ${Status}    Run Keyword and return status    Click element    Ok
#    Sleep    15s
#    Enter validation code
#    Sleep    10s
#    Wait until page contains element    Add Location
#    ${status}    Run keyword and return status    Wait until page contains element    Not Now    20s
#    Run Keyword If    ${status}    Click element    Not Now


TC-29:User be able to Forgot Password.
    [Tags]      testrailid=192497

    Open Application without uninstall and Navigate to dashboard    HPWHGen5
#    Sleep    5s
#    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
#    Click element     ${btnMenu}
#    Wait until page contains element    Sign Out     ${defaultWaitTime}
#    Click element    Sign Out
#    Sleep    2s
#    Wait until page contains element    Ok     ${defaultWaitTime}
#    Click element    Ok
#    Sleep    5s

#    Sign Out From the Application
#    Sleep    5s
#    Wait until page contains element    ${btnForgotPassword}    ${defaultWaitTime}
#    Click element    ${btnForgotPassword}
#    Wait until page contains element    ${txtBxForgotEmail}    ${defaultWaitTime}
#    Click element    ${txtBxForgotEmail}
#    Click element    ${txtSubmitButton}
#    Sleep    10s
#    Input text    ${txtBxEmailAddress}    ${emailId}
#    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
#    Click element     ${keyboardDoneButton}
#    Wait until page contains element     ${btnSubmitForgotPass}     ${defaultWaitTime}
#    Click element    ${btnSubmitForgotPass}
#    Sleep    5s
#    Wait until page contains element   ${GoToMail}     ${defaultWaitTime}
#    Click element    ${GoToMail}
#    Wait until page contains element   ${ApplyMail}     ${defaultWaitTime}
#    Click element    ${ApplyMail}
#    Sleep    5s
#    Background app    -1
#    go_back
#    Click element    EcoNet
#
#    Wait until page contains element    ${OTPScreen}    ${defaultWaitTime}
#    Input text      ${OTPScreen}    111111
#    Wait until page contains element    ${ButtonResetPassword}    ${defaultWaitTime}
#    Click element    ${ButtonResetPassword}
#    Sleep    5s
#    Click element    ${okButton}
#
#    Wait until page contains element    ${txtBxPasswordChange}   ${defaultWaitTime}
#    Input text    ${txtBxPasswordChange}   ${passwordValue}
#    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
#    Click element     ${keyboardDoneButton}
#    input text       ${txtBxCnfrmPassChange}    ${passwordValue}
#    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
#    Click element     ${keyboardDoneButton}
#
#    Wait until page contains element    ${txtSubmitButton}    ${defaultWaitTime}
#    Click element    ${txtSubmitButton}
#    set global variable    ${randPasswordValue}    ${password}
#    Sleep    10s
#
#    Wait until page contains element     ${txtBxEmailAddress}    ${defaultWaitTime}
#    Input Text   ${txtBxEmailAddress}    ${emailId}
#    Sleep    3s
#    Wait until page contains element      ${txtBxPassword}     ${defaultWaitTime}
#    Input Password    ${txtBxPassword}      ${passwordValue}
#    sleep  3s
#    Wait until page contains element     ${keyboardDoneButton}     ${defaultWaitTime}
#    Click element     ${keyboardDoneButton}
#    Wait until page contains element   ${sign_in_link}    ${defaultWaitTime}
#    Click element    ${sign_in_link}
#    sleep    5s
#    ${status}    run keyword and return status    Wait until page contains element    ${txtNotNow}    60s
#    Run keyword if    ${status}    Click element    ${txtNotNow}


TC-16:User should be able to add New Location.
    [Documentation]    User should be able to add New Location.
    [Tags]    testrailid=192498

    Open Application without device detail page
    Sign Out From the Application
    Sign in to the application     ${LocationemailId}	  ${LocationpasswordValue}
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click element    ${txtLocationProducts}
    Wait until page contains element    ${btnAddNewLocation}
    Click element   ${btnAddNewLocation}
    Wait until page contains element     ${MyCurrentLocation}
    Click element   ${MyCurrentLocation}
    Sleep    10s
    Click element    ${btnNext}
    Sleep    5s
    Navigate Back to the Screen
    Wait until page contains element    Exit    ${defaultWaitTime}
    Click element    Exit
    Sleep    10s
    Wait until page contains element     ic back     ${defaultWaitTime}
    Click element     ic back

TC-35:User should be able to change name from your profile
   [Documentation]    User should be able to change name from your profile
   [Tags]     testrailid=192499
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Go To Menu

    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click element    ${txtAccount}
    sleep    4s

    # all the element locators neeed to change
    Wait until page contains element     ${btnChangeName}     ${defaultWaitTime}

    Tap     ${btnChangeName}

    ${nameTxt}       Generate Random String    4    [LOWER]
    ${surNameTxt}    Generate random string    10    [LOWER]

    ${nameTxt}       Convert to title case    ${nameTxt}
    ${surNameTxt}    Convert to title case    ${surNameTxt}
    Wait until page contains element    ${txtNameFirst}     ${defaultWaitTime}

    clear text    firstNameTextField
    input text    firstNameTextField    ${nameTxt}

    clear text    lastNameTextField
    input text    lastNameTextField    ${surNameTxt}

    ${name}     catenate     ${nameTxt}${space}${surNameTxt}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element     ${keyboardDoneButton}

    Wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    Click element  ${btnSavePhoneChanges}
    Sleep    10s
    page should contain element      ${name}
    Navigate Back to the Screen

TC-09:User should be able to set Temperature in Celsius unit
    [Documentation]    User should be able to set Temperature  in Celsius unit
    [Tags]    testrailid=192500

    Temperature Unit in Celsius

TC-10:User should be able to set Temperature in Fahrenheit unit
    [Documentation]    User should be able to set Temperature  in Fahrenheit unit
    [Tags]    testrailid=192501

    Temperature Unit in Fahrenheit