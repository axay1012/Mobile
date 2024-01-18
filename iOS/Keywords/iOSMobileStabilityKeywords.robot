*** Settings ***
Library     ../../src/common/iOS_Handler.py
Library     Collections
Library     String
Library     OperatingSystem
Library     DateTime
Library     JSONLibrary
Library     ../../src/RheemCustom.py

Resource    Locators/iOSLabels.robot
Resource    Locators/iOSLocators.robot
Resource    Locators/Config.robot
Resource    MQttKeywords.robot
Resource    iOSMobileKeywords.robot


*** Variables ***

${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5

${EndDevice_id}                         4737

${NewECC_Mac_Address}                   40490F9E66D5
${NewECC_Mac_Address_In_Formate}        40-49-0F-9E-66-D5
${NewECCDevice_id}                      896

${Away_EndDevice_id}                    704
#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          heatpumpWaterHeaterGen4

${emailId}                              automation3@rheem.com
${passwordValue}                        12345678


${loopCount}                            10
${randomClickCount}                     25

${app_start_page_text}                  Connecting you to greater savings, protection and convenience


*** Keywords ***
Multitouch log on failure
    [Arguments]    ${status}    ${result}
    IF    '${status}'=='FAIL'
        log    =======Failure detected:${result}=======    console=yes    level=ERROR
        save screenshot with timestamp
    END

Get Current Time
    [Arguments]    ${time}
    ${currentTime}    Get Current Date    result_format=%H:%M:%S.%f

Change and Verify Temperature
    ${Status}    Run keyword and return status    Go to Temp Detail Screen    ${tempDashBoard}
    ${Temperature1_Mobile}    Increment temperature value
    Sleep    5s
    # Validating temperature value on End Device
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Should be Equal as Integers   ${Temperature1_Mobile}   ${Temperature_ED}

Change and Verify Mode
    [Arguments]    ${i}
    ${status}    Run keyword and return status    Go to Temp Detail Screen    ${tempDashBoard}
    ${Mode_mobile}    Change Mode    ${i}
    ${status}    Run keyword and return status    Navigate Back to the Screen
    Page Should Contain Text    ${i}



Change and Verify State
    [Arguments]    ${i}
    ${status}    run keyword and return status    Go to Temp Detail Screen    ${tempDashBoard}
     Wait until page contains    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element    ${waterHeaterStateButton}
    Wait until page contains    ${i}    ${defaultWaitTime}
    Click element    ${i}
    ${status}    run keyword and return status    Navigate Back to the Screen
    Page Should Contain Text    ${i}


Click At Random Coordinate
    FOR    ${index}    IN RANGE    ${randomClickCount}
        ${x}    Generate random string    3    123456789
        ${y}    Generate random string    3    123456789
        sleep    1s
        click element at coordinates    ${x}    ${y}
    END
    sleep    3s

Navigate To The Start Up Page
    ${status}    Run Keyword and return status    page should contain element    Choose Stored EcoNet
#    Run keyword if    ${status}    Click element    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypePopover/XCUIElementTypeOther[1]/XCUIElementTypeTable/XCUIElementTypeCell/XCUIElementTypeOther[1]/XCUIElementTypeOther
    IF    ${status}    Temporary Keyword
    sleep    5s
    ${status}    Run keyword and return status    page should contain element    ${testEnvButton}
    IF    ${status}    click element    ${testEnvButton}
    ${status}    Run keyword and return status    page should contain element    ${okButton}
    IF    ${status}    click element    ${okButton}
    FOR    ${index}    IN RANGE    5
        ${status}    run keyword and return status    wait until page contains element    ${sign_in_button}    5
        IF    ${status}
            ${enabled}    get element attribute    ${sign_in_button}    enabled
        ELSE
            ${enabled}    Set Variable    ${None}
        END
        IF    '${enabled}' == 'false' or '${enabled}' == 'None'
            Navigate Back To The Screen
        END
        ${status}    run keyword and return status    wait until page contains element    EXIT    5s
        IF    ${status}    Click Element    EXIT
    END
    sleep    3s

Navigate back to the profile screen
    ${status}    run keyword and return status    wait until page contains element    ${btnChangePassword}    5
    IF    '${status}' == 'False'    Navigate Back To The Screen

MultipleTouch action
    Click At Random Coordinate
    Click At Random Coordinate
    Click At Random Coordinate
    Click At Random Coordinate
    Click At Random Coordinate
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on TestEnvironment screen
    sleep    3s
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on Diagnostic mode screen
    wait until page contains    ${app_start_page_text}    ${defaultWaitTime}
    page should contain element    ${btnDiagnoseMode}
    click element    ${btnDiagnoseMode}
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on Create Account screen
    wait until page contains    ${app_start_page_text}    ${defaultWaitTime}
    click element    ${btnCreateAccount}
    sleep    5s
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on Signin screen
    wait until page contains    ${app_start_page_text}    ${defaultWaitTime}
    click element    ${sign_in_button}
    sleep    5s
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on Forgot Pass screen
    click element    ${sign_in_button}
    Sleep    3s
    click element    ${btnForgotPassword}
    sleep    5s
    Click At Random Coordinate
    Navigate To The Start Up Page

MultipleTouch action on Dashboard screen
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Your Profile screen
    wait until page contains    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    click element    ${txtAccount}
    sleep    4s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on General Settings screen
    wait until page contains    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains    ${txtGeneralSetting}    ${defaultWaitTime}
    click element    ${txtGeneralSetting}
    sleep    7s
    Click At Random Coordinate
    ${status}    Run keyword and return status    page should contain element    ${okButton}
    IF    ${status}    click element    ${okButton}
    Navigate back to dashboard screen

MultipleTouch action on Location and Products screen
    wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    click element    ${txtLocationProducts}
    sleep    3s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Manage Zone Names screen
    wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains element    ${txtManageZoneNames}    ${defaultWaitTime}
    click element    ${txtManageZoneNames}
    sleep    3s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Away Settings screen
    wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    click element    ${txtAwaySettings}
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Scheduled Away/Vacation screen
    wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    wait until page contains element    ${txtScheduleAway}    ${defaultWaitTime}
    click element    ${txtScheduleAway}
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Contacts screen
    wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    click element    ${btnMenu}
    scroll to the Contacts
    wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    click element    ${txtContacts}
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Detail screen
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen
    sleep    5s
    Click At Random Coordinate
    Navigate back to dashboard screen

Random Click on Schedule Screen
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    sleep    5s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Schedule screen of WH
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen
    sleep    5s
    Random Click on Schedule Screen

Random Click On usage report screen
    wait until page contains element    ${usageReport}    ${defaultWaitTime}
    Click Element    ${usageReport}
    Sleep    5s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Usage report screen of WH
    Select the Device Location    ${locationNameTriton}
    Go to Temp Detail Screen
    sleep    5s
    Random Click On usage report screen

MultipleTouch action on Zoneing Overview screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    sleep    3s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Main Zone Detail screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    sleep    3s
    select the zone    ${masterControl}    ${locationNameZoning}
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Main Zone Schedule screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    sleep    3s
    select the zone    ${masterControl}    ${locationNameZoning}
    Random Click on Schedule Screen

Random Click on Product Setting Screen
    wait until page contains element    ${btnSetting}    ${defaultWaitTime}
    Click Element    ${btnSetting}
    Sleep    5s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on Main Zone Product settings screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    sleep    3s
    select the zone    ${masterControl}    ${locationNameZoning}
    Random Click on Product Setting screen

MultipleTouch action on SubZone Detail screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    select the zone    ${zoneControl2}    ${locationNameZoning}
    sleep    3s
    Click At Random Coordinate
    Navigate back to dashboard screen

MultipleTouch action on SubZone schedule screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    select the zone    ${zoneControl2}    ${locationNameZoning}
    sleep    3s
    Random Click on Schedule Screen

MultipleTouch action on SubZone Product Settings screen
    Select the Device Location    ${locationNameZoning}
    Navigate to Zoning Overview screen
    select the zone    ${zoneControl2}    ${locationNameZoning}
    sleep    3s
    Random Click on Product Setting Screen

Enter data in create account page
    ${invalidEmail}    generate random string    10    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${invalidNumber}    generate random string    8    [LOWERS]
    ${invalidPassword}    generate random string    3    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    create Account    ${invalidEmail}    ${invalidNumber}    ${invalidPassword}    ${invalidPassword}
    wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}
    scroll to the upward    ${txtBxEmailAddress}
    Navigate To The Start Up Page

