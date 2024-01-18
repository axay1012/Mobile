*** Settings ***
Documentation       Stability test cases

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
Resource            ../Keywords/iOSMobileStabilityKeywords.robot

Suite Setup         Wait Until Keyword Succeeds    2x    2m    Run Keywords    Open App
...                     AND    Sign in to the application    ${emailId}    ${passwordValue}
...                     AND    Select the Device Location    ${LocationNameHPWHGen5}
...                     AND    Temperature Unit in Fahrenheit
...                     AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}
Suite Teardown      Run Keywords    save screenshot with timestamp    Close All Apps
Test Setup          Wait Until Keyword Succeeds    2x    4m    Open Application without uninstall and Navigate to dashboard    ${locationNameHPWHGen5}


*** Variables ***

#    -->cloud url and env
${URL}                                  https://rheemdev.clearblade.com
${URL_Cloud}                            https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                               f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                               F280E3C80B8CA1FB8FE292DDE458
${emailId}                              automation@rheem.com
${passwordValue}                        Vyom@0212

${bkgTime}      10
${lockTime}     10

${locationNameHPWHGen5}      HPWHGen5
@{HPWH_modes}                Energy Saver    Heat Pump
@{HPWH_state}                Enabled    Disabled

*** Test Cases ***

TC-01:Perform background and foreground operation in App continuously
    [Documentation]    Perform background and foreground operation in App continuously
    [Tags]    testrailid=165623

    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Background App    seconds=${bkgTime}
        IF    '${status}'=='FAIL'
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            launch application
            CONTINUE
        END
        sleep    10s
        ${status2}    ${result2}    Run Keyword And Ignore Error    Change and Verify Temperature
        IF    '${status2}'=='FAIL'
            log    \n=======Failure detected:${result2}=======    console=yes    level=ERROR
            Sleep    30s
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            Navigate back to the screen
        END
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes

TC-02:Perform background and foreground operation in App along with locking and unlocking the Mobile screen continuously
    [Documentation]    Perform background and foreground operation in App along with locking and unlocking the Mobile screen continuously
    [Tags]    testrailid=165624

    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s
        ${status}    ${result}    Run Keyword And Ignore Error    Background App    seconds=${bkgTime}
        IF    '${status}'=='FAIL'
            log    \n=======Failure detected:${result}=======    console=yes    level=ERROR
            Sleep    30s
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            launch application
            CONTINUE
        END
        Sleep    10s
        ${status2}    ${result2}    Run Keyword And Ignore Error    Lock    seconds=${lockTime}
        IF    '${status2}'=='FAIL'
            log    \n=======Failure detected:${result}=======    console=yes    level=ERROR
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            CONTINUE
        END
        Sleep    10s
        ${status3}    ${result3}    Run Keyword And Ignore Error    Change and Verify Temperature
        IF    '${status}'=='FAIL'
            Sleep    10s
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            launch application
            CONTINUE
        END
        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes

TC-03:Keep changing the Setpoint of device
    [Documentation]    Keep changing the Setpoint of device
    [Tags]    testrailid=165625

    ${Status}    RUN KEYWORD AND RETURN STATUS    Go to Temp Detail Screen    ${tempDashBoard}
    Write objvalue From Device
    ...    110
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    Sleep    10s
    ${setpoint_ED}    Read int return type objvalue From Device
    ...    ${whtrsetp}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    should be equal as integers    110    ${setpoint_ED}
    Navigate Back to the Screen
    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Change and Verify Temperature
        IF    '${status}'=='FAIL'
            append to list    ${failCountList}    ${index}
            Save screenshot with timestamp    ...
            Select the device location    ${locationNameHPWH}
            Sleep    30s
        END

        Get Current Time    End
    END

TC-08: Follow-Unfollow Schedule
    [Documentation]    Follow and unfollow schedule for N number of times
    [Tags]    testrailid=165630

    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Follow And Unfollow Schedule
        IF    '${status}'=='FAIL'
            Log    =======Failure detected:${result}=======    console=yes    level=ERROR
            Append to list    ${failCountList}    ${index}
            Save screenshot with timestamp
            launch application
            Sleep    10s
        END

        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes

TC-06: Keep changing the state from Home to Away and vice versa
    [Documentation]    Keep changing the state from Home to Away and vice versa
    [Tags]    testrailid=165628

    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Enable and Disable Away Mode
        IF    '${status}'=='FAIL'
            Log    =======Failure detected:${result}=======    console=yes    level=ERROR
            append to list    ${failCountList}    ${index}
            Sleep    30s
            save screenshot with timestamp
        END

        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes

TC-05:Verify whether the app is delayed while continuously dragging the screen to the top or bottom end.
    [Documentation]    Verify whether the app is delayed while continuously dragging the screen to the top or bottom end.
    [Tags]    testrailid=165627

    ${Status}    run keyword and return status    Go to temp detail screen    Mode
    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Drag temperature slider
        IF    '${status}'=='FAIL'
            Log    =======Failure detected:${result}=======    console=yes    level=ERROR
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
            select the device location    ${locationNameElectric}
            Go to temp detail screen    Mode
        END
        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Navigate Back to the Screen
    Log    Total Error List=${failCountList}    console=yes

TC-12:Keep changing the Mode of device
    [Documentation]    Keep changing the Mode of device
    [Tags]    testrailid=165629

    ${Status}    run keyword and return status    Select the Device Location    HPWHGen5
    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Change and Verify Mode    ${HPWH_modes}[0]
        ${status}    ${result}    Run Keyword And Ignore Error    Change and Verify Mode    ${HPWH_modes}[1]
        IF    '${status}'=='FAIL'
            Log    =======Failure detected:${result}=======    console=yes    level=ERROR
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
        END
        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes

TC-04: Keep Changing the State of the Devices
    [Documentation]    Keep changing the Mode of device
    [Tags]    testrailid=165645

    ${Status}    run keyword and return status    Select the Device Location    HPWHGen5

    @{failCountList}    Create List
    FOR    ${index}    IN RANGE    1
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        ${status}    ${result}    Run Keyword And Ignore Error    Change and Verify State    ${HPWH_state}[0]
        ${status}    ${result}    Run Keyword And Ignore Error    Change and Verify State    ${HPWH_state}[1]
        IF    '${status}'=='FAIL'
            log    =======Failure detected:${result}=======    console=yes    level=ERROR
            append to list    ${failCountList}    ${index}
            save screenshot with timestamp
        END
        Get Current Time    End
        Log    ${failCountList}    console=yes
    END
    Log    Total Error List=${failCountList}    console=yes
