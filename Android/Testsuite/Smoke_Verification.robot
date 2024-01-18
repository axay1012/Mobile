*** Settings ***
Documentation    This is the test file for Smoke Verification
Library          Collections
Library          String
Library          OperatingSystem
Library          AppiumLibrary

Resource         ../Locators/AndroidLabels.robot
Resource         ../Locators/AndroidLocators.robot
Resource         ../Locators/Androidconfig.robot
Resource         ../Resource/AndroidMobilekeywords.robot
Resource         ../Resource/MQttkeywords.robot
Library          ../../src/RheemMqtt.py
Library          ../../src/common/Android_Handler.py

Suite Setup  Run Keywords    Set Appium Timeout   1    AND    connect    ${Admin_EMAIL}    ${Admin_PWD}    ${SYSKEY}    ${SECKEY}    ${URL}
#...   AND    Get Android Platform Version
...   AND     Open App


Test Setup    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${select_HPWHGen5_location}

Suite Teardown       Run Keywords       save screenshot with timestamp     Close All Apps
Test Teardown      run keyword if test failed       save screenshot with timestamp


*** Variables ***
${Device_Mac_Address}                  40490F9E4947
${Device_Mac_Address_In_Formate}       40-49-0F-9E-49-47
${EndDevice_id}                        4737
${EndDevice_id1}                       896




# -->cloud url and env
${URL}                                 https://rheemdev.clearblade.com
${URL_Cloud}                           https://rheemdev.clearblade.com/api/v/1/

# --> test env
${SYSKEY}                              f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                              F280E3C80B8CA1FB8FE292DDE458

# --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}   D0-C5-D3-3B-CB-9C
${Device_TYPE_WiFiTranslator}          econetWiFiTranslator
${Device_TYPE}                         HeatPumpWaterHeaterGen5

${Device_WiFiTranslator_MAC_ADDRESS_NewEcc}   DC-F5-05-92-95-D8
${Device_TYPE_WiFiTranslator_NewEcc}          econetWiFiTranslator
${Device_TYPE_NewEcc}                         HVAC

# --> NewECC Modes List
@{newECC_modes_List}                   Heating       Cooling       Auto          Fan Only      Off
@{newECC_fanmodes_List}                Auto       Low       Med.Lo     Medium      Med.Hi      High

# --> admin cred
${Admin_EMAIL}                         automation@rheem.com
${Admin_PWD}                           Vyom@0212
${emailId}				               automation@rheem.com
${passwordValue}			           Vyom@0212

# --> Select Device Location
${select_HPWHGen5_location}            HPWHGen5
${deviceText}			               //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

##  --> Select Device Location
${select_NewECC_location}              NewECC
${deviceText_ECC}			           //android.widget.FrameLayout[@resource-id='com.rheem.econetconsumerandroid:id/hvacCardView']
# --> Setpoint Values

${setpoint_max}                        140
${setpoint_min}                        110
${setpoint_max_C}                      60
${setpoint_min_C}                      44
${value1}                              32
${value2}                              5
${value3}                              9

# --> Sleep Time
${Sleep_5s}                            5s
${Sleep_10s}                           10s
${Sleep_20s}                           20s
${forgot_email}                        jignesh.parekh@volansys.com
@{Gen5_modes_List}                    Disabled     Enabled

*** Test Cases ***
TC-01:User should be able to Create New Account if valid data is provided.
    [Documentation]    User should be able to Create New Account if valid data is provided.
    [Tags]      testrailid=170642


############################## Create New Account with Valid Data ####################################
    
    ${name1}=   Generate Random String    2   [LETTERS]
    ${name2}=   Generate Random String    3     [LETTERS]
    ${a}=       set variable  rheemautomation+
    ${z}=    generate random string  3  [NUMBERS]
    ${b}=      set variable       @gmail.com
    ${c}=     set variable      +91
    ${d}=      set variable   9054811677
    ${number}=      set variable  ${c}${d}
    ${EMAIL}=      set variable         ${a}${z}${b}
    ${Address}=     generate random string   5
    ${City}=        generate random string   3
    ${State}=       generate random string   3
    ${Postal_code}=  set variable   00501
    Set Global Variable     ${email_Id1}      ${EMAIL}
    Set Global Variable     ${NUMBER}       ${number}
    Create new account with valid data      ${name1}     ${name2}    ${EMAIL}     ${number}   ${Address}   ${City}   ${State}    ${Postal_Code}    ${passwordValue}     ${passwordValue}
    


