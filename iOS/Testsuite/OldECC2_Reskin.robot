*** Settings ***
Documentation       Rheem iOS Old ECC Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords
...                     Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Open App
...                     AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${locationNameOldECC}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameOldECC}

Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E4947
${Device_Mac_Address_In_Formate}        40-49-0F-9E-49-47
${EndDevice_id}                         896

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458

#    --> real rheem device info
${Device_WiFiTranslator_MAC_ADDRESS}    D0-C5-D3-3C-05-DC
${Device_TYPE_WiFiTranslator}           econetWiFiTranslator
${Device_TYPE}                          Old ECC

${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***

TC-72:Deadband of 6 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 6 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=103141
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application without uninstall and Navigate to dashboard
        ...    ${locationNameOldECC}
    END

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    6
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    56
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    sleep    5s
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1

    ${coolTemp_Mobile}    convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    convert to integer    ${heatTemp_Mobile}

    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    

    ${current_DeadBand_ED}    convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}

    Navigate to App Dashboard

TC-43:User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Tags]    testrailid=103145

    ${Away_status_M}    Set Away Mode Old ECC    ${locationNameOldECC}
    wait until element is visible    ${homeaway}    ${defaultWaitTime}
    Click Element    ${homeaway}
    Sleep    4s
    Element Value should be    ${homeaway}    ${awayModeText}
    Sleep    10s
    ${tempHeatMobile_ED}    get from list    ${Away_status_M}    0
    ${tempHeatMobile_ED}    convert to integer    ${tempHeatMobile_ED}
    ${tempCoolMobile_ED}    get from list    ${Away_status_M}    1
    ${tempCoolMobile_ED}    convert to integer    ${tempCoolMobile_ED}

    Sleep    4s

    # Validating temperature value on End Device
    
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vacaenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as integers    ${Away_status_ED}    1

    Sleep    4s
    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Sleep    4s
    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    should be equal    ${tempHeatMobile_ED}    ${TempHeat_ED}
    should be equal    ${tempCoolMobile_ED}    ${TempCool_ED}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    should be equal as integers    ${tempHeatMobile_ED}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    should be equal as integers    ${tempCoolMobile_ED}    ${dashBoardTemperature}
    

TC-44:User should be able to Disable Away from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103146
    wait until element is visible    ${homeaway}    ${defaultWaitTime}
    Click Element    ${homeaway}
    Sleep    4s
    Element Value should be    ${homeaway}    ${homeModeText}
    Sleep    5s

    # Validating temperature value on End Device
    
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vacaenab}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0


