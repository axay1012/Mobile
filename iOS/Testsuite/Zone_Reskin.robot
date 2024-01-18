*** Settings ***
Documentation       Rheem iOS Heat Pump Water Heater Test Suite

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../../src/RheemMqtt.py
Library             ../../src/RheemCustom.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}    AND    Open App    AND    Create Session    Rheem    http://econet-uat-api.rheemcert.com:80    AND    Sign in to the application    ${emailId}    ${passwordValue}    AND    Select the Device Location    ${locationNameZoning}
Suite Teardown      Close All Apps
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${Device_Mac_Address}                   F48E38A7F4FE
${Device_Mac_Address_In_Formate}        F4-8E-38-A7-F4-FE

${EndDevice_id_Main}                    896
${EndDevice_id_Zone}                    1665
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

${emailId}                              automation@rheem.com
${passwordValue}                        Vyom@0212

${value1}                               32
${value2}                               5
${value3}                               9


*** Test Cases ***
TC-01:Updating Auto Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Auto Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191874

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${deawriteOutput:dBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}
    sleep    10s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Swipe the screen left
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    page should contain element    ${heatBubble}
    page should contain element    ${coolBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-02:Updating Heating setpoint for Main ECC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating setpoint for Main ECC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191875

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${current_temp}    get text    ${heatBubble}
    ${temp1}    Get Substring    ${current_temp}    0    -1
    ${heatTemp_Mobile}    Change Temperature value    ${heatBubble}
    sleep    4s
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${heatTemp_Mobile}    ${current_temp_ED}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-03:Updating Heating setpoint for Main ECC from Equipment should be reflected on App dashboard. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating setpoint for Main ECC from Equipment should be reflected on App dashboard. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191876

    # Set temperature from mobile and validating it on mobile itself

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Sleep    4s
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    # Validating the temperature value on Rheem Mobile Application
    Sleep    5s
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}
    Navigate Back to the Screen

TC-04:Updating Cooling setpoint for Main ECC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Cooling setpoint for Main ECC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191877

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${current_temp}    get text    ${coolBubble}
    ${current_temp}    Get Substring    ${current_temp}    0    -1
    ${changedTemp_Mobile}    Change Temperature value    ${coolBubble}
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-05:Updating Cooling setpoint for Main ECC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Documentation]    Updating Cooling setpoint for Main ECC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Tags]    testrailid=191878

    # Set temperature from mobile and validating it on mobile itself

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-06:Min Heating setpoint that can be set for Main ECC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Documentation]    Min Heating setpoint that can be set for Main ECC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191879

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-07:Max Cooling setpoint that can be set for Main ECC from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Main ECC from Equipment should be 92F.
    [Tags]    testrailid=191880

    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-08:Min Heating setpoint that can be set for Main ECC from App should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Main ECC from App should be 50F.
    [Tags]    testrailid=191881

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    50    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    swipe down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    50
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen

TC-09:Max Cooling setpoint that can be set for Main ECC from App should be 92F. : EndDevice->Cloud->Mobile
    [Documentation]    Max Cooling setpoint that can be set for Main ECC from App should be 92F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191882

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    92    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    swipe up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    92
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-10:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from App
    [Tags]    testrailid=191883

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself

    # Set the minimum temperature    50    ${heatBubble}
    Scroll to the min temperature for Zone Device    50    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    swipe down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1

    Should be equal    ${Temperature_Mobile}    50
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-11:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from App. : EndDevice->Cloud->Mobile
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from App. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191884

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    92    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    # ${temp_app}    Scroll Down    ${coolBubble}
    swipe up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    92
    Navigate Back to the Screen
    # sleep    5s
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-12:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from Equipment
    [Tags]    testrailid=191885

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    49
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${TempChange_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen
    should not be equal as integers    49    ${Temperature_Mobile}

TC-13:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Main ECC from Equipment
    [Tags]    testrailid=191886

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    93
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${TempChange_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen
    should not be equal as integers    93    ${Temperature_Mobile}

TC-14:Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191887

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${current_temp}    get text    ${heatBubble}
    ${current_temp}    Get Substring    ${current_temp}    0    -1
    ${changedTemp_Mobile}    Change Temperature value    ${heatBubble}
    Navigate Back to the Screen
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
    Navigate Back to the Screen

TC-15:Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191888

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 4
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}
    Navigate Back to the Screen

TC-16:Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191889

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${current_temp}    get text    ${coolBubble}
    ${current_temp}    Get Substring    ${current_temp}    0    -1
    ${changedTemp_Mobile}    Change Temperature value    ${coolBubble}
    ${changedTemp_Mobile}    Convert to integer    ${changedTemp_Mobile}
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-17:Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Documentation]    Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Tags]    testrailid=191890

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 4
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-18:Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191891

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-19:Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.
    [Tags]    testrailid=191892

    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-20:Min Heating setpoint that can be set for Zoned CC from App should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from App should be 50F.
    [Tags]    testrailid=191893

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    50    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    swipe down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    50
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen

TC-21:Max Cooling setpoint that can be set for Zoned CC from App should be 92F. : EndDevice->Cloud->Mobile
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from App should be 92F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191894

    Navigate to Zoning Overview screen
    ${changed_Temp_ED}    Write objvalue From Device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    92    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    92
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-22:User should not be able to exceed Min Heating setpoint limit i.e. 50F for ZoneCC from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Main ECC from App
    [Tags]    testrailid=191895

    Navigate to Zoning Overview screen
    ${changed_Temp_ED}    Write objvalue From Device
    ...    51
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    50    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    50
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-23:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App: EndDevice->Cloud->Mobile
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App: EndDevice->Cloud->Mobile
    [Tags]    testrailid=191896

    ${changed_Temp_ED}    Write objvalue From Device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    92    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal    ${Temperature_Mobile}    92
    Navigate Back to the Screen
    Navigate Back to the Screen

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-24:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment
    [Tags]    testrailid=191897

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    49
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ...    ${TempChange_ED}=
    ...    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen
    should not be equal as integers    49    ${Temperature_Mobile}

TC-25:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment
    [Tags]    testrailid=191898

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${changed_Temp_ED}    Write objvalue From Device
    ...    93
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${TempChange_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${TempChange_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Navigate Back to the Screen
    Navigate Back to the Screen

    should not be equal as integers    93    ${Temperature_Mobile}

TC-26:Updating Off Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Off Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191899

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeOff}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Swipe the screen left
    # sleep    10s
    page should not contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-27:Updating Heating Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191900

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeHeatECC}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}
    Swipe the screen left
    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    page should contain element    ${imgBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-28:Max Heating setpoint for Main ECC that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint for Main ECC that can be set from App should be 90F.
    [Tags]    testrailid=191901

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Sleep    5s
    ${changed_Temp_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Scroll to the Max temperature for Zone Device    90    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate Back to the Screen

    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-29:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from App
    [Tags]    testrailid=191902
    ${changed_Temp_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Scroll to the Max temperature for Zone Device    90    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    swipe up the bubble    ${modeTempBubble}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate Back to the Screen
    Navigate Back to the Screen

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-30:Max Heating setpoint for Zoned CC that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from App should be 90F.
    [Tags]    testrailid=191903

    ${changed_Temp_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    90    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}

    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate Back to the Screen

    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-31:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App
    [Tags]    testrailid=191904

    ${changed_Temp_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    90    ${modeTempBubble}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    swipe up the bubble    ${modeTempBubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${modeTempBubble}
    ${Temperature_Mobile}    Get Substring    ${Temperature_Mobile}    0    -1
    Should be equal as integers    ${Temperature_Mobile}    90
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-32:Updating Cooling Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Cooling Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191905

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${mode_mobile}    Change the mode New ECC    ${modeCoolECC}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}

    Swipe the screen left
    Wait until page contains element    ${modetempbubble}    ${defaultWaitTime}
    page should contain element    ${modetempbubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-33:Min Cooling setpoint that can be set for Main ECC from App should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set for Main ECC from App should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191906

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${changed_Temp_ED}    Write objvalue From Device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Scroll to the min temperature for Zone Device    52    ${coolBubble}    ${coolingDecrease}
    ${temp_mobile}    get text    ${modetempbubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1

    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${temp_mobile}    ${get_temp_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-34:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191907

    ${changed_Temp_ED}    Write objvalue From Device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    52    ${coolBubble}    ${coolingDecrease}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1

    swipe down the bubble    ${modetempbubble}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${change_temp_mobile}    get text    ${modetempbubble}
    ${change_temp_mobile}    Get Substring    ${change_temp_mobile}    0    -1
    # sleep    5s
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${change_temp_mobile}    ${get_temp_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-35:Min Cooling setpoint that can be set for Zoned CC from App should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from App should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191908

    ${changed_Temp_ED}    Write objvalue From Device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    52    ${coolBubble}    ${coolingDecrease}
    Wait until page contains element    ${modetempbubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modetempbubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${temp_mobile}    ${get_temp_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-36:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from App. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from App. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191909

    ${changed_Temp_ED}    Write objvalue From Device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Scroll to the min temperature for Zone Device    52    ${coolBubble}    ${coolingDecrease}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modetempbubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1

    swipe down the bubble    ${modetempbubble}
    Wait until page contains element    ${modetempbubble}    ${defaultWaitTime}
    ${change_temp_mobile}    get text    ${modetempbubble}
    ${change_temp_mobile}    Get Substring    ${change_temp_mobile}    0    -1
    # sleep    5s
    ${get_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as strings    52    ${get_temp_ED}
    Should be equal as strings    ${change_temp_mobile}    ${get_temp_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-37:Updating Fan Only Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Only Mode of Main ECC from App should be applied on Zoned CCs and reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191910

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    sleep    4s
    ${mode_mobile}    Change the mode New ECC    ${modeFanECC}

    sleep    5s

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${ECC_modes}[${current_mode_ED}]    ${mode_mobile}

    Swipe the screen left
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    page should contain element    ${heatBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-38:Updating Fan Speed to Auto from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Auto from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191911

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeAutoECC}

    ${fanOnlyMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${fanOnlyMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    Auto

    ${fanSpeed_mobile}    Change fan mode    ${fanAutoMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}

    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-39:Updating Fan Speed to Low from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Low from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191912

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanLowMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}
    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-40:Updating Fan Speed to Med.Lo from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Med.Lo from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191913

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanLowMode}

    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}

    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-41:Updating Fan Speed to Medium from App detail page of Main ECC should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Medium from App detail page of Main ECC should be reflected on dashboard and Equipment.. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191914

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMediumMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}

    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-42:Updating Fan Speed to Med.Hi from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Med.Hi from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191915

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanMedHiMode}

    sleep    2s
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}

    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-43:Updating Fan Speed to High from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Fan Speed to Med.Hi from App detail page of Main ECC should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191916

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${fanSpeed_mobile}    Change the FanOnly Fan mode    ${fanHighMode}

    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${fanSpeed_mobile}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-44:Setting Off mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Documentation]    Setting Off mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191917

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${offMode}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${offMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Off

    Swipe the screen left
    page should not contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-45:Setting Heating mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Documentation]    Setting Heating mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191918

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${heatMode}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${heatMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Heating

    Swipe the screen left
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    page should contain element    ${tempBubble}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-46:Max Heating setpoint that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint that can be set from Equipment should be 90F.
    [Tags]    testrailid=191919

    ${set_Temp_ED}    write objvalue from device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${set_Temp_ED}    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    90

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-47:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.
    [Tags]    testrailid=191920

    ${set_Temp_ED}    write objvalue from device
    ...    91
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    should not be equal as integers    91    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    should not be equal as integers    ${temp_mobile}    91
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-48:Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Tags]    testrailid=191921

    ${set_Temp_ED}    write objvalue from device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${set_Temp_ED}    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    90

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-49:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment.
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment.
    [Tags]    testrailid=191922

    ${set_Temp_ED}    write objvalue from device
    ...    91
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    should not be equal as integers    91    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1

    should not be equal as integers    ${temp_mobile}    91
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-50:Setting Cooling mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Documentation]    Setting Cooling mode from Equipment for Main ECC applies on Zoned CCs. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191923

    ${coolMode}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${coolMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Cooling

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-51:Min Cooling setpoint that can be set for Main ECC from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set for Main ECC from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191924

    ${set_Temp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Should be equal as integers    52    ${get_Temp_ED}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    52

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-52:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Main ECC from Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191925

    ${set_Temp_ED}    write objvalue from device
    ...    51
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    should not be equal as integers    51    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    should not be equal as integers    ${temp_mobile}    51

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-53:Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191926

    ${set_Temp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as integers    52    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    Should be equal as integers    ${temp_mobile}    52

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-54:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment
    [Tags]    testrailid=191927

    ${set_Temp_ED}    write objvalue from device
    ...    51
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    should not be equal as integers    51    ${get_Temp_ED}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${temp_mobile}    get text    ${modeTempBubble}
    ${temp_mobile}    Get Substring    ${temp_mobile}    0    -1
    should not be equal as integers    ${temp_mobile}    51

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-55:User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Auto mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191928

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Auto

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Swipe the screen left
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}

    page should contain element    ${heatBubble}
    page should contain element    ${coolBubble}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-56:User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    User should be able to set Fan Only mode from Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=191929

    ${fanOnlyMode}    set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${fanOnlyMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    Should be equal as strings    ${ecc_modes}[${current_mode_ED}]    Fan Only

TC-57:Setting Away mode for Main ECC from App applies on Zoned CCs.: Mobile->Cloud->EndDevice
    [Documentation]    Setting Away mode for Main ECC from App applies on Zoned CCs.: Mobile->Cloud->EndDevice
    [Tags]    testrailid=191930

    ${Away_status_M}    Set Away Mode Old ECC    ${locationNameOldECC}

    wait until element is visible    ${homeaway}    ${defaultWaitTime}
    Click Element    ${homeaway}
    Sleep    4s
    Element Value should be    ${homeaway}    ${awayModeText}
    Sleep    10s
    ${tempHeatMobile_ED}    Get from list    ${Away_status_M}    0
    ${tempHeatMobile_ED}    Convert to integer    ${tempHeatMobile_ED}
    ${tempCoolMobile_ED}    Get from list    ${Away_status_M}    1
    ${tempCoolMobile_ED}    Convert to integer    ${tempCoolMobile_ED}

    Sleep    4s
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    ${vaca_net}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as integers    ${Away_status_ED}    1
    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Sleep    4s
    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal    ${tempHeatMobile_ED}    ${TempHeat_ED}
    Should be equal    ${tempCoolMobile_ED}    ${TempCool_ED}

    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeatMobile_ED}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCoolMobile_ED}    ${dashBoardTemperature}

TC-58:Away mode should get disabled from Cloud for Main ECC as well as Zoned CCs. : Mobile->Cloud->EndDevice
    [Documentation]    Away mode should get disabled from Cloud for Main ECC as well as Zoned CCs. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=191931

    Click Element    ${awayText}
    ${Away_status_M}    Disable Away Mode
    sleep    3s
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    AWAYMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Away_status_ED}    0

TC-59:Schedule the temperature and Fan speed from App for Main ECC: Mobile->Cloud->EndDevice
    [Documentation]    Schedule the temperature and Fan speed from App for Main ECC: Mobile->Cloud->EndDevice
    [Tags]    testrailid=191932

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${status}    set schedule zoning    ${locationNameZoning}

    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1
    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen
    Sleep    2s

TC-60:Copy the Scheduled Day slot, temperature and mode from App
    [Documentation]    Copy the Scheduled Day slot, temperature and mode from App
    [Tags]    testrailid=191933

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    Copy Schedule Data zoning    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Sub Screen
    Navigate Back to the Screen
    Navigate Back to the Sub Screen
    Navigate Back to the Screen

TC-61:Change the Scheduled temperature and Fan Speed from App for Main ECC.
    [Documentation]    Change the Scheduled temperature and Fan Speed from App for Main ECC.
    [Tags]    testrailid=191934

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${status}    set schedule zoning    ${locationNameZoning}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1
    ${schedule_mode}    Get from list    ${status}    2

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${stat_fan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen
    Sleep    2s
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_mode}

TC-119:User should be able to Resume Schedule when scheduled temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow
    [Tags]    testrailid=191935
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Wait Until Keyword Succeeds
        ...    2x
        ...    4m
        ...    Open Application and Navigate to Device Detail Page
        ...    ${locationNameZoning}
    END

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${schedule_list}    Get Temperatre And Mode from Current Schedule New ECC Button Slider    ${locationNameZoning}
    Sleep    10s
    Resume Schedule
    Sleep    10s

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1

    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate Back to the Screen
    Navigate Back to the Screen

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]
    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-120:User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled heat temperature is not follow
    [Tags]    testrailid=191936
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${schedule_list}    Get Temperatre And Mode from Current Schedule New ECC Button Slider    ${locationNameZoning}

    Change Temperature value    ${heatBubble}
    Sleep    10s

    verify schedule overridden message    ${msgSchedule}

    Resume Schedule
    Sleep    10s

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate Back to the Screen
    Navigate Back to the Screen

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]

    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-121:User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature is not follow
    [Tags]    testrailid=191937

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${schedule_list}    Get Temperatre And Mode from Current Schedule New ECC Button Slider    ${locationNameZoning}

    Change Temperature value    ${coolBubble}
    Sleep    10s

    verify schedule overridden message    ${msgSchedule}

    Resume Schedule
    Sleep    10s

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]
    Navigate Back to the Screen
    Navigate Back to the Screen

    ${dashboard_heating}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${dashboard_heating}    ${schedule_list}[0]

    ${dashboard_cooling}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${dashboard_cooling}    ${schedule_list}[1]
    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]

TC-123:User should be able to Resume Schedule when scheduled Mode is not follow
    [Documentation]    User should be able to Resume Schedule when scheduled cool temperature
    ...    in cooling mode is not follow
    [Tags]    testrailid=191938

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeHeatECC}
    Sleep    10s
    verify schedule overridden message    ${msgSchedule}
    Resume Schedule
    Sleep    10s
    Element value should be    ${eccMode}    Heating

TC-62:Re-Schedule the temperature and mode from App
    [Documentation]    Re-Schedule the temperature and mode from App
    [Tags]    testrailid=4620

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${status}    set schedule zoning    ${locationNameZoning}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1
    ${schedule_mode}    Get from list    ${status}    2

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}
    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${stat_fan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen
    Sleep    2s
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_mode}