###    Set Global Variable     ${email_Id_ca}      ${EMAIL}
##    Set Global Variable     ${NUMBER}       ${number}
##    Create new account with valid data      ${name1}     ${name2}    ${EMAIL}     ${number}      ${passwordValue}     ${passwordValue}
#
TC-02:User should be able to login successfully, with valid credentials
    [Documentation]  User should be able to login successfully, with valid credentials
    [Tags]      testrailid=170643


    Logout from the existing user account
    Navigate to Home Screen in Rheem application for app  ${email_Id}  ${passwordValue}
#
TC-03:User should be able to reset Password
    [Documentation]     User should be able to reset Password.
    [Tags]      testrailid=170644

################################# Reset Password using valid data ##################################
    
    Logout from the existing user account
    ${change_password}=  generate random string  8  [NUMBER]
    set global variable  ${change_password}  ${change_password}
    Forgot password with valid data  ${forgot_email}   ${change_password}
    
    sign in after forgot password   ${forgot_email}   ${change_password}
###    delete user account
##
####TC - Delete newly created account
####
####    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open application and Navigate to Dashboard App
####    Logout from the existing user account
####    Navigate to Home Screen in Rheem application for app  ${email_Id1}  ${change_password}
####    run keyword if   page should contain element  ${notification_icon}  run keyword  delete user account
##
TC-04:Validate the dashboard screen with Location and Device
    [Documentation]     Validate the dashboard screen without Location and Device
    [Tags]      testrailid=170645

    Logout from the existing user account
    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}

    
    Select Device Location    ${select_HPWHGen5_location}
    sleep  ${sleep_10s}
    Page Should Contain Element    ${deviceText}
    Sleep    ${Sleep_3s}


TC-05:Verify dashboard with location and product name
    [Documentation]     Verify dashboard with location and product name
    [Tags]      testrailid=170646

     
     Select Device Location   ${select_HPWHGen5_location}
     sleep  ${sleep_5s}
     Page Should Contain Text    ${select_HPWHGen5_location}
     Sleep    ${Sleep_3s}

     
     Page Should Contain Element    ${deviceText}
     Sleep    ${Sleep_3s}
     click element  ${deviceText}
#     wait until page contains element  ${deviceText}
     sleep  ${sleep_5s}
     go back

     
     Page Should Contain Element    ${Location_Away_icon}
     Sleep    ${Sleep_3s}

TC-06:Verify Menu of reskin application
    [Documentation]     Verify Menu of reskin application
    [Tags]      testrailid=170647

     
     Verify menu options

TC-07:User should be able to see the current account details.
    [Documentation]    User should be able to see the current account details.
    [Tags]      testrailid=170648

############################## Verify current account details ###############################
    
    ${Name}         Current Account Details
    
    sleep   10s


TC-08: User should be able to change profile name.
    [Documentation]    User should be able to change profile name.
    [Tags]      testrailid=170649

############################## Verify current account details ###############################
    
    ${Name}         Current Account Details
    
    sleep   ${sleep_5s}

############################ Change Name ######################################################
    
    ${first_name}=  generate random string  7  [LETTERS]
    ${last_name}=  generate random string  7  [LETTERS]
    ${name}   change account details  ${first_name}  ${last_name}
    
    sleep   10s


TC-09:User should be able to navigate into the notifications settings page
    [Documentation]     User should be able to select different notifications according to requirements..
    [Tags]      testrailid=170650

################################ Verify Different Notifications ###################################
#    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
    
    Notification settings

TC-10:User should be able to view General settings.
    [Documentation]   User should be able to view General settings.
    [Tags]      testrailid=170651

################################# Verify General settings details ###################################
    
    General settings


TC-11:User should be able to set Temperature in Celsius unit
    [Documentation]     User should be able to set Temperature  in Celsius unit
    [Tags]      testrailid=170652

#################################### Set Temperature Unit to Celsius #################################
    
    Temperature Unit in Celsius


TC-12:User should be able to set Temperature in Fahrenheit unit
    [Documentation]     User should be able to set Temperature  in Fahrenheit unit
    [Tags]      testrailid=170653

################################## Set Temperature Unit to Fahrenheit ###############################
    
    Temperature Unit in Fahrenheit



