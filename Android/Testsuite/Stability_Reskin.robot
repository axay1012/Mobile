*** Settings ***
Library         AppiumLibrary
Library         RequestsLibrary
Library         Collections
Library         String
Library         OperatingSystem
Library         Process
Library         DateTime
Resource        ../Locators/AndroidLabels.robot
Resource        ../Locators/AndroidLocators.robot
Resource        ../Locators/Androidconfig.robot
Resource        ../Keywords/AndroidMobilekeywords.robot
Resource        ../Keywords/Android_StabilityKeywords.robot
Resource        ../Keywords/MQttkeywords.robot

Suite Setup     Run Keywords    Open App
...                 AND    Navigate to Home Screen in Rheem application    ${emailId}    ${passwordValue}
...                 AND    Select Device Location    ${select_HPWH_location}
...                 AND    Temperature Unit in Fahrenheit
...                 AND    Connect    ${emailId}    ${passwordValue}    ${SYSKEY}    ${SECKEY}    ${URL}

Test Setup      Open Application wihout unistall and Navigate to dashboard    ${Select_HPWH_location}
*** Variables ***
#    -->cloud url and env
${URL}                              https://rheemdev.clearblade.com
${URL_Cloud}                        https://rheemdev.clearblade.com/api/v/1/

#    --> test env
${SYSKEY}                           f280e3c80bdc99859a8ce9d2a51e
${SECKEY}                           F280E3C80B8CA1FB8FE292DDE458

#    --> admin cred
${Admin_EMAIL}                      automation@rheem.com
${Admin_PWD}                        Vyom@0212

${emailId}                          automation@rheem.com
${passwordValue}                    Vyom@0212

#    --> Device MAC and Device ID
${Device_Mac_Address}               40490F9E66D5
${Device_Mac_Address_In_Formate}    40-49-0F-9E-66-D5
${EndDevice_id}                     4126
# ${EndDevice_id}    4736

#    --> Setpoint Values
${setpoint_max}                     140
${setpoint_min}                     110
${select_HPWH_location}             HPWHGen5

# -->Time in seconds
${bkgTime}                          15
${lockTime}                         15
${loopCount1}                       1
${loopCount2}                       1
${loopCount5}                       1
${loopCount6}                       1
${loopCount8}                       1
${loopCount9}                       1
${loopCount10}                      1
${loopCount11}                      1
${loopCount12}                      1
${lockloop}                         2
${ConnectionStatus}                 2

# -->WiFi Status
${WiFiStatus_OFF}                   0
${WiFiStatus_ON}                    2

${deviceText}                       //android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']


*** Test Cases ***
TC-01:Perform background and foreground operation in App continuously
    [Documentation]    Perform background and foreground operation in App continuously
    [Tags]    testrailid=52604

    FOR    ${index}    IN RANGE    2
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1

        ${status}    Run Keyword and return status    Background App    seconds=${bkgTime}

        IF    '${status}'=='False'
            save screenshot with timestamp
            launch application
            CONTINUE
        END
        sleep    10s
        Navigate to Detail Page    ${deviceText}
        ${status1}    Run Keyword and return status    Change and Verify Temperature    ${index}

        IF    '${status1}'=='False'
            save screenshot with timestamp
            Go Back
            launch application
            CONTINUE
        END
    END

TC-02:Perform background and foreground operation in App along with locking and unlocking the Mobile screen continuously
    [Documentation]    Perform background and foreground operation in App along with locking and unlocking the Mobile screen continuously.
    [Tags]    testrailid=52605

    FOR    ${index}    IN RANGE    2
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s

        ${status}    Run Keyword and return status    Background App    seconds=${bkgTime}

        IF    '${status}'=='False'
            Save screenshot with timestamp
            launch application
            CONTINUE
        END
        Sleep    10s

        ${status1}    Run Keyword and return status    Lock    seconds=${lockTime}

        IF    '${status1}'=='False'
            Save screenshot with timestamp
            Launch application
            CONTINUE
        END
        Sleep    10s
        Navigate to Detail Page    ${deviceText}
        ${status2}    Run Keyword and return status    Change and Verify Temperature    ${index}

        IF    '${status2}'=='False'
            save screenshot with timestamp
            Go Back
            launch application
            CONTINUE
        END
        Sleep    5s
    END

