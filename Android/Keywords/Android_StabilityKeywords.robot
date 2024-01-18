*** Settings ***
Documentation       Android Mobile Stability Keywords

Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            ../Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot


*** Variables ***
#    -->cloud url and env
${URL}                              https://rheemdev.clearblade.com
${URL_Cloud}                        https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                           f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                           F280E3C80B8CA1FB8FE292DDE458

#    --> admin cred
${Admin_EMAIL}                      automation@rheem.com
${Admin_PWD}                        12345678

${emailId}                          automation2@rheem.com
${passwordValue}                    12345678

#    --> Device MAC and Device ID

${Device_Mac_Address}               40490F9E66D5
${Device_Mac_Address_In_Formate}    40-49-0F-9E-66-D5
${EndDevice_id}                     4126
# ${EndDevice_id}    4736

#    --> Setpoint Values
${setpoint_max}                     140
${setpoint_min}                     110

#    --> Mobile Device&App Info
${REMOTE_URL}                       http://127.0.0.1:4729/wd/hub
${PLATFORM_NAME}                    Android
${DEVICE_NAME}                      ZY223WMBRP
${PLATFORM_VERSION}                 7.0
${APP_ACTIVITY}                     com.rheem.econet.view.splash.SplashActivity
${PACKAGE_NAME}                     com.rheem.econetconsumerandroid
${APP_LOCATION}                     /home/ashu/Stability testing/Rheem-E2E-Android-App2.0/Android_apk/rheem.apk
${AUTOMATION_NAME}                  UiAutomator2
${TIME_OUT}                         100
${No_Reset}                         True
${Full_Reset}                       False
${deviceText}                       //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

${X_max_value}                      1050
${Y_max_value}                      1755
${emailId}                          automation@rheem.com
${passwordValue}                    12345678

#    --> Labels
${Location_Guide}                   Welcome to the EcoNet app.
${Away_Guide}                       Switch between Home and Away settings to maximize energy savings
${Alerts_Guide}                     Account Alerts
${app_start_page_text}              Connecting you to greater savings, protection and convenience
${Rheem_Package}                    com.rheem.econetconsumerandroid

# --> Locators
${Start_Page}                       //android.widget.FrameLayout[@resource-id= 'android:id/content']
${imageLogo}                        //android.widget.ImageView[@index = '0']
${Create_account}                   //android.widget.TextView[@text = 'Create account']
${loginButton}                      //android.widget.TextView[@text = 'Sign in']
${Forgot_Pass}                      //android.widget.Button[@resource-id = 'com.rheem.econetconsumerandroid:id/forgot_password_button']
${userName}                         //android.widget.EditText[@resource-id = 'com.rheem.econetconsumerandroid:id/login_email_text']
${password}                         //android.widget.EditText[@resource-id = 'com.rheem.econetconsumerandroid:id/login_password_text']

# -->Time in seconds
${bkgTime}                          15
${lockTime}                         15
${loopCount1}                       125
${loopCount2}                       100
${loopCount5}                       20
${loopCount6}                       50
${loopCount8}                       80
${loopCount9}                       80
${loopCount10}                      100
${loopCount11}                      80
${loopCount12}                      280
${lockloop}                         4
${ConnectionStatus}                 2

${select_HPWH_location}             HPWH
${deviceText}                       Heat Pump Water Heater Gen 4
@{HPWH_modes_List}                  OFF    ENERGY SAVING    HEAT PUMP ONLY    HIGH DEMAND    ELECTRIC MODE
@{HPWHGen5_modes_List}              Off    Energy Saver    Heat Pump    High Demand    Electric    Vacation
# ${deviceText}    Heat Pump Water Heater Gen5

# -->Data For Another Application
${REMOTE_URL1}                      http://127.0.0.1:4723/wd/hub
${PACKAGE_NAME1}                    com.flipkart.android

# --> Sleep Times
${Sleep_5s}                         5s
${Sleep_10s}                        10s
${Sleep_20s}                        20s
${Sleep_30S}                        30s
${Sleep_60s}                        60s


