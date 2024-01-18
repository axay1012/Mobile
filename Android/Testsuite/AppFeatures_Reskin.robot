*** Settings ***
Documentation    This is the test file for Smoke Verification
Library          Collections
Library          String
Library          OperatingSystem
Library          AppiumLibrary

Resource         ../Locators/AndroidLabels.robot
Resource         ../Locators/AndroidLocators.robot
Resource         ../Locators/Androidconfig.robot
Resource         ../Keywords/AndroidMobilekeywords.robot
Resource         ../Keywords/MQttkeywords.robot
Library          ../../src/RheemMqtt.py
Library          ../../src/common/Android_Handler.py

Suite Setup  Run Keywords      connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
...   AND     Open App
...   AND     Sleep    5s
#...   AND     Navigate to Home Screen in Rheem application   ${emailId}    ${passwordValue}

Suite Teardown     Run Keywords         Close All Apps
#Test Teardown      Run Keyword if test failed       save screenshot with timestamp

*** Variables ***

# -->cloud url and env
${URL}                                 https://rheemdev.clearblade.com
${URL_Cloud}                           https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                              f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                              F280E3C80B8CA1FB8FE292DDE458

${Admin_EMAIL}                         automation@rheem.com
${Admin_PWD}                           Vyom@0212

${emailId}                             automation@rheem.com
${passwordValue}                       Vyom@0212

${select_HPWH_location}                HPWH

*** Test Cases ***

TC-04:User should be able to see the current account details.
    [Documentation]    User should be able to see the current account details.

    Sleep    5s

TC-05:User Shouldn't be able to change Phone number if invalid data is provided
    [Documentation]     User Shouldn't be able to change Phone number if invalid data is provided.

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
    ${number}=      Generate Random String     2    [NUMBERS]
    Change Phone number with invalid data       123456897

TC-06:User Should be able to change Phone number if valid data is provided
    [Documentation]     User Should be able to change Phone number if valid data is provided.

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
    ${country_prefix}       set variable  +91
    ${phone_number}       Generate Random String     10    [NUMBERS]
    ${number}  set variable  ${country_prefix}${phone_number}
    Change Phone number with valid data     ${number}

TC-07:User should be able to select different notifications according to requirements.
    [Documentation]     User should be able to select different notifications according to requirements..

    Notification settings

TC-08:User should be able to view General settings.
    [Documentation]   User should be able to view General settings.

    General settings

TC-09:User should be able to set Temperature in Celsius unit
    [Documentation]     User should be able to set Temperature  in Celsius unit

    Temperature Unit in Celsius

TC-10:User should be able to set Temperature in Fahrenheit unit
    [Documentation]     User should be able to set Temperature  in Fahrenheit unit

    Temperature Unit in Fahrenheit

TC-11:User should be navigate successfully to the 'Ask Alexa' screen.
    [Documentation]     User should be navigate successfully to the 'Ask Alexa' screen.

    Ask Alexa

TC-12:User should be able to navigate Launch Alexa App page
   [Documentation]    User should be able to navigate Launch Alexa App page

   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
   Launch Alexa Application Verification

TC-13:Navigate to the screen of Frequently Asked questions.
    [Documentation]     Navigate to the screen of Frequently Asked questions.

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
    Frequently asked questions

TC-14:User should be able to verify App&Wifi support details.
   [Documentation]   User should be able to verfiy App&Wifi support details.

   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
   Verify App&WiFi Support Details

TC-15:User should not be able to add new contractor without selecting heater types
   [Documentation]   User should not be able to add new contractor without selecting heater types.

   ${random_string}      Generate Random String     2     [LETTERS]
   ${domain}      set variable      @contractor.com
   ${number}      Generate Random String     10      [NUMBERS]
   ${EMAIL}       set variable      ${random_string}${domain}
   Add New Contractor without selecting device type     ${EMAIL}    ${number}
   go back

TC-16:Add new contractor in the application.
    [Documentation]      Add new contractor in the application.
    [Tags]      testrailid=170661

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application And Navigate To Dashboard App
    ${a}      set variable  akshay.suthar+1
    ${b}      set variable      @volansys.com
    ${name}        Generate Random String     7
    ${d}        Generate Random String     3
    ${number}      Generate Random String     5      [NUMBERS]
    ${EMAIL}      set variable      ${a}${d}${b}
    Set Global Variable  ${name}   ${name}
    Add new Contractor    ${name}   ${EMAIL}     +9199256${number}

