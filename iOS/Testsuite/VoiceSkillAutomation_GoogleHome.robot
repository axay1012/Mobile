*** Settings ***
Documentation       Alexa Test cases

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../src/RheemMqtt.py
Library             /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/src/voiceskill_helper.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot
Resource            ../Keywords/iOSVoiceSkillKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Select the Device Location    ${locationNameHVAC}
Suite Teardown      Run Keywords    Close Application
# Test Setup    Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Wait Until Keyword Succeeds    2x    4m
# ...    Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${locationNameWH}       Home 3
${locationNameHVAC}     NewECC
${speaker}              Hey Google

${emailId}              rheemautomation+j21@gmail.com
${passwordValue}        12345678

${english}              english

${sync_que}             ${speaker},Sync My Devices
${sync_ans}             Starting discovery, this will take a moment,

${deviceName}           My Room
${HVACName}             My Room
${WHName}               Your Laptop


*** Test Cases ***
TC-01:User should be able to Sync all the devices using Alexa
    [Tags]    testrailid=305390
    ${status}    ${resp}    Google Communication with Question
    ...    ${speaker}
    ...    ${sync_que}
    ...    ${sync_ans}
    ...    ${english}
#    Should Contain Any    ${resp}    syncing

TC-02:To Know the Current temperature value of HVAC
    [Tags]    testrailid=305406
#    Select the Device Location    ${locationNameHVAC}
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is current temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    Should Contain Any    ${resp}    temperature
#    Should Contain Any    ${resp}    ${dashBoardTemperature}°

TC-03:Set Auto Mode
    [Tags]    testrailid=305424
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Auto
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Auto
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
        Should be Equal    ${dashBoardTemperature}    Auto
    END

TC-40:To Know the Auto mode temperature value of HVAC
    [Tags]    testrailid=305417
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    temperature
    Should Contain Any    ${resp}    ${dashBoardTemperature}°


TC-04:Increase temperature on Auto mode
    [Tags]    testrailid=305418
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} < ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}' == 'False' or '${Status1}' == 'False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should Be True    ${heatdashBoardTemperature} < ${AfterheatdashBoardTemperature}
        Should Be True    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-05:Decrease temperature on Auto mode
    [Tags]    testrailid=305419
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}

    IF    '${Status}' == 'False' or '${Status1}' == 'False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be true    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
        Should be true    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    END

TC-06:Set Temperature on Auto mode
    [Tags]    testrailid=305420
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature by to degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should not be equal
    ...    ${heatdashBoardTemperature}
    ...    ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should not be equal
    ...    ${cooldashBoardTemperature}
    ...    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False' or '${Status1}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should not be equal    ${heatdashBoardTemperature}    ${AfterheatdashBoardTemperature}
        Should not be equal    ${cooldashBoardTemperature}    ${AftercooldashBoardTemperature}
    END

TC-07:Set Temperature on Auto mode [Invalid temperature Range Value]
    [Tags]    testrailid=305421
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 50 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}

    Should Contain Any    ${resp}    Only
    Should Contain Any    ${resp}    between

TC-08:Set Cool Mode
    [Tags]    testrailid=305423
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Cool
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Cooling
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
        Should be Equal    ${dashBoardTemperature}    Cooling
    END

TC-09:What is HVAC set to [For Cool]
    [Tags]    testrailid=305412
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    AC
    Should Contain Any    ${resp}    Set
    Should Contain Any    ${resp}    ${dashBoardTemperature}°

TC-10:Increase temperature on Cool mode
    [Tags]    testrailid=305413
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be true    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-11:Decrease temperature on Cool mode
    [Tags]    testrailid=305414
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be true    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    END

TC-12:Set Temperature on Cool mode
    [Tags]    testrailid=305415
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 65 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-13:Set Temperature on Cool mode [Invalid temperature Range Value]
    [Tags]    testrailid=305416
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 100 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

    Should Contain Any    ${resp}    Only
    Should Contain Any    ${resp}    between

TC-14:Set Heat Mode
    [Tags]    testrailid=305422
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Heat
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Heat
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Heating
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
        Should be Equal    ${dashBoardTemperature}    Heating
    END