*** Keywords ***
Relaunch Application
    Open Application
    ...    remote_url=${REMOTE_URL}
    ...    newCommandTimeout=${TIME_OUT}
    ...    alias=Rheem
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    app=${APP_LOCATION}
    ...    appActivity=${APP_ACTIVITY}
    ...    deviceName=${DEVICE_NAME}
    ...    automationName=uiautomator2

Click At Random Coordinate
    FOR    ${index}    IN RANGE    ${randomClickCount}
        ${x}    Generate random string    3    123456789
        ${y}    Generate random string    3    123456789
        sleep    1s
        click element at coordinates    ${x}    ${y}
    END
    sleep    3s

Multitouch log on failure
    [Arguments]    ${status}    ${result}
    IF    '${status}'=='FAIL'
        log    =======Failure detected:${result}=======    console=yes    level=ERROR
        save screenshot with timestamp
        Temporary Keyword
    END

MultipleTouch action on app startup screen
    sleep    3s
    
    wait until page contains    ${app_start_page_text}    10s
    For    ${index}    IN RANGE    20
    ${x}    Generate random string    3    123456789
    ${y}    Generate random string    3    123456789
    sleep    1s
    click element at coordinates    ${x}    ${y}
    sleep    3s

    For    ${index}    IN RANGE    5
    ${status}    run keyword and return status    wait until page contains element    ${loginButton}    5
    IF    "${status}" == "False"    run keyword    go back
    Sleep    3s

MultipleTouch action on TestEnvironment screen
    wait until page contains    ${app_start_page_text}    10s
    sleep    5s
    For    ${index}    IN RANGE    3
    click element at coordinates    550    409
    sleep    5s
    wait until page contains    Choose Environment    5s
    sleep    3s
    For    ${index}    IN RANGE    20
    ${x}    Generate random string    3    123456789
    ${y}    Generate random string    3    123456789
    sleep    1s
    click element at coordinates    ${x}    ${y}
    Sleep    3s
    For    ${index}    IN RANGE    5
    ${status}    run keyword and return status    wait until page contains element    ${loginButton}    5
    IF    "${status}" == "False"    run keyword    go back
    sleep    3s

MultipleTouch action on Diagnostic mode screen

MultipleTouch action on CreateAccount screen
    wait until page contains    ${app_start_page_text}    10s
    click element    ${Create_account}
    sleep    5s
    For    ${index}    IN RANGE    20
    ${x}    Generate random string    3    123456789
    ${y}    Generate random string    3    123456789
    sleep    1s
    click element at coordinates    ${x}    ${y}
    Go back
    For    ${index}    IN RANGE    5
    ${status}    run keyword and return status    wait until page contains element    ${loginButton}    5
    IF    '${status}' == 'False'    Go Back

    Sleep    5s

MultipleTouch action on Signin screen
    wait until page contains    ${app_start_page_text}    10s
    click element    ${loginButton}
    sleep    5s
    :For    ${index}    IN RANGE    20
    \    ${x} =    Generate random string    3    123456789
    \    ${y} =    Generate random string    3    123456789
    \    sleep    1s
    \    click element at coordinates    ${x}    ${y}
    go back
    :For    ${index}    IN RANGE    5
    \    ${status}=    run keyword and return status    wait until page contains element    ${loginButton}    5
    \    run keyword if    "${status}" == "False"    run keyword    go back
    sleep    5s

MultipleTouch action on Forgot Pass screen
    sleep    5s
    click element    ${Forgot_Pass}
    sleep    5s
    :For    ${index}    IN RANGE    20
    \    ${x} =    Generate random string    3    123456789
    \    ${y} =    Generate random string    3    123456789
    \    sleep    1s
    \    click element at coordinates    ${x}    ${y}
    sleep    5s
    go back
    sleep    3s
    :For    ${index}    IN RANGE    5
    \    ${status}=    run keyword and return status    wait until page contains element    ${loginButton}    5
    \    run keyword if    "${status}" == "False"    run keyword    go back
    sleep    5s

