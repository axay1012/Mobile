*** Settings ***
Library     AppiumLibrary
Library     Collections
Library     DateTime
Library     String
Library     ../../src/RheemMqtt.py
Library     ../../src/RheemCustom.py
Library             /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/src/voiceskill_helper.py

Resource    ../Locators/AndroidLabels.robot
Resource    ../Locators/AndroidLocators.robot
Resource    ../Locators/Androidconfig.robot



*** Variables ***
# --> Sleep Times
${Sleep_1s}                         1s
${Sleep_2s}                         2s
${Sleep_3s}                         3s
${Sleep_5s}                         5s
${Sleep_10s}                        10s
${Sleep_20s}                        20s
${Sleep_30S}                        30s
${Sleep_60s}                        60s
${Get_Current_Temp}                 10
${Device_Mac_Address}               40490F9E66D5
${Device_Mac_Address_In_Formate}    40-49-0F-9E-66-D5
${EndDevice_id}                     4107
${emailId}                          automation@rheem.com
${emailId1}                         automation@rheem.com
${passwordValue}                    Automation@4523

${EconetWifi}                       EcoNet WiFi Connections
${EconetWifi_delete}                com.rheem.econetconsumerandroid:id/settingsStoredSSIDDelete
${AddButton}                        com.rheem.econetconsumerandroid:id/addManuallyText
${EconetWifi_field}                 com.rheem.econetconsumerandroid:id/ssidNameEdit
${EconetWifi_inputtext}             EcoNet-abcd
${EconetWifi_changetext}            EcoNet-qwer
${EcoNet_editbutton}                com.rheem.econetconsumerandroid:id/settingsStoredSSIDEdit
${HomeWiFi}                         Home WiFi Connections
${EconetSSID_inputtext}             abcdefghi
${EconetSSID_changetext}            rheemeconet


*** Keywords ***
save screenshot with timestamp
    ${timestamp}    get current date    result_format=%Y%m%d_%H%M%S
    ${filename}    Set Variable    screenshot_${timestamp}.png
#    AppiumLibrary.capture page screenshot    ${filename}
    sleep    ${Sleep_5s}

Open Application wihout unistall and Navigate to dashboard
    [Arguments]    ${location_name}
#    Run Keywords    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
    Open application and Navigate to Dashboard App
    Select Device Location    ${location_name}

Open application and Navigate to Dashboard App
    Close All Applications
    open App again
#    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
    Navigate to Home Screen in Rheem application for app    ${emailId}    ${passwordValue}

Navigate to Home Screen in Rheem application
    [Arguments]    ${emailId}    ${passwordValue}
    Wait until page contains    ${app_start_page_text}    ${Sleep_30s}
    Sleep    ${Sleep_10s}
    tap    ${imageLogo}    count=3
    Wait until page contains    ${EnvText}    30s
    Click text    ${EnvText}
    Wait until page contains    ${saveText}
    Click text    ${saveText}
    Wait until page contains    Sign In
    Click Element    ${SignIn_Button}
    Wait until page contains    ${sign_in_text}    ${Sleep_10s}
    Wait until page contains element    ${userName}
    Click Element    ${userName}
    Input Text    ${userName}    ${emailId}
    Wait until page contains element    ${password}
    Click Element    ${password}
    Input Text    ${password}    ${passwordValue}
    Hide Keyboard
    Wait until page contains element    ${loginButton}
    Click Element    ${loginButton}
    Sleep    ${Sleep_30s}
    ${a}    Run Keyword and Return status    Page should contain text    OK
    IF    '${a}'=='True'    Click text    OK
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click text    While using the app
    ${status}    Run Keyword and Return status    Not Now validation
    IF    '${status}'=='True'    Click NOT NOW
    sleep    ${sleep_5s}

Location validation
    page should contain element    ${Location_per_text}

Not Now validation
    Page should contain text    NOT NOW

Click OK
    Click text    OK

Click NOT NOW
    Click text    NOT NOW

Navigate to Home Screen in Rheem application for app
    [Arguments]    ${emailId}    ${passwordValue}
    Wait until page contains    ${app_start_page_text}    ${Sleep_30s}
    Sleep    ${Sleep_10s}
    tap    ${imageLogo}    count=3
    Wait until page contains    ${EnvText}    30s
    Click text    ${EnvText}
    Wait until page contains    ${saveText}
    Click text    ${saveText}
    Wait until page contains    Sign In
    Click Element    ${SignIn_Button}
    Wait until page contains    ${sign_in_text}    ${Sleep_10s}
    Click text    ${sign_in_text}
    Wait until page contains element    ${userName}
    Click Element    ${userName}
    Input Text    ${userName}    ${emailId}
    Wait until page contains element    ${password}
    Click Element    ${password}
    Input Text    ${password}    ${passwordValue}
    Hide Keyboard
    Wait until page contains element    ${loginButton}
    Click Element    ${loginButton}
    sleep    ${Sleep_30s}
    sleep    ${Sleep_10s}
    ${status}    Run Keyword and Return status    Page should contain text    OK
    IF    '${status}'=='True'    Click text    OK
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click text    ${location_per}
    ${status}    Run Keyword and Return status    Not Now validation
    IF    '${status}'=='True'    Click NOT NOW
    sleep    ${sleep_5s}

Temperature Unit in Fahrenheit
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${sleep_3s}
    Click Element    ${General}
    Wait until page contains    ${generalsettings_text}
    Click Element    ${Temperature_unit}
    sleep    ${Sleep_3s}
    Click Element    ${Fahrenheit_unit}
    sleep    7s
    Go back
    Wait until page contains Element    ${notification_icon}    ${Sleep_20s}

Temperature Unit in Celsius
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click Element    ${General}
    Wait until page contains    ${generalsettings_text}
    Click Element    ${Temperature_unit}
    sleep    ${Sleep_3s}
    Click Element    ${Celsius_unit}
    sleep    ${Sleep_10s}
    Go back
    Wait until page contains Element    ${notification_icon}    ${Sleep_20s}

Navigate to Detail Page
    [Arguments]    ${locationName}

    Wait until page contains element    ${locationName}    ${Sleep_10s}
    sleep    ${Sleep_5s}
    Click Element    ${locationName}
    sleep    ${Sleep_5s}

Increment set point
    Sleep    2s
    Tap    ${Increment_Temp}
    Sleep    5s

Decrement setpoint
    Wait until element is visible    ${Decrement_Temp}    ${defaultwaittime}
    Tap    ${Decrement_Temp}

Get setpoint from details screen
    Sleep    ${sleep_2s}
    Wait until page contains element    ${WH_get_SetPointValue}    ${Default_Timeout}
    ${details_screen_text}    Get text    ${WH_get_SetPointValue}
#    ${details_screen_text}    get substring    ${details_screen_text}    0    -1
    ${Setpoint_Detailsscreen}    Convert To Integer    ${details_screen_text}
    RETURN    ${details_screen_text}

Get setpoint from equipmet card
    Sleep    ${sleep_2s}
    Wait until page contains element    ${WH_get_EC_SetPointValue}    ${Default_Timeout}
    ${text}    Get text    ${WH_get_EC_SetPointValue}
    ${text}    Get Substring    ${text}    0    -1
    ${Setpoint_Equipmet}    Convert To Integer    ${text}
    RETURN    ${Setpoint_Equipmet}

Validate set point Temperature From Mobile
    Wait until page contains element    ${WH_get_SetPointValue}    ${Default_Timeout}
    ${text}    Get text    ${WH_get_SetPointValue}
    ${Setpoint_Equipmet}    Convert To Integer    ${text}
    
    RETURN    ${Setpoint_Equipmet}

WH Set Mode
    [Arguments]    ${mode}
    Wait until page contains element    ${WH_changemode}    ${Default_Timeout}
    Click Element    ${WH_changemode}
    Wait until page contains    ${mode}    ${Sleep_10s}
    Click text    ${mode}
    
    RETURN    ${mode}

WH Get Mode
    sleep    ${sleep_10s}
    Wait until page contains element    ${GetModeText_DP}
    ${mode}    Get text    ${GetModeText_DP}
    
    RETURN    ${mode.strip()}

Get mode from equipment card
    [Arguments]    ${deviceText}
    Wait until page contains Element    ${deviceText}    ${Default_Timeout}
    ${mode_text}    Get text    ${WH_get_Eqipment_Mode}
    
    RETURN    ${mode_text}

Get Disabled mode from equipment card
    [Arguments]    ${deviceText}
    Wait until page contains    ${deviceText}    ${Default_Timeout}
    ${Disabled_mode_text}    Get text    ${Disabled_Text}
    
    RETURN    ${Disabled_mode_text}

Get Heatpump mode from equipment card
    [Arguments]    ${deviceText}
    Wait until page contains    ${deviceText}    ${Default_Timeout}
    ${Disabled_mode_text}    Get text    ${Heatpump_Text}
    
    RETURN    ${Heatpump_Text}

Get Energy Usage data
    [Arguments]    ${EnergyUsage_Day_month_year}
    sleep    ${Sleep_5s}
#    Wait until page contains element    ${WH_product_setting}    ${Default_Timeout}
#    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Wait until page contains    ${EnergyUsage_Day_month_year}    ${Sleep_60s}
    Click text    ${EnergyUsage_Day_month_year}
    Wait until page contains element    ${get_Usage_Report_data}    ${Sleep_20s}
    sleep    ${Sleep_5s}
    RETURN    ${get_Usage_Report_data}

Set Away mode from mobile application
    [Arguments]    ${value}
    Wait until page contains element    ${value}    ${Sleep_20s}
    Wait until page contains element    ${get_location_button}
    ${location_name}    Get text    ${get_location_button}
    
    Wait until page contains element    ${get_Away_status}    ${Sleep_5s}
    ${text}    Get text    ${get_Away_status}
    Wait until page contains element    ${Location_Away_icon}
    Click Element    ${Location_Away_icon}
    sleep    ${Sleep_5s}
    ${Status}    run keyword and return status    Wait until page contains element    //*[contains(@text, 'OK')]
    IF    '${Status}'=='True'    Enable Toggle Button In Away Settings
    Wait until page contains element    ${get_Away_status}
    sleep    ${Sleep_10s}
    ${text}    Get text    ${get_Away_status}
    
    should be equal as strings    ${text}    I'm Away

