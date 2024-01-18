*** Settings ***
Documentation       This is the test file for End to end testing of DR EcoNet OptFlow

Library             AppiumLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             ../../src/RheemMqtt.py
Resource            ../Locators/iOSLabels.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSConfig.robot
Resource            ../Keywords/iOSMobileKeywords.robot

Suite Setup         Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    Test
...                     AND    Temperature Unit in Fahrenheit
# ...    AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
# ...    AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
# Suite Teardown    Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${select_Electric_location}
# Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot


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


*** Test Cases ***
TC-01:Verify that the Energy & Savings menu should be displayed on the Menu bar.
    Go to Menubar
    Sleep    1s
    Page Should Contain Element    ${DREnergySavings}

TC-02:Verify that the Energy & Savings screen should be displayed
    Navigate to the Energy & Savings Page
    Page Should Contain Element    ${DRMyPrograms}

TC-03:Verify that the Device type/location alert screen UI components should be visible as expected.
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater
    Page Should Contain Element    ${DRLocationSelection}

TC-04:Verify that the "Energy & Savings" screen UI components Should be visible as expected.
    wait until element is visible    ${DRMyPrograms}
    Page Should Contain Element    ${DRMyPrograms}
    wait until element is visible    ${DRProgramCard}

TC-05:Verify that the user should be navigated to the Explore Programs screen.
    wait until element is visible    ${DRMyPrograms}
    Page Should Contain Element    ${DRProgramCard}

TC-06:Verify that the Device Zip Associated Programs List should be displayed on the Explore screen.
    Page Should Contain Element    ${DRProgramCard}

TC-07:Verify that the Program details screen should be displayed when the user selects Program.
    Wait until element is visible    ${DRProgramCard}
    Click Element    ${DRProgramCard}
    Wait until element is visible    ${DRSignUpboxButton}    30s
    Page Should Contain Element    ${DRSignUpboxButton}

TC-08:Verify that the Sign Up button should be displayed on the screen.
    Page Should Contain Element    ${DRSignUpboxButton}

TC-09:Verify that the Product and Customer information screen should be displayed when the user click on the Sign Up button.
    Click Element    ${DRSignUpboxButton}
    Sleep    2s
    Page Should Contain Element    ${select_Electric_location}
    Page should contain Element    ${Admin_EMAIL}

TC-10:Verify that the Product and Customer information screen UI components should be visible as expected.
    Page Should Contain Element    Product Information
    Page Should Contain Element    Product Name
    Page Should Contain Element    Location
    Page Should Contain Element    Serial #
    Page Should Contain Element    Customer Information

TC-11:Verify that the "Continue" button should not be enabled while checkbox is unchecked.
    Element Should Be Disabled    ${DRContinueButton}

TC-12:Verify that the "Continue" button should be enabled while checkbox is checked.
    FOR    ${temp}    IN RANGE    3
        ${Status}    Run Keyword And Return Status    Wait until element is visible    ${DRSignUpCheckbox}
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END

    Wait until element is visible    ${DRSignUpCheckbox}
    Click element    ${DRSignUpCheckbox}
    Sleep    3s

TC-13:Verify that the Terms and Conditions screen should be displayed when the user Continue the Program process.
    Wait until element is visible    ${DRContinueButton}
    Click Element    ${DRContinueButton}
    Sleep    2s
    Page Should Contain Element    ${DRCancelTermsandCondition}
    Page Should Contain Element    ${DRIAgree}

TC-14:Verify that the Agree button should be enabled when the scroll the Terms and Conditions screen.
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
    Wait until element is visible    ${DRCancelTermsandCondition}    30s
    Click Element    ${DRCancelTermsandCondition}
    Wait until element is visible    ${DRProgramCard}    30s
    Page should not contain element    ${DRIAgree}
    Page should not contain element    ${DRCancelTermsandCondition}

TC-16:Verify that the Program successfully selected after terms and conditions full filled.
    Create DR Program Request

TC-17:Verify that the Program Selected Congratulation screen UI components should be visible as expected.
    Wait until element is visible    ${DRprogramConfirmationContentID2}    10s
    Page Should Contain Element    ${DRprogramConfirmationContentID2}

