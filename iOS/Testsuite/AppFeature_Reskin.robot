*** Settings ***

Documentation    Rheem iOS App Only features Test Suite

Library          AppiumLibrary      run_on_failure=No Operation
Library          RequestsLibrary
Library          Collections
Library          String
Library          OperatingSystem
Library          DateTime

Library          ../../src/RheemMqtt.py
Library          ../../src/common/iOS_Handler.py

Resource         ../Locators/iOSConfig.robot
Resource         ../Locators/iOSLocators.robot
Resource         ../Locators/iOSLabels.robot
Resource         ../Keywords/iOSMobileKeywords.robot
Resource         ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
#...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***

${Device_Mac_Address}               40490F9E66D5
${Device_Mac_Address_In_Formate}    40-49-0F-9E-66-D5

${EndDevice_id}                     4107
#  -->cloud url and env
${URL}                              https://rheemdev.clearblade.com
${URL_Cloud}                        https://rheemdev.clearblade.com/api/v/1/

#  --> test env
${SYSKEY}                           f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                           F280E3C80B8CA1FB8FE292DDE458

#  --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}         D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}                econetWiFiTranslator
${Device_TYPE}                               heatpumpWaterHeaterGen4


${emailId}				                    automation@rheem.com
${passwordValue}			                Vyom@0212

${LocationemailId}				            akshay.suthar@volansys.com
${LocationpasswordValue}			        rheem123


${maxTempVal}                       140

${value1}     32
${value2}     5
${value3}     9
${LocationName}                     HPWHGen5

*** Test Cases ***

Tc-01:User should be able to proceed with the device provisioning steps for Diagnostic mode.
    [Documentation]    User should be able to proceed with the device provisioning steps for Diagnostic mode.
    [Tags]    testrailid=192318

#    Sign Out From the Application
    Wait until page contains element    ${sign_in_link}    ${defaultWaitTime}
    Click Element    ${btnDiagnoseMode}
    Wait until page contains element    ${btnConnect}    ${defaultWaitTime}
    Click Element    ${btnConnect}
    Wait until page contains element    ${product0}     ${defaultWaitTime}
    Click Element       ${product0}
    Wait until page contains element    ${btnContinue}    ${defaultWaitTime}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Wait until page contains element    ${ExitLabel}    ${defaultWaitTime}
    Click Element    ${ExitLabel}
    Wait until page contains element    ${sign_in_link}    ${defaultWaitTime}

TC-02:User shouldn't be able to Create New Account if invallid data is provided.
    [Documentation]    User shouldn't be able to Create New Account if invallid data is provided.
    [Tags]    testrailid=192319

    ${emailID}     Generate the random email
    ${number}      Generate random string    10    0123456789
    ${password}    Generate random string    10    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${invalidEmail}       Generate random string    10    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${invalidNumber}      Generate random string     8    [LOWERS]
    ${invalidPassword}    Generate random string     3    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    Create Account    ${invalidEmail}    ${invalidNumber}    ${invalidPassword}    ${invalidPassword}
    Wait until page contains element     ${ErrPhoneNumberValiddigits}    ${defaultWaitTime}
    Wait until page contains element     ${ErrValidEmailAddress}    ${defaultWaitTime}
    Wait until page contains element     ${ErrPasswordConfirmPasswordnotmatch}    ${defaultWaitTime}
    Navigate Back to the Sub Screen
    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Sign in to the application    ${emailId}    ${passwordValue}

User should be able to see the current account details.
    [Documentation]    User should be able to see the current account details.
    [Tags]    testrailid=192321

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element     ${btnMenu}
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Wait until page contains element    ${LabelPhoneNumber}    ${defaultWaitTime}
    Wait until page contains element    ${emailId}      ${defaultWaitTime}
    Wait until page contains element    ${LabelPassword}        ${defaultWaitTime}
    Wait until page contains element    ${LabelAddress}         ${defaultWaitTime}
    Navigate Back to the Screen

User should be able to Create New Account if valid data is provided using Email.
    [Documentation]    User should be able to Create New Account if valid data is provided.
    [Tags]    testrailid=192320

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Run keyword and ignore error    Sign Out From the Application
    ${emailID}      Generate the random email
    ${number}       Generate the random Number
    ${password}     Generate random string   10      [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${firstName}    Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz
    ${lastName}     Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz
    Set global variable    ${randEmailId}    ${emailID}
    Set global variable    ${randPasswordValue}    ${password}
    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Click Element    ${btnCreateAccount}
    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}
    Input text    ${txtBxFirstName}       ${firstName}
    Input text    ${txtBxLastName}        ${lastName}
    Input text    ${txtBxPhoneNumber}     ${number}
    Input text    ${txtBxEmailAddress}    ${emailID}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}
    Wait until page contains element     ${txtBxCnfrmPasswrd}   ${defaultWaitTime}
    Click Element    ${txtBxCnfrmPasswrd}
    Input text   ${txtBxCnfrmPasswrd}    ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}
    Input text      ${txtBxPassword}        ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}
    Click Element    ${btnAddress}
    Sleep    15s
    ${Status}    Run keyword and return status    Click Element    Your current location?
    run keyword if    ${Status}==False   Run Keywords  Click Element    ${BackButton}        AND    Click Element    ${btnAddress}    AND  Sleep    10s  AND   Click Element    Your current location?
    Sleep    4s
    Wait until page contains element     ${agreeCheckBox}    ${defaultWaitTime}
    Click Element    ${agreeCheckBox}
    Sleep    2s
    Swipe    60     461     60    250   5000
    Swipe    60     461     60    250   5000
    Click Element    	Create Account
    Sleep    5s
    Click Element    ${txtBxForgotEmail}
    Click Element    ${txtSubmitButton}
    Sleep    5s
    Wait until page contains element   ${GoToMail}     ${defaultWaitTime}
    Click Element    ${GoToMail}
    Wait until page contains element   ${ApplyMail}     ${defaultWaitTime}
    Click Element    ${ApplyMail}
    Sleep    5s
    Background app    -1
    go_back
    Click Element    EcoNet
    Sleep    5s
    Enter validation code
    Sleep    5s
    Wait until page contains element    Add Location
    ${status}    Run keyword and return status    Wait until page contains element    Not Now    20s
    Run Keyword If    ${status}    Click Element    Not Now


User Should be able to change Password if valid data is provided.
    [Documentation]    User Should be able to change Password if valid data is provided.
    [Tags]    testrailid=192350

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}

    Wait until page contains element    ${btnChangePassword}    ${defaultWaitTime}
    ${location}=    Get element location   ${btnChangePassword}
    ${x}=    evaluate    str(${location}[x] + 50)
    ${y}=    evaluate    str(${location}[y] + 10)
    Click Element At Coordinates     ${x}     ${y}
    ${password}    Generate random string    10    [NUMBERS]abcdefghijklmn

    Wait until page contains element    ${currentPassword}    ${defaultWaitTime}
    Input text    ${currentPassword}    ${randPasswordValue}
    Input text    ${passwordChangePassword}    ${password}
    Input text    ${confirmPassword}    ${password}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element     ${btnSavePhoneChanges}    ${defaultWaitTime}
    Click Element    ${btnSavePhoneChanges}
    set global variable    ${randPasswordValue}    ${password}
    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    ${present}    Run Keyword And Return Status     Page Should Contain Element     ${txtUpdatePassword}
    Run Keyword If    ${present}     Click Element     ${txtUpdatePassword}