Enable Toggle Button In Away Settings
    Click text    OK
    Wait until page contains element    ${Awaytoggleswitch}    10s
    Click Element    ${Awaytoggleswitch}
    Sleep    5s
    Click text    Save
    Sleep    6s
    Click text    OK
    Sleep    2s
    Go back
    Sleep    5s
    Click Element    ${Location_Away_icon}

Disable Away mode from mobile application
    [Arguments]    ${value}
#    Wait until page contains element    ${value}    ${Sleep_20s}
    Wait until page contains element    ${get_location_button}
    ${location_name}    Get text    ${get_location_button}
    
    Wait until page contains element    ${get_Away_status}    ${Sleep_5s}
    ${text}    Get text    ${get_Away_status}
    Wait until page contains element    ${Location_Away_icon}
    Click Element    ${Location_Away_icon}
    sleep    ${Sleep_5s}
    Wait until page contains element    ${get_Away_status}
    sleep    ${Sleep_10s}
    ${text}    Get text    ${get_Away_status}
    
    should be equal as strings    ${text}    I'm Home

HPWH Follow Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Click text    ${status}

    Sleep    2s

    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    ${get_current_mode}    Get text    ${Schedule_mode}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}
    Go back
    Go back

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    ${status}    Get text    ${FollowSchedule_button}
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}

    sleep    ${sleep_5s}
    Click text    ${Save_button}
    sleep    ${Sleep_5s}
    RETURN    ${get_current_setpoint}    ${get_current_mode}

HPWH Copy Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${schedule_button}
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}
    ${currentDay}    Get Current Date    result_format=%A
    

    sleep    ${Sleep_10s}

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time40}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time10}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time20}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time30}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp40}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp10}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp20}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp30}    Get text    ${temp3}

    @{data_list1}    create list
    ...    ${time40}
    ...    ${time10}
    ...    ${time20}
    ...    ${time30}
    ...    ${temp40}
    ...    ${temp10}
    ...    ${temp20}
    ...    ${temp30}
    Click Element    ${click_copy}

############################################### Copied day############################################################
    
    IF    '${currentDay}'=='Sunday'
        Click text    ${day_Monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click text    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${day_Sunday}
    END
    sleep    2s

    Click text    Save

    sleep    2s

    #############################    Select Next Day according to current day    for copy data    ################################
    IF    '${currentDay}'=='Monday'
        Click text    ${Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click text    ${Monday}
    END
    sleep    5s

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time91}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time92}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time93}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time94}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp91}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp92}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp93}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp94}    Get text    ${temp3}

    @{data_list2}    create list
    ...    ${time91}
    ...    ${time92}
    ...    ${time93}
    ...    ${time94}
    ...    ${temp91}
    ...    ${temp92}
    ...    ${temp93}
    ...    ${temp94}

    should be equal    ${data_list1}    ${data_list2}

Get Mode and Setpoint From Schedule screen
    Page should contain text    Time Slot
    ${Scheduled_Temp}    Get text    ${ScheduleTime_Temp}
    ${Scheduled_Mode}    Get text    ${ScheduleTime_Mode}
    Click Element    ${ScheduleTime_Mode}
    sleep    ${Sleep_3s}
    ${Scheduled_Mode1}    Get text    ${ScheduleTime_Mode}
    ${Scheduled_Temp1}    Get text    ${ScheduleTime_Temp}
    Click Element    ${loginButton}
    wait unit page contain text    Schedule

HPWH Update Setpoint and Mode From Schedule screen
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END
    Click text    ${status}
    Sleep    5s

    Increment set point
    sleep    ${Sleep_5s}
    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    ${get_current_mode}    Get text    ${Schedule_mode}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
#    ${status}    convert to string    ${status}
#    ${status}    Get text    ${status}

    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}

    sleep    ${sleep_5s}
    Click text    ${Save_button}
    sleep    ${Sleep_5s}
    RETURN    ${get_current_setpoint}    ${get_current_mode}

Unfollow the schedule
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    IF    '${status}'=='true'    Click Element    ${FollowSchedule_button}
    sleep    ${sleep_3s}
    Click text    ${Save_button}
    sleep    5s

Change Schedule Temperature Using Inc/Dec Button HPWH
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${WH_product_setting_all_ele}[0]
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_5s}

###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

######################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${Follow_Sche_status}    Get text    ${FollowSchedule_button}
    IF    '${Follow_Sche_status}'=='OFF'
        Click Element    ${FollowSchedule_button}
    END
    Click Element    ${loginButton}

Select Device Location
    [Arguments]    ${locationName}
    Wait until page contains element    ${get_location_button}    ${Sleep_30s}
    Click Element    ${get_location_button}
    sleep    ${Sleep_5s}
    Click text    ${locationName}

Change the Status of device if Device is in away mode
    ${Status}    Run keyword and Return Status    Wait until page contains    I'm Away    ${Sleep_10s}
    IF    ${Status}==true    Click Element    ${get_Away_status}

HPWHGen5 WH Set Mode
    [Arguments]    ${mode}
    Wait until page contains element    ${Mode_Change}    ${Sleep_10s}
    Click Element    ${Mode_Change}
    Wait until page contains    ${mode}    ${Sleep_10s}
    Click text    ${mode}
    
    RETURN    ${mode}

HPWHGen5 WH Get Mode
    Wait until page contains element    ${Mode_Change}    ${Sleep_10s}
    ${mode}    Get text    ${Mode_Value}
    sleep    5s
    
    RETURN    ${mode}

Changing Energy Saver mode from the caution message
    sleep    ${Sleep_10s}
    Wait until page contains element    ${Energy_Saver_Msg}
    ${Get_Energy_Saver_Msg}    Get text    ${Energy_Saver_Msg}
    
    should be equal as strings    ${Msg_For_Energy_Saving}    ${Get_Energy_Saver_Msg}
    Click Element    ${Energy_Saving_Enable_Button}
    sleep    ${Sleep_10s}
    page should not contain text    ${Get_Energy_Saver_Msg}

Set Disabled state
    Wait until page contains Element    ${Dis/Ena_State}
    Get Element Location    ${Dis/Ena_State}
    Click Element    ${Dis/Ena_State}
    Wait until page contains Element    //*[contains(@text, 'Disable')]    ${default_timeout}
    ${location}    Get element location    //*[contains(@text, 'Disable')]
    Click Element At Coordinates    ${location}[x]    ${location}[y]
#    Click text    Disable
    Sleep    5s
    RETURN    Disabled


Set Enable state
    Wait until page contains Element    ${Dis/Ena_State}
    Click Element    ${Dis/Ena_State}
    Wait until page contains Element    //*[contains(@text, 'Enable')]    ${default_timeout}
    ${location}    Get element location    //*[contains(@text, 'Enable')]
    Click Element At Coordinates    ${location}[x]    ${location}[y]
    Sleep    5s

Combustion Health Status Verification
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[2]
    Wait until page contains    Product Health
    Page should contain text    Compressor Health
    Page should contain text    Element Health
    Page should contain text    Leak sensor not installed
    Page should contain text    Shut-OFF Valve - Closed

Electric WH Follow Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s
###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Click text    ${status}
    Sleep    2s

    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}
    sleep    ${sleep_3s}
    Click Element    ${loginButton}
    RETURN    ${get_current_setpoint}

Gladiator WH Follow Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Click text    ${status}
    Sleep    2s

    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked

    ${status}    Get text    ${FollowSchedule_button}
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}

    sleep    ${sleep_5s}
    Click text    ${Save_button}
    sleep    ${Sleep_5s}
    RETURN    ${get_current_setpoint}

Gladiator WH COPY Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${schedule_button}
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}
    ${currentDay}    Get Current Date    result_format=%A
    

    sleep    ${Sleep_10s}

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time40}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time10}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time20}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time30}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp40}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp10}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp20}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp30}    Get text    ${temp3}

    @{data_list1}    create list
    ...    ${time40}
    ...    ${time10}
    ...    ${time20}
    ...    ${time30}
    ...    ${temp40}
    ...    ${temp10}
    ...    ${temp20}
    ...    ${temp30}
    Click Element    ${click_copy}

############################################### Copied day############################################################
    
    IF    '${currentDay}'=='Sunday'
        Click text    ${day_Monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click text    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${day_Sunday}
    END
    sleep    2s

    Click text    Save

    sleep    2s

    #############################    Select Next Day according to current day    for copy data    ################################
    IF    '${currentDay}'=='Monday'
        Click text    ${Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click text    ${Monday}
    END
    sleep    5s

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time91}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time92}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time93}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time94}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp91}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp92}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp93}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp94}    Get text    ${temp3}

    @{data_list2}    create list
    ...    ${time91}
    ...    ${time92}
    ...    ${time93}
    ...    ${time94}
    ...    ${temp91}
    ...    ${temp92}
    ...    ${temp93}
    ...    ${temp94}

    should be equal    ${data_list1}    ${data_list2}

Electric WH COPY Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    Click Element    ${schedule_button}
    ${currentDay}    Get Current Date    result_format=%A
    

    sleep    ${Sleep_10s}

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time40}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time10}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time20}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time30}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp40}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp10}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp20}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp30}    Get text    ${temp3}

    @{data_list1}    create list
    ...    ${time40}
    ...    ${time10}
    ...    ${time20}
    ...    ${time30}
    ...    ${temp40}
    ...    ${temp10}
    ...    ${temp20}
    ...    ${temp30}
    Click Element    ${click_copy}

############################################### Copied day############################################################
    
    IF    '${currentDay}'=='Sunday'
        Click text    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click text    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${sunday}
    END
    sleep    2s

    Click text    Save

    sleep    2s

    #############################    Select Next Day according to current day    for copy data    ################################
    IF    '${currentDay}'=='Monday'
        Click text    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click text    ${day_Monday}
    END
    sleep    5s

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time91}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time92}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time93}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time94}    Get text    ${time3}

    Wait Until Element is Visible    ${temp0}    ${Sleep_5s}
    ${temp91}    Get text    ${temp0}

    Wait Until Element is Visible    ${temp1}    ${Sleep_5s}
    ${temp92}    Get text    ${temp1}

    Wait Until Element is Visible    ${temp2}    ${Sleep_5s}
    ${temp93}    Get text    ${temp2}

    Wait Until Element is Visible    ${temp3}    ${Sleep_5s}
    ${temp94}    Get text    ${temp3}

    @{data_list2}    create list
    ...    ${time91}
    ...    ${time92}
    ...    ${time93}
    ...    ${time94}
    ...    ${temp91}
    ...    ${temp92}
    ...    ${temp93}
    ...    ${temp94}

    should be equal    ${data_list1}    ${data_list2}

