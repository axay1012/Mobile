*** Settings ***
Documentation       Suite Contains Test cases for Elo Devices

Library             AppiumLibrary    run_on_failure= Capture Pag eScreenshot
Library             OperatingSystem
Library             Process

*** Variables ***
${browser}                  firefox
${server}                   Test
${eloUrl}                   https://manage-sfp-ic.eloci.us/3.66.16/devicedetails/yDtdjYoBCxLFqQUVdony
${usrName}                  pratik.agrawal+sfp@volansystech.com
${pwd}                      Volansys@123
${deviceName}               E223A50002
${devicePwd}                1elo
${athensTimeout}            5s
${viennaTimeout}            30s
${Days}                     5
${wifiSSID}                 redmi
${wifiPasswordValue}        hotspott
${BluetoothName}            elo-desktop

${userLoginField}           //*[@id="username"]
${passwordField}            //*[@id="password"]
${loginBtn}                 //*[@id="loginUser"]
${Content}                  //*[text()="Content"]
${App Library}              //*[text()="App Library"]
${search}                   //input[@name="q"]
${searchedurl}              //*[@class="api-searched-app api-searched-url"]
${target}                   //*[@title="F223A43792"]

${clickOnAdmin}             //android.widget.Button[@text='Admin']
${EnterPassword}            //android.widget.TextView[@resource-id='com.elotouch.home:id/textinput_placeholder']
${Settings}                 //android.widget.Button[@resource-id='com.elotouch.home:id/quickSettingsBtnSettings']
${ChooseSettings}           //android.widget.Button[@text='Diagnostics']
${AdroidSettings}           //android.widget.Button[@resource-id='com.elotouch.home:id/btnAndroidSettings']
${DeviceStatusOnline}       //android.widget.TextView[@resource-id='com.elotouch.home:id/tvDeviceStatus']
## ${DeviceName}               //android.widget.TextView[@resource-id='com.elotouch.home:id/tvDeviceName']
${UpdateDevice}             //android.widget.Button[@resource-id='com.elotouch.home:id/btnUpdateDevice']
${SystemUpdate}             //android.widget.TextView[@text='System Update']
${UpdateMsg}                //android.widget.TextView[@text='OS cannot be downgraded']
${SySUpdateOK}              //android.widget.TextView[@text='OK']

${SYSKEY}                   84ed919e0bd6f5edf6d2f79fae28
${SECKEY}                   D0CDDCAF0BC4D18F94AC89EEC6D501
${URL}                      https://rheemdev.clearblade.com
${PLATFORM_NAME}            Android
${APP_LOCATION}             /Users/shraddha.shah/PycharmProjects/Locust/Bharat.apk
${APP_ACTIVITY}             com.example.bharat.MainActivity
${App_Package}              com.example.bharat
${AUTOMATION_NAME}          UiAutomator2
${SCREENSHOT_FOLDER}        ../screenshots/
${TIME_OUT}                 60000
${Default_Timeout}          10s
${REMOTE_URL}               http://127.0.0.1:4732
#${appiumPort}               4723 #${AppiumPort}
${DeviceName}               ${DeviceName}
${AUTOMATION_NAME}          UiAutomator2
${Network&Internet}         //android.widget.TextView[@resource-id='android:id/title' and @text='Network & internet']
${Wifi}                     //android.widget.TextView[@resource-id='android:id/summary'and @text='Rheem_Testlab']
${Rheem_Testlab}            //android.widget.TextView[@resource-id='android:id/title' and @text='Rheem_Testlab']
${EnterWiFiPW}              //android.widget.EditText[@resource-id='com.android.settings:id/password']
${ConnectBtn}               //android.widget.Button[@resource-id='android:id/button1' and @text='CONNECT']
${RebootDevice}             //android.widget.Button[@resource-id='com.elotouch.home:id/btnReboot']

