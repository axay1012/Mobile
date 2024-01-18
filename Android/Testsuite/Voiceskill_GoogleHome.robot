*** Settings ***
Documentation       This is the test file for End to end testing of HPWH
Library              /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/src/voiceskill_helper.py
Library             Collections
Library             String
Library             OperatingSystem
Library             AppiumLibrary
Library             ../../src/RheemMqtt.py
Library             ../../src/common/Android_Handler.py
Library             ../../src/RheemMqtt.py
Resource            ../Locators/AndroidLabels.robot
Resource            ../Locators/AndroidLocators.robot
Resource            ../Locators/Androidconfig.robot
Resource            ../Keywords/AndroidMobilekeywords.robot
Resource            ../Keywords/MQttkeywords.robot

Suite Setup         Run Keywords    Androidconfig.Open App
...                     AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                     AND    Select Device Location    ${locationNameHVAC}
#...                     AND    Temperature Unit in Fahrenheit
#...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Run Keywords    Close All Apps
Test Setup          Run Keyword If    '${PREV TEST STATUS}' == 'FAIL'    Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}



*** Variables ***
${deviceText}                           //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']

${locationNameWH}       TesT
${locationNameHVAC}     NewECC
${speaker}              Hey Google

${emailId}              rheemautomation+j21@gmail.com
${passwordValue}        rheem123

${english}              english

${sync_que}             ${speaker},Discover My Devices
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
#    List should contain value    ${resp}    syncing

TC-02:To Know the Current temperature value of HVAC
    [Tags]    testrailid=305406
#    Select Device Location    ${locationNameHVAC}
#    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is current temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    temperature
#    List should contain value    ${resp}    ${dashBoardTemperature}°

TC-03:Set Auto Mode
    [Tags]    testrailid=305424
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Auto
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get mode name from equipment card HVAC 
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Auto
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${dashBoardTemperature}    Get mode name from equipment card HVAC 
        Should be Equal    ${dashBoardTemperature}    Auto
    END

TC-40:To Know the Auto mode temperature value of HVAC
    [Tags]    testrailid=305417
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    temperature
#    List should contain value    ${resp}    ${dashBoardTemperature}°