Get Schedule Data of Gladiator WH
    Page should contain text    Time Slot
    ${Scheduled_Temp}    Get text    ${ScheduleTime_Temp}
    ${Scheduled_Temp1}    Get text    ${ScheduleTime_Temp}
    Click Element    ${loginButton}
    Wait until page contains    Schedule

Gladiator WH Update Setpoint From Schedule screen
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${DefaultTimeout}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[0]
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}

###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

#    Wait Until Element is Visible    ${status}    ${sleep_10s}
    Click text    ${status}

    Sleep    5s
    Increment set point
    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}
    sleep    ${sleep_3s}
    Click Element    ${loginButton}
    RETURN    ${get_current_setpoint}

Electric WH Update Setpoint From Schedule screen
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${DefaultTimeout}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[0]
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}

###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

#    Wait Until Element is Visible    ${status}    ${sleep_10s}
    Click text    ${status}

    Sleep    5s
    Increment set point
    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}
    sleep    ${sleep_3s}
    Click Element    ${loginButton}
    RETURN    ${get_current_setpoint}

Get WH Mode Value From Equipment Card
    Wait until page contains element    ${get_location_button}    ${Default_Timeout}
    ${Mode_Text_EC}    Get text
    ...    ${xPathPrefix}${textViewClass}\[@resource-id="com.rheem.econetconsumerandroid:id/whModeText"]
    RETURN    ${Mode_Text_EC}

Get WH State Value From Equipment Card
    Wait until page contains element    ${get_location_button}    ${Default_Timeout}
    ${State_EC}    Get text    ${GetState_EC}
    RETURN    ${State_EC}

Electric Set Mode Energy Saver
    Wait until page contains element    ${Electric_ModeCard}    ${Default_Timeout}
    Click Element    ${Electric_ModeCard}
    Wait until page contains element    ${Select_Energy_Mode}    ${Default_Timeout}
    Click Element    ${Select_Energy_Mode}
    Sleep    5s
    swipe    400    1500    400    1200    2000
    Sleep    2s
    Page should contain text    Energy Saver
    RETURN    Energy Saver

Electric Set Mode Performance
    Wait until page contains element    ${Electric_ModeCard}    ${Default_Timeout}
    Click Element    ${Electric_ModeCard}
    Wait until page contains element    ${Select_Performance_Mode}    ${Default_Timeout}
    Click Element    ${Select_Performance_Mode}
    swipe    400    1500    400    1200    2000
    Sleep    2s
    Page should contain text    Performance
    RETURN    Performance

Triton WH Occupied/Unoccupied Schedule
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time1}
    ELSE
        set global variable    ${status}    ${time1}
    END

    Click text    ${status}

    Sleep    2s

    ${status}    Get Element attribute    ${Occ/Unocc_Switch}    checked
    IF    '${status}'=='false'    Click Element    ${Occ/Unocc_Switch}
    Click Element    ${loginButton}
    Go back
    Wait until page contains element    ${Increment_Temp}    ${Default_Timeout}
    page should contain element    ${Increment_Temp}
    Go back

Triton Copy Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${schedule_button}
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}
    ${currentDay}    Get Current Date    result_format=%A
    

    sleep    ${Sleep_10s}

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time40}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time10}    Get text    ${time1}

    @{data_list1}    create list    ${time40}    ${time10}
    Click Element    ${click_copy}

############################################### Copied day############################################################
    
    IF    '${currentDay}'=='Monday'
        Click text    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click text    ${day_Monday}
    END
    sleep    2s

    Click text    Save

    sleep    2s

    #############################    Select Next Day according to current day    for copy data    ################################
    IF    '${currentDay}'=='Sunday'
        Click text    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click text    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${sunday}
    END
    sleep    5s

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time91}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time92}    Get text    ${time1}

    @{data_list2}    create list    ${time91}    ${time92}

    should be equal    ${data_list1}    ${data_list2}
    Go back

Tankless WH Follow Schedule
    [Arguments]    ${Verify_text_Schedule}
    Sleep    5s
    Click Element    ${schedule_button}
    sleep    5s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Click text    ${status}

    Sleep    2s

    ${schedule_setpoint}    Get text    ${WH_get_SetPointValue}
    ${get_current_setpoint}    Convert To Integer    ${schedule_setpoint}
    sleep    ${sleep_2s}
    Wait until page contains    Save    ${Sleep_5s}
    Click text    Save
    Sleep    ${Sleep_5s}

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${status}    Get Element attribute    ${FollowSchedule_button}    checked
#    ${status}    Get text    ${FollowSchedule_button}
    IF    '${status}'=='false'    Click Element    ${FollowSchedule_button}

    sleep    ${sleep_5s}
    Click text    ${Save_button}
    sleep    ${Sleep_5s}
    RETURN    ${get_current_setpoint}


Navigate to the Product Settings Screen
    [Arguments]    ${Verify_text_ProductSettings}=10
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    Click Text    Settings
    Sleep    5s

Enable/Disable Water Save From Product Settings
    Wait until page contains element    ${FollowSchedule_button}    ${DefaultTimeout}
    ${Status}    Get text    ${FollowSchedule_button}
    IF    '${Status}'=='OFF'    Click Element    ${FollowSchedule_button}
    Go back
    Go back

Set Alitude To Sea Level From Product Settings Screen
    Wait until page contains element    ${AltitudeLevelDropDown}    ${DefaultTimeout}
    Click Element    ${AltitudeLevelDropDown}
    Click Element    ${SeaLevel}
    RETURN    ${AltitudeValue}

#    
#    ${AltitudeValue}    Get text    ${SeaLevel}
Set Alitude To Low Altitude From Product Settings Screen
    Wait until page contains element    ${AltitudeLevelDropDown}    ${DefaultTimeout}
    Click Element    ${AltitudeLevelDropDown}
    Click Element    //android.view.ViewGroup[@index='1']
    RETURN    ${AltitudeValue}

Set Alitude To Med. Altitude From Product Settings Screen
    Wait until page contains element    ${AltitudeLevelDropDown}    ${DefaultTimeout}
    Click Element    ${AltitudeLevelDropDown}
    Click Element    //android.view.ViewGroup[@index='2']
    RETURN    ${AltitudeValue}


Set Alitude To High Altitude From Product Settings Screen
    Wait until page contains element    ${AltitudeLevelDropDown}    ${DefaultTimeout}
    Click Element    ${AltitudeLevelDropDown}
    Click Element    //android.view.ViewGroup[@index='3']
    RETURN    ${AltitudeValue}


Set Recirc Pump Operations None From the Product Settings Screen
    Wait until page contains element    ${RecircDropDown}    ${DefaultTimeout}
    click Text    Mode
    Sleep    5s
    click text    None
    Sleep    2s
    RETURN    ${ModeValue}

Set Recirc Pump Operations Timer-Perf From the Product Settings Screen
    Wait until page contains element    ${RecircDropDown}    ${DefaultTimeout}
    click Text    Mode
    Sleep    5s
    click text    Timer-Perf.
    Sleep    2s
    RETURN    ${ModeValue}


Set Recirc Pump Operations Timer-E-Save From the Product Settings Screen
    Wait until page contains element    ${RecircDropDown}    ${DefaultTimeout}
    click Text    Mode
    Sleep    5s
    click text    Timer-E-Save
    Sleep    2s
    RETURN    ${ModeValue}


Set Recirc Pump Operations On Demand From the Product Settings Screen
    Wait until page contains element    ${RecircDropDown}    ${DefaultTimeout}
    click Text    Mode
    Sleep    5s
    click text    On-Demand
    Sleep    2s
    RETURN    ${ModeValue}


Set Recirc Pump Operations Schedule From the Product Settings Screen
    Wait until page contains element    ${RecircDropDown}    ${DefaultTimeout}
    click Text    Mode
    Sleep    5s
    click text    Schedule
    Sleep    2s
    RETURN    ${ModeValue}


Dragon WH Occupied/Unoccupied Schedule
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time1}
    ELSE
        set global variable    ${status}    ${time1}
    END

    Click text    ${status}

    Sleep    2s

    ${status}    Get Element attribute    ${Occ/Unocc_Switch}    checked
    IF    '${status}'=='false'    Click Element    ${Occ/Unocc_Switch}
    Click Element    ${loginButton}
    Go back
    Wait until page contains element    ${Increment_Temp}    ${Default_Timeout}
    page should contain element    ${Increment_Temp}
    Go back

Navigate to Dragon WH Product Settings Screen
    [Arguments]    ${Verify_text_ProductSettings}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[4]
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}

Set Shutoff Valve Config to'Closed if Leak Detected'
    Wait until page contains element    ${Dragon_ShutoffValve_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_ShutoffValve_Config}
    Wait until page contains element    ${ClosedifLeakDetected}    ${DefaultTimeout}
    Click Element    ${ClosedifLeakDetected}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_ShutoffValve_Config}
    Go back
    RETURN    ${Mode_Text}

Set Shutoff Valve Config to'Closed if Unocc. Leak Detect'
    Wait until page contains element    ${Dragon_ShutoffValve_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_ShutoffValve_Config}
    Wait until page contains element    ${ClosedifUnoccLeakDetect}    ${DefaultTimeout}
    Click Element    ${ClosedifUnoccLeakDetect}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_ShutoffValve_Config}
    Go back
    RETURN    ${Mode_Text}

Set Shutoff Valve Config to 'Open'
    Wait until page contains element    ${Dragon_ShutoffValve_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_ShutoffValve_Config}
    Wait until page contains element    ${Open}    ${DefaultTimeout}
    Click Element    ${Open}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_ShutoffValve_Config}
    Go back
    RETURN    ${Mode_Text}

Set Shutoff Valve Config to 'Closed'
    Wait until page contains element    ${Dragon_ShutoffValve_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_ShutoffValve_Config}
    Wait until page contains element    ${Closed}    ${DefaultTimeout}
    Click Element    ${Closed}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_ShutoffValve_Config}
    Go back
    RETURN    ${Mode_Text}