TC-63:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=4621

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    # sleep    4s
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    # sleep    4s
    Unfollow the schedule for zoning    ${locationNameZoning}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-64:Schedule the temperature and Fan speed from App for Zoned CC: Mobile->Cloud->EndDevice
    [Documentation]    Schedule the temperature and Fan speed from App for Zoned CC: Mobile->Cloud->EndDevice
    [Tags]    testrailid=4622

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    sleep    4s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${status}    Set schedule zoning    ${locationNameZoning}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

    [Teardown]    write objvalue from device    ${autoMode}    ${statmode}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id_Main}

TC-65:Copy the Scheduled Day slot, temperature and fan speed from App for Zoned CC.
    [Documentation]    Copy the Scheduled Day slot, temperature and fan speed from App for Zoned CC.
    [Tags]    testrailid=4623

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    # sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    Copy Schedule Data zoning    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-66:Change the Scheduled temperature and Fan Speed from App for Zoned CC.
    [Documentation]    Change the Scheduled temperature and Fan Speed from App for Zoned CC.
    [Tags]    testrailid=4624

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    sleep    10s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${status}    Set schedule zoning    ${locationNameZoning}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-72: User should be able to Resume Schedule when scheduled temperature is not follow for Sub Zone device
    [Documentation]    User should be able to Resume Schedule when scheduled temperature is not follow for Sub Zone device
    [Tags]    tc-72

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Change Temperature value    ${heatBubble}
    Sleep    5s
    ${schedule_list}    Get Temperatre And Mode from Current Schedule Zoning    ${locationNameZoning}