Random data in create account page
    FOR    ${index}    IN RANGE    ${loopCount}
        ${status}    Run Keyword And Ignore Error    Enter data in create account page
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            save screenshot with timestamp
            Navigate To The Start Up Page
        END
    END

Enter data in sign in page
    ${invalidEmail}    generate random string    10    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${invalidNumber}    generate random string    8    [LOWERS]
    wait until page contains element    ${sign_in_link}    ${defaultWaitTime}
    ${location}    get element location    ${sign_in_link}
    ${x}    evaluate    str(${location}[x]+10)
    ${y}    evaluate    str(${location}[y]+5)
    Click Element At Coordinates    ${x}    ${y}
    Wait Until Page Contains element    ${signin_page_text}    ${defaultWaitTime}
    Input Text    ${emailTextbox}    ${invalidEmail}
    Input Password    ${passwordTextbox}    ${invalidNumber}
    sleep    3s
    wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element    ${keyboardDoneButton}
    Navigate To The Start Up Page

Random data in sign in page
    FOR    ${index}    IN RANGE    ${loopCount}
        ${status}    Run Keyword And Ignore Error    Enter data in sign in page
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            save screenshot with timestamp
            Navigate To The Start Up Page
        END
    END

Enter data in change phone no
    wait until page contains element    ${btnChangePhone}    ${defaultWaitTime}