User Shouldn't be able to change Phone number if invalid data is provided.
    [Documentation]    User Shouldn't be able to change Phone number if invalid data is provided.
    [Tags]    testrailid=192322

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Sleep    4s
    Wait until page contains element    Phone Number   ${defaultWaitTime}
    Tap     Phone Number
    ${invalidNumber}    generate random string    4    0123456789
    ${validNumber}      generate random string    10    0123456789
    Wait until page contains element    ${txtBxNewNumber}     ${defaultWaitTime}
    Input text    ${txtBxNewNumber}    ${invalidNumber}
    Wait until page contains element    ${errMsgPhnNumberValid}     ${defaultWaitTime}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User Should be able to change Phone number if valid data is provided.
    [Documentation]    User Should be able to change Phone number if valid data is provided.
    [Tags]    testrailid=192323

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Sleep    4s
    Wait until page contains element     Phone Number    ${defaultWaitTime}
    Tap     Phone Number
    ${newNumber}     generate the random number
    clear text    ${txtBxNewNumber}
    Wait until page contains element    ${txtBxNewNumber}     ${defaultWaitTime}
    Input text    ${txtBxNewNumber}    ${newNumber}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Sleep    3s
    Click Element     ${keyboardDoneButton}
    Wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    Click Element  ${btnSavePhoneChanges}
    Wait until page contains element     ${ValidateButton}    ${defaultWaitTime}
    Input text      ${validatecode}    111111
    Click Element    ${ValidateButton}
    Sleep  10s
    Wait until page contains element    Got It
    Click Element    Got It
    Sleep    5s
    Navigate Back to the Screen

User should be able to select different notifications according to requirements.
    [Documentation]    User should be able to select different notifications according to requirements.
    [Tags]    testrailid=192324

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtNotification}    ${defaultWaitTime}
    Click Element    ${txtNotification}
    Wait until page contains element    ${btnSave}    ${defaultWaitTime}
    Click Element    ${chkBox1Notification}
    Click Element    ${chkBox3Notification}
    Click Element    ${chkBox2Notification}
    Click Element    ${chkBox4Notification}
    Click Element    ${save_Copy_screen}
    Sleep    10s
    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    Click Element    ${okButton}

User should be able to view General settings.
    [Documentation]    User should be able to view General settings.
    [Tags]    testrailid=192325

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Sleep    5s
    Page should contain element    Temperature Units
    Page should contain element    ${homeWifiConn}
    Navigate Back to the Screen

User should be able to set Temperature in Celsius unit
    [Documentation]    User should be able to set Temperature  in Celsius unit
    [Tags]    testrailid=192326

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Temperature Unit in Celsius

User should be able to set Temperature in Fahrenheit unit
    [Documentation]    User should be able to set Temperature  in Fahrenheit unit
    [Tags]    testrailid=192327

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Temperature Unit in Fahrenheit

User should be navigated successfully to the 'Ask Alexa' screen.
    [Documentation]    User should be navigated successfully to the 'Ask Alexa' screen.
    [Tags]    testrailid=192328

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAskAlexa}    ${defaultWaitTime}
    Click Element    ${txtAskAlexa}

    Wait until page contains element    ${btnLaunchAlexa}    ${defaultWaitTime}
    Page should contain element    ${btnLaunchAlexa}
    Navigate Back to the Screen

Navigate to the screen of Frequently Asked questions.
    [Documentation]    Navigate to the screen of Frequently Asked questions.
    [Tags]    testrailid=192330

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Scroll the menu slider
    Wait until page contains element    ${txtFAQ}    ${defaultWaitTime}
    Click Element    ${txtFAQ}
    Sleep    10s
    Wait until page contains element    ${logoQuestions}    ${defaultWaitTime}
    Navigate Back to the Screen

Add new contractor in the application.
    [Documentation]    Add new contractor in the application.
    [Tags]    testrailid=192333

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click Element    ${txtContacts}
    Sleep  5s
    Wait until page contains element     ${btnAddNewContractor}     ${defaultWaitTime}
    Click Element    ${btnAddNewContractor}
    ${email}     Generate the random Email
    ${phoneNumber}     Generate the random number
    Set global variable    ${email}
    Wait until page contains element    	${waterHeaterCheckbox}       ${defaultWaitTime}
    Click Element   ${waterHeaterCheckbox}
    Sleep    10s
    Input text    ${txtnameTextField}      ${email}
    Input text    ${txtBxNewNumber}     ${phoneNumber}
    Input text    ${txtBxEmailAddress}     ${email}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Click Element    ${btnSavePhoneChanges}
    Sleep    5s
    Wait until page contains element    ${btnAddNewContractor}    ${defaultWaitTime}
    Navigate Back to the Screen


Edit the Contractor in the Application.
    [Documentation]    Edit the Contractor in the Application.
    [Tags]    testrailid=192334

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element    ${btnMenu}
    scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click Element    ${txtContacts}
    Wait until page contains element     ${Contractor5thList}   ${defaultWaitTime}
    Click Element                      	 ${Contractor5thList}
    Sleep    2s
    Wait until page contains element   ${EditContractor}  ${defaultWaitTime}
    Click Element    ${EditContractor}
    ${status}    run keyword and return status    Wait until page contains element   ${waterHeaterCheckbox}
    run keyword if    ${status}    Click Element  ${waterHeaterCheckbox}
    ${status}    run keyword and return status    Wait until page contains element    	${HVACContractorSelect}
    run keyword if    ${status}    Click Element   ${HVACContractorSelect}
    Wait until page contains element   	${txtnameTextField}    ${defaultWaitTime}
    ${string}    generate random string    4    [LOWER]
    Input text    ${txtnameTextField}      ${string}
    Click Element    ${btnSavechanges}
    Sleep   3s
    Navigate Back to the Screen
    Go back

Delete the Contractor in the Application
    [Documentation]    Delete the Contractor in the Application
    [Tags]    testrailid=192335

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Wait until page contains element    ${Contractor5thList}     ${defaultWaitTime}
    click Text  	${Contractor5thList}
    Wait until page contains element   ${btnDeleteDraft}  ${defaultWaitTime}
    Click Element    ${btnDeleteDraft}
    Sleep    5s
    Wait until page contains element     ${btnAddNewContractor}     ${defaultWaitTime}
    Navigate Back to the Screen


User should not be able to Edit Zones with Blank values.
    [Documentation]    User should not be able to Edit Zones with Blank values.
    [Tags]    testrailid=192347

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtManageZoneNames}    ${defaultWaitTime}
    Click Element    ${txtManageZoneNames}
    Wait until page contains element    ${RightZoning}    ${defaultWaitTime}
    Click Element    ${RightZoning}
    Wait until page contains element   ${FirstZoneSelection}  ${defaultWaitTime}
    Click Element    ${FirstZoneSelection}
    Wait until page contains element    ${txtBxZone}    ${defaultWaitTime}
    Clear text    ${txtBxZone}
    Wait until page contains element   Zone Name field can not be empty.    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Navigate Back to the Screen