#    verify schedule overridden message    ${msgSchedule}
    Resume Schedule

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${current_heat_temp}    get element attribute    ${heatBubble}    value
    ${current_heat_temp}    Get Substring    ${current_heat_temp}    0    -1
    Should be equal as integers    ${current_heat_temp}    ${schedule_list}[0]
    ${current_cool_temp}    get element attribute    ${coolBubble}    value
    ${current_cool_temp}    Get Substring    ${current_cool_temp}    0    -1
    Should be equal as integers    ${current_cool_temp}    ${schedule_list}[1]

    ${heat_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as strings    ${heat_temp_ED}    ${schedule_list}[0]
    ${cool_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as strings    ${cool_temp_ED}    ${schedule_list}[1]
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    STAT_FAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as strings    ${fan_Speed}[${current_mode_ED}]    ${schedule_list}[2]

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-67:Re-Schedule the temperature and Fan speed from App for Zoned CC.
    [Documentation]    Re-Schedule the temperature and Fan speed from App for Zoned CC.
    [Tags]    testrailid=4625

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${status}    Set schedule zoning    ${locationNameZoning}
    ${tempHeat}    Get from List    ${status}    0
    ${tempCool}    Get from List    ${status}    1

    ${tempHeat}    Convert to integer    ${tempHeat}
    ${tempCool}    Convert to integer    ${tempCool}

    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Should be equal as integers    ${tempHeat}    ${TempHeat_ED}
    Should be equal as integers    ${tempCool}    ${TempCool_ED}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-68:Unfollow the scheduled temperature and mode from App
    [Documentation]    Unfollow the scheduled temperature and mode from App
    [Tags]    testrailid=4626

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    # sleep    4s
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click Element    ${scheduleButton}
    # sleep    4s
    Unfollow the schedule for zoning    ${locationNameZoning}

    Navigate Back to the Screen
    Navigate Back to the Screen

##############################    Dead Band test cases.    ############################################################

TC-69:Deadband of 0 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 0 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4627

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    4s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    ${deadBandVal}    set variable    0
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    # sleep    4s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}

    # Set Heat Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    # sleep    4s
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}

    # Set Cool Point as 52F
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    52
    Should be equal as strings    ${coolTemp_Mobile}    52
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-71:Deadband of 1 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 1 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4629

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    1
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    90
    Should be equal as strings    ${coolTemp_Mobile}    91
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-75:Deadband of 2 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 2 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4633

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    4s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    50
    Should be equal as strings    ${coolTemp_Mobile}    52
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-79:Deadband of 3 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 3 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4637

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    3
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    53
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    50
    Should be equal as strings    ${coolTemp_Mobile}    53
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-83:Deadband of 4 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 4 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4641

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    54
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    50
    Should be equal as strings    ${coolTemp_Mobile}    54
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-87:Deadband of 5 should be maintained for min setpoint limit from Equipment for Zoned CC.. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 5 should be maintained for min setpoint limit from Equipment for Zoned CC.. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4645

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    4s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    5
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    55
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    50
    Should be equal as strings    ${coolTemp_Mobile}    55
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-91:Deadband of 6 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Documentation]    Deadband of 6 should be maintained for min setpoint limit from Equipment for Zoned CC. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=4649

    ${autoMode}    set variable    2
    ${setMode_ED}    write objvalue from device
    ...    ${autoMode}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    sleep    5s
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${deadBandVal}    set variable    6
    ${setMode_ED}    write objvalue from device
    ...    ${deadBandVal}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${current_mode_ED}    ${setMode_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    sleep    5s
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    ${setHeatTemp_ED}    write objvalue from device
    ...    56
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main
    sleep    5s
    ${getHeatTemp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${setHeatTemp_ED}    ${getHeatTemp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${heatTemp_Mobile}    get text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${coolTemp_Mobile}    get text    ${coolBubble}
    ${coolTemp_Mobile}    Get Substring    ${coolTemp_Mobile}    0    -1
    Should be equal as strings    ${heatTemp_Mobile}    50
    Should be equal as strings    ${coolTemp_Mobile}    56
    Navigate Back to the Screen
    Navigate Back to the Screen
    [Teardown]    Write objvalue From Device    1    ${deadband}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id_Main}

TC-95:Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Main Zone.
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Main Zone.    :EndDevice->Mobile
    [Tags]    testrailid=7214

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-96:Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Main Zone
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=7215

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-97:Max temperature of heating that can be set from App should be 32C for Auto mode in Main Zone.
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode in Main Zone. :Mobile->EndDevice
    [Tags]    testrailid=7216

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    32    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    swipe up the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    32
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-98:Min temperature of heating that can be set from App should be 10C for Auto mode in Main Zone
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=7217

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    10    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    swipe down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    10
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-99:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Main Zone.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=7218

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    32    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Swipe Up the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    32
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Sleep    10s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-100:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Main Zone.
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=7219

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    10    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${setpoint_M_DP}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    10
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${setpoint_M_DP}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${setpoint_M_DP}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-101:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Main Zone
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=7220

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-102:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Main Zone.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Main Zone    :EndDevice->Mobile
    [Tags]    testrailid=7221

    ${changeUnitValue}    Set Variable    1
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Temperature Unit in Celsius
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}

    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-103:Max temperature of cooling that can be set from App should be 33C for Auto mode in Main Zone.
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode in Main Zone.    :Mobile->EndDevice
    [Tags]    testrailid=7222

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Scroll to the Max temperature for Zone Device    33    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${Temperature_Mobile}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    # sleep    10s
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${Temperature_Mobile}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-104:Min temperature of cooling that can be set from App should be 11C for Auto mode in Main Zone
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=7223

    Temperature Unit in Celsius

    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Scroll to the min temperature for Zone Device    11    ${coolBubble}    ${coolingDecrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Down the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    11
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-105:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Main Zone
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=7224

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}

    Scroll to the Max temperature for Zone Device    33    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${setpoint_M_EC}    ${Temperature_Mobile}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${Temperature_Mobile}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-106:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Main Zone
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Main Zone    :Mobile->EndDevice
    [Tags]    testrailid=7225

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    11    ${coolBubble}    ${coolingDecrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Down the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    11
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_M_EC}    get setpoint from equipmet card    ${coolTempDashBoard}
    # ${setpoint_M_DP}=    evaluate    ${Temperature_Mobile}-1
    Should be equal as integers    ${setpoint_M_EC}    ${Temperature_Mobile}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}
    Should be equal as integers    ${result2}    ${setpoint_M_EC}

