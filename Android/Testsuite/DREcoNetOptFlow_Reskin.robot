*** Settings ***
Documentation       This is the test file for End to end testing of Electric WH

*** Settings ***

Library    AppiumLibrary

Library             Collections
Library             String
Library             OperatingSystem

Library             ../../src/RheemMqtt.py
Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/Android/Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot

Suite Setup         Run Keywords    Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
#...                     AND    Select Device Location    ${select_Electric_location}
#...                     AND    Temperature Unit in Fahrenheit
#...                     AND    Connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}

Suite Teardown      Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_Electric_location}

*** Variables ***


${DRProgramName}                        EcoNetAutomationTesting
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         704
${DeviceMacaddressReal}                 80-91-33-8A-AD-E2

${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          heatpumpWaterHeaterGen4

${Admin_EMAIL}                          automation3@rheem.com
${Admin_PWD}                            12345678
${emailId}                              automation3@rheem.com
${passwordValue}                        12345678

${select_Electric_location}             Test
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']


*** Test Cases ***

TC-01:Verify that the Energy & Savings menu should be displayed on the Menu bar.
    [Tags]

    Go to Menubar
    Sleep    1s
    Page Should Contain Element    ${DREnergySavings}

TC-02:Verify that the Energy & Savings screen should be displayed
    [Tags]

    Navigate to the Energy & Savings Page
    Page Should Contain Text    My Programs
    Page Should Contain Text    Explore

TC-03:Verify that the Device type/location alert screen UI components should be visible as expected.
    [Tags]

    Select Location from Energy & Savings Screen      ${select_Electric_location}    Heat Pump Water Heater
    Page Should Contain Element    ${DRLocationSelection}

TC-04:Verify that the "Energy & Savings" screen UI components Should be visible as expected.
    [Tags]

    Page Should Contain Text    My Programs
    Page Should Contain Text    Explore
    Page Should Contain Element    ${DRProgramCard}

TC-05:Verify that the user should be navigated to the Explore Programs screen.
    [Tags]

    Sleep    2s
    Click Text    Explore
    Page Should Contain Element    ${DRProgramCard}

TC-06:Verify that theDevice Zip Associated Programs List should be displayed on the Explore screen.
    [Tags]

    Click Text    Explore
    Page Should Contain Element    ${DRProgramCard}

TC-07:Verify that the Program details screen should be displayed when the user selects Program.
    [Tags]

    Wait until element is visible    ${DRProgramCard}
    Click Element    ${DRProgramCard}
    Sleep    20s
    Page Should Contain Text    Sign Up Now


TC-08:Verify that the Sign Up button should be displayed on the screen.
    [Tags]

    Page Should Contain Text    Sign Up Now

TC-09:Verify that the Product and Customer information screen should be displayed when the user click on the Sign Up button.

    Click Text    Sign Up Now
    Sleep    2s
    Page Should Contain Text    ${select_Electric_location}
    Page should contain Text  ${Admin_EMAIL}


TC-10:Verify that the Product and Customer information screen UI components should be visible as expected.
    [Tags]

    Page Should Contain Text    Product Information
    Page Should Contain Text    Product Name
    Page Should Contain Text    Location
    Page Should Contain Text    Serial #
    Page Should Contain Text    Customer Information

TC-11:Verify that the "Continue" button should not be enabled while checkbox is unchecked.
    [Tags]

    Element Should Be Disabled    ${DRContinueButton}


TC-12:Verify that the "Continue" button should be enabled while checkbox is checked.
    [Tags]


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
    Element Should Be Enabled    ${DRContinueButton}


TC-13:Verify that the Terms and Conditions screen should be displayed when the user Continue the Program process.
    [Tags]

    Click Text    Continue
    Sleep    2s
    Page Should Contain Text    Cancel
    Page Should Contain Text    I Agree

TC-14:Verify that the Agree button should be enabled when the scroll the Terms and Conditions screen.
    [Tags]

    FOR    ${temp}    IN RANGE    4
        ${Status}    Run Keyword And Return Status    Element Should Be Enabled    ${DRIAgree}
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END

TC-15:Verify that the Terms and Conditions screen should be closed when the user click on the Cancel button.
    [Tags]

    Sleep    2s
    Click Text    Cancel
    Sleep    20s
    Page should not contain text    Terms and Conditions
    Page should not contain text    Cancel


TC-16:Verify that the Program successfully selected after terms and conditions full filled.
    [Tags]

    Create DR Program Request

TC-17:Verify that the Program Selected Congratulation screen UI components should be visible as expected.
    [Tags]

    Wait until element is visible    //*[@text="Congratulations!"]    20s
    Page should contain text    Congratulations!
    Page should contain text    Complete

TC-18:Verify that the enrolled programs status should be displayed as "Pending"
    [Tags]

    Wait Until Element is Visible    ${DRCompleteButton}
    CLick Element      ${DRCompleteButton}
    wait until element is visible    //*[@text="Enrollment Pending"]    20s
    Page Should Contain Text    Enrollment Pending
    Page Should Contain Text    Status:
    Page Should Contain Text    EcoNetAutomationTesting will email you with more information.


TC-19:Verify that the Program should be active when the user approve the program from the DR Admin(Backend).
    [Tags]

    ${Status}    ApprovedRequest   ${DeviceMacaddressReal}    approved
    Should be true    ${Status}

TC-20:Verify that the enrolled programs should be displayed on the My Program tab.
    [Tags]

    Go Back
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen      ${select_Electric_location}    Heat Pump Water Heater
    wait until element is visible     //*[@text="Account Active"]    20s
    Page should contain text    Account Active
    Page should contain text    Status:
    Page should contain element    ${DRMyProgramsList}

TC-21:Verify that the Active status should be updated on the My Program tab.
    [Tags]

    Page should contain text       Account Active
    Page should contain element    ${DRMyProgramsList}


TC-33:Verify that the Active event should be displayed on the device.

    Go Back
    Select Device Location     Test
    ${Status}    startDREvent
    Should Be True  ${Status}


TC-34:Verify that the Leaf icon should be displayed on the device equipment card when the DR event is Activated.

    Select Device Location    ${select_Electric_location}
    Wait until element is visible    ${DRIcon}     ${defaultwaittime}
    Page should contain element      ${DRIcon}


TC-35:Verify that the Alert pop-up screen should be displayed when the user click on the equipment card.

   Navigate to Detail Page    ${deviceText}
   Page should contain text    Clear Alert


TC-36:Verify that the Alert pop-up screen UI components should be visible as expected.

   Page should contain text    Opt Out Of Event
   Page should contain text    Clear Alert

TC-37:Verify that the Alert pop-up screen should be removed when the user click on the Clear Alert.

   Click Text    Clear Alert
   Sleep    1s
   Click Text    OK
   Wait until element is visible    ${DRIcon}     ${defaultwaittime}
   Page should contain element      ${DRIcon}

TC-38:Verify that the Opt out event confirmation pop-up should be displayed when the user click on the Opt out event

   Navigate to Detail Page    ${deviceText}
   Sleep  1s
   Page should contain text    Clear Alert
   Click Text    Opt Out Of Event
   Sleep    1s
   Page should contain text    NO
   Page should contain text    YES

TC-39:Verify that the Opt out event confirmation pop-up should be removed when the user click on the Go Back button

   Click Text    NO
   Page should not contain text    NO
   Page should not contain text    YES


TC-40:Verify that the event should be Opt out when the user click on the Ok from the Confirmation pop-up

   Click Text    Opt Out Of Event
   Sleep    2s
   Page should contain text    NO
   Page should contain text    YES
   Click Text    YES
   WAIT UNTIL PAGE DOES NOT CONTAIN ELEMENT     ${DRIcon}


#TC-42:Verify that the DR event behavior on the End Device.
#
#TC-43:Verify that the Opt out the device when the user Changes the from the Enddevice.


TC-22:Verify that the program unenroll pop-up message should be displayed when the user click on the (X) button from Active status.
   [Tags]

   Go to Menubar
   Navigate to the Energy & Savings Page
   Select Location from Energy & Savings Screen      ${select_Electric_location}    Heat Pump Water Heater
   Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
   Click Element     ${DRCloseActionImage}
   Sleep    2s
   Page should contain text    YES
   Page should contain text    NO

TC-23:Verify that the program unenroll pop-up message UI components should be visible as expected.
   [Tags]

   wait until element is visible    //*[@text="YES"]
   wait until element is visible    //*[@text="NO"]

TC-24:Verify that the program unenroll pop-up message should be closed when the user click on the "Dismiss" button
   [Tags]

   Sleep  1s
   Click Text    NO
   Page Should Not Contain Text    YES
   Page Should Not Contain Text    NO

TC-25:Verify that the Cancel enrollment process confirmation pop-up should be displayed when the user click on the Ok button.

   Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
   Click Element     ${DRCloseActionImage}
   Sleep  1s
   Click Text  YES
   Sleep  1s
   Page should contain text    Are you sure you want to cancel your enrollment?
   Page should contain text    YES
   Page should contain text    NO

TC-26:Verify that the Cancel enrollment process confirmation pop-up should be should be closed when the user click on the "Dismiss" button

   Click Text    NO
   Page Should Not Contain Text    YES
   Page Should Not Contain Text    NO

TC-27:Verify that the Upon unenrolling, the program should be removed from the 'My Programs' list and shown in the 'Explore' list"

   Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
   Click Element     ${DRCloseActionImage}
   Sleep     1s
   Click Text  YES
   Sleep  1s
   Click Text  YES
   Sleep    20s
   CLick Text    My Programs
   Page Should Not Contain Element    ${DRCloseActionImage}

TC-28:Verify that the Program should be removed from the My Program list when the user Opt Out the device.

   Page Should Not Contain Element    ${DRCloseActionImage}
   Page Should Not Contain Element    ${DRMyProgramsList}

TC-29:Verify that the program should be displayed on the Explore tab when the user Opt out the Event

    Click Text    Explore
    Page should contain element    ${DRProgramCard}    10s

TC-30:Verify that the program remove from list confirmation pop-up should be displayed on the Ineligible for Enrollment status

   Click Text    Explore
   Create DR Program Request
   wait until element is visible    //*[@text="Congratulations!"]    20s
   Page should contain text    Congratulations!
   Page should contain text    Complete
   Wait Until Element is Visible    ${DRCompleteButton}
   CLick Element      ${DRCompleteButton}
   wait until element is visible    //*[@text="Enrollment Pending"]    20s
   Page Should Contain Text    Enrollment Pending
   Page Should Contain Text    Status:
   Page Should Contain Text    EcoNetAutomationTesting will email you with more information.
   Go Back
   ${Status}    ApprovedRequest    ${DeviceMacaddressReal}    ineligible
   Should be true    ${Status}
   Go to Menubar
   Navigate to the Energy & Savings Page
   Select Location from Energy & Savings Screen      ${select_Electric_location}    Heat Pump Water Heater
   wait until element is visible     //*[@text="Ineligible for Enrollment"]    20s
   Page should contain element    ${DRMyProgramsList}
   Page should contain element     ${DRCloseActionImage}

TC-32:Verify that the user should be able to remove the program from the My program list on Ineligible for Enrollment status

   Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
   Click Element     ${DRCloseActionImage}
   Sleep  1s
   Click Text  YES
   Sleep    10s
   CLick Text    My Programs
   Page Should Contain Element    ${DRCloseActionImage}
   Page Should Contain Element    ${DRMyProgramsList}
   Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
   Click Element     ${DRCloseActionImage}
   Sleep     1s
   Click Text  YES
   Sleep    20s
   CLick Text    My Programs
   Page Should Not Contain Element    ${DRCloseActionImage}


#Verify that the green banner should be displayed on the locations for new connected device for Energy & Savings programs.
#Verify that the Green Notify banner UI components should be visible as expected.
#Verify that the Green banner should be removed when the user click on the (X) icon.
#Verify that the Green banner should not be come again once it's removed from the location.
#Verify that the Green banner should be displayed on the locations if provided Zip Code does not have any programs.
#Verify that the Device type/location alert screen should be displayed when the user click on the "Click to Learn More" or click  on the Green banner.
#Verify that the Green banner and Device type/location alert screen should be removed from the locations.
#Verify that the user should be navigated to "Energy & Savings" screen when the user click on the "Click to Learn More" button.