TC-13:User should be able to add New Location.
    [Documentation]    User should be able to add New Location.
    [Tags]      testrailid=170654

################################### Add New Location from the application ################################
    
    Add new location in current account

TC-14:User should be able to Navigate into the Zone settings
    [Documentation]     User should be able to Navigate into the Zone settings
    [Tags]      testrailid=170655

    
    Zone settings page

TC-15:User should be able to Navigate into the Away settings page
    [Documentation]     User should be able to Navigate into the Away settings page
    [Tags]      testrailid=170656

    
    Away settings page
    go back

TC-16:User should be able to set Away mode for particular devices.
    [Documentation]     User should be able to set Away mode for multiple devices.
    [Tags]      testrailid=170657

################################## Set Away Mode for multiple devices ################################
    
    Away settings page
    
    set HPWH into the away mode     ${select_HPWHGen5_location}

TC-17:User should be able to disable Away mode for particular devices.
    [Documentation]     User should be able to set Away mode for multiple devices.
    [Tags]      testrailid=170658

################################## Set Away Mode for multiple devices ################################
    
    Away settings page
    
    disable HPWH into the away mode  ${select_HPWHGen5_location}


TC-18:User should be able to Navigate into the Schedule/Away settings page
    [Documentation]     User should be able to Navigate into the Schedule/Away settings page
    [Tags]      testrailid=170659

    
    Scheduled Away/Vacation Settings


TC-19:User should be navigate successfully to the 'Ask Alexa' screen.
    [Documentation]     User should be navigate successfully to the 'Ask Alexa' screen.
    [Tags]      testrailid=170660

############################## Navigate to Ask Alexa Screen ################################
    
    Ask Alexa

TC-20:Add new contractor in the application.
    [Documentation]      Add new contractor in the application.
    [Tags]      testrailid=170661

################################### Add new contractor in the application ###############################
    
    ${a}=      set variable     rheemautomation+
    ${z}=    generate random string      3      [NUMBERS]
    ${b}=      set variable      @gmail.com
    ${name}=    Generate Random String     7
    ${Cdc}=      set variable      +91
    ${Phone_no}=      Generate Random String     10      [NUMBERS]
    ${number}=        set variable     ${Cdc}${Phone_no}
    ${EMAIL}=      set variable      ${a}${z}${b}
    Add new Contractor    ${name}   ${EMAIL}     ${number}

TC-21:User should be able to view Privacy Notice
    [Documentation]      User should be able to view Privacy Notice
    [Tags]      testrailid=170662

################################## Verify Privacy Notice Screen ###################################
     Navigate to Privacy Notice page

TC-22:User should be able to increment Set Point temperature from App.
    [Documentation]    User should be able to increment  Set Point temperature from App.
    [Tags]      testrailid=170663

########################### Set Temperature From Mobile and Validating it On Mobile itself ####################
    Select Device Location   ${select_HPWHGen5_location}
    Temperature Unit in Fahrenheit
    
    Navigate to Detail Page      ${deviceText}
    sleep   ${Sleep_5s}
    Increment set point
    ${setpoint_M_DP}    get setpoint from details screen
    
    
    Go Back
    ${setpoint_M_EC}    get setpoint from equipmet card
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

########################### Validating Temperature Value on End Device ##########################
    
    ${setpoint_ED}      Read int return type objvalue From Device       WHTRSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    should be equal as integers    ${setpoint_ED}     ${setpoint_M_EC}
    


TC-23:User should be able to increment Set Point temperature from Equipment.
    [Documentation]    User should be able to increment Set Point temperature from Equipment.
    [Tags]      testrailid=170664

######################### Set Temperature From Equipment and Validating it On Equipment itself ####################
    Select Device Location    ${select_HPWHGen5_location}
    
    ${setpoint_ED_R}      Read int return type objvalue From Device       WHTRSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED_W} =      Evaluate    ${setpoint_ED_R} + 1
    ${setpoint_ED}=    Write objvalue From Device    ${setpoint_ED_W}    WHTRSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    
    sleep     ${Sleep_10s}

######################### Validating Temperature Value On Rheem Mobile Application ####################
    
    Navigate to Detail Page        ${deviceText}
    ${setpoint_M_DP}        Validate set point Temperature From Mobile
    
    go back
    ${setpoint_M_EC}        get setpoint from equipmet card
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}