Get ShutoffValve Config Value from Product Settings screen
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[4]
    Wait until page contains element    ${Dragon_ShutoffValve_Config}    ${DefaultTimeout}
    ${Mode_Text}    Get text    ${Dragon_ShutoffValve_Config}
    Go back
    RETURN    ${Mode_Text}

Set Recirc Pump Config to'Off'
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_RecircPump_Config}
    Wait until page contains element    ${RecircOFF}    ${DefaultTimeout}
    Click Element    ${RecircOFF}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Set Recirc Pump Config to'On'
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_RecircPump_Config}
    Wait until page contains element    ${RecircON}    ${DefaultTimeout}
    Click Element    ${RecircON}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Set Recirc Pump Config to'Schedule'
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_RecircPump_Config}
    Wait until page contains element    ${RecircSchedule}    ${DefaultTimeout}
    Click Element    ${RecircSchedule}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Set Recirc Pump Config to'Schedule On'
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_RecircPump_Config}
    Wait until page contains element    ${RecircScheduleOn}    ${DefaultTimeout}
    Click Element    ${RecircScheduleOn}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Set Recirc Pump Config to'On Demand'
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    Click Element    ${Dragon_RecircPump_Config}
    Wait until page contains element    ${RecircOnDemand}    ${DefaultTimeout}
    Click Element    ${RecircOnDemand}
    sleep    ${Sleep_5s}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Get Recirc Pump Config Value from Product Settings screen
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[4]
    Wait until page contains element    ${Dragon_RecircPump_Config}    ${DefaultTimeout}
    ${Mode_Text}    Get text    ${Dragon_RecircPump_Config}
    Go back
    RETURN    ${Mode_Text}

Set Leak Detection to Alarm Only
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[4]
    Wait until page contains element    ${AlarmOnly}    ${DefaultTimeout}
    Click Element    ${AlarmOnly}
    Go back

Set Leak Detection to Disable Water Heater
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[4]
    Wait until page contains element    ${DisableWH}    ${DefaultTimeout}
    Click Element    ${DisableWH}
    Go back

Set Auto Mode Of Smart Thermosate
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click Element    ${Auto_Mode}
    sleep    ${Sleep_3s}

Set Heating Mode Of Smart Thermosate
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click Element    ${Heating_Mode}
    sleep    ${Sleep_3s}

Set Cooling Mode Of Smart Thermosate
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click Element    ${Cooling_Mode}
    sleep    ${Sleep_3s}

Set FanOnly Mode Of Smart Thermosate
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click Element    ${FanOnly_Mode}
    sleep    ${Sleep_3s}

Set OFF Mode Of Smart Thermosate
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click Element    ${Off_Mode}
    sleep    ${Sleep_3s}

Get mode name from equipment card HVAC
    Wait until page contains element    ${get_location_button}    ${Default_Timeout}
    ${Get_ModeText}    Get text    ${HVACMode_EquipmentCard}
    RETURN    ${Get_ModeText}


Get Heat Setpoint from equipmet card HVAC
    Wait until page contains element    ${HAVCHeatTemp_Equipmentcard}    ${Default_Timeout}
    ${text}    Get text    ${HAVCHeatTemp_Equipmentcard}
    ${text}    Get Substring    ${text}    0    -1
    ${Get_HeatSetpoint}    Convert To Integer    ${text}
    RETURN    ${Get_HeatSetpoint}

Get Cool Setpoint from equipmet card HVAC
    Wait until page contains element    ${get_location_button}    ${Default_Timeout}
    ${text}    Get text    ${HAVCCoolTemp_Equipmentcard}
    ${text}    Get Substring    ${text}    0    -1
    ${Get_CoolSetpoint}    Convert To Integer    ${text}
    RETURN    ${Get_CoolSetpoint}

Get FanSpeed from equipment card HVAC
    Wait until page contains element    ${HVACFanSpeed_EquipmentCard}    ${Default_Timeout}
    ${Get_Fanspeed}    Get text    ${HVACFanSpeed_EquipmentCard}
    RETURN    ${Get_Fanspeed}

Set AwayMode for HVAC device
    [Arguments]    ${LocationText}
    Wait until page contains element    ${get_location_button}    ${Default_Timeout}
    Click Element    ${menu_bar}
    Wait until page contains element    ${AwaySettings}    ${Default_Timeout}
    Click Element    ${AwaySettings}
    Sleep    5s
    Click text    ${LocationText}
    Sleep    10s

    Wait until page contains element    ${AwayHVAC_FanSpeed}    ${Default_Timeout}
    ${FanSpeed}    Get text    ${AwayHVAC_FanSpeed}

    ${HeatTemp}    Get text    ${AwayHVAC_HeatTemp}
    ${CoolTemp}    Get text    ${AwayHVAC_CoolTemp}
    ${FanSpeed}    Get text    ${AwayHVAC_FanSpeed}
    Go back
    Run Keyword and Ignore Error    Click Element    ${loginButton}
    Run Keyword and Ignore Error    Click text    OK
    Go back
    RETURN    1    ${HeatTemp}    ${CoolTemp}    ${FanSpeed}

Set Schedule For HVAC Device
    [Arguments]    ${Verify_text_Schedule}
    Sleep    5s
    Click Element    ${schedule_button}

###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}

    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Sleep    5s
    Click text    ${status}
    Sleep    5s
    ${HeatSetpoint}    Get text
    ...    //android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/valueHeatTo"]
    ${CoolSetpoint}    Get text
    ...    //android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/valueCoolTo"]
    ${FanSpeed}    Get text    //android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/modeValue"]
    Go back

########################### Click On Follow Switch according to its current status ON/OFF and Save Schedule Changes #####################
    ${Follow_Sche_status}    Get Element Attribute    ${FollowSchedule_button}    checked
    IF    '${Follow_Sche_status}'=='false'
        Click Element    ${FollowSchedule_button}
    END
    Click Element    ${loginButton}
    Sleep    5s
    RETURN    ${HeatSetpoint}    ${CoolSetpoint}    ${FanSpeed}

Copy HVAC Schedule Data
    [Arguments]    ${Verify_text_Schedule}
    Sleep    5s
    Click Element    ${schedule_button}

###################### Get Current Day #################
    ${currentDay}    Get Current Date    result_format=%A
    

############################## Get Data of Current Day ###############################
    Sleep    ${Sleep_10s}

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time40}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time10}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time20}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time30}    Get text    ${time3}

    @{data_list1}    create list    ${time40}    ${time10}    ${time20}    ${time30}
    Click Element    ${click_copy}

