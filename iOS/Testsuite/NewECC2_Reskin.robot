*** Settings ***
Documentation       Rheem iOS New ECC Water Heater Test Suite

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

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
...                     AND    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Change Temp Unit Fahrenheit From Device    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
...                     AND    Select the Device Location    ${locationNameNewECC}
Suite Teardown      Run Keywords    Capture Screenshot    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
...                     Open Application and Navigate to Device Detail Page    ${locationNameNewECC}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   40490F9E66D5
${Device_Mac_Address_In_Formate}        40-49-0F-9E-66-D5

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
${Device_TYPE}                          New Ecc

${emailId}                              automationtest@rheem.com
${passwordValue}                        rheem123

${newECCMinTemperature}                 50
${maxCoolingSetPoint}                   92
${maxHeatingSetPoint}                   90
${minCoolingSetPoint}                   52

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-68:Deadband of 5 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 5 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99146

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    5
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
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
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
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    55
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings     ${setHeatTemp_ED}     ${getHeatTemp_ED}
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-69:Deadband of 5 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 5 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99147
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    5
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings     ${current_DeadBand_ED}     ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    87
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-70:Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99148
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    5
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    sleep    3s
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-71:Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 5 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99149
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    5
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

TC-72:Deadband of 6 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 6 should be maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=99150

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
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
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
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
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
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
    ${heatTemp_Mobile}    Get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-73:Deadband of 6 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Deadband of 6 should be maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99151
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    86
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-74:Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99152
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-75:Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment. : EndDevice->Cloud->Mobile
#    [Tags]    testrailid=99153
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${autoMode}    set variable    2
#    ${setMode_ED}    write objvalue from device
#    ...    ${autoMode}
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_mode_ED}    Read int return type objvalue From Device
#    ...    ${statmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${heatTemp_Mobile}    Get text    ${heatBubble}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolBubble}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-77:User should be able to enable Fan running status of device from EndDevice
#    [Documentation]    User should be able to enable Fan Running status of device from EndDevice
#    [Tags]    testrailid=99155
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${changeModeValue}    Set Variable    1
#    ${mode_set_ED}    Write objvalue From Device
#    ...    ${changeModeValue}
#    ...    ${hvacmode}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Element value should be    ${thermostatCardCurrentValueIdentifier}    Fan Only
#    Navigate Back to the Screen

TC-82:Max temperature of heating that can be set from Equipment should be 32C for Auto mode.
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode. :EndDevice->Mobile
    [Tags]    testrailid=99160

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
    ${result2}    Convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${result2}    ${dashBoardTemperature}

TC-83:Min temperature of heating that can be set from Equipment should be 10C for Auto mode.
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode.    :EndDevice->Mobile
    [Tags]    testrailid=99161

    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
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
    ${result2}    Convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${result2}    ${dashBoardTemperature}