TC-18:Verify that the enrolled programs status should be displayed as "Pending"
    Wait Until Element is Visible    ${DRCompleteButton}
    CLick Element    ${DRCompleteButton}
    wait until element is visible    ${Enrollment_Pending}    20s
    Page Should Contain Element    ${Enrollment_Pending}
    Page Should Contain Element    ${Status:}
    Page Should Contain Element    ${SuccessMsges}

TC-19:Verify that the Program should be active when the user approve the program from the DR Admin(Backend).
    ${Status}    ApprovedRequest    ${DeviceMacaddressReal}    approved
    Should be true    ${Status}

TC-20:Verify that the enrolled programs should be displayed on the My Program tab.
    Go Back
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater
    wait until element is visible    ${Account_Active}    20s
    Page Should Contain Element    ${Account_Active}
    Page Should Contain Element    ${Status:}

TC-21:Verify that the Active status should be updated on the My Program tab.
    Page Should Contain Element    ${Account_Active}
    Navigate Back to the Screen

TC-33:Verify that the Active event should be displayed on the device.
    Select the Device Location    ${select_Electric_location}
    ${Status}    startDREvent
    should be True    True

TC-34:Verify that the Leaf icon should be displayed on the device equipment card when the DR event is Activated.
    Select the Device Location    ${select_Electric_location}
    Wait until element is visible    ${DRIcon}    ${defaultwaittime}
    Page should contain element    ${DRIcon}

TC-35:Verify that the Alert pop-up screen should be displayed when the user click on the equipment card.
    Go to Temp Detail Screen    ${tempDashBoard}
    Page Should Contain Element    ${DRClearAlert}

TC-36:Verify that the Alert pop-up screen UI components should be visible as expected.
    Page Should Contain Element    ${DROutOfEvent}
    Page Should Contain Element    ${DRClearAlert}

TC-37:Verify that the Alert pop-up screen should be removed when the user click on the Clear Alert.
    wait until element is visible    ${DRClearAlert}    ${defaultwaittime}
    Click Element    ${DRClearAlert}
    wait until element is visible    Ok    ${defaultwaittime}
    Click Element    Ok
    Wait until element is visible    ${DRIcon}    ${defaultwaittime}
    Page should contain element    ${DRIcon}

TC-38:Verify that the Opt out event confirmation pop-up should be displayed when the user click on the Opt out event
    Go to Temp Detail Screen    ${tempDashBoard}
    Wait until element is visible    ${DRClearAlert}    ${defaultwaittime}
    Page Should Contain Element    ${DRClearAlert}
    Click Element    ${DROutOfEvent}
    Wait until element is visible    ${buttonNo}    ${defaultwaittime}
    Page Should Contain Element    ${buttonNo}
    Page Should Contain Element    ${btnYes}

TC-39:Verify that the Opt out event confirmation pop-up should be removed when the user click on the Go Back button
    Wait until element is visible    ${buttonNo}    ${defaultwaittime}
    Click Element    ${buttonNo}
    Page should not contain text    ${buttonNo}
    Page should not contain text    ${btnYes}

TC-40:Verify that the event should be Opt out when the user click on the Ok from the Confirmation pop-up
    Wait until element is visible    ${DROutOfEvent}    ${defaultwaittime}
    Click Element    ${DROutOfEvent}
    Sleep    2s
    Page Should Contain Element    ${buttonNo}
    Page Should Contain Element    ${btnYes}
    Click Element    ${btnYes}
    WAIT UNTIL PAGE DOES NOT CONTAIN ELEMENT    ${DRIcon}

# TC-42:Verify that the DR event behavior on the End Device.
#
# TC-43:Verify that the Opt out the device when the user Changes the from the Enddevice.

TC-22:Verify that the program unenroll pop-up message should be displayed when the user click on the (X) button from Active status.
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater
    Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
    Click Element    ${DRCloseActionImage}
    Sleep    2s
    Page Should Contain Element    ${btnYes}
    Page Should Contain Element    ${buttonNo}

TC-23:Verify that the program unenroll pop-up message UI components should be visible as expected.
    wait until element is visible    ${btnYes}
    wait until element is visible    ${buttonNo}

TC-24:Verify that the program unenroll pop-up message should be closed when the user click on the "Dismiss" button
    wait until element is visible    ${buttonNo}
    Click Element    ${buttonNo}
    Page Should Not Contain Text    ${btnYes}
    Page Should Not Contain Text    ${buttonNo}