MultipleTouch action on Dashboard screen
    wait until page contains    ${app_start_page_text}    10s
    sleep    3s
    :For    ${index}    IN RANGE    3
    \    click element at coordinates    550    409
    sleep    2s
#    Click Element    ${imageLogo}
#    Sleep    1s
#    Click Element    ${imageLogo}
##    Sleep    1s
#    Click Element    ${imageLogo}
    sleep    5s
    click text    Test
    sleep    2s
    click text    Save
    sleep    3s
    click element    ${loginButton}
    sleep    5s
    Click Element    ${userName}
    Input Text    ${userName}    ${emailId}
    sleep    3s
    go back
    sleep    3s
    Click Element    ${password}
    Input Text    ${password}    ${passwordValue}
    Hide Keyboard
    click text    Sign in
    sleep    20s
    click text    ALLOW
    sleep    2s
    :For    ${index}    IN RANGE    20
    \    ${x} =    Generate random string    3    123456789
    \    ${y} =    Generate random string    3    123456789
    \    sleep    1s
    \    click element at coordinates    ${x}    ${y}
    sleep    5s
    :For    ${index}    IN RANGE    5
    \    ${status}=    run keyword and return status    wait until page contains element    ${notification_icon}    5
    \    run keyword if    "${status}" == "False"    run keyword    go back
    sleep    5s

MultipleTouch action on Detail screen
    sleep    10s
    click text    Heat Pump Water Heater Gen 4
    sleep    5s
    For    ${index}    IN RANGE    20
    ${x}    Generate random string    3    123456789
    ${y}    Generate random string    3    123456789
    sleep    1s
    click element at coordinates    ${x}    ${y}
    END
    sleep    5s
    
#    Get_Memory_Data

Change and Verify Temperature
    [Arguments]    ${i}

    sleep    ${Sleep_5s}
    Increment set point
    ${setpoint_M_DP}    get setpoint from details screen
    Go Back
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    

Dragging Slider Continuously
    [Arguments]    ${i}
    
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s

Keep Changing Home/Away State
    [Arguments]    ${i}
    
    Set Away mode from mobile application
    Sleep    5s
    click element    ${Location_Away_icon}
    sleep    5s
    Page Should Contain Text    I'm Home
    Navigate to Detail Page    ${select_HPWH_location}
    sleep    3s
    Increment set point
    ${setpoint_M_DP}    get setpoint from details screen
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    HPWHGen5 WH Set Mode    @{HPWHGen5_modes_List}[${changeModeValue}]
    go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    Sleep    5s
    

Continuously Follow/Unfollow Schedule
    [Arguments]    ${i}
    
    ${get_current_set_point}    ${get_current_mode}    HPWH Follow Schedule Data    Schedule
    go back
    sleep    5s
    Go back
    sleep    5s
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as strings    ${setpoint_M_EC}    ${get_current_set_point}
    Navigate to Detail Page    ${select_HPWH_location}
    ${Mobile_output}    Unfollow the schedule    Schedule
    Go Back
    Navigate to Detail Page    ${select_HPWH_location}

Keep Changing Setpoint Continuously
    [Arguments]    ${i}
    
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s
    Increment set point
    sleep    1s

Keep Changing Mode Continuously
    [Arguments]    ${i}
    
    ${changeModeValue}    Set Variable    1
    ${set_mode_M}    WH Set Mode    ${HPWHGen5_modes_List}[${changeModeValue}]
    ${changeModeValue}    Set Variable    2
    ${set_mode_M}    WH Set Mode   ${HPWHGen5_modes_List}[${changeModeValue}]
    ${changeModeValue}    Set Variable    3
    ${set_mode_M}    WH Set Mode    ${HPWHGen5_modes_List}[${changeModeValue}]