User should be able to Edit Zone Names from the Application
    [Documentation]    User should be able to Edit Zone Names from the Application
    [Tags]    testrailid=192348

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtManageZoneNames}    ${defaultWaitTime}
    Click Element    ${txtManageZoneNames}
    Wait until page contains element    ${RightZoning}    ${defaultWaitTime}
    Click Element    ${RightZoning}
    Wait until page contains element    Smart Thermostat    ${defaultWaitTime}
    Click Element    Smart Thermostat
    Wait until page contains element    ${txtBxZone}    ${defaultWaitTime}
    Input text    zoneNameTextField     Edited Zone
    Click Element    ${btnSavechanges}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Navigate Back to the Screen

User should be able to add New Location.
    [Documentation]    User should be able to add New Location.
    [Tags]    testrailid=192336

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Sign Out From the Application
    Sign in to the application     ${LocationemailId}	  ${LocationpasswordValue}
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Wait until page contains element    ${btnAddNewLocation}
    Click Element   ${btnAddNewLocation}
    Wait until page contains element     ${MyCurrentLocation}
    Click Element   ${MyCurrentLocation}
    Sleep    10s
    Click Element    ${btnNext}
    Sleep    5s
    Navigate Back to the Screen
    Wait until page contains element    Exit    ${defaultWaitTime}
    Click Element    Exit
    Sleep    10s
    Wait until page contains element     ${BackButtonic}     ${defaultWaitTime}
    Click Element     ${BackButtonic}

User should be able to Edit New Location.
    [Documentation]    User should be able to Edit New Location.
    [Tags]    testrailid=192337

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Wait until page contains element    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]    ${defaultWaitTime}
    Click Element    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]
    Wait until page contains element    ${EditContractor}    ${defaultWaitTime}
    Click Element    ${EditContractor}
    Input text    locationNameTextField     Edited
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element   ${btnSavechanges}      ${defaultWaitTime}
    Click Element    ${btnSavechanges}
    Sleep    5s
    Click Element    ${BackButtonic}
    Sleep    3s
    Click Element    ${BackButtonic}

User should be able to Delete New Location.
    [Documentation]    User should be able to Delete New Location.
    [Tags]    testrailid=192338

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Wait until page contains element    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]   ${defaultWaitTime}
    Click Element   //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]
    Wait until page contains element    deleteBin    ${defaultWaitTime}
    Click Element    deleteBin
    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    Click Element    ${okButton}
    Sleep    5s
    Click Element    ${BackButtonic}
    Sign Out From the Application
    Sign in to the application     ${emailId}	  ${passwordValue}

User should be able to set Away mode for devices.
    [Documentation]    User should be able to set Away mode for devices.
    [Tags]    testrailid=192339

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Select the Device Location    ${locationNameHPWHGen5}
    Click Element    ${homeaway}
    ${Status}    run keyword and return status    Wait until page contains element    Ok
    RUN KEYWORD IF   ${Status}==True     Enable Away Setting    ${locationNameHPWHGen5}

    ${Away_status_ED}=      Read int return type objvalue From Device       ${vaca_net}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    4107
    ${status}    set variable     0
    ${status}   convert to integer     ${status}
    should be equal as integers    ${Away_status_ED}    ${status}
    Select the Device Location    Electric
    Click Element    ${homeaway}
    ${Status}    run keyword and return status    Wait until page contains element    Ok
    RUN KEYWORD IF   ${Status}==True     Enable Away Setting    Electric
    ${Away_status_ED}=      Read int return type objvalue From Device       ${vaca_net}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    704
    ${status}    set variable     0
    ${status}    convert to integer     ${status}
    should be equal as integers    ${Away_status_ED}    ${status}

User should be able to disable Away mode for devices.
    [Documentation]    User should be able to disable Away mode for multiple devices.
    [Tags]    testrailid=192340

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Go To Menu
    Click Element    Away Settings
    Sleep    2s
    Click Element    ${locationNameHPWHGen5}
    Click Element    ${awaySwitch}
    Click Element    ${savebutton01}
    Sleep    5s
    Wait until page contains element    Success
    Click Element    Ok
    Navigate Back to the Screen

User should be able to set Away mode for One particular device and disable Away mode for one particular device
    [Documentation]    User should be able to set Away mode for One particular device and disable Away mode for one particular device
    [Tags]    testrailid=192341

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Click Element   ${homeaway}
    ${Status}    run keyword and return status    Wait until page contains element    Ok
    RUN KEYWORD IF   ${Status}==True     Enable Away Setting    HPWHGen5
    ${Away_status_ED}=      Read int return type objvalue From Device       ${vaca_net}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${status}    set variable     1
    ${status}    convert to integer     ${status}
    should be equal as integers    ${Away_status_ED}    ${status}
    Go To Menu
    Click Element    Away Settings
    Sleep    2s
    Click Element    ${locationNameHPWHGen5}
    Click Element    ${awaySwitch}
    Click Element    ${savebutton01}
    Sleep    5s
    Wait until page contains element    Success
    Click Element    Ok
    Navigate Back to the Screen

User should be able to Email contractor when device is disconnected
    [Documentation]    User should not be able to Edit Zones with Blank values.
    [Tags]    testrailid=192342

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

     Wait until page contains element     ${iconNotification}     ${defaultWaitTime}
     Click Element       ${iconNotification}
     Sleep  3s
     ${status}=   Run Keyword And Return Status   page should contain element    ${noAlertText}
     Run Keyword If  ${status}   Navigate Back to the screen
     Run Keyword If  ${status}   Pass Execution  No Alerts
     Wait until page contains element     ${alertIcon}      ${defaultWaitTime}
     Click Element     ${alertIcon}
     Wait until page contains element      ${btnForwardContractor}     ${defaultWaitTime}
     click text      ${btnForwardContractor}
     Wait until page contains element     ${btnCancelContractor}      ${defaultWaitTime}
     Click Element     ${btnCancelContractor}
     Navigate Back to the Screen
     Navigate to App Dashboard

User should be able to Reprovision the device if found disconnected.
    [Documentation]     User should be able to Reprovision the device if found disconnected.
    [Tags]    testrailid=192345

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu

    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Wait until page contains element    ${btnAddNewLocation}
    Click Element   ${btnAddNewLocation}
    Wait until page contains element     ${MyCurrentLocation}
    Click Element   ${MyCurrentLocation}
    Sleep    10s
    Click Element    ${btnNext}
    Sleep    5s
    Navigate Back to the Screen
    Wait until page contains element    Exit    ${defaultWaitTime}
    Click Element    Exit
    Sleep    10s
    Wait until page contains element     ${BackButtonic}     ${defaultWaitTime}
    Click Element     ${BackButtonic}