#TC-84:Max temperature of heating that can be set from App should be 32C for Auto mode.
#    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode.    :Mobile->EndDevice
#    [Tags]    testrailid=99162
#
#    ${setpoint_ED}    Write objvalue From Device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${changeUnitValue}    Set Variable    1
#    ${TempUnit_ED}    Write objvalue From Device
#    ...    ${changeUnitValue}
#    ...    ${dispunit}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Temperature Unit in Celsius
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
#    Scroll to the Max Temperature new ECC    32    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe Up the bubble    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${heatBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    32
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    Sleep    5s
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}
#
#TC-85:Min temperature of heating that can be set from App should be 10C for Auto mode.
#    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode.    :Mobile->EndDevice
#    [Tags]    testrailid=99163
#
#    ${setpoint_ED}    Write objvalue From Device
#    ...    50
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Temperature Unit in Celsius
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Scroll to the min temperature new ECC    10    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe down the bubble    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${heatBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    10
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    Sleep    5s
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}
#
#TC-86:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode.
#    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode.:Mobile->EndDevice
#    [Tags]    testrailid=99164
#
#    ${setpoint_ED}    Write objvalue From Device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#
#    Temperature Unit in Celsius
#    ${changeUnitValue}    Set Variable    1
#    ${TempUnit_ED}    Write objvalue From Device
#    ...    ${changeUnitValue}
#    ...    ${dispunit}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${Temperature_ED}    Write objvalue From Device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Scroll to the Max Temperature new ECC    32    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe Up the bubble    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${heatBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    32
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}
#
#TC-87:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.
#    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode.    :Mobile->EndDevice
#    [Tags]    testrailid=99165
#
#    ${setpoint_ED}    Write objvalue From Device
#    ...    50
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#
#    Temperature Unit in Celsius
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${Temperature_ED}    Write objvalue From Device
#    ...    10
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Scroll to the min temperature new ECC    10    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${heatBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe down the bubble    ${heatBubble}
#    wait until page contains element    ${heatBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${heatBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    10
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${heatTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-88:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode.
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode. :EndDevice->Mobile
    [Tags]    testrailid=99166
    
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
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
    ${result2}    Convert to integer    ${result1}
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-89:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode. :EndDevice->Mobile
    [Tags]    testrailid=99167

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
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
    ${result2}    Convert to integer    ${result1}
    Navigate back to the screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

#TC-90:Max temperature of cooling that can be set from App should be 33C for Auto mode.
#    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode. :Mobile->EndDevice
#    [Tags]    testrailid=99168
#
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Temperature Unit in Celsius
#    ${Temperature_ED}    Write objvalue From Device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    Scroll to the Max Temperature new ECC    33    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${coolBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe Up the bubble    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${coolBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    33
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}
#
#TC-91:Min temperature of cooling that can be set from App should be 11C for Auto mode.
#    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode. :Mobile->EndDevice
#    [Tags]    testrailid=99169
#
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Temperature Unit in Celsius
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${Temperature_ED}    Write objvalue From Device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Scroll to the min temperature new ECC    11    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${coolBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe down the bubble    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${coolBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    11
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}

#TC-92:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode.
#    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode. :Mobile->EndDevice
#    [Tags]    testrailid=99170
#
#    ${deadBandVal}    set variable    1
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Temperature Unit in Celsius
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${Temperature_ED}    Write objvalue From Device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Scroll to the Max Temperature new ECC    33    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${Temperature_Mobile}    Get text    ${coolBubble}
#    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
#    ${temp_app}    Swipe Up the bubble    ${coolBubble}
#    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
#    ${setpoint_M_DP}    Get text    ${coolBubble}
#    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
#    Should be equal as integers    ${setpoint_M_DP}    3
#    Navigate Back to the Screen
#    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
#    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
#    ${setpoint_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
#    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
#    ${result2}    Convert to integer    ${result1}
#    Should be equal as integers    ${result2}    ${setpoint_M_DP}
#    Should be equal as integers    ${result2}    ${setpoint_M_EC}
#
TC-93:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode.:Mobile->EndDevice
    [Tags]    testrailid=99171

    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius
    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Scroll to the min Temperature new ECC    11    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe down the bubble    ${coolBubble}
    wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    Get text    ${coolBubble}
    ${setpoint_M_DP}    Get Substring    ${setpoint_M_DP}    0    -1
    Should be equal as integers    ${setpoint_M_DP}    11
    Navigate Back to the Screen
    ${setpoint_M_EC}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}
    Temperature Unit in Fahrenheit

TC-98:Max Cooling and Heating setpoint that can be set from App should be 92F & 90F
    [Documentation]    Max Cooling and Heating setpoint that can be set from App should be 92F & 90F
    [Tags]    testrailid=99172

    ${setpoint_ED}    Write objvalue From Device    91    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    89    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    91
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    89
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${cool_temp}    92
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heat_temp}    90
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    90
    ${cool_setpoint_ED}    Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    92
    ${heat_setpoint_ED}    Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    90

