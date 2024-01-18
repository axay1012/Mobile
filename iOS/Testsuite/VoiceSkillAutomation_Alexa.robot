*** Settings ***
Documentation       Alexa Test cases

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../src/RheemMqtt.py
Library             ../src/voiceskill_helper.py
Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot
Resource            ../Keywords/iOSVoiceSkillKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Select the Device Location    NewECC
Suite Teardown      Run Keywords    Close Application
Test Teardown       Run Keyword If Test Failed    Capture Page Screenshot


*** Variables ***
${locationNameWH}       HPWH
${locationNameHVAC}     NewECC
${speaker}              Alexa

${emailId}              productiontestlab@gmail.com
${passwordValue}        rheem123

${english}              english

${sync_que}             ${speaker},Discover My Devices
${sync_ans}             Starting discovery, this will take a moment,

${deviceName}           My Room
${HVACName}             Smart Thermostat
${WHName}               My Team Room


*** Test Cases ***
TC-01:User should be able to Sync all the devices using Alexa
    [Tags]    testrailid=305337
    ${status}    ${resp}    Alexa Communiation with Question
    ...    ${speaker}
    ...    ${sync_que}
    ...    ${sync_ans}
    ...    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any   ${resp}    Starting  discovery   This  will    take few  moments Power    on  your  new  devices  now

TC-02:To Know the Current Set Point value of HVAC
    [Tags]    testrailid=305354

    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is current Set Point of ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    temperature    ${dashBoardTemperature}  ${HVACName}

TC-03:Set Auto Mode
    [Tags]    testrailid=305372
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Auto
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Set    Auto    to
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Auto
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
        Should be Equal    ${dashBoardTemperature}    Auto
    END

TC-40:To Know the Auto mode Set Point value of HVAC
    [Tags]    testrailid=305365
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    temperature    ${dashBoardTemperature}  ${HVACName}

TC-04:Increase Set Point on Auto mode
    [Tags]    testrailid=305366
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    auto    between    temperature    and
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

TC-05:Decrease Set Point on Auto mode
    [Tags]    testrailid=305367
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    auto    between    temperature    and keeping
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
    [Tags]    testrailid=305368
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 60 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    auto    between    temperature    and keeping
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

TC-07:Set Temperature on Auto mode [Invalid Set Point Range Value]
    [Tags]    testrailid=305369
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 50 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}      between    temperature    only    set    and
    Select the Device Location    ${locationNameHVAC}
    Should Contain Any    ${resp}    Only
    Should Contain Any    ${resp}    between

TC-08:Set Cool Mode
    [Tags]    testrailid=305371
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Cool
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Set    Cool    to    It
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Cooling
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${dashBoardTemperature}    Get dashboard value from equipment card    ${modeEccDashBard}
        Should be Equal    ${dashBoardTemperature}    Cooling
    END

TC-09:What is HVAC set to [For Cool]
    [Tags]    testrailid=305360
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    AC    ${dashBoardTemperature}    set    to

TC-10:Increase Set Point on Cool mode
    [Tags]    testrailid=305361
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    The AC is set to
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