User Shouldn't be able to change Password if invalid data is provided.
    [Documentation]    User Shouldn't be able to change Password if invalid data is provided.
    [Tags]    testrailid=192349

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Sign Out From the Application



    ${number}     Generate random string    10    0123456789
    ${password}   Generate random string    10    [NUMBERS]abcdefghigklmnopqrstuvwxyz

    Sign in to the application    ${emailId}    ${passwordValue}
    Go To Menu
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}

    Wait until page contains element    ${btnChangePassword}    ${defaultWaitTime}
    Sleep   3s
    ${location}=    Get element location    ${btnChangePassword}
    ${x}=    evaluate    str(${location}[x] + 50)
    ${y}=    evaluate    str(${location}[y] + 10)
    Click Element At Coordinates     ${x}     ${y}
    ${inValidPassword}    generate random string    4    [NUMBERS]abcdefghijklmn

    Wait until page contains element    ${currentPassword}    ${defaultWaitTime}
    Input text    ${currentPassword}    ${passwordValue}

    Wait until page contains element    Password must be at least 8 characters long.

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}

    Wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    Click Element  ${btnSavePhoneChanges}

    Wait until page contains element    ${currentPassword}    ${defaultWaitTime}
    Navigate Back to the Screen
    Navigate Back to the Screen




User should be able to create more than one schedule events of single location.
   [Documentation]    User should be able to create more than one schedule events of single location.
   [Tags]    testrailid=192366
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

   log out from the Application

   login to the application    ${zone_email}    ${zone_password}

############################# Create More than one Pre-Scheduled Events #############################

   Create Home schedule Event for device     ${locationNameTriton}
   Create Away schedule Event for device     ${locationNameTriton}
#
#
User should be able to select temperature slider OR Button according to requirements.
   [Documentation]    User should be able to select temperature slider OR Button according to requirements.
   [Tags]     testrailid=42732
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

############################ Select Temperature Slider ###########################

   Go to Temp Detail Screen   ${tempDashBoard}
   Page should contain element  ${setpointIncreaseButton}
   Page should contain element  ${setpointDecreaseButton}
   Navigate Back to the Screen

   Navigate Back to the Screen


User Should be able to logout from current account.
    [Documentation]    User Should be able to logout from current account.
    [Tags]    testrailid=192346

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Sign Out From the Application


User shouldn't be able to reset Password if invalid data is provided.
    [Documentation]    User shouldn't be able to reset Password if invalid data is provided.
    [Tags]    testrailid=192351

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Wait until page contains element    ${btnForgotPassword}    ${defaultWaitTime}
    Click Element    ${btnForgotPassword}
    Wait until page contains element    ${txtBxForgotEmail}    ${defaultWaitTime}
    Click Element    ${txtBxForgotEmail}
    Input text     ${txtBxForgotEmail}     123123
    Wait until page contains element    ${invalidEmailMessage}    ${defaultWaitTime}
    Page should contain element    ${invalidEmailMessage}
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen


User be able to reset Password.
    [Documentation]    User be able to reset Password.
    [Tags]    testrailid=192352

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Wait until page contains element    ${btnForgotPassword}    ${defaultWaitTime}
    Click Element    ${btnForgotPassword}
    Wait until page contains element    ${txtBxForgotEmail}    ${defaultWaitTime}
    Click Element    ${txtBxForgotEmail}
    Click Element    ${txtSubmitButton}
    Sleep    10s
    Input text    ${txtBxEmailAddress}    ${emailId}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element     ${btnSubmitForgotPass}     ${defaultWaitTime}
    Click Element    ${btnSubmitForgotPass}
    Sleep    5s
    Wait until page contains element   ${GoToMail}     ${defaultWaitTime}
    Click Element    ${GoToMail}
    Wait until page contains element   ${ApplyMail}     ${defaultWaitTime}
    Click Element    ${ApplyMail}
    Sleep    5s
    Background app    -1
    go_back
    Click Element    EcoNet


    Wait until page contains element    ${OTPScreen}    ${defaultWaitTime}
    Input text      ${OTPScreen}    111111
    Wait until page contains element    ${ButtonResetPassword}    ${defaultWaitTime}
    Click element    ${ButtonResetPassword}
    Sleep    5s
    Click Element    ${okButton}

    Wait until page contains element    ${txtBxPasswordChange}   ${defaultWaitTime}
    Input text    ${txtBxPasswordChange}   ${passwordValue}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Input text       ${txtBxCnfrmPassChange}    ${passwordValue}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}

    Wait until page contains element    ${txtSubmitButton}    ${defaultWaitTime}
    Click Element    ${txtSubmitButton}
    set global variable    ${randPasswordValue}    ${password}
    Sleep    10s

    Wait until page contains element     ${txtBxEmailAddress}    ${defaultWaitTime}
    Input text   ${txtBxEmailAddress}    ${emailId}
    Sleep    3s
    Wait until page contains element      ${txtBxPassword}     ${defaultWaitTime}
    Input Password    ${txtBxPassword}      ${passwordValue}
    sleep  3s
    Wait until page contains element     ${keyboardDoneButton}     ${defaultWaitTime}
    Click element     ${keyboardDoneButton}
    Wait until page contains element   ${sign_in_link}    ${defaultWaitTime}
    Click element    ${sign_in_link}
    sleep    5s
    ${status}    run keyword and return status    Wait until page contains element    ${txtNotNow}    60s
    Run keyword if    ${status}    Click element    ${txtNotNow}


User should be able to change name from your profile
   [Documentation]    User should be able to change name from your profile
   [Tags]     testrailid=192355
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

############################ Change User Name from the application #############################

    Go To Menu

    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Sleep    4s

    # all the element locators neeed to change
    Wait until page contains element     ${btnChangeName}     ${defaultWaitTime}

    Tap     ${btnChangeName}

    ${nameTxt}       Generate Random String    4    [LOWER]
    ${surNameTxt}    Generate random string    10    [LOWER]

    ${nameTxt}       Convert to title case    ${nameTxt}
    ${surNameTxt}    Convert to title case    ${surNameTxt}
    Wait until page contains element    ${txtNameFirst}     ${defaultWaitTime}

    clear text    ${txtNameFirst}
    Input text    ${txtNameFirst}    ${nameTxt}

    clear text    ${txtNameSecond}
    Input text    ${txtNameSecond}    ${surNameTxt}

    ${name}     catenate     ${nameTxt}${space}${surNameTxt}


    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}

    Wait until page contains element    ${btnSavePhoneChanges}    ${defaultWaitTime}
    Click Element  ${btnSavePhoneChanges}
    Sleep    10s
    page should contain element      ${name}
    Navigate Back to the Screen



User should be able to enable Geo Fencing option for setting Away mode.
    [Documentation]    User should be able to perform geo fencing functionality if button is On for Geo Fencing
    [Tags]    testrailid=192369

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Sleep    10s
    Enable or Disable Geofencing    On
    Navigate Back to the Screen
    Navigate Back to the Screen

User should be able to set different location from the list.
    [Documentation]     User should be able to set different location from the list
    [Tags]    testrailid=192370

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Sleep    5s
    Click Element    ${txtGeofencing}
    Enable or Disable Geofencing    On
    Click Element    Current Location
    Sleep    2s
    Click Element     Gladiator
    Enable or Disable Geofencing    On
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Navigate Back to the Screen