#
TC-15:What is HVAC set to [For Heat]
    [Tags]    testrailid=305407
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    AC
    Should Contain Any    ${resp}    Set
    Should Contain Any    ${resp}    ${dashBoardTemperature}°

TC-16:Increase temperature on Heat mode
    [Tags]    testrailid=305408
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be true    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-17:Decrease temperature on Heat mode
    [Tags]    testrailid=305409
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be true    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    END

TC-18:Set Temperature on Heat mode
    [Tags]    testrailid=305410
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 65 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-19:Set Temperature on Heat mode [Invalid temperature Range Value]
    [Tags]    testrailid=305411
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 100 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

    Should Contain Any    ${resp}    Only
    Should Contain Any    ${resp}    between

TC-20:Turn Off HVAC
    [Tags]    testrailid=305398
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}.
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Turn On HVAC
    [Tags]    testrailid=305403
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Cut Off HVAC
    [Tags]    testrailid=305399
    ${temp_que}    Set Variable    ${speaker} ... Cut Off ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Make HVAC On
    [Tags]    testrailid=305405
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} On
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Make HVAC Off
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} Off
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-23:Try to increase HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305426
    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

    Should Contain Any    ${resp}    request
    Should Contain Any    ${resp}    accept

TC-24:Try to decrease HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305427
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

    Should Contain Any    ${resp}    request
    Should Contain Any    ${resp}    accept

TC-25:Try to know current temperature of HVAC if HVAC was disable
    [Tags]    testrailid=305428
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is the temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Should Contain Any    ${resp}    request
    Should Contain Any    ${resp}    accept

    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-26:To Know the temperature value of WH
    [Tags]    testrailid=305391
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa

    Should Contain Any    ${resp}    temperature
    Should Contain Any    ${resp}    ${dashBoardTemperature}°

TC-27:Set WH setpoint
    [Tags]    testrailid=305392
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 115 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status
    ...    Should be equal as integers
    ...    115
    ...    ${dashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers    115    ${dashBoardTemperature}
    END

TC-28:Set WH setpoint [Invalid Value]
    [Tags]    testrailid=305393
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 145 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
     Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status
    ...    Should be equal as integers
    ...    115
    ...    ${dashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers    115    ${dashBoardTemperature}
    END

TC-29:Increase temperature value WH
    [Tags]    testrailid=305394
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${dashBoardTemperature}    < ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be true    ${dashBoardTemperature} < ${AfterdashBoardTemperature}
    Should be Equal    120    ${AfterdashBoardTemperature}
    END

TC-30:Decrease temperature value WH
    [Tags]    testrailid=305395
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${dashBoardTemperature} < ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be true    ${dashBoardTemperature} > ${AfterdashBoardTemperature}
    END

TC-31:Turn off WH
    [Tags]    testrailid=305396
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-32:Turn On WH
    [Tags]    testrailid=305401
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-33:Make WH off
    [Tags]    testrailid=305397
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} Off
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-34:Make WH on
    [Tags]    testrailid=305402
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} On
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-35:Disable WH
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Disable ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-36:Try to increase temperature if was disable WH
    [Tags]    testrailid=305430
    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}

    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-37:Try to decrease temperature if was disable WH
    [Tags]    testrailid=305431
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}

    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-38:Try to know current temperature of if was disable WH
    [Tags]    testrailid=305432
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa

    Should Contain Any    ${resp}    accept
    Should Contain Any    ${resp}    mode

TC-39:Enable WH
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Enable ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-43:Increase Temperature where temperature set at 140 degree "fahrenheit"
    [Tags]    testrailid=305433
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}
    Navigate Back to the Screen

    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-44:Decrease Temperature by 5 degree where temperature was set at 110 degree "fahrenheit"
    [Tags]    testrailid=305434
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    Scroll to the min temperature    110    ${imgBubble}
    Navigate Back to the Screen

    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-45:Increase Temperature where temperature set at 60 degree "celsius"
    [Tags]    testrailid=305435
    Temperature Unit in Celsius
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Auto
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END