TC-17:Edit the Contractor in the Application.
    [Documentation]     Edit the Contractor in the Application.

    Wait Until Page Contains Element    ${menu_bar}    ${Sleep_10s}
    click element     ${menu_bar}
    sleep   ${Sleep_10s}
    Click Text     Contacts
    Sleep   5s

    FOR    ${temp}    IN RANGE      60
           ${Status}  Run Keyword And Return Status   Page Should Contain Text   ${name}
           Run Keyword If   ${Status} == False    swipe    400     1500     400    1000   2000
           ...    ELSE    Exit For Loop
           sleep    2s
    END

    Click Text  ${name}
    Click Element  ${edit_contractor_button}
    ${name1}       Generate Random String     7
    Clear Text  ${New_contactor_Name}
    Input Text  ${New_contactor_Name}  ${name1}
    Click Text  Save
    Sleep  5s
    Page Should Contain Text  ${name1}

TC-18:Delete the Contractor in the Application
    [Documentation]     Delete the Contractor in the Application.

    Delete Contractor  ${name}

TC-19:User should be able to add New Location.
    [Documentation]    User should be able to add New Location.

    Add new location in current account

TC-20:User should be able to edit Location Name.
    [Documentation]     User should be able to edit Location Name.

    ${name}     Generate Random String      4      [LETTERS]
    Edit location name   ${name}


TC-21:User should be able to Delete Location Name.
    [Documentation]     User should be able to Delete Location Name.

    Delete Location name


TC-22:User should be able to set Away mode for Location.
    [Documentation]     User should be able to set Away mode for multiple devices.
    [Tags]    1223

    Set Away mode to multiple devices
    ${status}   Get Element attribute   ${away_toggel_button}   checked
    Should Be Equal   ${status}  true
    Go back
    Go back

TC-23:User should be able to disable Away mode for Location.
   [Documentation]     User should be able to disable Away mode for all devices.

   Disable all Devices from Away mode
   ${status}   Get Element attribute    ${away_toggel_button}    checked
   Should Be Equal   ${status}  false
   Go back
   Go back

TC-24:User should be able to set Away mode for One particular device and disable Away mode for one particular device
   [Documentation]    User should be able to set Away mode for One particular device and disable Away mode for one particular device

    Set Away mode to multiple devices
    ${status}   Get Element attribute   ${away_toggel_button}   checked
    Should Be Equal   ${status}  true
    Go back
    Go back
    Disable all Devices from Away mode
    ${status}   Get Element attribute   ${away_toggel_button}   checked
    Should Be Equal   ${status}  false
    Go back
    Go back

TC-25:User should be able to Email contractor when device is disconnected
    [Documentation]     User should be able to Email contractor when device is disconnected.

    Email Contractor from the Alert
    Go Back
    Go Back

TC-26:User should be able to verify alert on Detail page
   [Documentation]   User should be able to verify alert on Detail page

   Verfiy Alerts On Detail Page

TC-27:User should be able to clear Alert from the application
   [Documentation]   User should be able to clear Alert from the application

   Clear Alerts from the Dashboard notification

TC-29:User Should be able to logout from current account.
    [Documentation]     User Should be able to logout from current account.

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
    Logout from the existing user account

TC-28:User should be able to Reprovision the device if found disconnected.
    [Documentation]     User should be able to Reprovision the device if found disconnected.

    Navigate to Home Screen in Rheem application   automation3@rheem.com    Vyom@0212
    Reprovision disconnected device

    [Teardown]     Logout from the existing user account

TC-30:User should not be able to Edit Zones with Blank values.
    [Documentation]     User should be able to Edit Zone Names from the Application

    Navigate to Home Screen in Rheem application   ${emailId}    ${passwordValue}
    Edit zone device name with blank values

TC-31:User should be able to Edit Zone Names from the Application
    [Documentation]     User should be able to Edit Zone Names from the Application.

    ${name}     Generate Random String     4
    Edit Zone Device Name With Valid Data     ${name}

TC-32:User Shouldn't be able to change Password if invalid data is provided.
    [Documentation]     User Shouldn't be able to change Password if invalid data is provided.

    ${current_pass}      Generate Random String    9
    ${new_pass}          Generate Random String    9
    ${conf_pass}         Generate Random String    9
    Change Password with invalid data     ${current_pass}     ${new_pass}     ${conf_pass}

TC-33:User Should be able to change Password if valid data is provided.
    [Documentation]     User Should be able to change Password if valid data is provided.

    ${current_pass}      Generate Random String    9
    ${new_pass}          Generate Random String    9
    Change Password with valid data       ${passwordValue}     ${new_pass}      ${new_pass}


TC-34:User shouldn't be able to reset Password if invalid data is provided.
    [Documentation]    User shouldn't be able to reset Password if invalid data is provided.

    Logout from the existing user account
    ${email}      Generate Random String
    Forgot password with invalid data