TC-24:Min temperature that can be set from App should be 110F.
    [Documentation]    Min temperature that can be set from App should be 110F.
   [Tags]      testrailid=170665

############################ Set Minimum Setpoint Temperature From Mobile and Validating it On Mobile itself ####################
    Select Device Location    ${select_HPWHGen5_location}
    
     Navigate to Detail Page      ${deviceText}
     ${setpoint_ED}=    Write objvalue From Device    111    WHTRSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}   ${EndDevice_id}
     
     sleep  ${sleep_5s}
     Decrement setpoint
     ${setpoint_M_DP}   get setpoint from details screen
     Go Back
     ${setpoint_M_EC}  convert to integer    110
     should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
############################ Validating Temperature Value On End Device #############################
    
    ${setpoint_ED}      Read int return type objvalue From Device       WHTRSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
    


TC-25:Max temperature that can be set from Equipment should be 140F.
    [Documentation]    Max temperature that can be set from Equipment should be 140F.
    [Tags]      testrailid=170666

########################### Set Maximum Setpoint Temperature From Equipment and Validating it On Equipment itself ####################
    Select Device Location   ${select_HPWHGen5_location}
    
    ${setpoint_ED}=    Write objvalue From Device    140    WHTRSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    
    sleep     ${Sleep_5s}

############################ Validating Temperature Value On Rheem Mobile Application #####################
    
    Navigate to Detail Page       ${deviceText}
    ${setpoint_M_DP}        Validate set point Temperature From Mobile
    
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_DP}
    go back
    ${setpoint_M_EC}        get setpoint from equipmet card
    should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}


TC-26:User should be able to set Energy Saver mode from App
    [Documentation]   User should be able to set Automate Savings mode from App for heat pump Water heater.
    [Tags]      testrailid=170667

############################ Set Energy Saver Mode From Mobile Application #########################
    Select Device Location    ${select_HPWHGen5_location}
    
    Navigate to Detail Page       ${deviceText}
    sleep     ${Sleep_5s}
    ${changeModeValue}=    Set Variable    1
    ${set_mode_M}   WH Set Mode     ${HPWHGen5_modes_List}[${changeModeValue}]
    sleep    ${Sleep_5s}
    Go Back
    sleep    ${Sleep_5s}
    ${cur_mode_M_EC}    get mode from equipment card  ${deviceText}
    should be equal as strings     ${cur_mode_M_EC.strip()}    ${set_mode_M}

############################ Validating Mode on End Device ##############################
    
    ${mode_ED}      Read int return type objvalue From Device       WHTRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer  ${mode_ED}
    should be equal as strings   ${HPWHGen5_modes_List}[${mode_ED}]    ${cur_mode_M_EC.strip()}
    

TC-27:Schedule the temperature and mode from App
    [Documentation]     Schedule the temperature and mode from App
    [Tags]      testrailid=170668

############################ Follow Schedule Data ############################
    
    Navigate to Detail Page        ${deviceText}
    sleep     ${Sleep_5s}
    ${get_current_set_point}    ${get_current_mode}    HPWH Follow Schedule Data   Schedule


############################ Verify Followed Schedule Changes like Set Point and Mode on Detail Page #########################
#    Wait Until Page Contains       ${deviceText}      ${Sleep_10s}
    ${setpoint_M_DP}       Validate set point Temperature From Mobile
    Sleep     ${Sleep_5s}
    Swipe  994    2058    937   1537    1000
    ${mode_M_DP}     WH Get Mode
    should be equal as integers     ${setpoint_M_DP}        ${get_current_set_point}
    Should Be Equal As Strings      ${mode_M_DP}        ${get_current_mode.strip()}
    Page Should Contain Text      Following Schedule
    go back
    ${setpoint_M_EC}    get setpoint from equipmet card
    sleep       ${Sleep_10s}
    ${Mode_M_EC}        get mode from equipment card    ${deviceText}
    should be equal as strings      ${setpoint_M_EC}       ${get_current_set_point}
    should be equal as strings      ${Mode_M_EC}          ${get_current_mode}

############################ Validating Temperature Value and Mode On End Device ####################
    ${setpoint_ED}      Read int return type objvalue From Device       WHTRSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should Be Equal As Strings      ${setpoint_ED}      ${get_current_set_point}
    ${mode_ED}          Read int return type objvalue From Device       WHTRCNFG    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    convert to integer  ${mode_ED}
    should be equal as strings    ${HPWHGen5_modes_List}[${mode_ED}]    ${get_current_mode.strip()}
    