TC-107:Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Zone CC
    [Documentation]    Max temperature of heating that can be set from Equipment should be 32C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=7226

    ${changeModeValue}    Set Variable    2
    ${mode_set_ED}    Write objvalue From Device
    ...    ${changeModeValue}
    ...    ${statmode}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${setpoint_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    32
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-108:Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Zone CC.
    [Documentation]    Min temperature of heating that can be set from Equipment should be 10C for Auto mode in Zone CC    :EndDevice->Mobile
    [Tags]    testrailid=7227

    ${setpoint_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})

    ${result2}    Convert to integer    ${result1}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    10
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-109:Max temperature of heating that can be set from App should be 32C for Auto mode in Zone CC
    [Documentation]    Max temperature of heating that can be set from App should be 32C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=7228

    Temperature Unit in Celsius

    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    # Set the minimum temperature    50    ${heatBubble}
    Scroll to the Max temperature for Zone Device    32    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Up the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    32
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-110:Min temperature of heating that can be set from App should be 10C for Auto mode in Zone CC
    [Documentation]    Min temperature of heating that can be set from App should be 10C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=7229

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    # Set the minimum temperature    50    ${heatBubble}
    Scroll to the min temperature for Zone Device    10    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    10
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-111:User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed heating temp max setpoint limit i.e. 32C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=7230

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    32    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Up the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    32
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-112:User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Zone CC
    [Documentation]    User should not be able to exceed heating temp mini setpoint limit i.e. 10C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=7231

    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    10    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    ${temp_app}    Swipe Down the bubble    ${heatBubble}
    Wait until page contains element    ${heatBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${heatBubble}
    Should be equal    ${Temperature_Mobile}    10
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-113:Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Zone CC.
    [Documentation]    Max temperature of cooling that can be set from Equipment should be 33C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=7232

    ${setpoint_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-114:Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Zone CC.
    [Documentation]    Min temperature of cooling that can be set from Equipment should be 11C for Auto mode in Zone CC.    :EndDevice->Mobile
    [Tags]    testrailid=7233

    ${setpoint_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Temperature Unit in Celsius
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    11
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-115:Max temperature of cooling that can be set from App should be 33C for Auto mode in Zone CC
    [Documentation]    Max temperature of cooling that can be set from App should be 33C for Auto mode in Zone CC    :Mobile->EndDevice
    [Tags]    testrailid=7234

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    33    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-116:Min temperature of cooling that can be set from App should be 11C for Auto mode in Zone CC.
    [Documentation]    Min temperature of cooling that can be set from App should be 11C for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=7235

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the min temperature for Zone Device    11    ${coolBubble}    ${coolingDecrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Down the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    11
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-117:User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed cooling temp max setpoint limit i.e. 33C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=7239

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    33    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${setpoint_ED}    evaluate    ${setpoint_ED}+1
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    Should be equal as integers    ${result2}    ${Temperature_Mobile}

TC-118:User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Zone CC.
    [Documentation]    User should not be able to exceed cooling temp mini setpoint limit i.e. 11C from App for Auto mode in Zone CC.    :Mobile->EndDevice
    [Tags]    testrailid=7240

    Temperature Unit in Celsius
    ${DeadbandValue}    Set Variable    1
    ${Deadband_set_ED}    Write objvalue From Device
    ...    ${DeadbandValue}
    ...    ${deadband}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Scroll to the Max temperature for Zone Device    33    ${coolBubble}    ${coolingIncrease}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    ${temp_app}    Swipe Up the bubble    ${coolBubble}
    Wait until page contains element    ${coolBubble}    ${defaultWaitTime}
    ${Temperature_Mobile}    get text    ${coolBubble}
    Should be equal    ${Temperature_Mobile}    33
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${result1}    Evaluate    (${setpoint_ED} - ${value1})* (${value2}/${value3})
    ${result2}    Convert to integer    ${result1}
    ${result2}    Evaluate    ${result2}+1
    Should be equal as integers    ${result2}    ${Temperature_Mobile}
    Temperature Unit in Fahrenheit

TC-125:Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Documentation]    Updating Heating setpoint for Zoned CC from App should be reflected on dashboard and Equipment. : Mobile->Cloud->EndDevice
    [Tags]    testrailid=33588

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${changedTemp_Mobile}    Update Setpoint Value Using Button HVAC
    ...    ${setpointIncreaseButton}
    ...    ${heatTempButton}
    ...    ${coolTempButton}
    ${changedTemp_Mobile}    Get from list    ${changedTemp_Mobile}    0
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}

TC-126: Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard.
    [Documentation]    Updating Heating setpoint for Zoned CC from Equipment should be reflected on App dashboard.
    [Tags]    testrailid=33589

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Sleep    5s
    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    # Sleep    4s
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    # Validating the temperature value on Rheem Mobile Application
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED_R}    ${Temperature_Mobile}

TC-127:Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Documentation]    Updating Cooling setpoint for Zoned CC from App should be reflected on App dashboard and Equipment. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=33590
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    Wait until page contains element    ${coolTempHeater}    ${defaultWaitTime}
    ${coolTempHeater}    Update Cooling Setpoint Value Using Button
    ...    ${coolTempHeater}
    ...    ${coolSetPointIncreaseButton}
    ${changedTemp_Mobile}    Convert to integer    ${coolTempHeater}
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${current_temp_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${changedTemp_Mobile}    ${current_temp_ED}

TC-128:Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Documentation]    Updating Cooling setpoint for Zoned CC from Equipment should be reflected on App dashboard. Equipment->Cloud->App
    [Tags]    testrailid=33591

    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED_W}    Evaluate    ${Temperature_ED_R} + 1
    ${Temperature_ED}    Write objvalue From Device
    ...    ${Temperature_ED_W}
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED_R}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    # Validating the temperature value on Rheem Mobile Application
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolTempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-129:Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from Equipment should be 50F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=33592

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-130:Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from Equipment should be 92F.
    [Tags]    testrailid=33593
    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolTempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-131:Min Heating setpoint that can be set for Zoned CC from App should be 50F.
    [Documentation]    Min Heating setpoint that can be set for Zoned CC from App should be 50F.
    [Tags]    testrailid=33594
    ${Temperature_ED}    Write objvalue From Device
    ...    51
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    51
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${changedTemp_Mobile}    Update Setpoint Value Using Button HVAC
    ...    ${setpointDecreaseButton}
    ...    ${heatTempButton}
    ...    ${coolTempButton}
    ${changedTemp_Mobile}    Get from list    ${changedTemp_Mobile}    0
    Should be equal    ${changedTemp_Mobile}    50
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${changedTemp_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-132:Max Cooling setpoint that can be set for Zoned CC from App should be 92F. : EndDevice->Cloud->Mobile
    [Documentation]    Max Cooling setpoint that can be set for Zoned CC from App should be 92F. : EndDevice->Cloud->Mobile
    [Tags]    testrailid=33595

    ${Temperature_ED}    Write objvalue From Device
    ...    91
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    91
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}
    ${tempMobile}    Update Cooling Setpoint Value Using Button    ${coolTempHeater}    ${coolSetPointIncreaseButton}
    Should be equal    ${tempMobile}    92
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${tempMobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-133:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from App
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from App
    [Tags]    testrailid=33596

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    50
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${changedTemp_Mobile}    Update Setpoint Value Using Button HVAC
    ...    ${setpointDecreaseButton}
    ...    ${heatTempButton}
    ...    ${coolTempButton}
    ${changedTemp_Mobile}    Get from list    ${changedTemp_Mobile}    0
    Should be equal    ${changedTemp_Mobile}    50
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${changedTemp_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-134:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from App
    [Tags]    testrailid=33597

    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    90
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${changedTemp_Mobile}    Update Setpoint Value Using Button HVAC
    ...    ${setpointIncreaseButton}
    ...    ${heatTempButton}
    ...    ${coolTempButton}
    ${changedTemp_Mobile}    Get from list    ${changedTemp_Mobile}    0
    Should be equal    ${changedTemp_Mobile}    90
    Navigate Back to the Screen

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${changedTemp_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-135:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from App
    [Tags]    testrailid=33598

    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    92
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}
    ${tempMobile}    Update Cooling Setpoint Value Using Button    ${coolTempHeater}    ${coolSetPointIncreaseButton}
    Should be equal    ${tempMobile}    92
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${tempMobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-136:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from App
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 92F for Zoned CC from App
    [Tags]    testrailid=33599

    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    52
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}
    ${tempMobile}    Update Cooling Setpoint Value Using Button    ${coolTempHeater}    ${coolSetPointDecreaseButton}
    Should be equal    ${tempMobile}    52
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${tempMobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}
    Navigate Back to the Screen

TC-137:User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Max Cooling setpoint limit i.e. 92F for Zoned CC from Equipment
    [Tags]    testrailid=33600

    ${Temperature_ED}    Write objvalue From Device
    ...    92
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    92
    ${Temperature_ED}    Write objvalue From Device
    ...    93
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    92
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-138:User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Cooling setpoint limit i.e. 52F for Zoned CC from Equipment
    [Tags]    testrailid=33601

    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    52
    ${Temperature_ED}    Write objvalue From Device
    ...    51
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    52
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-139:User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Min Heating setpoint limit i.e. 50F for Zoned CC from Equipment
    [Tags]    testrailid=33602

    ${Temperature_ED}    Write objvalue From Device
    ...    50
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    50
    ${Temperature_ED}    Write objvalue From Device
    ...    49
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    50
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-140:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Zoned CC from Equipment
    [Tags]    testrailid=33603

    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    90

    ${Temperature_ED}    Write objvalue From Device
    ...    91
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    90
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}

    Navigate Back to the Screen
    Navigate Back to the Screen

TC-141:Max Heating setpoint for Zoned CC that can be set from App should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from App should be 90F.
    [Tags]    testrailid=33604

    # Set Maximum setpoint temperature from mobile and validating it on mobile itself

    ${Temperature_ED}    Write objvalue From Device
    ...    89
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    89
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    ${changedTemp_Mobile}    Update Setpoint Value Using Button HVAC
    ...    ${setpointIncreaseButton}
    ...    ${heatTempButton}
    ...    ${coolTempButton}
    ${changedTemp_Mobile}    Get from list    ${changedTemp_Mobile}    0
    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${changedTemp_Mobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}

    Navigate Back to the Screen

TC-142:Min Cooling setpoint that can be set for Zoned CC from App should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from App should be 52F.
    [Tags]    testrailid=33605

    ${Temperature_ED}    Write objvalue From Device
    ...    51
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Should be equal as integers    ${Temperature_ED}    51
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}

    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    ${Temperature_Mobile}    Convert to integer    ${Temperature_Mobile}
    Should be equal    ${Temperature_ED}    ${Temperature_Mobile}

    ${tempMobile}    Update Cooling Setpoint Value Using Button    ${coolTempHeater}    ${coolSetPointDecreaseButton}
    Should be equal    ${tempMobile}    52

    Navigate Back to the Screen
    ${Temperature_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    ${tempMobile}    Convert to integer    ${tempMobile}
    Should be equal as integers    ${Temperature_ED}    ${tempMobile}

    Navigate Back to the Screen

TC-143:Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Tags]    testrailid=33606
    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}

    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}

    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-144:Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Documentation]    Max Heating setpoint for Zoned CC that can be set from Equipment should be 90F.
    [Tags]    testrailid=33607

    # Set temperature from water heater
    ${Temperature_ED}    Write objvalue From Device
    ...    90
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-145:User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.
    [Documentation]    User should not be able to exceed Max Heating setpoint limit i.e. 90F for Main ECC from Equipment.
    [Tags]    testrailid=33608

    ${set_Temp_ED}    write objvalue from device
    ...    91
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${get_Temp_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    should not be equal as integers    91    ${get_Temp_ED}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${tempHeater}
    should not be equal as integers    91    ${Temperature_Mobile}
    Navigate Back to the Screen
    Navigate Back to the Screen

TC-146:Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F.
    [Documentation]    Min Cooling setpoint that can be set for Zoned CC from Equipment should be 52F.
    [Tags]    testrailid=33609

    ${Temperature_ED}    Write objvalue From Device
    ...    52
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Zone}
    Navigate to Zoning Overview screen
    Select the zone    ${zoneControl}    ${locationNameZoning}
    Wait until page contains element    ${coolTempHeater}    ${defaultWaitTime}
    ${Temperature_Mobile}    Get Setpoint using button on Detail screen    ${coolTempHeater}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Should be equal as integers    ${Temperature_ED}    ${Temperature_Mobile}