${ModeSelectEloView}        //android.widget.Button[@resource-id='com.elotouch.presetup:id/chooseSetupLlEnrollWithEloview']
${ConfirmPopMsg}            //android.widget.Button[@resource-id='com.elotouch.presetup:id/btnOk']
${InputEmailAdd}            //android.widget.EditText[@resource-id='com.elotouch.presetup:id/signInEdtEmailId']
${InputPassword}            //android.widget.EditText[@resource-id='com.elotouch.presetup:id/etPassword']
${SignInBtn}                //android.widget.Button[@resource-id='com.elotouch.presetup:id/signInIvLogin']
${ConnectEloServer}         //android.widget.EditText[@text='Touch to Select Server']
${ClickOKbtn}               //android.widget.Button[@resource-id='com.elotouch.home:id/btn_ok']
${EmailAddressName}         faisal.koradiya@volansys.com
${PasswordName}             Nirav@123

*** Keywords ***

Navigate to the Home Dashboard
    ${Status}    run    adb shell input keyevent KEYCODE_HOME
    ${Status}    run    adb shell input keyevent KEYCODE_HOME

Select the right left option button
    Run    adb shell am start -n com.elotouch.home/com.elotouch.home.settings.QuickSettingsActivity

Select the Admin option
    Log to Console  Clicking on Admin Text from Settings screen.
    Wait until element is visible    ${clickOnAdmin}    timeout=10s
    Click element    ${clickOnAdmin}

Enter the Admin Password
    Log to Console  Entering 1elo Password to the Textbox
    Run    adb shell input text "1elo"
    Log to Console  Clicking Enter button
    Run    adb shell input keyevent 66

Click on the Settings Button
    Log to Console  Clicking on Settings Screen.
    wait until element is visible    ${Settings}    timeout=10s
    Click element    ${Settings}

Choose the Android Settings

    wait until element is visible    ${AdroidSettings}    timeout=10s
    click element    ${AdroidSettings}

Choose the Settings Diagnostics
    Log to Console  Clicking on Diagnostics Settings Screen.
    wait until element is visible    ${ChooseSettings}    timeout=10s
    click element    ${ChooseSettings}

Check the Device Online status or not
    Log to Console  Verifying Online Device status in Diagnostics screen.
    page should contain text     Offline
    Sleep    2s
    ${Status}    Get Text    ${devicestatusonline}
    should be equal    Online    ${Status}
    Log to console    nirav.mistry+sfp01@volansys.com

Verify Registered Email ID on Diagnostics Page

    wait until page contains    nirav.mistry+sfp01@volansys.com      30s
    Log to console    nirav.mistry+sfp01@volansys.com

Click on the Update Device for the OTA
    wait until element is visible    ${UpdateDevice}    timeout=10s
    click element    ${UpdateDevice}
    Sleep    3s

Reboot Device
    Log to Console  Clicking on Reboot Button
    wait until element is visible    ${RebootDevice}    timeout=10s
    click element    ${RebootDevice}
    Sleep    4s
    Click Text   Yes
    Log to Console  Waiting for Device to Waking Up.
    Sleep    60s
    log to console  Device has started after rebooting the device.

#Open App
#    Open application    ${REMOTE_URL}
#    ...    platformName=${PLATFORM_NAME}
#    ...    platformVersion=10
#    ...    deviceName=D213A01286
#    ...    automationName=${AUTOMATION_NAME}

#...    app=/media/volansys/AOSP/DOWNLOAD/EriBank.apk
 #    ...    appPackage=com.experitest.ExperiBank
 #    ...    appActivity=com.experitest.ExperiBank.LoginActivity
 #

Select the EloView Option
    Log to console  Selecting EloView Mode from Mode Selection Options
    Wait Until Element Is Visible    ${ModeSelectEloView}    10s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ModeSelectEloView}

Confirm the Popup Message
    Log to console  Clicking OK on Confirm the Pop-Up  /n
    Wait Until Element Is Visible    ${ConfirmPopMsg}    10s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${ConfirmPopMsg}