############################################### Copied day############################################################
    
    IF    '${currentDay}'=='Sunday'
        Click text    ${Day_monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click text    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${Day_wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${Day_thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${Day_saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${Day_sunday}
    END
    sleep    2s

    Click text    Save

    sleep    2s

    #############################    Select Next Day according to current day    for copy data    ################################
    IF    '${currentDay}'=='Monday'
        Click text    ${Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click text    ${Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click text    ${Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click text    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click text    ${Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click text    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click text    ${Monday}
    END
    sleep    5s

    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time91}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time92}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time93}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time94}    Get text    ${time3}

    @{data_list2}    create list    ${time91}    ${time92}    ${time93}    ${time94}

    should be equal    ${data_list1}    ${data_list2}

Change Schedule data for HVAC Device
    [Arguments]    ${Verify_text_Schedule}
    Wait until page contains element    ${WH_product_setting}    ${DefaultTimeout}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[0]
    Wait until page contains    ${Verify_text_Schedule}    ${Sleep_10s}

###################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p

########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}
    Go back
    Click Element    ${loginButton}
    Wait until page contains element    ${Schedule_Data}    ${DefaultTimeout}
    Click Element    ${loginButton}

Change Humidity Value in HVAC Device
    ${element_size}    Get Element Size    ${Humidity_Seekbar}
    ${element_location}    Get Element Location    ${Humidity_Seekbar}

Verify BurnTime Value
    Wait until page contains element    ${WH_product_setting}    ${DefaultTimeout}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[3]
    ${BurnTimeValue}    Get text    ${BurnValue}

Verify Altitude Level
    Wait until page contains element    ${WH_product_setting}    ${DefaultTimeout}
    @{WH_product_setting_all_ele}    get webelements    ${WH_product_setting}
    Click Element    ${WH_product_setting_all_ele}[3]
    ${Altitude}    Get text    ${AltitudeValue}

Logout from the existing user account
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_3s}
    Click Element    ${SignOut}
    sleep    ${Sleep_3s}
    Click text    OK
    sleep    ${Sleep_10s}

Validate Diagnostic Mode
    Page should contain text    Diagnostic Mode
    Click text    Diagnostic Mode
    Sleep    5s
    Page should contain text    Connect
    Click text    Connect
    Sleep    5s
    Go back
    Click text    EXIT
    Sleep    1s
    Go back

Create new account with invalid data
    ${c}    set variable    +91
    ${d}    Generate Random String    4    [NUMBERS]
    ${number}    set variable    ${c}${d}

    Sleep    2s
    tap    ${imageLogo}    count=3
    sleep    ${Sleep_5s}
    Wait until page contains    ${envtext}    ${Sleep_20s}
    Click text    ${envtext}
    Wait until page contains    ${saveText}
    Click text    ${saveText}
    Wait until page contains    ${create_text}    ${sleep_10s}
    Click text    ${create_text}
    Wait until page contains    ${createacc_text}    ${sleep_10s}

    Click Element    ${Phone_Number}
    Input Text    ${Phone_Number}    ${number}
    sleep    ${Sleep_5s}
    Page should contain text    Please enter a valid phone number.
    Go back
    Go back

Create new account with valid data
    [Arguments]
    ...    ${name1}
    ...    ${name2}
    ...    ${email}
    ...    ${number}
    ...    ${address_cred}
    ...    ${city_cred}
    ...    ${state_cred}
    ...    ${postalcode_cred}
    ...    ${pass}
    ...    ${conf_pass}
    Wait until page contains    ${app_start_page_text}    ${Sleep_30s}
    Wait until page contains element    ${imageLogo}    ${sleep_5s}
    sleep    ${sleep_3s}
    Click Element    ${imageLogo}
    Sleep    1s
    Click Element    ${imageLogo}
    Sleep    1s
    Click Element    ${imageLogo}
    sleep    ${Sleep_5s}
    Wait until page contains    ${envtext}    ${Sleep_20s}
    Click text    ${envtext}
    Wait until page contains    ${saveText}
    Click text    ${saveText}
    Wait until page contains    ${create_text}    ${sleep_10s}
    Click text    ${create_text}
    Wait until page contains    ${createacc_text}    ${sleep_10s}
    Click Element    ${first_name}
    Input Text    ${first_name}    ${name1}
    sleep    ${Sleep_5s}
    Click Element    ${last_name}
    Input Text    ${last_name}    ${name2}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${email_Add}
    Input Text    ${email_Add}    ${email}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${Phone_Number}
    Input Text    ${Phone_Number}    ${number}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${country}
    sleep    ${sleep_2s}
    Click text    United States
    sleep    ${sleep_2s}
    Click Element    ${AddressCA}
    Input Text    ${AddressCA}    ${address_cred}
    sleep    ${Sleep_2s}
    Go back
    Click Element    ${CityCA}
    Input Text    ${CityCA}    ${city_cred}
    sleep    ${Sleep_2s}
    Go back
    Click Element    ${StateCA}
    Input Text    ${StateCA}    ${state_cred}
    Sleep    ${Sleep_2s}
    Go back
    Click Element    ${Postal_CodeCA}
    Input Text    ${Postal_CodeCA}    ${postalcode_cred}
    sleep    ${Sleep_2s}
    Go back
    Click Element    ${Acc_Pass}
    Input Text    ${Acc_Pass}    ${pass}
    Click Element    ${See_Pass}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${Confirm_Pass}
    Input Text    ${Confirm_Pass}    ${conf_pass}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${check_box}
    Click Element    ${loginButton}
    sleep    ${sleep_5s}
    
    Wait until page contains    ${validate_text}    ${sleep_10s}

    Click text    Submit
    Wait until page contains    ${otp_validation}    ${sleep_30s}
    Click Element    ${OTP_number}
    Input Text    ${OTP_number}    ${otp}
    Go back
    Click Element    ${loginButton}
    sleep    ${sleep_3s}
    Click text    OK
    sleep    ${sleep_30s}
    ${a}    Run Keyword and Return status    page should contain element    ${Location_per_text}
    IF    '${a}'=='True'    Click Element    ${ok_button_validation}
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click Element    ${location_permission_validation}
    ${status}    Run Keyword and Return status    Page should contain text    NOT NOW
    IF    '${status}'=='True'    Click NOT NOW
    sleep    ${sleep_5s}

Current Account Details
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Profile
    Wait until page contains    ${account_text}    ${Sleep_10s}
    ${get_email_id}    Get text    ${get_email}
    Go back
    RETURN    ${get_email_id}

Change Phone number with invalid data
    [Arguments]    ${number}
    Sleep    5s
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Profile
    Wait until page contains    ${account_text}    ${Sleep_10s}
    Click text    Phone Number
    Wait until page contains    Phone Number    ${Sleep_10s}
    Clear Text    ${ChangePhnNumberTextBox}
    Input Text    ${ChangePhnNumberTextBox}    ${number}
    Sleep    1s
    Click text    Save
    Page should contain text    Phone number must have a country code.
    Go back

Change Phone number with valid data
    [Arguments]    ${number}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Profile
    Wait until page contains    ${account_text}    ${Sleep_10s}
    Click text    Phone Number
    Wait until page contains    Phone Number    ${Sleep_10s}
    Clear Text    ${ChangePhnNumberTextBox}
    Input Text    ${ChangePhnNumberTextBox}    ${number}
    Sleep    1s
    Click text    Save
    sleep    ${Sleep_5s}
    Input Text    ${OTP_number}    ${otp}
    Click text    Validate
    Sleep    5s
    Page should contain text    Your phone number has been updated
    Click text    OK
    Sleep    5s
    Page should contain text    ${number}
    Go back

Notification settings
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click Element    ${Notifications}
    sleep    ${sleep_10s}
#    Wait until page contains    ${notification_text}
    Click Element    ${check_box1}
#    Scroll    ${text2}    ${text1}
#    swipe    1014    1150    1014    695
    Click text    ${saveText}
    sleep    ${Sleep_10s}
    Go back

General settings
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click Element    ${General}
    Wait until page contains    ${generalsettings_text}
    Page should contain text    ${temperature_text}
    Go back

Ask Alexa
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click Element    ${AskAlexa}
    Wait until page contains    ${alexa_text}
    Page should contain text    ${launch_alexa_text}
    Go back

Launch Alexa Application Verification
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_10s}
    Click text    ${alexa_text}
    Wait until page contains    ${alexa_text}
    Page should contain text    ${launch_alexa_text}
    Click text    ${launch_alexa_text}
    sleep    ${Sleep_5s}
    Go back
    Page should contain text    ${alexa_text}
    Go back

Frequently asked questions
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_10s}
    Click text    FAQ
    Wait until page contains    Frequently Asked Questions    ${Sleep_20s}
    Go back

Verify App&WiFi Support Details
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Contacts
    Wait until page contains    Contacts    ${Sleep_10s}
    sleep    ${Sleep_5s}
#    Wait until page contains    App & Wi-Fi Support
    Go back

Add New Contractor without selecting device type
    [Arguments]    ${email}    ${phone}
    Sleep    5s
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click Element    ${Contacts}
    Wait until page contains    Contractors    ${Sleep_30s}
    Click text    Add Contractor
    sleep    ${Sleep_5s}
    input text    ${New_contactor_Name}    ${email}
    sleep    ${Sleep_5s}
    Element Should Be Disabled    ${create_account_button}
    Go back

Add new Contractor
    [Arguments]    ${name}    ${email}    ${phone}
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_10s}
    Click Element    ${Contacts}
    Wait until page contains    Contractors    ${Sleep_10s}
    Click text    Add Contractor
    sleep    ${Sleep_5s}
    Wait until page contains    New Contractor    ${Sleep_10s}
    Click Element    ${contractor_checkbox}
    Sleep    ${Sleep_2s}
    Click Element    ${New_contactor_Name}
    input text    ${New_contactor_Name}    ${name}
    Click Element    ${New_contactor_Mail}
    input text    ${New_contactor_Mail}    ${email}
    Click Element    ${New_contactor_Phonenumber}
    input text    ${New_contactor_Phonenumber}    ${phone}
    Go back
    sleep    ${sleep_5s}
    Click text    ${saveText}
    sleep    ${Sleep_5s}
    Wait until page contains    Contractors    ${Sleep_30S}
    sleep    ${sleep_5s}
    Go back

Edit Contractor
    [Arguments]    ${email}    ${number}
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_10s}
    Click text    ${Contacts}
    Wait until page contains    App & Wi-Fi Support    ${Sleep_10s}
    Click Element    ${Contarctor_field}
    Wait until page contains element    ${edit_contractor_button}
    Click Element    ${edit_contractor_button}
    sleep    ${Sleep_5s}
    Click Element    ${New_contactor_Mail}
    input text    ${New_contactor_Mail}    ${email}
    sleep    ${Sleep_5s}
    Go back
    Click Element    ${New_contactor_Phonenumber}
    input text    ${New_contactor_Phonenumber}    ${number}
    Go back
    Click Element    ${loginButton}
    Wait until page contains element    ${edit_contractor_button}

Delete Contractor
    [Arguments]    ${name}
    Click Element    ${Delete_button}
    wait until page does not contain    ${sleep_10s}
    Click text    YES
    Sleep    5s
    Page Should Not Contain Text    ${name}
    Go back

Add new location in current account
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
#    scroll    ${Away_Settings}    ${ask_alexa}
    Click Element    ${Locations&Products}
    sleep    5s

    FOR    ${temp}    IN RANGE    60
        ${Status}    Run Keyword And Return Status    Page should contain text    Add New Location
        IF    ${Status} == False
            swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END
    sleep    ${sleep_2s}
    Click text    Add New Location
    sleep    ${sleep_10s}
    Click text    Use My Current Location
    sleep    ${Sleep_10s}
    ${a}    Run Keyword and Return status    Location validation
    IF    '${a}'=='True'    Click text    OK
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click text    ${location_per}
#    Page should contain text    Where is the product installed?
    sleep    ${Sleep_5s}
    ${a}    Run Keyword and Return status    Page should contain text    OK
    IF    '${a}'=='True'    Click text    OK
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click text    While using the app
    ${status}    Run Keyword and Return status    Not Now validation
    IF    '${status}'=='True'    Click NOT NOW
    Click text    Next
    Wait until page contains    Add Device    ${Sleep_5s}
    Go back
    Wait until page contains    ${Exit_text}    ${Sleep_10s}
    Click text    ${Exit_text}
    sleep    ${Sleep_10s}
    Click Element    ${back_screen}
    
#    Go back
#    Go back
#    Go back

Edit location name
    [Arguments]    ${LocatioName}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Locations & Products
    sleep    ${Sleep_5s}
    Click text    Testing
    Click Element    ${location_edit}
    clear text    ${edit_location_name}
    Input Text    ${edit_location_name}    ${LocatioName}
    sleep    ${Sleep_5s}
    Click text    Save
    sleep    30s
    Go back

Delete Location name
    ${Status}    Run Keyword and Return status    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    IF    ${Status} == True    Click Element    ${menu_bar}
    sleep    5s
    Click text    Locations & Products
    sleep    ${Sleep_5s}
    Click Element    Testing
    Sleep    5s
    Wait until page contains Element    ${deleteLocationICon}    ${default_timeout}
    Click Element    ${deleteLocationICon}
    sleep    ${Sleep_5s}
    Click text    OK
    sleep    ${Sleep_30s}
    Go back
    sleep    3s
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}

Set Away mode to multiple devices
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    5s
    Click text    Away Settings
    sleep    ${Sleep_10s}
    Click text    HPWH
    sleep    3s
    ${status}    Get Element attribute    ${away_toggel_button}    checked
    IF    '${status}'=='false'    Away Toggle button