TC-06:Keep changing the Wifi status on/off
    [Documentation]    Keep changing the Wifi status on/off
    [Tags]    testrailid=52608
    IF    '${PREV TEST STATUS}' == 'FAIL'
        Open Application wihout unistall and Navigate to dashboard    ${Select_HPWH_location}
    END
    FOR    ${index}    IN RANGE    2
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s
        Navigate to Detail Page    ${deviceText}
        ${status}    Run Keyword and return status    Change and Verify Temperature    ${index}

        IF    '${status}'=='False'
            Save screenshot with timestamp
            Go Back
            Go Back
            Open Application wihout unistall and Navigate to dashboard    ${Select_HPWH_location}
            CONTINUE
        END
        Sleep    10s

        ${status1}    Run Keyword and return status    Background App    seconds=${bkgTime}

        IF    '${status1}'=='False'
            Save screenshot with timestamp
            Launch application
            CONTINUE
        END
        Sleep    10s

        ${status2}    Run Keyword and return status    Setting the network connection status    0

        IF    '${status2}'=='False'
            save screenshot with timestamp
            CONTINUE
        END
        Sleep    10s

        ${status3}    Run Keyword and return status    Setting the network connection status    2

        IF    '${status3}'=='False'
            save screenshot with timestamp
            CONTINUE
        END
    END

TC-09:Keep changing the state from Home to Away and vice versa
    [Documentation]    Keep changing the state from Home to Away and vice versa
    [Tags]    testrailid=52611

    Select device location    ${select_HPWH_location}
    FOR    ${index}    IN RANGE    2
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s

        ${status}    Run Keyword and return status    Keep Changing Home/Away State    ${index}

        IF    '${status}'=='False'
            save screenshot with timestamp
            Go BACk
            CONTINUE
        END
        Sleep    5s
    END

TC-10:Follow/Unfollow Schedule
    [Documentation]    Follow/Unfollow Schedule
    [Tags]    testrailid=52612

    Select device location    ${select_HPWH_location}

    FOR    ${index}    IN RANGE    2
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s
        Navigate to Detail Page    ${deviceText}
        ${status}    Run Keyword and return status    Continuously Follow/Unfollow Schedule    ${index}

        IF    '${status}'=='False'
            save screenshot with timestamp
            Open Application wihout unistall and Navigate to dashboard    ${Select_HPWH_location}
            CONTINUE
        END
        Sleep    5s
    END

TC-11:Keep changing the Setpoint of device
    [Documentation]    Keep changing the Setpoint of device
    [Tags]    testrailid=52613

    Navigate to Detail Page    ${deviceText}
    FOR    ${index}    IN RANGE    ${loopCount11}
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s

        Navigate to Detail Page    ${deviceText}
        ${status}    Run Keyword and return status    Change and Verify Temperature    ${index}

        IF    '${status}'=='False'
            save screenshot with timestamp
            Go Back
            Navigate to Detail Page    ${select_HPWH_location}
            CONTINUE
        END
        Sleep    5s
    END

TC-12:Keep changing the Mode of device
    [Documentation]    Keep changing the Mode of device
    [Tags]    testrailid=52614

    FOR    ${index}    IN RANGE    ${loopCount12}
        Get Current Time    Start
        ${i}    Evaluate    ${index}+1
        sleep    2s
        Navigate to Detail Page    ${deviceText}
        ${status}    Run Keyword and return status    Keep Changing Mode Continuously    ${index}

        IF    '${status}'=='False'
            save screenshot with timestamp
            Navigate to Detail Page    ${deviceText}
            CONTINUE
        END
        Sleep    5s
    END