User should be able to set different distance unit from the list
    [Documentation]    User should be able to set different distance unit from the list
    [Tags]    testrailid=192371

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Sleep    5s
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Enable or Disable Geofencing    enable
    Click Element    ${txtGeofencing}
    Change Geofencing Distance Unit     ${miles}
    Change Geofencing Distance Unit     ${kilometers}
    Navigate Back to the Screen
    Navigate Back to the Screen


User should be able set Radius for Home/Away
    [Documentation]    User should be able set Radius for Home/Away
    [Tags]    testrailid=192372

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Enable or Disable Geofencing    enable
    Change Geofencing Radius
    Sleep   5s
    Navigate Back to the Screen
    Navigate Back to the Screen


User should be able to Enable Geo fencing for a particular loaction
    [Documentation]     User should be able to change location after disabling Geo Fencing
    [Tags]      testrailid=52484

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Sleep    10s
    Enable or Disable Geofencing    On
    Navigate Back to the Screen
    Navigate Back to the Screen


User should be able to disable Geo Fencing option for setting Away mode
    [Documentation]     User should be able to disable Geo Fencing option for setting Away mode
    [Tags]      testrailid=192373

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Sleep    10s
    Enable or Disable Geofencing    Off
    Navigate Back to the Screen
    Navigate Back to the Screen


User should not be able to set distance unit and Radius after disabling Geo fencing
    [Documentation]     User should not be able to set distance unit and Radius after disabling Geo fencing
    [Tags]      testrailid=52482
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element    ${btnMenu}
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Enable or Disable Geofencing    disable
    Wait until page contains element       ${awayGeoFencing}      ${defaultWaitTime}
    Click Element   ${awayGeoFencing}
    Sleep   2s
    page should not contain element     ${bubble}
    Click Element at mid point     ${geoUnitName}
    page should not contain element   ${cancel}
    Navigate Back to the Screen


User should be able to change location after disabling Geo Fencing
    [Documentation]     User should be able to change location after disabling Geo Fencing
    [Tags]      testrailid=52483
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element    ${btnMenu}
    Wait until page contains element    ${txtAwaySettings}     ${defaultWaitTime}
    Click Element    ${txtAwaySettings}
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'    Enable or Disable Geofencing    disable
    Wait until page contains element    ${geoLocationName}
    Click Element at mid point   ${geoLocationName}
    Wait until page contains element    ${cancel}     ${defaultWaitTime}
    Click Element    ${cancel}
    Click Save button of Away Settings
    Wait until page contains element     ${success}     ${defaultWaitTime}
    Click Element    ${okButton}
    Navigate Back to the Screen


User should be able to clear Alerts from the application
    [Documentation]     User should be able to clear all Alerts from the application
    [Tags]  testrailid=192344
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page
    Select the Device Location    HPWHGen5
    Sleep    2s
    ${status}    Run Keyword And Return Status    Wait until page contains element    validateBell    ${defaultWaitTime}
    run keyword if    ${status}    Click Element     validateBell
    #### Block Due to Locator not available for the Selection of Alerts


User should be able to view Privacy Notice
    [Documentation]     User should be able to view Privacy Notice
    [Tags]  testrailid=192356
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page
    Go To Menu
    scroll to the upward    ${txtAwaySettings}
    Wait until page contains element    ${privacyNotice}    ${defaultWaitTime}
    Click Element   ${privacyNotice}
    Sleep    5s
    wait until page contains element    ${privacyNotice}
    Sleep   15s
    Navigate Back to the Screen

User should be able to add HomeRouter SSID
    [Documentation]     User should be able to add HomeRouter SSID
    [Tags]  TC-109  testrailid=192374
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${WiFiName}  Generate Random String     5    [LOWER]
    set global variable     ${WiFiName}
    ${index}=     Add HomeRouter SSID Manually    ${WiFiName}   password1   WPA2
    page should contain element     ${WiFiName}
    Swipe    50    50    50    100
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User should not be able to add same SSID
    [Documentation]     User should be able to add multiple HomeRouter SSID
    [Tags]      TC-111  testrailid=192376
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m  Open Application without device detail page    Go To Menu
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Wait until page contains element    ${homeWifiConn}     ${defaultWaitTime}
    Click Element   ${homeWifiConn}
    Wait until page contains element    ${btnAdd}   ${defaultWaitTime}
    Click Element    ${btnAdd}
    Wait until page contains element    ${txtBxAddSSID}     ${defaultWaitTime}
    Sleep   3s
    Input text    ${txtBxAddSSID}    ${WiFiName}
    Sleep   3s
    Wait until page contains element    Security type   ${defaultWaitTime}
    Click Element      Security type

    Wait until page contains element    WPA2   ${defaultWaitTime}
    Click Element      WPA2
    Sleep   3s
    Input text    ${ssidPassword}    password1

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    page should contain element    ${errMsgConnectionInUser}
    Navigate Back to the Screen
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to add multiple HomeRouter SSID
    [Documentation]     User should be able to add multiple HomeRouter SSID
    [Tags]      TC-110  testrailid=52764

    Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element     ${btnMenu}
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${WiFiName1}  Generate Random String     6   [LOWER]
    Add HomeRouter SSID Manually    ${WiFiName1}   password1   WPA2
    page should contain element     ${WiFiName1}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    ${WiFiName2}  Generate Random String     7    [LOWER]
    Add HomeRouter SSID Manually    ${WiFiName2}   password1   WPA2
    page should contain element     ${WiFiName2}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to add SSID with None security type.
    [Documentation]     should be able to add SSID with None security type.
    [Tags]      TC-112      testrailid=192377
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element     ${btnMenu}
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${WiFiName}  Generate Random String     5    [LOWER]
    Add HomeRouter SSID Manually    ${WiFiName}   password1   None
    page should contain element     ${WiFiName}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User should be able to edit SSID name
    [Documentation]    User should be able to edit SSID name
    [Tags]      TC-113      testrailid=52767
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${WiFiName}  Generate Random String     5    [LOWER]
    Edit HomeRouter SSID name      ${WiFiName}
    page should contain element    ${WiFiName}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to remove HomeRouter SSID
    [Documentation]     User should be able to remove HomeRouter SSID
    [Tags]      TC-114      testrailid=192378
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${removed}=     Remove HomeRouter SSID
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to add EcoNet WiFi Connections.
    [Documentation]     User should be able to remove HomeRouter SSID
    [Tags]      TC-115      testrailid=192379
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${EcoWiFiName}  Generate Random String     5    [LOWER]
    Add EcoNet WiFi Connections    ${EcoWiFiName}
    page should contain element    EcoNet-${EcoWiFiName}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to edit EcoNet WiFi Connection name.
    [Documentation]     User should be able to edit EcoNet WiFi Connection name.
    [Tags]      TC-117      testrailid=192380
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Edit EcoNet WiFi Connections
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User should be able to remove Econet WiFi Connections.
    [Documentation]    User should be able to remove Econet WiFi Connections.
    [Tags]      TC-119      testrailid=192382
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Remove EcoNet Wifi connection
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to add multiple EcoNet WiFi Connections.
    [Documentation]    User should be able to add multiple EcoNet WiFi Connections.
    [Tags]      TC-116      testrailid=52770
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${EcoWiFiName}  Generate Random String     5    [LOWER]
    Add EcoNet WiFi Connections    ${EcoWiFiName}
    page should contain element    EcoNet-${EcoWiFiName}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen
    Sleep    5s
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    ${EcoWiFiName1}  Generate Random String     6    [LOWER]
    set global variable   ${EcoWiFiName1}
    Add EcoNet WiFi Connections    ${EcoWiFiName1}
    page should contain element    EcoNet-${EcoWiFiName1}
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User should not be able to add same EcoNet WiFi ID
    [Documentation]    User should not be able to add same EcoNet WiFi ID
    [Tags]      TC-118      testrailid=192381
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Wait until page contains element    EcoNet WiFi Connections     ${defaultWaitTime}
    Click Element   EcoNet WiFi Connections
    Wait until page contains element    ${btnAdd}   ${defaultWaitTime}
    Click Element    ${btnAdd}
    Wait until page contains element    ${txtBxAddSSID}     ${defaultWaitTime}
    Sleep   3s
    Input text    ${txtBxAddSSID}    ${EcoWiFiName1}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    page should contain element     //XCUIElementTypeStaticText[@name="Connection name is in use"]
    Navigate Back to the Screen
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen


User should be able to verfiy App & Wifi support details
   [Documentation]    User should be able to verfiy App & Wifi support details
   [Tags]    testrailid=192331

    Open Application without device detail page
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click Element    ${btnMenu}
    scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click Element    ${txtContacts}
    Click Element    //XCUIElementTypeStaticText[@name="Contractor Name"][1]
    page should not contain element    ${EditContractor}
    page should not contain element    ${btnDeleteDraft}
    Wait until page contains element    ${btnAddNewContractor}    ${defaultWaitTime}

Create an Account with Phone Number
    [Tags]      testrailid=165679

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Run keyword and ignore error    Sign Out From the Application
    ${emailID}      Generate the random email
    ${number}       Generate the random Number
    ${password}     Generate random string   10      [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${firstName}    Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz
    ${lastName}     Generate random string    5      [LOWERS]abcdefghijklmnopqrstuvwxyz

    Set global variable    ${randEmailId}    ${emailID}
    Set global variable    ${randPasswordValue}    ${password}

    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Click Element    ${btnCreateAccount}



    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}



    Input text    ${txtBxFirstName}       ${firstName}
    Input text    ${txtBxLastName}        ${lastName}
    Input text    ${txtBxPhoneNumber}     ${number}
    Input text    ${txtBxEmailAddress}    ${emailID}

    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}
    Sleep    4s

    Click Element    ${txtBxCnfrmPasswrd}
    Input text   ${txtBxCnfrmPasswrd}    ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}

    Input text      ${txtBxPassword}        ${password}
    ${Status}    Run Keyword And Return Status    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Run Keyword If    ${Status} == True           Click Element    ${keyboardDoneButton}


    Click Element    ${btnAddress}
    Sleep    15s
    ${Status}    run keyword and return status    Click Element    Your current location?
    run keyword if    ${Status}==False   Run Keywords  Click Element    ${BackButton}        AND    Click Element    ${btnAddress}    AND  Sleep    10s  AND   Click Element    Your current location?
    Sleep    4s
    Wait until page contains element     ${agreeCheckBox}    ${defaultWaitTime}
    Click Element    ${agreeCheckBox}
    Sleep    2s
    Swipe    60     461     60    250   5000
    Swipe    60     461     60    250   5000
    Click Element    	Create Account
    Sleep    5s
    Click Element   ${SubmitButtonXpath}
    Sleep    10s
    ${Status}    Run Keyword and return status    Click Element    Ok

    Sleep    15s
    Enter validation code
    Sleep    10s
    Wait until page contains element    Add Location
    ${status}    Run keyword and return status    Wait until page contains element    Not Now    20s
    Run Keyword If    ${status}    Click Element    Not Now


Verify length of first name and last name field
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Go To Menu

    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Sleep    4s
    Wait until page contains element     ${btnChangeName}     ${defaultWaitTime}
    Tap     ${btnChangeName}

    ${nameTxt}       Generate Random String    32    [LOWER]
    ${surNameTxt}    Generate random string    43    [LOWER]

    ${nameTxt}       convert to title case    ${nameTxt}
    ${surNameTxt}    convert to title case    ${surNameTxt}
    Wait until page contains element    ${txtNameFirst}     ${defaultWaitTime}

    clear text    ${txtNameFirst}
    Input text    ${txtNameFirst}    ${nameTxt}

    Wait until page contains element    First name can not be longer than 32 characters.

    clear text    ${txtNameSecond}
    Input text    ${txtNameSecond}    ${surNameTxt}

    Wait until page contains element    Last name can not be longer than 32 characters.

    clear text     ${txtNameFirst}
    clear text     ${txtNameSecond}

    Wait until page contains element    Please enter first name.
    Wait until page contains element    Please enter last name.

    Click Element     ${BackButtonic}
    Navigate Back to the Screen

Verify create account functionality with already existed email id
    # Create Account Block Due to locator is not available of Agress Checkbox



Verify create account functionality with already existed phone number
 # Create Account Block Due to locator is not available of Agress Checkbox

Verify create account button by leaving any field as blank
 # Create Account Block Due to locator is not available of Agress Checkbox


Verify sign in button when both fields are blank (email address and password)
     Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
     Sign Out From the Application
     Click Element   //XCUIElementTypeStaticText[@name="Sign In"]
     Input text    ${txtBxEmailAddress}     1234
     clear text    ${txtBxEmailAddress}
     Wait until page contains element    Email Address field can not be empty.
     Click Element   //XCUIElementTypeStaticText[@name="Sign In"]
     Input text    passwordTextField     1234678
     clear text    passwordTextField
     Wait until page contains element    Password field can not be empty.


Verify two pop up options should be displayed when the user long press on button I'm home / I'm away
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Long Press  5000
    Wait until page contains element     Scheduled Away/Vacation
    Wait until page contains element     Away Settings

Verify maxmimum character limit of first name and last name

    Click Element    //XCUIElementTypeStaticText[@name="Create Account"]
    ${nameTxt}       Generate Random String    32    [LOWER]
    ${surNameTxt}    generate random string    43    [LOWER]
    ${nameTxt}       convert to title case    ${nameTxt}
    ${surNameTxt}    convert to title case    ${surNameTxt}
    Wait until page contains element    ${txtNameFirst}     ${defaultWaitTime}
    Input text    ${txtNameFirst}    ${nameTxt}
    Wait until page contains element    First name can not be longer than 32 characters.
    Input text    ${txtNameSecond}    ${surNameTxt}\
    Wait until page contains element    Last name can not be longer than 32 characters.
    clear text     ${txtNameFirst}
    clear text     ${txtNameSecond}
    Wait until page contains element    Please enter first name.
    Wait until page contains element    Please enter last name.
    Navigate Back to the Screen

Verify save funtionality at the time of blank phone number wihile editing the field
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page

    Go To Menu
    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
    Click Element    ${txtAccount}
    Sleep    4s
    Wait until page contains element    Phone Number   ${defaultWaitTime}
    Tap     Phone Number
    Wait until page contains element    ${txtBxNewNumber}    ${defaultWaitTime}
    Clear Text    ${txtBxNewNumber}
    Wait until page contains element    Mobile Phone Number field can not be empty.