TC-147:User should be able to set Away mode from App
    [Documentation]    User should be able to set Away mode from App using button slider
    [Tags]    testrailid=33610

    ${Away_status_M}    Set Away Mode New ECC Using Button    ${locationNameZoning}
    ${tempCoolMobile_ED}    Get from list    ${Away_status_M}    0
    ${tempCoolMobile_ED}    Convert to integer    ${tempCoolMobile_ED}
    ${tempHeatMobile_ED}    Get from list    ${Away_status_M}    1
    ${tempHeatMobile_ED}    Convert to integer    ${tempHeatMobile_ED}
    ${tempModeMobile_ED}    Get from list    ${Away_status_M}    2

    ${Away_status_ED}    Read int return type objvalue From Device
    ...    AWAYMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}

    Should be equal as integers    ${Away_status_ED}    1
    ${TempHeat_ED}    Read int return type objvalue From Device
    ...    ${heatsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${TempCool_ED}    Read int return type objvalue From Device
    ...    ${coolsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal    ${tempHeatMobile_ED}    ${TempHeat_ED}
    Should be equal    ${tempCoolMobile_ED}    ${TempCool_ED}
    ${current_mode_ED}    Read int return type objvalue From Device
    ...    STAT_FAN
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${heatTempDashBoard}
    Should be equal as integers    ${tempHeatMobile_ED}    ${dashBoardTemperature}
    ${dashBoardTemperature}    get setpoint from equipmet card    ${coolTempDashBoard}
    Should be equal as integers    ${tempCoolMobile_ED}    ${dashBoardTemperature}
    ${modeValueDashboard}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal    ${tempModeMobile_ED}    ${modeValueDashboard}

TC-148:User should be able to Disable Away from App
    [Documentation]    User should be able to disable away mode from app
    [Tags]    testrailid=33611

    ${count}    get matching xpath count    ${homeModeText}
    IF    ${count}>0    Click Element    ${awayMode}
    ${Away_status_M}    Disable Away Mode New ECC
    ${Away_status_ED}    Read int return type objvalue From Device
    ...    AWAYMODE
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as integers    ${Away_status_ED}    0

TC-124:User should be able to update fan Speed from App using slider button
    [Documentation]    User should be able to update fan Speed from App using slider button
    [Tags]    testrailid=33587

    ${medHiMode}    set variable    4
    ${setMode_ED}    write objvalue from device
    ...    ${medHiMode}
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Navigate to Zoning Overview screen
    Select the zone    ${masterControl}    ${locationNameZoning}
    ${mode_mobile}    Change the mode New ECC    ${modeFanECC}
    ${new_fan_speed}    Update Fanspeed Using Buton    ${fanSppedPlus}
    # Should be equal as strings    ${new_fan_speed}    ${fanHighMode}
    Navigate Back to the Screen
    Navigate Back to the Screen
    ${fan_mode}    get dashboard value from equipment card    ${speedFanDashBoard}
    Should be equal as strings    ${fan_mode}    ${fanHighMode}
    ${current_fanSpeed_ED}    Read int return type objvalue From Device
    ...    ${statnfan}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id_Main}
    Should be equal as strings    ${fan_Speed}[${current_fanSpeed_ED}]    ${new_fan_speed}