TC-25:Verify that the Cancel enrollment process confirmation pop-up should be displayed when the user click on the Ok button.
    Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
    Click Element    ${DRCloseActionImage}
    Sleep    1s
    Click Element    ${btnYes}
    Sleep    1s
    Page Should Contain Element    ${btnYes}
    Page Should Contain Element    ${buttonNo}

TC-26:Verify that the Cancel enrollment process confirmation pop-up should be should be closed when the user click on the "Dismiss" button
    Wait until element is visible    ${buttonNo}    ${defaultwaittime}
    Click Element    ${buttonNo}
    Page Should Not Contain Text    ${btnYes}
    Page Should Not Contain Text    ${buttonNo}

TC-27:Verify that the Upon unenrolling, the program should be removed from the 'My Programs' list and shown in the 'Explore' list"
    Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
    Click Element    ${DRCloseActionImage}
    Wait until element is visible    ${btnYes}    ${defaultwaittime}
    Click Element    ${btnYes}
    Wait until element is visible    ${btnYes}    ${defaultwaittime}
    Click Element    ${btnYes}
    wait until element is visible    ${DRProgramCard}    20s
    Page Should Not Contain Element    ${DRCloseActionImage}

TC-28:Verify that the Program should be removed from the My Program list when the user Opt Out the device.
    Page Should Not Contain Element    ${DRCloseActionImage}

TC-29:Verify that the program should be displayed on the Explore tab when the user Opt out the Event
    wait until element is visible    ${DRProgramCard}    20s
    Page should contain element    ${DRProgramCard}    10s

TC-30:Verify that the program remove from list confirmation pop-up should be displayed on the Ineligible for Enrollment status
    Create DR Program Request
    wait until element is visible    ${DRprogramConfirmationContentID}    20s
    Page Should Contain Element    ${DRprogramConfirmationContentID}
    Page Should Contain Element    ${DRCompleteButton}
    Wait Until Element is Visible    ${DRCompleteButton}
    CLick Element    ${DRCompleteButton}
    wait until element is visible    ${Enrollment_Pending}    20s
    Page Should Contain Element    ${Enrollment_Pending}
    Page Should Contain Element    ${Status:}
    Page Should Contain Element    ${SuccessMsges}
    Go Back
    ${Status}    ApprovedRequest    ${DeviceMacaddressReal}    ineligible
    Should be true    ${Status}
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater
    wait until element is visible    Ineligible for Enrollment    20s
    Page should contain element    ${DRCloseActionImage}

TC-32:Verify that the user should be able to remove the program from the My program list on Ineligible for Enrollment status
    Wait until element is visible    ${DRCloseActionImage}    ${defaultwaittime}
    Click Element    ${DRCloseActionImage}
    Sleep    1s
    Click Element    ${btnYes}
    wait until element is visible    ${DRProgramCard}    30s
    Page should contain element    ${DRProgramCard}
    Page Should Not Contain Element    ${DRCloseActionImage}

TC-33: Verify that user should be able to remove the program from the My Programs list on Action Required for Enrtollment status.
    Create DR Program Request
    wait until element is visible    ${DRprogramConfirmationContentID}    20s
    Page Should Contain Element    ${DRprogramConfirmationContentID}
    Page Should Contain Element    ${DRCompleteButton}
    Wait Until Element is Visible    ${DRCompleteButton}    ${defaultwaittime}
    Click Element    ${DRCompleteButton}
    wait until element is visible    ${Enrollment_Pending}    20s
    Page Should Contain Element    ${Enrollment_Pending}
    Page Should Contain Element    ${Status:}
    Page Should Contain Element    ${SuccessMsges}
    Go Back
    ${Status}    ApprovedRequest    ${DeviceMacaddressReal}    ${DRaccountActionRequired}
    Should be true    ${Status}
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater
    wait until element is visible    ${Account_Action_Required}    20s

TC-34: Verify that user declined the request from the ineligible
    ApprovedRequest    ${DeviceMacaddressReal}    ineligible
    ApprovedRequest    ${DeviceMacaddressReal}    cancelled
    Navigate Back to the Screen
    Go to Menubar
    Navigate to the Energy & Savings Page
    Select Location from Energy & Savings Screen    ${select_Electric_location}    Heat Pump Water Heater

    # QA Can Continue on the Testing once the QA Team will received the bu