=    ${set_mode_M}    WH Set Mode    @{HPWHGen5_modes_List}[${changeModeValue}]
    ${set_mode_M}    WH Set Mode    @{HPWHGen5_modes_List}[${changeModeValue}]

Setting the network connection status
    [Arguments]    ${sec}
    Set Network Connection Status    ${sec}

Launch First app after
    [Arguments]    ${appPackage}    ${appActivity}
    start activity    ${appPackage}    ${appActivity}

Create new account with invalid data multiple time
    [Arguments]    ${name1}    ${name2}    ${email}    ${number}    ${pass}    ${conf_pass}
    sleep    5s
    Click Element    ${imageLogo}
    Sleep    1s
    Click Element    ${imageLogo}
    Sleep    1s
    Click Element    ${imageLogo}
    sleep    ${Sleep_10s}
    swipe    670    1710    670    400
    Wait Until Page Contains    ${stgText}    ${Sleep_20s}
    Click Text    ${stgText}
    wait until page contains    ${saveText}
    Click Text    ${saveText}
    sleep    5s
    click element    ${Login_CreateACC}
    wait until page contains    ${create_acc_text}    ${Sleep_20s}
    click element    ${first_name}
    sleep    ${Sleep_5s}
    click element    ${last_name}
    sleep    ${Sleep_5s}
    go back
    click element    ${check_box}
#    scroll    ${Confirm_Pass}    ${Acc_Pass}
    scroll    ${Confirm_Pass}    ${email_Add}
    click element    ${submit_button}
    page should not contain element    ${notification_icon}
    scroll    ${Acc_Pass}    ${submit_button}
    click element    ${first_name}
    Input Text    ${first_name}    ${name1}
    sleep    ${Sleep_5s}
    go back
    click element    ${last_name}
    Input Text    ${last_name}    ${name2}
    sleep    ${Sleep_5s}
    go back
    click element    ${email_Add}
    Input Text    ${email_Add}    ${email}
    sleep    ${Sleep_5s}
    go back
    click element    ${Phone_Number}
    Input Text    ${Phone_Number}    ${number}
    sleep    ${Sleep_5s}
    go back
    click element    ${Acc_Pass}
    Input Text    ${Acc_Pass}    ${pass}
    click element    ${See_Pass}
    sleep    ${Sleep_5s}
    go back
    click element    ${Confirm_Pass}
    Input Text    ${Confirm_Pass}    ${conf_pass}
    go back
    scroll    ${Confirm_Pass}    ${email_Add}
    click element    ${submit_button}
    sleep    ${Sleep_5s}
    page should contain element    ${Error_Email_msg}
    click element    ${email_Add}
    Input Text    ${email_Add}    ${email_id}
    go back
    click element    ${submit_button}
    page should contain element    ${Error_Email_msg}
    click element    ${Phone_Number}
    Input Text    ${Phone_Number}    ${number}
    go back
    click element    ${submit_button}
    page should contain element    ${Error_Email_msg}
    click element    ${Acc_Pass}
    Input Text    ${Acc_Pass}    ${set_pass}
    go back
    click element    ${submit_button}
    page should contain element    ${Error_Email_msg}
    click element    ${Confirm_Pass}
    Input Text    ${Confirm_Pass}    ${set_pass}
    go back
    sleep    ${Sleep_5s}
    go back

Invalid Data SignIn Page
    [Arguments]    ${email}    ${pass}
    sleep    5s
    Wait Until Page Contains    ${sign_in_text}    ${Sleep_10s}
    wait until page contains element    ${userName}
    Click Element    ${userName}
    Input Text    ${userName}    ${email}
    wait until page contains element    ${password}
    Click Element    ${password}
    Input Text    ${password}    ${pass}
    Hide Keyboard
    wait until page contains element    ${loginButton}
    Click Element    ${loginButton}
    page should contain text    ${Signin_email_error}
    sleep    5s

Get Current Time
    [Arguments]    ${time}
    ${currentTime}    Get Current Date    result_format=%H:%M:%S.%f
    