TC-99:Min Cooling and Heating setpoint that can be set from App should be 52F & 50F
    [Documentation]    Min Cooling and Heating setpoint that can be set from App should be 52F & 50F
    [Tags]    testrailid=99173

    ${setpoint_ED}    Write objvalue From Device    53    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${setpoint_ED}    Write objvalue From Device    51    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    53
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    51
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${cool_temp}    52
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heat_temp}    50
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    50
    ${cool_setpoint_ED}    Read int return type objvalue From Device    ${coolsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${cool_setpoint_ED}    52
    ${heat_setpoint_ED}    Read int return type objvalue From Device    ${heatsetp}    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    Should be equal as integers    ${heat_setpoint_ED}    50

TC-100:User should not be able to exceed max setpoint limit i.e. 92F & 90F from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 92F & 90F from App
    [Tags]    testrailid=99174

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
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    90
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${coolTemp}    92
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heatTemp}    90
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    92
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
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

TC-101:User should not be able to exceed min setpoint limit i.e. 52F & 50F from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 52F & 50F from App
    [Tags]    testrailid=99175
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
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    50
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${cool_temp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${cool_temp}    52
    ${heat_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heat_temp}    50
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    52
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
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
    [Tags]    testrailid=99177

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${status}    Set schedule using button ECC    ${locationNameNewECC}
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
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_mode}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}

TC-106:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to resume schedule when schedule temperature is not follow using click button
    [Tags]    testrailid=99178

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule New ECC Button Slider    ${locationNameNewECC}
    ${new_heating_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Sleep    5s
    Resume Schedule
    Sleep    5s
    wait until page contains    ${followScheduleMsgDashboard}
    ${current_heat_temp}    get element attribute    ${heatTempButton}    value
    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolTempButton}    value
    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate to App Dashboard
    ${dashboard_heating}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]
    ${dashboard_cooling}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-105:Deadband of 0 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment using button slider
    [Tags]    testrailid=99179

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    0
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
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${heatTemp_Mobile}    Get text    ${heatTempButton}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolTempButton}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-106:Deadband of 0 should be maintained for max setpoint limit from Equipment
#    [Documentation]    Deadband of 0 should be maintained for max setpoint limit from Equipment
#    [Tags]    testrailid=99180
#
#    ${deadBandVal}    set variable    0
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${heatTemp_Mobile}    Get text    ${heatTempButton}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolTempButton}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard

TC-107:Deadband of 6 should be maintained for min setpoint limit from Equipment
    [Documentation]    Deadband of 6 should be maintained for max setpoint limit from Equipment
    [Tags]    testrailid=99181

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${deadBandVal}    set variable    6
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${current_DeadBand_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    56
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
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
    ${heatTemp_Mobile}    Get text    ${heatTempButton}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Get text    ${coolTempButton}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
    Navigate to App Dashboard

#TC-109:Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment
#    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for min setpoint limit from Equipment
#    [Tags]    testrailid=99182
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setCoolTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getCoolTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    52
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${heatTemp_Mobile}    Get text    ${heatTempButton}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolTempButton}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#
#TC-108:Deadband of 6 should be maintained for max setpoint limit from Equipment
#    [Documentation]    Deadband of 6 should be maintained for max setpoint limit from Equipment
#    [Tags]    testrailid=99183
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    92
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    86
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${heatTemp_Mobile}    Get text    ${heatTempButton}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolTempButton}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#    [Teardown]    write objvalue from device    0    ${deadband}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
#
#TC-110:Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment
#    [Documentation]    Setpoints should not update if Deadband of 6 is not maintained for max setpoint limit from Equipment
#    [Tags]    testrailid=99184
#
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${deadBandVal}    set variable    6
#    ${setMode_ED}    write objvalue from device
#    ...    ${deadBandVal}
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${current_DeadBand_ED}    Read int return type objvalue From Device
#    ...    ${deadband}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${current_DeadBand_ED}    ${setMode_ED}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${heatsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${setHeatTemp_ED}    write objvalue from device
#    ...    90
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    sleep    5s
#    ${getHeatTemp_ED}    Read int return type objvalue From Device
#    ...    ${coolsetp}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    ${heatTemp_Mobile}    Get text    ${heatTempButton}
#    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Get text    ${coolTempButton}
#    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
#    ${coolTemp_Mobile}    Convert to integer    ${coolTemp_Mobile}
#    ${heatTemp_Mobile}    Convert to integer    ${heatTemp_Mobile}
#    ${difference}    evaluate    ${coolTemp_Mobile}-${heatTemp_Mobile}
#    ${current_DeadBand_ED}    Convert to integer    ${current_DeadBand_ED}
#    Should be equal as integers    ${current_DeadBand_ED}    ${difference}
#    Navigate to App Dashboard
#    [Teardown]    write objvalue from device    0    ${deadband}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