TC-11:Decrease Set Point on Cool mode
    [Tags]    testrailid=305362
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    The AC is set to   ${cooldashBoardTemperature-7}
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
    [Tags]    testrailid=305363
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 65 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     The    AC    is    set    to    65
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-13:Set Temperature on Cool mode [Invalid Set Point Range Value]
    [Tags]    testrailid=305364
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 100 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    I  can  only    set  the  temperature  between    52    and  92
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${coolTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END


TC-14:Set Heat Mode
    [Tags]    testrailid=305370
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Heat
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
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

TC-15:What is HVAC set to [For Heat]
    [Tags]    testrailid=305355
    Select the Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Heat    set    ${dashBoardTemperature}    to

TC-16:Increase Set Point on Heat mode
    [Tags]    testrailid=305356
    ${cooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Heat    set    to
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

TC-17:Decrease Set Point on Heat mode
    [Tags]    testrailid=305357
    ${heatdashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Heat    set    to
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
    [Tags]    testrailid=305358
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 65 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    Heat    set    to    65
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-19:Set Temperature on Heat mode [Invalid Set Point Range Value]
    [Tags]    testrailid=305359
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} Set Point by 100 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    I    can    only    set  the    temperature    between    50    and  90
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get setpoint from equipmet card    ${heatTempDashBoard}
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-20:Turn Off HVAC
    [Tags]    testrailid=305345
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}.
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Turn On HVAC
    [Tags]    testrailid=305350
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Cut Off HVAC
    [Tags]    testrailid=305346
    ${temp_que}    Set Variable    ${speaker} ... Cut Off ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Make HVAC On
    [Tags]    testrailid=305351
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} On
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Make HVAC Off
    [Tags]    testrailid=305347
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} Off
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-23:Try to increase HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305377
    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    ${HVACName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-24:Try to decrease HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305378
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} Set Point by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    ${HVACName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
    Select the Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-25:Try to know current temperature of HVAC if HVAC was disable
    [Tags]    testrailid=305379
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is the Set Point of ${HVACName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Should Contain Any    ${resp}    ${HVACName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device

    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-26:To Know the Set Point value of WH
    [Tags]    testrailid=305338
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    ${dashBoardTemperature}     ${locationNameWH}  temperature    fahrenheit

TC-27:Set WH setpoint
    [Tags]    testrailid=305339
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 115 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    My laptop    set  to    115    fahrenheit
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
    [Tags]    testrailid=305340
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 145 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}        value   out    of   range  for  device
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

TC-29:Increase Set Point value WH
    [Tags]    testrailid=305341
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    My laptop  increased    by    five  fahrenheit
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

TC-30:Decrease Set Point value WH
    [Tags]    testrailid=305342
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    My laptop  decreased    by    five  fahrenheit
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${dashBoardTemperature} < ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be true    ${dashBoardTemperature} > ${AfterdashBoardTemperature}
        Should be Equal    115    ${AfterdashBoardTemperature}
    END

TC-31:Turn off WH
    [Tags]    testrailid=305343
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-32:Turn On WH
    [Tags]    testrailid=305348
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-33:Make WH off
    [Tags]    testrailid=305344
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} Off
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-34:Make WH on
    [Tags]    testrailid=305349
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} On
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-35:Disable WH
    [Tags]    testrailid=305337
    ${temp_que}    Set Variable    ${speaker} ... Disable ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}    OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-36:Try to increase temperature if was disable WH
    [Tags]    testrailid=305380
    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     ${WHName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
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
    [Tags]    testrailid=305381
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     ${WHName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
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
    [Tags]    testrailid=305382
    Select the Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa

    Should Contain Any    ${resp}     ${WHName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device

TC-39:Enable WH
    [Tags]    testrailid=305352
    ${temp_que}    Set Variable    ${speaker} ... Enable ${WHName}
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     OK
    Select the Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-43:Increase Temperature where temperature set at 140 degree "fahrenheit"
    [Tags]    testrailid=305384
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    scroll to the max temperature    140    ${imgBubble}
    Navigate Back to the Screen

    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     ${WHName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-44:Decrease Temperature by 5 degree where temperature was set at 110 degree "fahrenheit"
    [Tags]    testrailid=305385
    Go to Temp Detail Screen    ${tempDashBoard}
    Sleep    2s
    Scroll to the min temperature    110    ${imgBubble}
    Navigate Back to the Screen
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 45 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Should Contain Any    ${resp}     ${WHName}    mode     doesn't    accept    requests  Please    change  its    mode   app    device
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-45:Increase Temperature where temperature set at 60 degree "celsius"
    [Tags]    testrailid=305386
    Temperature Unit in Celsius
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Alexa Communiation with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
    Select the Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application and Navigate to Device Detail Page    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END