Disable all Devices from Away mode
    Sleep    5s
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    5s
    Click text    Away Settings
    sleep    ${Sleep_10s}
    Click text    HPWH
    sleep    3s
    ${status}    Get Element attribute    ${away_toggel_button}    checked
    IF    '${status}'=='true'    Away Toggle button

Disable one device and Enable one device
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    ${away_text}
    sleep    ${Sleep_5s}
    Wait until page contains    ${away_text}    ${Sleep_30s}
    Click text    ${location_name}
    sleep    ${Sleep_5s}
    Click text    ${done_text}
    sleep    ${Sleep_10s}
    Go back
    Wait until page contains element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${Location_Away_icon}
    sleep    ${Sleep_10s}
    page should not contain element    ${Dashboard_Away_icon}
    sleep    ${Sleep_5s}
    Click Element    ${Location_Away_icon}
    sleep    ${Sleep_5s}

Email Contractor from the Alert
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${notification_icon}
    sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains Element
    ...    ${notification_alert_text}
    ...    ${default_timeout}
    IF    ${Status} == True
        sleep    ${Sleep_5s}
        Click Element    ${notification_alert_text}
        sleep    ${Sleep_5s}
        Page should contain text    Forward to Contractor
        sleep    ${Sleep_5s}
        Page should contain text    Clear Alert
    END
    Go back

Verfiy Alerts On Detail Page
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${notification_icon}
    sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains Element
    ...    ${notification_alert_text}
    ...    ${default_timeout}
    IF    ${Status} == True
        sleep    ${Sleep_5s}
        Click Element    ${notification_alert_text}
        sleep    ${Sleep_5s}
        Page should contain text    Forward to Contractor
        sleep    ${Sleep_5s}
        Page should contain text    Clear Alert
    END
    Go back

Clear Alerts from the Dashboard notification
    sleep    ${Sleep_5s}
    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains Element
    ...    ${notification_alert_text}
    ...    ${default_timeout}
    IF    ${Status} == True
        sleep    ${Sleep_5s}
        Click Element    ${notification_alert_text}
        sleep    ${Sleep_5s}
        Page should contain text    Forward to Contractor
        sleep    ${Sleep_5s}
        Page should contain text    Forward to Contractor
        Click text    Clear Alert
        Sleep    5s
        Click text    OK
        Sleep    10s
    END
    Go back

Reprovision disconnected device
    sleep    ${Sleep_5s}
    Page should contain text    Disconnected
    Click text    Disconnected
    Wait until page contains    Connect Now    ${Sleep_10s}
    Click text    Connect Now
    Go back
    Click text    EXIT

Zone settings page
    sleep    ${Sleep_10s}
#    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
#    Scroll    ${Away_Settings}    ${Location_&_Products}
    Click Element    ${ZoneNames}
    Wait until page contains    ${zone_page_text}    ${Sleep_10s}
    Click Element    ${back_screen}
    

Edit zone device name with blank values
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Zone Settings
    Sleep    5s
    Click text    Zone
    sleep    ${Sleep_5s}
    Click text    EcoNet Control C
    sleep    ${Sleep_5s}
    clear text    ${ZoneNameEdit}
    sleep    ${Sleep_5s}
    Element Should Be Visible    //android.widget.Button[@text='Save']
    Go back
    Go back
    Go back

Edit Zone Device Name With Valid Data
    [Arguments]    ${name}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Zone Settings
    Sleep    5s
    Click text    Zone
    sleep    ${Sleep_5s}
    Click text    EcoNet Control C
    sleep    ${Sleep_5s}
    clear text    ${ZoneNameEdit}
    Input Text    ${ZoneNameEdit}    ${name}
    Click text    Save
    sleep    20s
    Page should contain text    ${name}
    Go back
    Go back

Change Password with invalid data
    [Arguments]    ${current_pass1}    ${new_pass}    ${conf_pass}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Profile
    Wait until page contains    ${account_text}    ${Sleep_10s}
    Click text    Password
    Input Text    //*[@text="Current Password"]    ${current_pass1}
    sleep    ${Sleep_5s}
    Input Text    //*[@text="New Password"]    ${new_pass}
    Input Text    //*[@text="Confirm New Password"]    ${conf_pass}
    Click text    Save
    Sleep    5s
    Page should contain text    Current password is incorrect
    Click text    OK
    Go back
    Go back

Change Password with valid data
    [Arguments]    ${current_pass1}    ${new_pass}    ${conf_pass}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Profile
    Wait until page contains    ${account_text}    ${Sleep_10s}
    Click text    Password
    Input Text    //*[@text="Current Password"]    ${current_pass1}
    sleep    ${Sleep_5s}
    Input Text    //*[@text="New Password"]    ${new_pass}
    Input Text    //*[@text="Confirm New Password"]    ${conf_pass}
    Click text    Save
    Sleep    5s
    Page should contain text    Current password is incorrect
    Click text    OK
    Go back
    Go back

Forgot password with invalid data
    Sleep    5s
    Click text    Sign In
    Sleep    5s
    Click text    Forgot Password?
    Click text    Continue
    Input Text    //*[@text="Phone"]    +919934545656
    sleep    ${Sleep_5s}
    Click text    Submit
    sleep    ${Sleep_10s}
    Page should contain text    User is not associated with provided phone number
    Click text    OK
    Go back
    Go back

Forgot password with valid data
    Sleep    5s
    Click text    Forgot Password?
    Click Element    Continue
    Input Text    //*[@text="Phone"]    +919934545656
    sleep    ${Sleep_5s}
    Click text    Submit
    sleep    ${Sleep_10s}
    Page should contain text    Success
    Click text    OK
    Go back
    Go back

sign in after forgot password
    [Arguments]    ${emailId}    ${change_password}
    Wait until page contains    ${sign_in_text}    ${Sleep_10s}
    Click text    ${sign_in_text}
    Wait until page contains element    ${userName}
    Click Element    ${userName}
    Input Text    ${userName}    ${emailId}
    Wait until page contains element    ${password}
    Click Element    ${password}
    Input Text    ${password}    ${change_password}
    Hide Keyboard
    Wait until page contains element    ${loginButton}
    Click Element    ${loginButton}
    sleep    ${Sleep_30s}
    ${a}    Run Keyword and Return status    Location validation
    IF    '${a}'=='True'    Click Element    ${ok_button_validation}
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click Element    ${location_permission_validation}
    ${status}    Run Keyword and Return status    Not Now validation
    IF    '${status}'=='True'    Click NOT NOW
    sleep    ${sleep_3s}
    Wait until page contains Element    ${notification_icon}    ${Sleep_30s}

Edit product name for selected location
    [Arguments]    ${name}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Locations & Products
    sleep    ${Sleep_5s}
    Click Element    //android.widget.ImageView[@resource-id="com.rheem.econetconsumerandroid:id/locationArrow"]

    Sleep    5s
    Click Element    ${Edit_product_name}
    Sleep    5s
    Clear Text    ${edit_location_name}
    Input Text    ${edit_location_name}    ${name}
    Click text    Save
    sleep    ${Sleep_5s}
    Go back
    Go back
    Go back

Delete product for selected location
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Click text    Locations & Products
    sleep    ${Sleep_5s}
    Click text    //android.widget.ImageView[@resource-id="com.rheem.econetconsumerandroid:id/locationArrow"]

    Sleep    5s
    Click Element    ${Edit_product_name}
    Sleep    5s
    Click Element    ${deleteLocationICon}
    Click text    OK
    sleep    ${Sleep_5s}
    Go back
    Go back

Navigate to Privacy Notice page
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    5s
    Click Element    ${PrivacyNotice}
    sleep    5s
    Go back

Set Pre-Scheduled Away
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Scheduled Away/Vacation
    Sleep    5s
    ${time}    Get Current Date    result_format=%d
    ${time}    Remove String    ${time}    0
    
#    ${time}    evaluate    ${current_time}+1
    
    Click text    HPWH
    Wait until page contains    HPWH    ${Sleep_5s}
    Click text    Set Date
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    2s
    Click text    OK

    Click Element    //android.widget.TextView[@text='Set Date' and @index='6']
    ${time}    Evaluate    ${time} + 1
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    2s
    Click text    OK
    Sleep    5s
    Click text    Save
    Sleep    5s
    Page should contain text    Scheduled Away/Vacation configured
    Click text    OK
    Sleep    1s
    Page should contain text    HPWH
    Go back

Away settings page
    sleep    ${Sleep_10s}
#    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click Element    ${AwaySettings}
    Wait until page contains    Away Settings    ${Sleep_5s}
    Page should contain text    Geofencing Settings

Scheduled Away/Vacation Settings
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click Element    ${ScheduledAway/Vacation}
    Wait until page contains    Scheduled Away
    Sleep    ${Sleep_3s}
    Go back

Set Pre-Scheduled Home
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Scheduled Away/Vacation
    Sleep    5s
    ${time}    Get Current Date    result_format=%d
    ${time}    Remove String    ${time}    0
    
#    ${time}    evaluate    ${current_time}+1
    
    Click text    HPWH
    Wait until page contains    HPWH    ${Sleep_5s}
    Click text    State Away
    Sleep    2s
    Click text    Home
    Sleep    2s
    Click text    Set Date
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    2s
    Click text    OK

    Click Element    //android.widget.TextView[@text='Set Date' and @index='6']
    ${time}    evaluate    ${time} + 1
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    1s
    Click text    OK
    Sleep    1s
    Click text    Save
    Sleep    5s
    Page should contain text    Scheduled Away/Vacation configured
    Click text    OK
    Sleep    1s
    Page should contain text    HPWH
    Go back

Check Pre-Scheduled Away Status
    [Arguments]    ${value}
    Wait until page contains element    ${notification_icon}    ${Sleep_5s}
    ${text}    Get text    ${get_Away_status}
    should be equal as strings    ${text}    I'm Away
    page should contain element    ${Location_Away_icon}

Delete Pre-Scheduled Event
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Scheduled Away/Vacation
    Sleep    5s
    Click Element    //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/includeHeaderSkip']
    Sleep    5s
    Click Element
    ...    //android.widget.ImageView[@resource-id='com.rheem.econetconsumerandroid:id/imgDeletePreScheduleConfig']
    Click text    OK
    Sleep    10s
    Go back
    Go back