TC-04:Increase temperature on Auto mode
    [Tags]    testrailid=305418
    ${heatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${cooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} < ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}' == 'False' or '${Status1}' == 'False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should Be True    ${heatdashBoardTemperature} < ${AfterheatdashBoardTemperature}
        Should Be True    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-05:Decrease temperature on Auto mode
    [Tags]    testrailid=305419
    ${heatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${cooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}

    IF    '${Status}' == 'False' or '${Status1}' == 'False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should be true    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
        Should be true    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    END

TC-06:Set Temperature on Auto mode
    [Tags]    testrailid=305420
    ${heatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${cooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature by to degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should not be equal
    ...    ${heatdashBoardTemperature}
    ...    ${AfterheatdashBoardTemperature}
    ${Status1}    Run Keyword And Return Status
    ...    Should not be equal
    ...    ${cooldashBoardTemperature}
    ...    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False' or '${Status1}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should not be equal    ${heatdashBoardTemperature}    ${AfterheatdashBoardTemperature}
        Should not be equal    ${cooldashBoardTemperature}    ${AftercooldashBoardTemperature}
    END

TC-07:Set Temperature on Auto mode [Invalid temperature Range Value]
    [Tags]    testrailid=305421
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 50 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}

#    List should contain value    ${resp}    Only
#    List should contain value    ${resp}    between

TC-08:Set Cool Mode
    [Tags]    testrailid=305423
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Cool
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get mode name from equipment card HVAC 
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Cooling
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${dashBoardTemperature}    Get mode name from equipment card HVAC 
        Should be Equal    ${dashBoardTemperature}    Cooling
    END

TC-09:What is HVAC set to [For Cool]
    [Tags]    testrailid=305412
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    AC
#    List should contain value    ${resp}    Set
#    List should contain value    ${resp}    ${dashBoardTemperature}°

TC-10:Increase temperature on Cool mode
    [Tags]    testrailid=305413
    ${cooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should be true    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-11:Decrease temperature on Cool mode
    [Tags]    testrailid=305414
    ${cooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should be true    ${cooldashBoardTemperature} > ${AftercooldashBoardTemperature}
    END

TC-12:Set Temperature on Cool mode
    [Tags]    testrailid=305415
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 65 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-13:Set Temperature on Cool mode [Invalid temperature Range Value]
    [Tags]    testrailid=305416
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 100 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Cool Setpoint from equipmet card HVAC
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

#    List should contain value    ${resp}    Only
#    List should contain value    ${resp}    between

TC-14:Set Heat Mode
    [Tags]    testrailid=305422
    ${temp_que}    Set Variable    ${speaker} ... Change ${HVACName} to Heat
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Heat
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get mode name from equipment card HVAC 
    ${Status}    Run Keyword And Return Status    Should be Equal    ${dashBoardTemperature}    Heating
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${dashBoardTemperature}    Get mode name from equipment card HVAC 
        Should be Equal    ${dashBoardTemperature}    Heating
    END
#
TC-15:What is HVAC set to [For Heat]
    [Tags]    testrailid=305407
    Select Device Location    ${locationNameHVAC}
    ${dashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${temp_que}    Set Variable    ${speaker} ... What is ${HVACName} set to

    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    AC
#    List should contain value    ${resp}    Set
#    List should contain value    ${resp}    ${dashBoardTemperature}°

TC-16:Increase temperature on Heat mode
    [Tags]    testrailid=305408
    ${cooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        Should be true    ${cooldashBoardTemperature} < ${AftercooldashBoardTemperature}
    END

TC-17:Decrease temperature on Heat mode
    [Tags]    testrailid=305409
    ${heatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AfterheatdashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        Should be true    ${heatdashBoardTemperature} > ${AfterheatdashBoardTemperature}
    END

TC-18:Set Temperature on Heat mode
    [Tags]    testrailid=305410
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 65 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END

TC-19:Set Temperature on Heat mode [Invalid temperature Range Value]
    [Tags]    testrailid=305411
    ${temp_que}    Set Variable    ${speaker} ... Set ${HVACName} temperature to 100 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
    ${Status}    Run Keyword And Return Status    Should be equal as integers    65    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get Heat Setpoint from equipmet card HVAC
        Should be equal as integers    65    ${AftercooldashBoardTemperature}
    END
#
#    List should contain value    ${resp}    Only
#    List should contain value    ${resp}    between

TC-20:Turn Off HVAC
    [Tags]    testrailid=305398
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}.
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Turn On HVAC
    [Tags]    testrailid=305403
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Cut Off HVAC
    [Tags]    testrailid=305399
    ${temp_que}    Set Variable    ${speaker} ... Cut Off ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-21:Make HVAC On
    [Tags]    testrailid=305405
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} On
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should not be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should not be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-22:Make HVAC Off
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Make ${HVACName} Off
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-23:Try to increase HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305426
    ${temp_que}    Set Variable    ${speaker} ... Increase ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

    #    List should contain value    ${resp}    request
#    List should contain value    ${resp}    accept

TC-24:Try to decrease HVAC temperature if HVAC was disable (off)
    [Tags]    testrailid=305427
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${HVACName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameHVAC}
    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

    #    List should contain value    ${resp}    request
#    List should contain value    ${resp}    accept

TC-25:Try to know current temperature of HVAC if HVAC was disable
    [Tags]    testrailid=305428
    ${dashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${temp_que}    Set Variable    ${speaker} ... What is the temperature of ${HVACName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${HVACName}    ${english}
#    List should contain value    ${resp}    request
#    List should contain value    ${resp}    accept

    ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
    ${Status}    Run Keyword And Return Status    Should be equal    OFF    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameHVAC}
        ${AftercooldashBoardTemperature}    Get dashboard value from equipment card    ${equipmentCard}
        Should be equal    OFF    ${AftercooldashBoardTemperature}
    END

TC-26:To Know the temperature value of WH
    [Tags]    testrailid=305391
    Select Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa

#    List should contain value    ${resp}    temperature
#    List should contain value    ${resp}    ${dashBoardTemperature}°

TC-27:Set WH setpoint
    [Tags]    testrailid=305392
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 115 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status
    ...    Should be equal as integers
    ...    115
    ...    ${dashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers    115    ${dashBoardTemperature}
    END

TC-28:Set WH setpoint [Invalid Value]
    [Tags]    testrailid=305393
    ${temp_que}    Set Variable    ${speaker} ... Set ${WHName} temperature by 145 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
    ${Status}    Run Keyword And Return Status
    ...    Should be equal as integers
    ...    115
    ...    ${dashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be equal as integers    115    ${dashBoardTemperature}
    END

TC-29:Increase temperature value WH
    [Tags]    testrailid=305394
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${dashBoardTemperature}    < ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be true    ${dashBoardTemperature} < ${AfterdashBoardTemperature}
#    Should be Equal    120    ${AfterdashBoardTemperature}
    END

TC-30:Decrease temperature value WH
    [Tags]    testrailid=305395
    ${dashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status
    ...    Should be true
    ...    ${dashBoardTemperature} < ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}
        Should be true    ${dashBoardTemperature} > ${AfterdashBoardTemperature}
#    Should be Equal    115    ${AfterdashBoardTemperature}
    END

TC-31:Turn off WH
    [Tags]    testrailid=305396
    ${temp_que}    Set Variable    ${speaker} ... Turn Off ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-32:Turn On WH
    [Tags]    testrailid=305401
    ${temp_que}    Set Variable    ${speaker} ... Turn On ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-33:Make WH off
    [Tags]    testrailid=305397
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} Off
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-34:Make WH on
    [Tags]    testrailid=305402
    ${temp_que}    Set Variable    ${speaker} ... Make ${WHName} On
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-35:Disable WH
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Disable ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-36:Try to increase temperature if was disable WH
    [Tags]    testrailid=305430
    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get dashboard value from equipment card    ${tempDashBoard}

    ${AftercooldashBoardTemperature}   Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}   Get Disabled mode from equipment card    ${deviceText}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-37:Try to decrease temperature if was disable WH
    [Tags]    testrailid=305431
    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 5 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}

    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-38:Try to know current temperature of if was disable WH
    [Tags]    testrailid=305432
    Select Device Location    ${locationNameWH}
    ${dashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${temp_que}    Set Variable    ${speaker} ... What is temperature of ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa

#    List should contain value    ${resp}    accept
#    List should contain value    ${resp}    mode

TC-39:Enable WH
    [Tags]    testrailid=305390
    ${temp_que}    Set Variable    ${speaker} ... Enable ${WHName}
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
    ${Status}    Run Keyword And Return Status    Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AftercooldashBoardTemperature}    Get Disabled mode from equipment card    ${deviceText}
        Should not be equal    Disabled    ${AftercooldashBoardTemperature}
    END

TC-43:Increase Temperature where temperature set at 140 degree "fahrenheit"
    [Tags]    testrailid=305433
    Navigate to Detail Page    ${deviceText}
    Sleep    2s
    ${setpoint_ED}    Write objvalue From Device
    ...    140
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back

    ${dashBoardTemperature}    Get setpoint from equipmet card

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card    ${tempDashBoard}

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-44:Decrease Temperature by 5 degree where temperature was set at 110 degree "fahrenheit"
    [Tags]    testrailid=305434

    Navigate to Detail Page    ${deviceText}
    Sleep    2s
    ${setpoint_ED}    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    go back
    ${dashBoardTemperature}    Get setpoint from equipmet card

    ${temp_que}    Set Variable    ${speaker} ... Decrease ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END

TC-45:Increase Temperature where temperature set at 60 degree "celsius"
    [Tags]    testrailid=305435
    Temperature Unit in Celsius
    ${dashBoardTemperature}    Get setpoint from equipmet card

    ${temp_que}    Set Variable    ${speaker} ... Increase ${WHName} temperature by 45 degree
    ${status}    ${resp}    Google Communication with Question    ${speaker}    ${temp_que}    ${WHName}    ${english}
    # Run Keyword If    '${status}'=='False'    Fail    No response from Alexa
#    List should contain value    ${resp}    Auto
    Select Device Location    ${locationNameWH}
    ${AfterdashBoardTemperature}    Get setpoint from equipmet card   

    ${Status}    Run Keyword And Return Status    Should be equal as integers    ${dashBoardTemperature}    ${AfterdashBoardTemperature}

    IF    '${Status}'=='False'
        Open Application wihout unistall and Navigate to dashboard    ${locationNameWH}
        ${AfterdashBoardTemperature}    Get setpoint from equipmet card    
        Should be equal as integers      ${dashBoardTemperature}    ${AfterdashBoardTemperature}
    END