TC-28:Unfollow the scheduled temperature and mode from App
    [Documentation]      Unfollow the scheduled temperature and mode from App
    [Tags]      testrailid=170669

############################# Unfollow the Schedule and verify text on detail screen ###########################
    Select Device Location    ${select_HPWHGen5_location}
    
    Navigate to Detail Page        ${deviceText}
    sleep     ${Sleep_5s}
    Unfollow the schedule     Schedule
    page should not contain text     Following Schedule
    sleep  ${sleep_5s}
    go back

TC-29:User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Documentation]   User should be able to view the current and historical data of the Current Day from the energy usage data.
    [Tags]      testrailid=170670

########################## View Daily Usage Report Data From Mobile Application ############################
    Select Device Location   ${select_HPWHGen5_location}
    
    Navigate to Detail Page       ${deviceText}
    sleep     ${Sleep_5s}
    
    sleep   ${sleep_5s}
    click text  ${UsageReport_text}
    ${Mobile_output}    get Energy Usage data      Daily
    sleep   ${Sleep_5s}
    

######################### View Current Data ###########################
    
    ${status}       get element attribute    ${HistoricalData_Switch}    checked
    Run Keyword If  '${status}' == 'true'     Click Element   ${HistoricalData_Switch}
    sleep   ${Sleep_5s}
    wait until page contains element      ${Usage_Chart}     ${sleep_10s}

########################## View Historical Data ###########################
    
    ${status}       get element attribute    ${HistoricalData_Switch}    checked
    Run Keyword If  '${status}' == 'false'     Click Element   ${HistoricalData_Switch}
    sleep   ${Sleep_5s}
    wait until page contains element      ${Usage_Chart}     ${sleep_10s}

########################## Validate orientation of screen ############################
    
    click element       ${Full_Screen_Mode}
    sleep   ${Sleep_5s}
    Wait until page contains element   ${Usage_Chart}    ${Sleep_10s}
    click element       ${Full_Screen_Mode}
    sleep   ${Sleep_5s}
    Wait until page contains element   ${Usage_Chart}    ${Sleep_10s}
    go back
    go back


TC-30:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App for Heat Pump Water Heater
    [Tags]      testrailid=170671

############################ Set Away Mode From Mobile Application ##########################
    Select Device Location    ${select_HPWHGen5_location}
    
    Select Device Location       ${select_HPWHGen5_location}
    sleep     ${Sleep_5s}
    ${Away_status_M}        Set Away mode from mobile application    ${deviceText}
    Sleep    ${Sleep_10s}

############################ Validate Away Status On Equipment #########################
    
    ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    ${Sleep_5s}
    ${a}    set variable  1
    ${a}    convert to integer  ${a}
    should be equal as integers    ${Away_status_ED}    ${a}
    

TC-31:User should be able to Disable Away from App
    [Documentation]    User should be able to Disable Away from App for Heat Pump Water Heater
    [Tags]      testrailid=170672

############################ Disable Away Mode From Mobile Application ##########################
    Select Device Location    ${select_HPWHGen5_location}
    
    Select Device Location        ${select_HPWHGen5_location}
    sleep     ${Sleep_5s}
    ${Away_status_M}        Disable Away mode from mobile application    ${deviceText}
    sleep  ${Sleep_10s}

############################ Validate  Away Mode Status on Equipment ##########################
    
    ${Away_status_ED}      Read int return type objvalue From Device       VACA_NET    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    ${Sleep_5s}
    ${a}    set variable  0
    ${a}    convert to integer  ${a}
    should be equal as integers    ${Away_status_ED}    ${a}
    