#    click element    ${btnChangePhone}
    ${location}    get element location    ${btnChangePhone}
    ${x}    evaluate    str(${location}[x]+44)
    ${y}    evaluate    str(${location}[y]+15)
    Click Element At Coordinates    ${x}    ${y}
    ${invalidNumber}    generate random string    5    0123456789
    wait until page contains element    ${txtBxNewNumber}    ${defaultWaitTime}
    input text    ${txtBxNewNumber}    ${invalidNumber}
    input text    ${txtBxConfirmNumber}    ${invalidNumber}

    wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element    ${keyboardDoneButton}

    wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    click element    ${btnSavePhoneChanges}
    wait until page contains element    ${txtBxNewNumber}    ${defaultWaitTime}
    Navigate Back to the Screen

Random data in change phone number
    FOR    ${index}    IN RANGE    ${loopCount}
        ${status}    Run Keyword And Ignore Error    Enter data in change phone no
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            save screenshot with timestamp
            Navigate back to the profile screen
        END
    END

Enter data in change password
    wait until page contains element    ${btnChangePassword}    ${defaultWaitTime}
#    click element    ${btnChangePassword}
    ${location}    get element location    ${btnChangePassword}
    ${x}    evaluate    str(${location}[x] + 50)
    ${y}    evaluate    str(${location}[y] + 15)
    Click Element At Coordinates    ${x}    ${y}
    ${inValidPassword}    generate random string    4    [NUMBERS]abcdefghijklmn
    wait until page contains element    ${currentPassword}    ${defaultWaitTime}
    input text    ${currentPassword}    ${inValidPassword}
    input text    ${passwordChangePassword}    ${passwordValue}
    input text    ${confirmPassword}    ${passwordValue}

    wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element    ${keyboardDoneButton}

    wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    click element    ${btnSavePhoneChanges}

    wait until page contains element    ${currentPassword}    ${defaultWaitTime}
    Navigate Back to the Screen

Random data in change password
    FOR    ${index}    IN RANGE    ${loopCount}
        ${status}    Run Keyword And Ignore Error    Enter data in change phone no
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            save screenshot with timestamp
            Navigate back to the profile screen
        END
    END

Enter data in change name
    wait until page contains element    ${btnChangeName}    ${defaultWaitTime}
#    Tap    ${btnChangeName}
    ${location}    get element location    ${btnChangeName}
    ${x-cordinate}    evaluate    str(${location}[x] + 44)
    ${y-cordinate}    evaluate    str(${location}[y] + 15)
    Click Element At Coordinates    ${x-cordinate}    ${y-cordinate}
    ${nameTxt}    Generate Random String    10    [NUMBERS][LOWER]
    ${surNameTxt}    generate random string    10    [NUMBERS][LOWER]
    wait until page contains element    ${txtNameFirst}    ${defaultWaitTime}
    clear text    ${txtNameFirst}
    input text    ${txtNameFirst}    ${nameTxt}

    clear text    ${txtNameSecond}
    input text    ${txtNameSecond}    ${surNameTxt}
    wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    click element    ${keyboardDoneButton}
    ${name}    catenate    ${nameTxt}${space}${surNameTxt}
    sleep    4s
    click element    ${btnSavePhoneChanges}
    wait until page contains element    ${iconEmail}    ${defaultWaitTime}
#    Sleep    10s
#    page should contain element    ${name}

Random data in change Name
    FOR    ${index}    IN RANGE    ${loopCount}
        ${status}    Run Keyword And Ignore Error    Enter data in change name
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            save screenshot with timestamp
            Navigate back to the profile screen
        END
    END

Drag temperature slider
    ${Temperature1_Mobile}    Increment temperature value
    Sleep    5s

Enable and Disable Away Mode
    click element    homeAwayButtonIdentifier
    ${Status}    run keyword and return status    wait until page contains element    Ok
    IF    ${Status}==True    Enable Away Setting    HPWH

    # Validating temperature value on End Device
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${A}    set variable    1
    ${A}    convert to integer    ${A}
    should be equal as integers    ${Away_status_ED}    ${A}
    Sleep    15s
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

Follow And Unfollow Schedule

    Go to Temp Detail Screen    ${tempDashBoard}
    sleep    3s
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

    Sleep    2s
    ${updatedTemp}    Get Text    //XCUIElementTypeStaticText[@name="currentTemp"]
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click Element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    wait until page contains element    //XCUIElementTypeButton[@name="btnSave"]    ${defaultWaitTime}
    Click Element    //XCUIElementTypeButton[@name="btnSave"]
    ${abc}    run keyword and return status    click element    modalBackButtonIdentifier
    sleep    5s

    ${tempDashboard}    Get current temperature from mobile app
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    should be equal    ${scheduled_temp}    ${tempDashboard}

    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    sleep    10s
    wait until page contains element    ${scheduleToggle}    ${defaultWaitTime}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==1    Turn on schedule toggle
    Tap    ${saveSchedule}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Navigate Back to the Screen