Verify that the validation message should be displayed when the user enter already registered phone number.
    Click Element   ${txtBxNewNumber}     8780961795
    Click Element    ${btnsavechanges}
    Sleep    5s
    Wait until page contains element     User is already associated with phone number
    Click Element    Ok
    Navigate Back to the Sub Screen
    Navigate Back to the Screen


User should not able to create contractor with Invalid Detail
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    2m    Open Application without device detail page
    Go To Menu
    scroll to the Contacts
    Wait until page contains element    ${txtContacts}    ${defaultWaitTime}
    Click Element    ${txtContacts}
    Sleep  5s

    Wait until page contains element     ${btnAddNewContractor}     ${defaultWaitTime}
    Click Element    ${btnAddNewContractor}
    ${email}     Generate the random Email
    ${phoneNumber}     generate the random number
    Set global variable    ${email}



    Wait until page contains element    	${waterHeaterCheckbox}       ${defaultWaitTime}
    Click Element   ${waterHeaterCheckbox}
    Sleep    10s
    Input text    ${txtnameTextField}      1234455555555555557645376535
    Input text    ${txtBxNewNumber}     536764855321
    Input text    ${txtBxEmailAddress}     1267888

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}

    Wait until page contains element     Name can not be longer than 32 characters.
    Wait until page contains element     Please enter a valid email address.
    Wait until page contains element     Phone number must have valid digits.
    Sleep    5s
    Navigate Back to the Screen
    Wait until page contains element    ${btnAddNewContractor}    ${defaultWaitTime}
    Navigate Back to the Screen

Verify that the validation message is displayed when the EcoNet Wifi connections field is blank.
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Click Element    EcoNet WiFi Connections
    Click Element    ${btnAdd}
    clear text    ${txtBxAddSSID}
    Wait until page contains element    WiFi name field can not be empty.
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

Verify that the validation message is displayed when the Home connections field is blank.
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtGeneralSetting}    ${defaultWaitTime}
    Click Element    ${txtGeneralSetting}
    Click Element    ${homeWifiConn}
    Click Element    ${btnAdd}
    Input text    ${txtBxAddSSID}   123
    clear text    ${txtBxAddSSID}
    Wait until page contains element    WiFi name field can not be empty.
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click Element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

User should not be able to proceed if Invalid location creation details are provided
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Sleep    5s
    Click Element    Add New Location
    Input text  postalCode(nil, true)TextField    123
    wait until page contains element    Please enter a valid zip code.
    Navigate Back to the Screen
    Click Element    Exit
    Sleep    2s
    Click Element    ${BackButtonic}


user not able to create new location with existing location name
    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
      ...       Open Application without device detail page
    Go To Menu
    Wait until page contains element    ${txtLocationProducts}    ${defaultWaitTime}
    Click Element    ${txtLocationProducts}
    Sleep    5s
    Click Element    Dragon
    Sleep    5s
    Click Element     ${EditContractor}
    Clear text    locationNameTextField
    Input text    locationNameTextField    HPWHGen5
    Wait until page contains element     //XCUIElementTypeStaticText[@name="Location name is in use"]

#User should able delete Reskin Account
#    [Documentation]    User should able delete Reskin Account
#    [Tags]     testrailid=192383
#    Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Wait Until Keyword Succeeds  2x  2m
#      ...       Open Application without device detail page
#    Go To Menu
#    Wait until page contains element    ${txtAccount}    ${defaultWaitTime}
#    Click Element    ${txtAccount}
#    Wait until page contains element     //XCUIElementTypeStaticText[@name="Delete Account"]    ${defaultWaitTime}
#    Click Element     //XCUIElementTypeStaticText[@name="Delete Account"]
#
#    Wait until page contains element    Delete   ${defaultWaitTime}
#    Click Element    Delete


User should be able to set Away pre-schedule event for a particular location.
   [Documentation]    User should be able to set Away pre-schedule event for a particular location.
   [Tags]     testrailid=192357

   Sign in to the application    ${emailId}    ${passwordValue}

   Create Away schedule Event for device      HPWHGen5

User should be able to delete Away pre-schedule event of the particular location
   [Documentation]   User should be able to delete Away pre-schedule event of the particular location
   [Tags]     testrailid=192361
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page


   Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
   Delete Pre-Scheduled Event
   Navigate Back to the Screen


User should be able to delete scheduled event in between the scheduled time.
   [Documentation]   User should be able to delete scheduled event in between the scheduled time.
   [Tags]    testrailid=192368
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page


   sleep    5s
   Select The Device Location        ${locationNameHPWHGen5}
   Check Pre-Scheduled Away Status
   sleep    5s
   Delete Pre-Scheduled Event
   Navigate Back to the Screen
   Sleep    5s
   Check Pre-Scheduled Away Status


User should not be able to create scheduled event when Away settings are off.
    [Documentation]   User should not be able to create scheduled event when Away settings are off.
    [Tags]    testrailid=192367
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page
    ############################# Create Pre-Scheduled Event when Away settings are off ############################

    # Enable Or Disable Away Mode For Multiple Product    ${locationNameHPWHGen5}   Enabled    Enabled
    Go To Menu
    Wait until page contains element     ${txtScheduleAway}    ${defaultWaitTime}
    Click Element    ${txtScheduleAway}
    Wait until page contains element     ${locationNameHPWHGen5}    ${defaultWaitTime}
    Click Element    ${locationNameHPWHGen5}
    Wait until page contains element    ${btnStartDate}    ${defaultWaitTime}
    Click Element     ${btnStartDate}
    Wait until page contains element    //XCUIElementTypeApplication[@name="EcoNet 2022"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther    ${defaultWaitTime}
    Click Element    //XCUIElementTypeApplication[@name="EcoNet 2022"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element    ${btnEndDate}    ${defaultWaitTime}
    Click Element     ${btnEndDate}
    Wait until page contains element     //XCUIElementTypeApplication[@name="EcoNet 2022"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    Click Element       //XCUIElementTypeApplication[@name="EcoNet 2022"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element    ${saveButton1}    ${defaultWaitTime}
    Click Element     ${saveButton1}
    Wait until page contains element    Ok    ${defaultWaitTime}
    Click Element     Ok
    sleep   5s
    Swipe    50    50    50    100

User should be able to check Home status according to scheduled events
   [Documentation]   User should be able to check Home status according to scheduled events
   [Tags]    testrailid=192362
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

   Wait until page contains element    ${btnMenu}    ${defaultWaitTime}

############################ Check Pre-Scheduled Home Status ############################

   Select the Device Location    ${locationNameHotSpring}
   ${Away_status_M}      Check Pre-Scheduled Home Status

############################ Validate Away Status On Equipment #########################

#   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Preschedule_Mac}    ${Device_Preschedule_Mac_In_Format}    ${preSchedule_device_id}
   sleep    5s
#   should be equal as integers    ${Away_status_ED}    ${Away_status_M}