TC-111:User should not be able to exceed max setpoint limit i.e. 33C & 32C from App
    [Documentation]    User should not be able to exceed max setpoint limit i.e. 33C & 32C from App
    [Tags]    testrailid=99185

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
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
    ${cool_temp_ed}    Convert to integer    ${result1}
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
    ${heat_temp_ed}    Convert to integer    ${result1}
    Should be equal as integers    ${heat_temp_ed}    32
    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    Should be equal as integers    ${coolTemp}    33
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingIncrease}
    Should be equal as integers    ${heatTemp}    32
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    33
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    32

TC-112:User should not be able to exceed min setpoint limit i.e. 11C & 10C from App
    [Documentation]    User should not be able to exceed min setpoint limit i.e. 11C & 10C from App
    [Tags]    testrailid=99186

    Temperature Unit in Celsius
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    5s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${cool_temp_ed}    Convert to integer    ${result1}
    Should be equal as integers    ${cool_temp_ed}    11
    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    sleep    5s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${heat_temp_ed}    Convert to integer    ${result1}
    Should be equal as integers    ${heat_temp_ed}    10
    ${coolTemp}    Update Cooling Setpoint Using Button    ${coolingDecrease}
    Should be equal as integers    ${coolTemp}    11
    ${heatTemp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    Should be equal as integers    ${heatTemp}    10
    Navigate Back to the Screen
    ${cool_setpoint_M}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${cool_setpoint_M}    11
    ${heat_setpoint_M}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${heat_setpoint_M}    10

#TC-102:User should be able to update fan Speed from App using slider button
#    [Documentation]    User should be able to update fan Speed from App using slider button
#    [Tags]    testrailid=33546
#
#    ${medHiMode}    set variable    4
#    ${setMode_ED}    write objvalue from device
#    ...    ${medHiMode}
#    ...    ${statnfan}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Sleep    10s
#    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
#    ${mode_mobile}    Change the mode New ECC    ${modeFanECC}
#    ${new_fan_speed}    Update Fanspeed Using Button    ${fanSppedPlus}
#    Should be equal as strings    ${new_fan_speed}    ${fanHighMode}
#    Navigate to App Dashboard
#    ${fan_mode}    get dashboard value from equipment card    ${thermostatCardCurrentValueIdentifier}
#    Should be equal as strings    ${fan_mode}    ${fanHighMode}
#    ${current_fanSpeed_ED}    Read int return type objvalue From Device
#    ...    ${statnfan}
#    ...    ${Device_Mac_Address}
#    ...    ${Device_Mac_Address_In_Formate}
#    ...    ${EndDevice_id}
#    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanHighMode}

TC-45:Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
    [Documentation]    Schedule the temperature and mode from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99119

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${status}    set schedule New ECC    ${locationNameNewECC}
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
    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}#    Should be equal as integers    ${tempCool}    ${TempCool_ED}
    Navigate to App Dashboard
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}

TC-46:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=99120

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Copy Schedule Data without mode    ${locationNameNewECC}
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-47:Change the Scheduled temperature and mode from App
    [Documentation]    Change the Scheduled temperature and mode from App
    [Tags]    testrailid=99121

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${temp}    Increment temperature value
    wait until page contains element    ${btnResume}
    Navigate to App Dashboard