Check Pre-Scheduled Home Status
    [Arguments]    ${value}
    Wait until page contains element    ${notification_icon}    ${Sleep_5s}
    ${text}    Get text    ${get_Away_status}
    sleep    ${Sleep_5s}
    should be equal as strings    ${text}    I'm Home
    sleep    ${Sleep_5s}
    page should not contain element    ${Dashboard_Away_icon}

Change Pre-Scheduled Status
    [Arguments]    ${value}
    Wait until page contains element    ${notification_icon}    ${Sleep_5s}
    ${text}    Get text    ${get_Away_status}
    sleep    ${Sleep_5s}
    page should contain element    ${Dashboard_Away_icon}

Check Pre-scheduled Event List after Followed
    Wait until page contains element    ${notification_icon}    ${Sleep_5s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    scroll    ${general_settings}    ${notification_settings}
    sleep    ${Sleep_5s}
    Click text    Scheduled Away/Vacation
    sleep    ${Sleep_5s}
    Wait until page contains element    ${Scheduled_Events}    ${Sleep_5s}
    Click Element    ${Scheduled_Events}
    sleep    ${Sleep_5s}
    sleep    ${Sleep_5s}
    page should contain element    ${Pre-Scheduled_No_Data}
    Go back
    page should contain element    ${Scheduled_Events}
    Go back

Away Settings OFF Create Pre-Scheduled Event
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    5s
    Click text    Away Settings
    sleep    ${Sleep_10s}
    Click text    HPWH
    sleep    3s
    ${status}    Get Element attribute    ${away_toggel_button}    checked
    IF    '${status}'=='true'    Away Toggle button
    Go back
    Go back
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Scheduled Away/Vacation
    Sleep    5s
    ${time}    Get Current Date    result_format=%d
    ${time}    Remove String    ${time}    0
    
#    ${time}    evaluate    ${current_time}+1
    
    Click text    HPWH
    Wait until page contains    HPWH    ${Sleep_5s}
    Click text    Set Date
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    2s
    Click text    OK

    Click Element    //android.widget.TextView[@text='Set Date' and @index='6']
    ${time}    Evaluate    ${time} + 1
    Click Element    //android.view.View[@index='${time}']
    Click text    OK
    Sleep    2s
    Click text    OK
    Sleep    5s

    Click text    OK
    Click text    Save
    Sleep    5s

Enable Geo Fencing
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Away Settings
    Wait until page contains    Away Settings
    Click text    Geofencing Settings
    sleep    ${Sleep_5s}
    ${beforeToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    Click Element    ${GeoFencing_Switch}
    Click text    Save
    sleep    30s
    Page should contain text    Away settings have been configured successfully.
    Click text    OK
    Sleep    5s
    ${AfterToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    Should Not Be Equal    ${AfterToggleChanged}    ${beforeToggleChanged}
    Go back
    Go back

Select Location For Geo Fencing
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Away Settings
    Wait until page contains    Away Settings
    Click text    Geofencing Settings
    sleep    ${Sleep_5s}
    Click text    Current Location
    Click text    HPWH
    ${beforeToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    Click Element    ${GeoFencing_Switch}
    Click text    Save
    sleep    30s
    Page should contain text    Away settings have been configured successfully.
    Click text    OK
    Sleep    5s
    ${AfterToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    Should Not Be Equal    ${AfterToggleChanged}    ${beforeToggleChanged}
    Go back
    Go back

Select Distance Unit For Geo Fencing
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Away Settings
    Wait until page contains    Away Settings
    Click text    Geofencing Settings
    Sleep    5s
    ${AfterToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    IF    '${AfterToggleChanged}'=='false'
        Click Element    ${GeoFencing_Switch}
    END
    Click text    Distance Unit
    Click text    Kilometers
    Page should contain text    Kilometers
    sleep    ${Sleep_5s}
    Run Keyword And Ignore Error    Click text    ${location_per}
    Click text    Save
    sleep    ${Sleep_5s}
    Run Keyword And Ignore Error    Click text    OK
    Go back
    Go back

Set Home/Away Radius For Geo Fencing
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Away Settings
    Wait until page contains    Away Settings
    Click text    Geofencing Settings
    sleep    ${Sleep_5s}
    ${beforeToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    IF    '${beforeToggleChanged}'=='false'
        Click Element    ${GeoFencing_Switch}
    END
    Sleep    2s
    Click text    Radius
    Sleep    2s
    ${a}    Run Keyword and Return status    Page should contain text    OK
    IF    '${a}'=='True'    Click text    OK
    ${b}    run keyword and return status    Page should contain text    ${location_per}
    IF    '${b}'=='True'    Click text    ${location_per}
    Sleep    5s
    ${Locationx}    Get Element Location
    ...    //android.widget.SeekBar[@resource-id='com.rheem.econetconsumerandroid:id/radiusBar']
    
    Click Element At Coordinates    ${Locationx}[x]    ${Locationx}[y]
    ${value}    Get text
    ...    //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/radiusDescription']
    Go back
    Page should contain text    ${value}
    Click text    Save
    sleep    30s
    Run Keyword And Ignore Error    Click text    OK
    Sleep    5s
    Go back
    Go back

Disable Geo Fencing For Home/Away
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    Away Settings
    Wait until page contains    Away Settings
    Click text    Geofencing Settings
    Sleep    5s
    ${AfterToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    IF    '${AfterToggleChanged}'=='true'
        Click Element    ${GeoFencing_Switch}
    END
    Sleep    10s
    ${AfterToggleChanged}    Get Element Attribute    ${GeoFencing_Switch}    checked
    Should Be Equal    false    ${AfterToggleChanged}
    Go back
    Go back

Add Econet WiFi Connection
    [Arguments]    ${homewifiname1}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${EconetWifi}
    Wait until page contains element    ${AddButton}    ${Sleep_5s}
    Click Element    ${AddButton}
    Sleep    ${Sleep_3s}
    Click Element    ${EconetWifi_field}
    Input Text    ${EconetWifi_field}    ${homewifiname1}
    Go back
    Click text    Save
    Sleep    ${Default_Timeout}
    Page should contain text    ${homewifiname1}
    Go back
    Go back

Edit Econet WiFi Connection Name
    [Arguments]    ${EconetSSID_inputtext}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${EconetWifi}
    Wait until page contains element    ${AddButton}    ${Sleep_5s}
    Click Element    ${SSIDEdit}
    Sleep    ${Sleep_3s}
    Clear Text    ${EconetWifi_field}
    Input Text    ${EconetWifi_field}    ${EconetSSID_inputtext}12
    Click text    Save
    Sleep    ${Default_Timeout}
    Page should contain text    ${EconetSSID_inputtext}12
    Go back
    Go back

Remove Econet WiFi Connections
    ${Status}    Run Keyword And Return Status    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    IF    ${Status} == True    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${EconetWifi}
    Wait until page contains element    ${EconetWifi_delete}    ${Sleep_5s}
    Click Element    ${EconetWifi_delete}
    Sleep    5s
    Click text    YES
    Go back
    Go back

Add HomeRouter SSID
    [Arguments]    ${EconetSSID_inputtext}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${HomeWiFi}
    Wait until page contains element    ${AddButton}    ${Sleep_5s}
    Click Element    ${AddButton}
    Sleep    ${Sleep_3s}
    Click Element    ${EconetWifi_field}
    Input Text    ${EconetWifi_field}    ${EconetSSID_inputtext}
    Go back
    Click text    Save
    Sleep    ${Default_Timeout}
    Page should contain text    ${EconetSSID_inputtext}
    Go back
    Go back

Edit HomeRouter SSID
    [Arguments]    ${EconetSSID_inputtext}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${HomeWiFi}
    Wait until page contains element    ${AddButton}    ${Sleep_5s}
    Click Element    ${SSIDEdit}
    Sleep    ${Sleep_3s}
    Clear Text    ${EconetWifi_field}
    Input Text    ${EconetWifi_field}    ${EconetSSID_inputtext}12
    Click text    Save
    Sleep    ${Default_Timeout}
    Page should contain text    ${EconetSSID_inputtext}
    Go back
    Go back

Add HomeRouter SSID with None Type
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${HomeWiFi}
    Wait until page contains element    ${AddButton}    ${Sleep_5s}
    Click Element    ${AddButton}
    Sleep    ${Sleep_3s}
    Click Element    ${EconetWifi_field}
    Input Text    ${EconetWifi_field}    ${EconetSSID_inputtext}
    Go back
    Click text    Save
    Sleep    ${Default_Timeout}
    Page should contain text    ${EconetSSID_inputtext}
    Go back
    Go back

Remove HomeRouter SSID
    ${Status}    Run Keyword And Return Status    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    IF    ${Status} == True    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click text    General
    sleep    5s
    Click text    ${HomeWiFi}
    Wait until page contains element    ${EconetWifi_delete}    ${Sleep_5s}
    Click Element    ${EconetWifi_delete}
    Click text    YES
    Go back
    Go back

Navigate To Zone Detail Page
    [Arguments]    ${locationName}
    Wait until page contains element    ${locationName}    ${Sleep_30s}
    Click Element    ${locationName}
    sleep    ${Sleep_5s}

Navigate To Main Zone Detail Screen
    Sleep    2s
    Click text    EcoNet Control C
    sleep    5s

Navigate To Sub Zone Device Detail Screen
    Wait until page contains element
    ...    //android.widget.FrameLayout[@index="1"]/android.widget.FrameLayout[@resource-id="com.rheem.econetconsumerandroid:id/zoneCard"]
    ...    ${Sleep_10s}
    Click Element
    ...    //android.widget.FrameLayout[@index="1"]/android.widget.FrameLayout[@resource-id="com.rheem.econetconsumerandroid:id/zoneCard"]
    sleep    5s

Zone Set Mode
    [Arguments]    ${mode}
    Wait until page contains    ${HVAC_Mode}    ${Default_Timeout}
    Click text    ${HVAC_Mode}
    sleep    ${Sleep_5s}
    Click text    ${mode}
    sleep    ${Sleep_3s}
    RETURN    ${mode}

Zone Get Mode
    Wait until page contains element    ${ZoneModeDP}    ${Sleep_30s}
    ${mode}    Get text    ${ZoneModeDP}
    
    RETURN    ${mode}

Verify menu options
    Wait until page contains Element    ${notification_icon}    ${Sleep_10s}
    Click Element    ${menu_bar}
    Sleep    ${Sleep_3s}
    Page Should Contain Element    ${Profile}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${Notifications}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${General}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${SignOut}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${Locations&Products}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${ZoneNames}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${AwaySettings}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${ScheduledAway/Vacation}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${AskAlexa}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${Contacts}
    Sleep    ${Sleep_2s}
    Page Should Contain Element    ${FAQ}
    Sleep    ${Sleep_2s}
    Go back
    Wait until page contains Element    ${notification_icon}    ${Sleep_30s}

change account details
    [Arguments]    ${name1}    ${name2}
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}
    sleep    ${Sleep_5s}
    Click Element    ${Profile}
    Wait until page contains    ${account_text}    ${Sleep_10s}
    Click Element    ${get_email}
#    Wait until page contains    ${change_name_text}    ${sleep_10s}
    Click Element    ${change_first_name}
    Input Text    ${change_first_name}    ${name1}
    Go back
    Click Element    ${change_last_name}
    Input Text    ${change_last_name}    ${name2}
    Go back
    Click text    Save
    sleep    ${sleep_5s}
    Wait until page contains    Success
    Click text    OK
    Wait until page contains    ${account_text}    ${Sleep_10s}
    ${get_name}    Get text    ${get_email}
    Go back
    RETURN    ${get_name}

Away Toggle button
    Click Element    ${away_toggel_button}
    sleep    ${Sleep_3s}
    Click text    Save
    Wait until page contains    Success    ${sleep_20s}
    Click text    OK

Set HPWH into the away mode
    [Arguments]    ${location}
    Wait until page contains    ${location}    ${sleep_10s}
    Click text    ${location}
    Wait until page contains    ${location}    ${sleep_10s}
    sleep    ${sleep_20s}
    ${status}    Get Element attribute    ${away_toggel_button}    checked
    IF    '${status}'=='false'    Away Toggle button
    Go back
    Go back

Disable HPWH into the away mode
    [Arguments]    ${location}
    Wait until page contains    ${location}    ${sleep_10s}
    Click text    ${location}
    Wait until page contains    ${location}    ${sleep_10s}
    sleep    ${sleep_20s}
    sleep    ${sleep_20s}
    ${status}    Get Element attribute    ${away_toggel_button}    checked
    IF    '${status}'=='false'    Away Toggle button
    Go back
    Go back

Navigate Back to the Sub Screen
    Go back
    Wait until page contains    Settings    ${Sleep_5s}

Navigate Back to the Screen
    Go back

Set Schedule in Screen
    [Arguments]    ${setpoint}    ${Decrement_Temp}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p
########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Wait Until Element is Visible    //android.widget.TextView[@text='${status}']    ${sleep_10s}
    Click Element    //android.widget.TextView[@text='${status}']

    Sleep    2s

    ${temp}    Get text    ${current_schedule_Temp}
    FOR    ${temp}    IN RANGE    60
        ${updatedTemp}    Get text    ${current_schedule_Temp}
        IF    ${updatedTemp} == ${SetPoint}    BREAK
        Click Element    ${Decrement_Temp}
        sleep    2s
    END

    Should be equal as integers    ${updatedTemp}    ${SetPoint}

    Wait Until Element Is Visible    ${create_account_button}    ${sleep_10s}
    Click Element    ${create_account_button}

    Go back
    Go back

Set Schedule in Screen Maximum temp
    [Arguments]    ${setpoint}    ${Increment_Temp}
    Wait until page contains element    ${WH_product_setting}    ${Sleep_10s}
    ${get_set_point_value}    Get text    ${WH_get_SetPointValue}
    ${get_mode_name}    Get text    ${WH_changemode}
    Click Element    ${schedule_button}
    sleep    10s

####################### Get Current Time #################
    ${current_time}    Get Current Date    result_format=%I:%M %p
########################### Get Current Time Slot from the schedule screen #################################
    Wait Until Element is Visible    ${time0}    ${Sleep_5s}
    ${time0}    Get text    ${time0}

    Wait Until Element is Visible    ${time1}    ${Sleep_5s}
    ${time1}    Get text    ${time1}

    Wait Until Element is Visible    ${time2}    ${Sleep_5s}
    ${time2}    Get text    ${time2}

    Wait Until Element is Visible    ${time3}    ${Sleep_5s}
    ${time3}    Get text    ${time3}

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        set global variable    ${status}    ${time0}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        set global variable    ${status}    ${time1}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        set global variable    ${status}    ${time2}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        set global variable    ${status}    ${time3}
    ELSE
        set global variable    ${status}    ${time3}
    END

    Wait Until Element is Visible    //android.widget.TextView[@text='${status}']    ${sleep_10s}
    Click Element    //android.widget.TextView[@text='${status}']

    Sleep    2s

    ${temp}    Get text    ${current_schedule_Temp}
    FOR    ${temp}    IN RANGE    60
        ${updatedTemp}    Get text    ${current_schedule_Temp}
        IF    ${updatedTemp} == ${SetPoint}    BREAK
        Click Element    ${Increment_Temp}
        sleep    2s
    END

    Should be equal as integers    ${updatedTemp}    ${SetPoint}

    Wait Until Element Is Visible    ${create_account_button}    ${sleep_10s}
    Click Element    ${create_account_button}

    Go back
    Go back

Verify Device Alerts
    [Arguments]    ${name}

#    Wait until page contains Element    //XCUIElementTypeStaticText[@name="${name}"]
    Wait until page contains Element    ${Alert_list}
    Click Element    ${Alert_list}
    Wait until page contains Element    ${create_account_button}    ${sleep_5s}
#    Wait until page contains Element    //XCUIElementTypeStaticText[@name="Clear Alert"]
    Click Element    ${create_account_button}

    # Forward Contractor
    Sleep    5s
    Wait until page contains Element
    ...    //XCUIElementTypeSheet[@name="Choose Contractor"]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeScrollView[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]
    Click Element    Cancel

    # Clearing Alerts
    Wait until page contains Element    ${Choose_Contractor}
    Click Element    ${Choose_Contractor}
    Click Element    ${button_OK}
    Sleep    5s

    Go back

Generate the random Email
    ${string}    generate random string    4    [LOWER]
    ${randEmail}    catenate    rheemautomation+${string}@gmail.com
    RETURN    ${randEmail}

Generate the random Number
    ${number}    generate random string    8    0123456789
    ${phoneNumber}    catenate    +9199${number}
    RETURN    ${phoneNumber}

Delete user account
    Click Element    ${menu_bar}
    sleep    ${sleep_2s}
    Click Element    ${profile}
    sleep    ${Sleep_5s}
    Click Element    ${delete_account_button}
    Wait until page contains element    ${delete_account}
    Click Element    ${delete_account}
    Wait until page contains    ${app_start_page_text}    ${Sleep_30s}

Update Heating Setpoint Using Button
    [Arguments]    ${SetPoint}    ${Locator}

    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}'=='False'    Click Element    ${SwitchToButton}

    FOR    ${i}    IN RANGE    0    60
        Wait Until Element is Visible    ${HeatButtonSetPoint}    ${default_timeout}
        ${Heat}    Get text    ${HeatButtonSetPoint}
        
        IF    ${Heat} == ${SetPoint}    BREAK
        Click Element    ${Locator}
        Sleep    2s
    END

    Sleep    5s
    RETURN    ${Heat}


Update Cooling Setpoint Using Button
    [Arguments]    ${SetPoint}    ${Locator}

    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains Element
    ...    ${HeatPlusButton}
    ...    ${default_timeout}
    IF    '${Status}==False'    Click Element    ${SwitchToButton}

    FOR    ${i}    IN RANGE    0    60
        Wait Until Element is Visible    ${CoolButtonSetPoint}    ${default_timeout}
        ${Heat}    Get text    ${CoolButtonSetPoint}
        
        IF    ${Heat} == ${SetPoint}    BREAK
        Click Element    ${Locator}
        Sleep    2s
    END
    Sleep    5s
    RETURN    ${Heat}

Change Temp Unit Fahrenheit From Device
    [Arguments]    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    
    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    10s

Set Fan Speed
    [Arguments]    ${MOde}
    Sleep    2s
    Click text    Fan Speed
    Sleep    2s
    Click text    ${MOde}
    Sleep    2s

Go to Menubar
    Wait until page contains Element    ${menu_bar}    ${Sleep_10s}
    Click Element    ${menu_bar}


Create DR Program Request
    Wait until element is visible    ${DRProgramCard}    10s
    Click Element    ${DRProgramCard}
    Sleep    20s
    Click Text    Sign Up Now
    FOR    ${temp}    IN RANGE    3
        ${Status}    Run Keyword And Return Status    Wait until element is visible    ${DRSignUpCheckbox}    ${defaultwaittime}
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END
    Wait until element is visible    ${DRSignUpCheckbox}    ${defaultwaittime}
    Click Element    ${DRSignUpCheckbox}
    Click Text    Continue
    Sleep    2s
    FOR    ${temp}    IN RANGE    4
        ${Status}    Run Keyword And Return Status    Element Should Be Enabled    //*[@text="I Agree"]
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END

    Click Text    I Agree

Navigate to the Energy & Savings Page

    Click Text    Energy & Savings
    Sleep    20s


Select Location from Energy & Savings Screen
    [Arguments]    ${locationname}    ${devicename}

    Wait Until Element is visible     ${DRLocationSelection}
    Click Element    ${DRLocationSelection}

    Sleep  2s
    Click Text    ${locationname}
    Click Text    ${devicename}
    Sleep    20s

Google Communication with Question
    [Arguments]    ${speaker}    ${question}    ${expected_answer}    ${language}
    Log    \n\n===> Starting commnunication    console=yes
    ${status}    ${response}    alexa_comm   ${question}    ${expected_answer}    ${language}
    Log    Response status: ${status}    console=yes
    RETURN    ${status}    ${response}

Alexa Communiation with Question
    [Arguments]    ${speaker}    ${question}    ${expected_answer}    ${language}
    Log    \n\n===> Starting commnunication    console=yes
    ${status}    ${response}    alexa_comm    ${question}    ${expected_answer}    ${language}
    Log    Response status: ${status}    console=yes
    RETURN    ${status}    ${response}