TC-35:User should be able to reset Password
    [Documentation]     User should be able to reset Password.

    Logout from the existing user account
    go back
    Forgot password with valid data      ${forgot_pass}     ${passwordValue}    ${passwordValue}

TC-36:User should be Able to Edit New Product Under selected location.
    [Documentation]     User should be Able to Edit New Product Under selected location.

    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
    Logout from the existing user account
    Navigate to Home Screen in Rheem application    automation3@rheem.com     Vyom@0212
    ${product_name}=     Generate Random String     8   [NUMBERS]
    Edit product name for selected location      ${product_name}

TC-37:User should be Able to Delete New Product Under selected location.
    [Documentation]     User should be Able to Delete New Product Under selected location.

    Delete product for selected location

TC-38:User should be able to change user name from your profile
   [Documentation]    User should be able to change user name from your profile

    ${Name}         Current Account Details
    sleep   ${sleep_5s}
    ${first_name}   Generate random string  7  [LETTERS]
    ${last_name}    Generate random string  7  [LETTERS]
    ${name}   Change account details  ${first_name}  ${last_name}
    sleep   3s

TC-39:User should be able to view Privacy Notice
    [Documentation]      User should be able to view Privacy Notice

    Navigate to Privacy Notice page

#TC-40:User should be able to set Away pre-schedule event for a particular location.
#   [Documentation]    User should be able to set Away pre-schedule event for a particular location.
#
##   Set Pre-Scheduled Away


#TC-41:User should be able to set Home pre-schedule event for a particular location.
#   [Documentation]    User should be able to set Home pre-schedule event for a particular location.
#
##   Set Pre-Scheduled Home
#
#
#TC-42:User should be able to check Away mode status according to scheduled events
#   [Documentation]    User should be able to check Away mode status according to scheduled events
#
##   Navigate to Detail Page        ${select_HPWH_location}
#   ${Away_status_M}      Check Pre-Scheduled Away Status     ${deviceText}
#
#   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#   sleep    ${Sleep_5s}
#   should be equal as integers    ${Away_status_ED}    ${Away_status_M}
#
#
#TC-43:User should be able to change Away status of the particular location in between scheduled events
#   [Documentation]   User should be able to change Away status of the particular location in between scheduled events
#
#   Navigate to Detail Page        ${select_HPWH_location}
#   ${Away_status_M}        Disable Away mode from mobile application    ${deviceText}
#   sleep  ${Sleep_10s}
#   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#   sleep    ${Sleep_5s}
#   should be equal as integers    ${Away_status_ED}    ${Away_status_M}
#
#TC-44:User should be able to delete Away pre-schedule event of the particular location
#   [Documentation]   User should be able to delete Away pre-schedule event of the particular location
#
#   Delete Pre-Scheduled Event
#   Navigate to Detail Page        ${select_HPWH_location}
#
#
#TC-45:User should be able to check Home status according to scheduled events
#   [Documentation]   User should be able to check Home status according to scheduled events
##
#   Navigate to Detail Page        ${select_HPWH_location}
#   ${Away_status_M}      Check Pre-Scheduled Home Status     ${deviceText}
#   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#   sleep    ${Sleep_5s}
#   should be equal as integers    ${Away_status_ED}    ${Away_status_M}
#
#
#TC-46:User should be able to change Away status of the particular device in between scheduled events
#    [Documentation]     User should be able to change Away status of the particular device in between scheduled events
##
#   Select Device Location        ${select_HPWH_location}
#   ${Away_status_M}      Change Pre-Scheduled Status      ${deviceText}
#   ${Away_status_ED}     Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#   sleep    ${Sleep_5s}
#   should be equal as integers    ${Away_status_ED}    ${Away_status_M}
#
#TC-47:Pre scheduled event should be removed after following the event.
#   [Documentation]   Pre scheduled event should be removed after following the event.
#
#   Select Device Location        ${select_HPWH_location}
#   Check Pre-scheduled Event List after Followed