########################################### HVAC Device Testcases #####################################################
#TC-32:Updating Auto Mode from App detail page should be reflected on dashboard and Equipment.
#    [Documentation]    Updating Auto Mode from App detail page should be reflected on dashboard and Equipment.
#    [Tags]    testrailid=221891
############################# Change the temperature unit and deadband on App and EndDevice ############################
#    ${DeadbandValue}=    Set Variable    0
#    ${Deadband_set_ED}=    Write objvalue From Device    ${DeadbandValue}    DEADBAND      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    convert to integer      ${Deadband_set_ED}
#    
#    Sleep    ${Sleep_10s}
#
#    ${changeUnitValue}=    Set Variable    2
#    
#    ${TempUnit_ED}=    Write objvalue From Device    ${changeUnitValue}    DISPUNIT      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#
############################# Set Econet COntrol Center Mode From Mobile Application ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    sleep    ${Sleep_5s}
#    Navigate to Detail Page        ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    Set Auto Mode Of Smart Thermosate
#    Go Back
#    ${mode_M_EC}     Get mode name from equipment card HVAC
#    sleep   ${Sleep_5s}
#
############################# Validating Mode on End Device ############################
#    
#    ${mode_ED}      Read int return type objvalue From Device       STATMODE    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    convert to integer  ${mode_ED}
#    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}
#    
#
#
#
#TC-33:Updating Heating set point from App should be reflected on dashboard and Equipment.
#    [Documentation]    Updating Heating set point from App should be reflected on dashboard and Equipment.
#    [Tags]    testrailid=221892
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
############################# Set Temperature From Mobile and Validating it on Mobile itself ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page     ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    click element    ${Buttonslider}
#    sleep     ${Sleep_5s}
#    Increment set point
#
################################## Validating Temperature On Mobile App #################################
#    
#    Go Back
#    sleep  ${Sleep_5s}
#    ${setpoint_M_EC_heat}     Get Heat Setpoint from equipmet card HVAC
#    ${setpoint_M_EC_cool}     Get Cool Setpoint from equipmet card HVAC
#
############################# Validating Temperature Value On End Device ############################
#    
#    ${setpoint_ED_heat}      Read int return type objvalue From Device       HEATSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    Should Be Equal As Strings      ${setpoint_ED_heat}      ${setpoint_M_EC_heat}
#    Sleep    ${Sleep_5s}
#    ${setpoint_ED_cool}      Read int return type objvalue From Device       COOLSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    Should Be Equal As Strings      ${setpoint_ED_cool}     ${setpoint_M_EC_cool}
#    

#TC-34:Updating Cooling set point from App should be reflected on Equipment.
#    [Documentation]    Updating Cooling set point from App should be reflected on Equipment.
#    [Tags]    testrailid=221893
#   Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for         NewECC
#
############################# Set Temperature From Mobile and Validating it on Mobile itself ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page     ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    click element    ${CoolPlusButton}
#    sleep     ${Sleep_5s}
#
################################## Validating Temperature On Mobile App #################################
#    
#    Go Back
#    sleep  ${Sleep_5s}
#    ${setpoint_M_EC_heat}     Get Heat Setpoint from equipmet card HVAC
#    ${setpoint_M_EC_cool}     Get Cool Setpoint from equipmet card HVAC
#    sleep    ${Sleep_5s}
#
############################# Validating Temperature Value On End Device ############################
#    
#    ${setpoint_ED_heat}      Read int return type objvalue From Device       HEATSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    Should Be Equal As Strings      ${setpoint_ED_heat}      ${setpoint_M_EC_heat}
#    Sleep    ${Sleep_5s}
#    ${setpoint_ED_cool}      Read int return type objvalue From Device       COOLSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    Should Be Equal As Strings      ${setpoint_ED_cool}     ${setpoint_M_EC_cool}
#    