TC-94:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=99122

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameNewECC}
    Resume Schedule
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate to App Dashboard
    ${dashboard_heating}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]
    ${dashboard_cooling}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-95:User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Tags]    testrailid=99123

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameNewECC}
    Change Temperature value    ${heatBubble}
    verify schedule overridden message    ${msgSchedule}
    Resume Schedule
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    page should contain element    ${modeNameDetailScreenPrePart}${schedule_list}[2]${modeNameDetailScreenPostPart}
    Navigate to App Dashboard
    ${dashboard_heating}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]
    ${dashboard_cooling}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-96:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=99124

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameNewECC}
    Change Temperature value    ${coolBubble}
    verify schedule overridden message    ${msgSchedule}
    Resume Schedule
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate to App Dashboard
    ${dashboard_heating}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]
    ${dashboard_cooling}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-97:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature
    ...    in cooling mode is not follow
    [Tags]    testrailid=99125

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule ECC    ${locationNameNewECC}
    Change the mode New ECC    ${modeCoolECC}
    Change Temperature value    ${modeTempBubble}
    verify schedule overridden message    ${msgSchedule}
    Resume Schedule
    wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_cool_temp}    get element attribute    ${tempBubble}    value
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate to App Dashboard
    ${dashboard_cooling}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-48:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=99126

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
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${status}    set schedule New ECC    ${locationNameNewECC}
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
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeat}    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCool}    ${dashBoardTemperature}
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

TC-49:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=99127

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    sleep    4s
    Unfollow the schedule    ${locationNameNewECC}
    Navigate to App Dashboard

TC-43:User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Tags]    testrailid=99117

    ${Away_status_M}    Set Away Mode Old ECC    ${locationNameNewECC}
    wait until element is visible    ${homeaway}    ${defaultWaitTime}
    Click Element    ${homeaway}
    Element Value should be    ${homeaway}    ${awayModeText}
    ${tempHeatMobile_ED}    get from list    ${Away_status_M}    0
    ${tempHeatMobile_ED}    Convert to integer    ${tempHeatMobile_ED}
    ${tempCoolMobile_ED}    get from list    ${Away_status_M}    1
    ${tempCoolMobile_ED}    Convert to integer    ${tempCoolMobile_ED}
    Sleep    4s
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
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
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeatMobile_ED}    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCoolMobile_ED}    ${dashBoardTemperature}

TC-44:User should be able to Disable Away from App : Mobile->Cloud->EndDevice
    [Documentation]    User should be able to Disable Away from App : Mobile->Cloud->EndDevice
    [Tags]    testrailid=99118

    click element    ${awayText}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    0

TC-113:User should be able to change the Humidity value from App.
    [Documentation]    User should be able to change the Humidity value from App.
    [Tags]    testrailid=99187

    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${humidity}    Change Humidity ECC
    wait until page contains element    ${locationNamePrePart}${humidity}${postHumidity}    ${defaultWaitTime}
    page should contain element    ${locationNamePrePart}${humidity}${postHumidity}
    Navigate Back to the Screen

TC-43:User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Documentation]    User should be able to set Away mode from App: Mobile->Cloud->EndDevice
    [Tags]    testrailid=99176

    # Configure Away mode in App validate on cloud and vacation end device.

    ${Away_status_M}    Set Away Mode Old ECC    ${locationNameNewECC}
    wait until element is visible    ${homeaway}    ${defaultWaitTime}
    Click Element    ${homeaway}
    Element Value should be    ${homeaway}    ${awayModeText}
    ${tempHeatMobile_ED}    get from list    ${Away_status_M}    0
    ${tempHeatMobile_ED}    Convert to integer    ${tempHeatMobile_ED}
    ${tempCoolMobile_ED}    get from list    ${Away_status_M}    1
    ${tempCoolMobile_ED}    Convert to integer    ${tempCoolMobile_ED}
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Should be equal as integers    ${Away_status_ED}    1
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
    should be equal    ${tempHeatMobile_ED}    ${TempHeat_ED}
    should be equal    ${tempCoolMobile_ED}    ${TempCool_ED}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeatMobile_ED}    ${dashBoardTemperature}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCoolMobile_ED}    ${dashBoardTemperature}

Verify UI of Network Settings screen
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Sleep    2s
    Wait Until Page Contains Element    Settings
    Click Element    Settings
    ${Status}    Run Keyword and Return Status    Wait until page contains element    Network
    IF    ${Status}    Click Element    Network
    wait until page contains element    MAC Address
    wait until page contains element    WiFi Software Version
    wait until page contains element    Network SSID
    wait until page contains element    IP Address
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen
    Run keyword and ignore error    Navigate Back to the Screen