TC-82:Max temperature of heating that can be set from Equipment should be 32C for Auto mode.
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode. :EndDevice->Mobile
    [Tags]    testrailid=103147

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}

    Navigate Back to the Screen
    #############    Verify temperature on Mobile Application    ###########
    
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-83:Min temperature of heating that can be set from Equipment should be 10C for Auto mode.
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode. :EndDevice->Mobile
    [Tags]    testrailid=103148


    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ##########################    Set minimum temp 10C from equipment    #########################
    
    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Navigate Back to the Screen
    ###################    Verify temperature on Mobile Application    ############
    
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-84:Max temperature of heating that can be set from App should be 32C for Auto mode.
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode. :Mobile->EndDevice
    [Tags]    testrailid=103149


    ##############################    Set maximum temperature 32C from the Mobile Application    #################################
    
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    ${dispunit}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ##############################    Set maximum temperature 32C from the Mobile Application    #################################
    ${setpoint_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature old ECC    32    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Up the bubble    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    32

    

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-85:Min temperature of heating that can be set from App should be 10C for Auto mode.
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode. :Mobile->EndDevice
    [Tags]    testrailid=103150
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    Temperature Unit in Celsius

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ##############################    Set maximum temperature 32C from the Mobile Application    #################################
    ${Temperature_ED}    Write objvalue From Device
    ...    54
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the min temperature old ECC    10    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe down the bubble    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    10

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}-1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    ${result2}    evaluate    ${result2}+1
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-86:User should not be able to exceed heating temp max setpoint limit i.e. 33C from App for Auto mode.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode.    :Mobile->EndDevice
    [Tags]    testrailid=103151

    Temperature Unit in Celsius
    ${setpoint_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the Max Temperature old ECC    32    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Up the bubble    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    32

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    ####################    Validating Temperature Value On End Device    ####################
    
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-87:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.    :Mobile->EndDevice

    Temperature Unit in Celsius
    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    2s
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the min temperature old ECC    10    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe down the bubble    ${heatBubble}
    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    10

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

####################    Validating Temperature Value On End Device    ####################
    
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-88:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode.
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode.    :EndDevice->Mobile
    [Tags]    testrailid=103153

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    #####################################    Set maximum temp 33C from equipment    #########################################
    
    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}

    Navigate Back to the Screen
    ################################    Verify temperature on Mobile Application    #####################################
    
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-89:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode.    :EndDevice->Mobile
    [Tags]    testrailid=103154

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    #####################################    Set minimum temp 11C from equipment    #########################################
    
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ################################    Verify temperature on Mobile Application    #####################################
    
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-90:Max temperature of cooling that can be set from App should be 33C for Auto mode.
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode.    :Mobile->EndDevice
    [Tags]    testrailid=103155
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    Temperature Unit in Celsius
    ##############################    Set maximum temperature 33C from the Mobile Application    #################################
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${Temperature_ED}    Write objvalue From Device
    ...    89
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    2s
    Scroll to the Max Temperature old ECC    33    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${coolBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    Should be equal as integers    ${setpoint_M_DP}    33
    Navigate Back to the Screen

    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    

    ####################    Validating Temperature Value On End Device    ####################
    
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-91:Min temperature of cooling that can be set from App should be 11C for Auto mode.
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode.    :Mobile->EndDevice
    [Tags]    testrailid=103156
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    Temperature Unit in Celsius
    ##############################    Set maximum temperature 11C from the Mobile Application    #################################
    
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    2s
    Scroll to the min temperature old ECC    11    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe down the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${coolBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    11

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    

    ####################    Validating Temperature Value On End Device    ####################
    
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-92:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode.
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode.    :Mobile->EndDevice
    [Tags]    testrailid=103157
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    #######################    Set Setpoint above Maximum Setpoint limit 33C From Mobile App and Validating it On Mobile App itself    ######################
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Scroll to the Max Temperature new ECC    33    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${coolBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    33

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}

    ####################    Validating Temperature Value On End Device    ####################
    
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    

TC-93:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.    :Mobile->EndDevice
    [Tags]    testrailid=103158
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    Scroll to the min Temperature new ECC    11    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe down the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${coolBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    should be equal    ${setpoint_M_DP}    11

    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${result2}    convert to integer    ${result1}
    
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    
    Temperature Unit in Fahrenheit
TC-98:Max Cooling and Heating setpoint that can be set from App should be 92F & 90F
    [Documentation]    Max Cooling and Heating setpoint that can be set from App should be 92F & 90F
    [Tags]    testrailid=103159

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${setpoint_ED}    Write objvalue From Device    91    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    89    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    5s
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    91
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    89
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${cool_temp}    92
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heat_temp}    90
    # setpoint verificaton on dashboard is pending
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    90

    ${cool_setpoint_ED}    Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    92
    ${heat_setpoint_ED}    Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    90

# TC-99 from sheet

TC-99:Min Cooling and Heating setpoint that can be set from App should be 52F & 50F
    [Documentation]    Min Cooling and Heating setpoint that can be set from App should be 52F & 50F
    [Tags]    testrailid=103160

    ${setpoint_ED}    Write objvalue From Device    53    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    51    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    sleep    5s
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    53
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    51
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${cool_temp}    52
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heat_temp}    50
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    50

    ${cool_setpoint_ED}    Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    52
    ${heat_setpoint_ED}    Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    50

# TC-100 from sheet

TC-100:User should not be able to exceed max setpoint limit i.e. 92F & 90F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 92F & 90F from App
    [Tags]    testrailid=103161

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    90
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    

    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${coolTemp}    92
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heatTemp}    90
    # setpoint verificaton on dashboard is pending
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    90

    ${cool_setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    92
    ${heat_setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    90

# TC-101 from sheet

TC-101:User should not be able to exceed min setpoint limit i.e. 52F & 50F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 52F & 50F from App
    [Tags]    testrailid=103162

    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    50
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${cool_temp}    52
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heat_temp}    50
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    50

    ${cool_setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    52
    ${heat_setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    50

TC-105:User should be able to Change the temperature value from the Schedule screen.
    [Documentation]    Schedule the temperature and fanspeed from app using button slider
    [Tags]    testrailid=103163

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
#    sleep    4    s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}

    ${status}    set schedule using button ECC    ${locationNameOldECC}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    
    

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate to App Dashboard
    convert to integer    ${current_mode_ED}
    

    
    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}
    

TC-106:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to resume schedule when schedule temperature is not follow using click button
    [Tags]    testrailid=103164

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${schedule_list}    Get Temperatre And Mode from Current Schedule New ECC Button Slider    ${locationNameOldECC}

    ${new_heating_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Sleep    10s
    Resume Schedule

    
    wait until page contains element    ${followScheduleMsgDashboard}
    ${current_heat_temp}    get element attribute    ${heatTempButton}    value
#    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolTempButton}    value
#    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    page should contain element    ${modeNameDetailScreenPrePart}${schedule_list}[2]${modeNameDetailScreenPostPart}

    Navigate to App Dashboard

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]

    
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]


TC-113:User should not be able to exceed max setpoint limit i.e. 33C & 32C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 33C & 32C from App
    [Tags]    testrailid=103171
    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    #    Set maximum temp 33C from equipment
    
    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${cool_temp_ed}    convert to integer    ${result1}
    
    Should be equal as integers    ${cool_temp_ed}    33
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${heat_temp_ed}    convert to integer    ${result1}
    Should be equal as integers    ${heat_temp_ed}    32

    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${coolTemp}    33
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heatTemp}    32
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    33
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    32