Enter the Credential details
    log to console  Entering the credentials for the Sign In Page
    Run    adb shell input text "nirav.mistry+sfp01@volansys.com"
    Run    adb shell input keyevent 66
    Wait Until Element Is Visible    ${InputPassword}    10s
    Input Text    ${InputPassword}    ${PasswordName}
    Run    adb shell input keyevent 4
    Sleep    3s
    Wait Until Element Is Visible    ${SignInBtn}    10s
    Click Element    ${SignInBtn}
    log to console  Rebooting the Device
    Sleep    50s     # Reboot Device

Connect the Elo Server
    log to console    Selecting SFP on Elo Server Selection Screen
    Sleep    3s
    Wait Until Element Is Visible    ${ConnectEloServer}
    Click Element    ${ConnectEloServer}
    Run    adb shell input text "sfp"
    Run    adb shell input keyevent 66
    Log to console  Clicking OK after Selecting SFP on Elo Server Selection Screen
    Sleep    5s
    Click Text    OK
    Sleep    40s

Open Elo Browser
    [Arguments]    ${url}=${eloUrl}    ${alias}=None
    log to console  Opening Elo Browser
    Open Browser    url=${url}    browser=${browser}    alias=${alias}
    Sleep    3s
    Maximize Browser Window
    Sleep    5s

Verify that Device is avaiable or not
    Web.Wait Until Element Is Visible    //*[@text()="${deviceName}"]    timeout=20s

Login to Elo
    [Arguments]    ${user}    ${password}
    log to console  Entering Email Id
    Web.Wait Until Element Is Visible    ${userLoginField}    timeout=90s
    Web.Input Text    ${userLoginField}    ${user}
    log to console  Entering Password
    Web.Wait Until Element Is Visible    ${passwordField}    timeout=10s
    Web.Input Text    ${passwordField}    ${password}
    log to console  Clicking on Login Button
    Web.Wait Until Element Is Visible    ${loginBtn}    timeout=10s
    Web.Click Element    ${loginBtn}
    Sleep    4s

Go to Content Page
    log to console  Navigate to the Content Screen.
    Web.Wait Until Element Is Visible    ${Content}    timeout=10s
    Web.Click Element    ${Content}
    Web.Wait Until Element Is Visible    ${App Library}    timeout=10s

Drag and Drop Application
    log to console  Searching for APK
    Web.Wait Until Element Is Visible    ${search}    timeout=10s
    Web.Input text    ${search}    Eri
    Web.Press Keys    ${search}    ENTER
    Sleep    10s
    Web.Wait Until Element Is Visible    ${searchedurl}    timeout=10s
    Log to console  Draging APK to the Device
    Web.Drag and drop    ${searchedurl}    ${target}
    Sleep    5s
    Web.Wait Until Element Is Visible    //*[text()="Yes"]    timeout=10s
    Web.Click Element    //*[text()="Yes"]
    Web.Wait Until Element Is Visible    css:#cs-success    timeout=120s

Verify Content On Device Using ADB
    [Arguments]    ${PackageName}
    Log to console  Verifying Content on Device
    FOR    ${INDEX}    IN RANGE    0    5
        ${Status}    Run    adb shell dumpsys window
        Sleep    10s
        Should Contain    ${Status}    ${PackageName}
    END

Unlock Control Panel
    Run    adb shell input keyevent 187
    Sleep   5s
    Click Element     //android.widget.TextView[@resource-id='com.elotouch.home:id/tvOnlineStatus']
    Sleep    4s
    Log to Console  Entering 1elo Password to the Textbox
    Run    adb shell input text "1elo"
    Log to Console    Clicking Enter button
    Run    adb shell input keyevent 66
    Sleep    4s

Open App
    open application   ${REMOTE_URL}
    ...  platformName=Android
    ...  platformVersion=10
    ...  deviceName=F223A43792
    ...  automationName=${AUTOMATION_NAME}