#TC-48:User should not be able to set time less than the current time.
#   [Documentation]   User should not be able to set time less than the current time.
#
#
#   click element      ${Start_Date}
#   ${current_Date}    Get Current Date     result_format=%I:%M %p
#
#
#TC-49:User should be able to create more than one schedule events of single location.
#   [Documentation]    User should be able to create more than one schedule events of single location.
#
#   Set Pre-Scheduled Away
#   Set Pre-Scheduled Home
#   click text     HPWH
#   wait until page contains     HPWH     ${Sleep_5s}
#   click element      ${Start_Date}
#   ${current_Date}=    Get Current Date     result_format=%I:%M %p
#
#
#TC-50:User should not be able to create scheduled event when Away settings are off.
#   [Documentation]   User should not be able to create scheduled event when Away settings are off.
#
#   Away Settings OFF Create Pre-Scheduled Event
#   Wait Until Page Contains Element    ${notification_icon}    ${Sleep_10s}
#   click element      ${menu_bar}
#   sleep     ${Sleep_5s}
#
#
#TC-51:User should be able to delete scheduled event in between the scheduled time.
#   [Documentation]   User should be able to delete scheduled event in between the scheduled time.
#
#   Delete Pre-Scheduled Event
#   sleep    ${Sleep_5s}
#   Select Device Location        ${select_HPWH_location}
#   Check Pre-Scheduled Home Status
#   sleep    ${Sleep_5s}
#   ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#   sleep    ${Sleep_5s}


TC-52:User should be able to enable Geo Fencing option for setting Away mode.
  [Documentation]  User should be able to enable Geo Fencing option for setting Away mode.

  Enable Geo Fencing

TC-53:User should be able to set different location from the list.
   [Documentation]    User should be able to set different location from the list.

   Select Location For Geo Fencing

TC-54:User should be able to set different distance unit from the list
   [Documentation]    User should be able to set different distance unit from the list

   Select Distance Unit For Geo Fencing

TC-55:User should be able set Radius for Home/Away
   [Documentation]   User should be able set Radius for Home/Away

   Set Home/Away Radius For Geo Fencing

TC-56:User should be able to disable Geo Fencing option for setting Away mode
   [Documentation]   User should be able to disable Geo Fencing option for setting Away mode

   Disable Geo Fencing For Home/Away

TC-57:User should be able to add HomeRouter SSID
   [Documentation]   User should be able to add HomeRouter SSID

   ${econetwifiname1}     Generate Random String    3
   Add HomeRouter SSID   ${econetwifiname1}
   Set Global Variable  ${econetwifiname1}    ${econetwifiname1}

TC-58:User should be able to edit HomeRouter SSID name
   [Documentation]     User should be able to edit HomeRouter SSID name

   Edit HomeRouter SSID    ${econetwifiname1}

TC-59:User should not be able to add same SSID
   [Documentation]    User should not be able to add same SSID

   Add HomeRouter SSID    ${econetwifiname1}

TC-60:User should be able to add SSID with None security type
   [Documentation]     User should be able to add SSID with None security type

   ${econetwifiname1}     Generate Random String    3
   Add HomeRouter SSID with None Type

TC-61:User should be able to remove HomeRouter SSID
   [Documentation]    User should be able to remove HomeRouter SSID

   Remove HomeRouter SSID

TC-62:User should be able to add EcoNet WiFi Connections
   [Documentation]     User should be able to add EcoNet WiFi Connections

   ${homewifiname1}     Generate Random String    3
   Add Econet WiFi Connection   ${homewifiname1}
   Set Global Variable   ${homewifiname1}     ${homewifiname1}

TC-63:User should be able to edit EcoNet WiFi Connection name
   [Documentation]    User should be able to edit EcoNet WiFi Connection name

   Edit Econet WiFi Connection Name    ${homewifiname1}12

TC-64:User should not be able to add same EcoNet WiFi ID
   [Documentation]    User should not be able to add same EcoNet WiFi ID

   Add Econet WiFi Connection  ${homewifiname1}

TC-65:User should be able to remove Econet WiFi Connections
   [Documentation]    User should be able to remove Econet WiFi Connections

   Remove Econet WiFi Connections

TC-01:User should be able to proceed with the device provisioning steps for Diagnostic mode.
    [Documentation]     User should be able to proceed with the device provisioning steps for Diagnostic mode.

    Logout from the existing user account
    Validate Diagnostic Mode

TC-02:User shouldn't be able to Create New Account if invallid data is provided.
    [Documentation]    User shouldn't be able to Create New Account if invallid data is provided.

    Create new account with invalid data

TC-03:User should be able to Create New Account if valid data is provided.
    [Documentation]    User should be able to Create New Account if valid data is provided.

    ${name1}   Generate Random String    2   [LETTERS]
    ${name2}   Generate Random String    3     [LETTERS]
    ${a}       Set variable  jignesh.parekh+
    ${z}       generate random string  4  [NUMBERS]
    ${b}       set variable       @volansys.com
    ${c}       set variable      +91
    ${d}       set variable  6352591729
    ${number}      set variable  ${c}${d}
    ${EMAIL}       set variable         ${a}${z}${b}
    Set Global Variable     ${email_Id_ca}      ${EMAIL}
    Set Global Variable     ${NUMBER}       ${number}
    Create new account with valid data