#TC-35:Min Heating setpoint that can be set from Equipment should be 50F.
#    [Documentation]    Min Heating setpoint that can be set from Equipment should be 50F.
#    [Tags]    testrailid=221894
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
############################# Set Temperature From Equipment ############################
#    
#    ${setpoint_ED}=    Write objvalue From Device    50    HEATSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    
#
############################# Validating Temperature On Mobile App ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    ${setpoint_M_EC}   Get Heat Setpoint from equipmet card HVAC
#    
#    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
##
##
#TC-36:Max Cooling setpoint that can be set from Equipment should be 92F.
#    [Documentation]    Max Cooling setpoint that can be set from Equipment should be 92F.
#    [Tags]    testrailid=221895
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
#
############################# Set Temperature From Equipment ############################
#    
#    ${setpoint_ED}=    Write objvalue From Device    92    COOLSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    
#
############################# Validating Temperature On Mobile App ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    ${setpoint_M_EC}    Get Cool Setpoint from equipmet card HVAC
#    
#    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
#
#
#TC-37:Updating Off Mode from App detail page should be reflected on dashboard and Equipment.
#    [Documentation]    Updating Off Mode from App detail page should be reflected on dashboard and Equipment.
#    [Tags]    testrailid=221896
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
#
############################# Set Heat Pump Mode From Mobile Application ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page          ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    Set OFF Mode Of Smart Thermosate
#    Go Back
#    ${mode_M_EC}   get text     ${HVACOffText_Equipmentcard}
#
#
############################# Validating Mode on End Device ############################
#    
#    ${mode_ED}      Read int return type objvalue From Device       STATMODE    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    convert to integer  ${mode_ED}
#    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}
#    
#
##
#TC-38:Updating Heating Mode from App detail page should be reflected on dashboard and Equipment.
#    [Documentation]    Updating Heating Mode from App detail page should be reflected on dashboard and Equipment.
#    [Tags]    testrailid=221897
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
#
#    ${coolMode}    set variable    0
#    ${setMode_ED}    write objvalue from device    ${coolMode}    STATMODE    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    
#
############################# Set Heat Pump Mode From Mobile Application ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page          ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    Set Heating Mode Of Smart Thermosate
#    Go Back
#    ${mode_M_EC}     Get mode name from equipment card HVAC
#
#
############################# Validating Mode on End Device ############################
#    
#    ${mode_ED}      Read int return type objvalue From Device       STATMODE    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    convert to integer  ${mode_ED}
#    should be equal as strings    ${newECC_modes_List}[${mode_ED}]    ${mode_M_EC}
#    
#
#
#TC-39:Max Heating setpoint that can be set from App should be 90F.
#    [Documentation]    Max Heating setpoint that can be set from App should be 90F.
#    [Tags]    testrailid=221898
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
#
#    ${coolMode}    set variable    0
#    ${setMode_ED}    write objvalue from device    ${coolMode}    STATMODE    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    
#
############################# Set Temperature From Mobile and Validating it on Mobile itself ############################
#    
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page          ${deviceText_ECC}
#    sleep   ${Sleep_5s}
#    ${setpoint_ED}=    Write objvalue From Device    89    HEATSETP      ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    sleep   ${Sleep_5s}
#    ${setpoint_ED}      Read int return type objvalue From Device    HEATSETP   ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    sleep   ${Sleep_5s}
#    Increment set point
#    go back
#    ${setpoint_M_EC}  Get Heat Setpoint from equipmet card HVAC
#    
#
############################# Validating Temperature Value On End Device ############################
#    
#    ${setpoint_ED}      Read int return type objvalue From Device       HEATSETP    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    should be equal as integers    ${setpoint_ED}    ${setpoint_M_EC}
#    
#
#TC-40:Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.
#    [Documentation]    Updating Fan Speed to Low from App detail page should be reflected on dashboard and Equipment.
#    [Tags]    testrailid=221899
#    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'   Run Keywords    Open Application and Navigate to Device Detail Page for     NewECC
#
############################# Set Temperature From Mobile and Validating it on Mobile itself ############################
#    
#    ${changeFanModeValue}=    Set Variable    1
#    ${get_fanspeed}     Get FanSpeed from equipment card HVAC
#    ${get_fanspeed}     Get Index From List     ${newECC_fanmodes_List}     ${get_fanspeed}
#    Select Device Location      ${select_NewECC_location}
#    Navigate to Detail Page     ${deviceText_ECC}
#    sleep    ${Sleep_5s}
##    ${Fanspeed_M_DP}    mobile app change set point ecc     ${changeFanModeValue}      ${get_temp}      ${newECC_setpoint_fan_min}      ${newECC_setpoint_fan_max}       ${WH_SetPointValue_fan_set}    ######## Temperature slider locator issue #########
#    Go Back
#    ${FanSpeed_M_EC}    Get FanSpeed from equipment card HVAC
#    ${FanSpeed_M_EC}    Get Index From List     ${newECC_fanmodes_List}     ${FanSpeed_M_EC}
#    should be equal as strings    ${FanSpeed_M_EC}    ${Fanspeed_M_DP}
#    
#
############################# Validating Temperature Value On End Device ############################
#    
#    ${setpoint_ED}      Read int return type objvalue From Device       STATNFAN    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id1}
#    should be equal as integers    ${setpoint_ED}    ${Fanspeed_M_DP}
#    should be equal as integers    ${setpoint_ED}    ${FanSpeed_M_EC}
#    