User should be able to change Away status of the particular device in between scheduled events
   [Documentation]  User should be able to change Away status of the particular device in between scheduled events
   [Tags]   testrailid=192360
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

   Wait until page contains element    ${btnMenu}    ${defaultWaitTime}

############################ Change Pre-Scheduled Satatus ##########################

   Select the Device Location    ${locationNameHotSpring}
   ${Away_status_M}      Change Pre-Scheduled Status

############################ Validate Away Status On Equipment #########################

   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Preschedule_Mac}    ${Device_Preschedule_Mac_In_Format}    ${preSchedule_device_id}
   sleep    5s
   should be equal as integers    ${Away_status_ED}    ${Away_status_M}


Pre scheduled event should be removed after following the event.
   [Documentation]   Pre scheduled event should be removed after following the event.
   [Tags]     testrailid=192364
   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

   Wait until page contains element    ${btnMenu}    ${defaultWaitTime}

   ########################## Check Pre-Scheduled Event List ##########################

   Select the Device Location    ${locationNameHotSpring}
   Sign in to the application    ${emailId}    ${passwordValue}
    ########################## Set Away pre-scheduled Event from the application ###########################

   Create Away schedule Event for device      HPWHGen5

Verify that user can sign in with invalid Email and password multiple time
    [Tags]    New
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

#    Sign Out From the Application

    sleep     3s
    ${present}=    Run Keyword And Return Status     Page Should Contain Element     Allow While Using App
    Run Keyword If    ${present}     Handle Allow Location popup     Allow While Using App

    ${present}=   Run Keyword And Return Status    Wait until page contains element    ${btnAllow}     5s
    Run Keyword If    ${present}    select element using coordinate     ${btnAllow}    65      20
    sleep     3s
    ${present}=    Run Keyword And Return Status     Page Should Contain Element     Allow While Using App
    Run Keyword If    ${present}     Handle Allow Location popup     Allow While Using App
    sleep     10s
    Wait until page contains element    applogo    ${defaultWaitTime}
    Page Should Contain Element    applogo
    Tap    applogo   count=3
    sleep    10s
    Wait until page contains element    Test    ${defaultWaitTime}
    Click Element     Test
    sleep    6s

    Wait until page contains element    Sign In    ${defaultWaitTime}
    select element using coordinate     Sign In     10    5
    Sleep    3s
    Wait until page contains element   ${txtBxEmailAddress}    ${defaultWaitTime}
    Input text   ${txtBxEmailAddress}    akshay.suthar@dgfg.com
    Sleep    3s
    Wait until page contains element   passwordTextField     ${defaultWaitTime}
    Input Password    passwordTextField     12345678
    sleep  3s
    Wait until page contains element    ${keyboardDoneButton}     ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element  ${sign_in_link}    ${defaultWaitTime}
    Click Element    ${sign_in_link}

    Wait until page contains element    Incorrect Email id or Password
    Click Element    Ok


    Wait until page contains element   ${txtBxEmailAddress}    ${defaultWaitTime}
    Clear Text    ${txtBxEmailAddress}
    Input text   ${txtBxEmailAddress}    akshay.suthar@dgfg.com
    Sleep    3s
    Wait until page contains element    passwordTextField     ${defaultWaitTime}
    Input Password    passwordTextField     12345678
    sleep  3s
    Wait until page contains element     ${keyboardDoneButton}     ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Wait until page contains element   ${sign_in_link}    ${defaultWaitTime}
    Click Element    ${sign_in_link}
    Wait until page contains element    Incorrect Email id or Password
    Click Element    Ok

    Navigate Back to the Sub Screen


Verify that user can change the selected Phone/Email option when the user back navigates from the OTP screen.
    [Tags]    New

    ${emailID}      Generate the random email
    ${number}       Generate the random Number
    ${password}     Generate random string   10    [NUMBERS]abcdefghigklmnopqrstuvwxyz
    ${firstName}    Generate random string    5     [LOWERS]abcdefghijklmnopqrstuvwxyz
    ${lastName}     Generate random string    5     [LOWERS]abcdefghijklmnopqrstuvwxyz

    set global variable    ${randEmailId}    ${emailID}
    set global variable    ${randPasswordValue}    ${password}

    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Click Element    ${btnCreateAccount}
    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}

    Input text    ${txtBxFirstName}       ${firstName}
    Input text    ${txtBxLastName}        ${lastName}
    Input text    ${txtBxEmailAddress}    ${emailID}
    Input text    ${txtBxPhoneNumber}     ${number}
    Input text    ${txtBxPassword}        ${password}

    Wait until page contains element      ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    sleep    2s
    Input text    ${txtBxCnfrmPasswrd}    ${password}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click Element     ${keyboardDoneButton}
    Click Element    ${btnAddress}
    Sleep    15s
    ${Status}    run keyword and return status    Click Element    Your current location?
    run keyword if    ${Status}==False   Run Keywords  Click Element    ${BackButton}        AND    Click Element    ${btnAddress}    AND  Sleep    10s  AND   Click Element    Your current location?
    Sleep    4s
    Wait until page contains element     ${agreeCheckBox}    ${defaultWaitTime}
    Click Element    ${agreeCheckBox}

    Click Element    	createAccountButton
    Sleep    5s
    Click Element    Phone
    Click Element   ${SubmitButtonXpath}
    Sleep    10s
    Navigate Back to the Sub Screen
    Click Element    	createAccountButton
    Sleep    5s
    Click Element    Phone
    Click Element   ${SubmitButtonXpath}
    Sleep    5s
    Click Element    Ok

    Sleep    10s


Verify that user can change the selected Email Option to the Phone Option without getting Registered.
    [Tags]    New

    Navigate Back to the Sub Screen
    Click Element    	createAccountButton
    Sleep    5s
    Click Element    Phone
    Click Element   ${SubmitButtonXpath}
    Sleep    5s
    Click Element    Ok
    Sleep    10s

Verify that user can change the selected Phone Option to the Email Option without getting Registered.
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

    Navigate Back to the Sub Screen
    Click Element    	createAccountButton
    Sleep    5s
    Click Element    Phone
    Click Element   ${SubmitButtonXpath}
    Sleep    5s
    Click Element    Ok
    Sleep    10s
    Navigate Back to the Screen
    Navigate Back to the Sub Screen

Verify that scroll function of the application work as expected.
    [Tags]    New
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

    Sign in to the application    ${emailId}    ${passwordValue}
    Go To Menu
    Scroll to the Contacts

Verify that user can Set Geofencing setting in a new account without any location and Device provision.
    [Tags]    New
    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without device detail page

    Click Element    ${txtAwaySettings}
    Sleep    5s
    Click Element    ${txtGeofencing}
    Sleep    2s
    Wait until page contains element       ${geoFenceButton}    ${defaultWaitTime}
    ${on/off}=   Get Element Attribute       ${geoFenceButton}       value
    Run Keyword If      '${operation}'=='On' and '${on/off}'=='Off'      Click Element     ${geoFenceButton}
    ...    ELSE IF      '${operation}'=='Off' and '${on/off}'=='On'      Click Element     ${geoFenceButton}
    Click Save button of Away Settings
    Sleep    10s
    RUN KEYWORD AND IGNORE ERROR      Click Element    ${okButton}