# TC-114 from sheet

TC-112:User should not be able to exceed min setpoint limit i.e. 11C & 10C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 11C & 10C from App
    [Tags]    testrailid=103172

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    #    Set maximum temp 33C from equipment
    
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${cool_temp_ed}    convert to integer    ${result1}
    
    Should be equal as integers    ${cool_temp_ed}    11

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    
    ${heat_temp_ed}    convert to integer    ${result1}
    Should be equal as integers    ${heat_temp_ed}    10

    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${coolTemp}    11
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heatTemp}    10
    Navigate Back to the Screen
    
    ${cool_setpoint_M}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    11
    ${heat_setpoint_M}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    10

# TC-115 from app

TC-113:User should be able to change the Humidity value from App.
    [Documentation]    User should be able to change the Humidity value from App.
    [Tags]    testrailid=103173

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${humidity}    Change Humidity ECC
    
    element value should be    thermostatHumidityButton    ${humidity}
    Navigate Back to the Screen

TC-45:Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
    [Documentation]    Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=103175

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}

    ${status}    set schedule Old ECC    ${locationNameOldECC}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    STAT_FAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate to App Dashboard
    convert to integer    ${current_mode_ED}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}
    

TC-46:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=103176

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Copy Schedule Data    ${locationNameOldECC}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-47:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=103177

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${temp}    Increment temperature value
    Sleep    10s
    
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Navigate to App Dashboard
    

TC-94:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=103178


    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameOldECC}
    Resume Schedule
    Sleep    5s
    
    wait until page contains    ${followScheduleMsgDashboard}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    get substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    get substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]

    Navigate to App Dashboard

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]

    
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]
    

TC-95:User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Tags]    testrailid=103179

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameOldECC}

    Change Temperature value    ${heatBubble}
    Sleep    5s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}

    Resume Schedule
    Sleep    5s
    
    wait until page contains    ${followScheduleMsgDashboard}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    get substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    get substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]

    Navigate to App Dashboard

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]

    
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-96:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=103180

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameOldECC}

    Change Temperature value    ${coolBubble}
    Sleep    5s
    Verify Schedule Overridden Message    ${scheduleoverriddentext}
    Resume Schedule

    
    wait until page contains    ${followScheduleMsgDashboard}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    get substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    get substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]

    Navigate to App Dashboard

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1

    
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

    

TC-97:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature
    ...    in cooling mode is not follow
    [Tags]    testrailid=103181

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameOldECC}

    Change the mode New ECC    ${modeCoolECC}
    Change Temperature value    ${modeTempBubble}
    Sleep    10s
    verify schedule overridden message    ${msgSchedule}

    Resume Schedule
    Sleep    5s
    
    wait until page contains    ${followScheduleMsgDashboard}
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    get substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate to App Dashboard

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-48:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=103182

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    
    should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}

    ${status}    set schedule Old ECC    ${locationNameOldECC}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1
    ${schedule_mode}    get from list    ${status}    2

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    STAT_FAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate to App Dashboard
    convert to integer    ${current_mode_ED}
    
    should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_mode}

    
    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}

TC-49:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=103183

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Click Element    ${scheduleButton}
    Unfollow the schedule    ${locationNameOldECC}
    Navigate to App Dashboard