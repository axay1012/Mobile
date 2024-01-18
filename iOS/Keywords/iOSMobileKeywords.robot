*** Settings ***
Library     ../../src/common/iOS_Handler.py
Library     Collections
Library     String
Library     OperatingSystem
Library     DateTime
Library     JSONLibrary
Library     ../../src/RheemCustom.py

Resource    ../Locators/iOSLabels.robot
Resource    ../Locators/iOSLocators.robot
Resource    ../Locators/iOSConfig.robot
Resource    MQttKeywords.robot

*** Keywords ***
Save screenshot with timestamp
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${filename}    Set Variable    screenshot_${timestamp}.png
    Capture page screenshot    ${filename}

Open Application and Navigate to Device Detail Page
    [Arguments]    ${locationName}

    Close Application
    Open App again
    Sign in to the application    ${emailId}    ${passwordValue}
    Temperature Unit in Fahrenheit
    Select the Device Location    ${locationName}

Open Application without uninstall and Navigate to dashboard
    [Arguments]    ${locationName}
    Open App again
    Sleep    10s
    Sign in to the application    ${emailId}    ${passwordValue}
    Temperature Unit in Fahrenheit
    Sleep    5s
    Select the Device Location    ${locationName}

Open Application without device detail page
    Run Keyword    close_application
    Open App
    Sign in to the application    ${emailId}    ${passwordValue}

Open Application and Navigate to Device selection Page
    [Arguments]    ${emailId}    ${passwordValue}
    Run Keyword    close_application
    Open App
    Sign in to the application    ${emailId}    ${passwordValue}

Disable Away mode from mobile application
    ${text}    Get text    ${awayText}
    IF    "${text}"=="I'm Away"    Click element    ${awayText}
    Sleep    5s
    ${text}    Get text    ${awayText}
    RETURN    0

Check Pre-Scheduled Home Status
    Wait until page contains element    ${iconNotification}    ${defaultWaitTime}
    ${text}    Get text    ${awayText}
    Sleep    5s
    Should be equal as strings    ${text}    I'm Home
    RETURN    0

Change Pre-Scheduled Status
    Wait until page contains element    ${iconNotification}    ${defaultWaitTime}
    ${text}    Get text    ${awayText}
    Sleep    5s
    IF    "${text}"=="I'm Home"    Click element    ${awayMode}
    Sleep    5s
    RETURN    1

Check Pre-scheduled Event List after Followed
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

    Wait until page contains element    ${txtScheduleAway}    ${defaultWaitTime}
    Click element    ${txtScheduleAway}
    Wait until page contains element    ${btnScheduleEvent}    ${defaultWaitTime}

    Click element    ${btnScheduleEvent}
    Wait until page contains element    ${txtScheduleEvent}    ${defaultWaitTime}
    page should contain element    No Data Available

Delete Pre-Scheduled Event
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

    Wait until page contains element    ${txtScheduleAway}    ${defaultWaitTime}
    Click element    ${txtScheduleAway}

    Wait until page contains element    ${txtScheduleEvent}    ${defaultWaitTime}
    Click element    ${txtScheduleEvent}

    Wait until page contains element    ${btnDeleteDraft}    ${defaultWaitTime}
    Click element    ${btnDeleteDraft}

    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    Click element    ${okButton}

    Run Keyword and Ignore Error    Click element    ${modebackbuttonidentifier}
    Run Keyword and Ignore Error    Navigate Back to the Screen

Handle Allow Location popup
    [Arguments]    ${myVarText}

    Wait until page contains element    ${myVarText}    ${defaultWaitTime}
    Click element    ${myVarText}

Select element using coordinate
    [Arguments]    ${element}    ${xadd}=0    ${yadd}=0

    ${location}    Get element location    ${element}
    ${x}    Evaluate    str(${location}[x] + ${xadd})
    ${y}    Evaluate    str(${location}[y] + ${yadd})
    Click element At Coordinates    ${x}    ${y}

Login to the application
    [Arguments]    ${emailId}    ${passwordValue}

    Wait until page contains element    ${imageLogo}    ${defaultWaitTime}
    Page Should Contain Element    ${imageLogo}
    Wait until page contains element    ${sign_in_link}    ${defaultWaitTime}
    Select element using coordinate    ${sign_in_link}    10    5
    Wait Until Page Contains    ${signin_page_text}    ${defaultWaitTime}
    Input Text    ${emailTextbox}    ${emailId}
    Input Password    ${passwordTextbox}    ${passwordValue}
    Sleep    5s
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Wait until page contains element    ${sign_in_button}    ${defaultWaitTime}
    Click element    ${sign_in_button}
    Sleep    6s
    ${present}    Run Keyword And Return Status    Page Should Contain Element    ${txtNotNow}
    IF    ${present}    Click element    ${txtNotNow}
    ${present}    Run Keyword And Return Status    Page Should Contain Element    ${txtSavePassword}
    IF    ${present}    Click element    ${txtSavePassword}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}

Scroll to the Contacts
    ${location}    Get element location    ${txtLocationProducts}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    Swipe    ${x}    ${y}    ${x}   ${y}

Scroll the menu slider
    ${location}    Get Element Location    ${txtLocationProducts}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Swipe    ${x}    ${y}    ${x}    ${endY}

Scroll to the upward
    [Arguments]    ${locationElement}
    ${location}    Get element location    ${locationElement}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}+200
    Swipe    ${x}    ${y}    ${x}    ${endY}

Check Pre-Scheduled Away Status
    ${text}    Get text    ${awayText}
    RETURN    1

Go to Temp Detail Screen
    [Arguments]    ${deviceName}

    Wait until page contains element    ${deviceName}    ${defaultWaitTime}
    Click element    ${deviceName}

Select the element with location and coordinate
    [Arguments]    ${element}    ${xRange}    ${yRange}
    ${location}    Get element location    ${element}
    ${x}    Evaluate    str(${location}[x]+${xRange})
    ${y}    Evaluate    str(${location}[y]+${yRange})
    Click element At Coordinates    ${x}    ${y}

Navigate to App Dashboard
    Wait until page contains element    ${backButtonDetailPage}    ${defaultWaitTime}
    Click element    ${backButtonDetailPage}

Navigate Back to the Screen
    Wait until page contains element    ${backButtonDetailPage}    ${defaultWaitTime}
    Click element    ${backButtonDetailPage}

Delete the contractor
    [Arguments]    ${contractorname}

    Wait until page contains element    ${contractorname}    ${defaultWaitTime}
    Click element    ${contractorname}
    Wait until page contains element    ${btnDeleteDraft}    ${defaultWaitTime}
    Click element    ${btnDeleteDraft}

Navigate Back to the Sub Screen
    Run Keyword And Ignore Error    Click element    ${modebackbuttonidentifier}

Generate the random Email
    ${string}    Generate random string    4    [LOWER]
    ${randEmail}    Catenate    rheemautomation+${string}@gmail.com
    RETURN    ${randEmail}

Generate the random Number
    ${number}    Generate random string    6    [NUMBERS]
    ${phoneNumber}    Catenate    9925${number}
    RETURN    ${phoneNumber}

Select the Device Location
    [Arguments]    ${locationName}

    Wait until page contains    ${rightarrow}    ${defaultWaitTime}
    Select element using coordinate    ${rightarrow}    10    5
    Wait until page contains    ${locationName}    ${defaultWaitTime}
    Select element using coordinate    ${locationName}    10    5

Select the zone
    [Arguments]    ${zoneName}    ${deviceName}

    Wait until page contains element    ${zoneName}    ${defaultWaitTime}
    Set global variable    ${zoneVal}    ${zoneName}
    Click element    ${zoneName}

Navigate to Zoning Overview screen

    Wait until page contains element    ${equipmentCard}    ${defaultWaitTime}
    Click element    ${equipmentCard}

Get current temperature from mobile app
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp}    Get Text    ${currentTemp}
    ${Setpoint}    Convert To Integer    ${temp}
    RETURN    ${Setpoint}

Get current temperature from mobile app New ECC
    Wait until page contains element    ${heatbubble}    ${defaultWaitTime}
    ${tempHeat}    Get Text    ${heatbubble}
    Wait until page contains element    ${coolbubble}    ${defaultWaitTime}
    ${tempCool}    Get Text    ${coolbubble}
    ${temp_list}    Create list    ${tempHeat}    ${tempCool}
    RETURN    ${temp_list}

Update Setpoint Value Using Button
    [Arguments]    ${button}
    Wait until page contains element    ${button}    ${defaultWaitTime}
    Click element    ${button}
    Sleep    3s
    ${temp}    Get current temperature from mobile app
    RETURN    ${temp}

Get Substring value from text
    [Arguments]    ${currentTemp}
    ${temp}    Get Text    ${currentTemp}
    ${temp}    Get Substring    ${temp}    0    -1
    RETURN    ${temp}

Get current temperature from mobile app HVAC
    [Arguments]    ${heatText}    ${coolText}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${tempHeat}    Get Text    ${heatText}
    ${heatText}    Get Substring value from text    ${heatText}
    ${coolText}    Get Substring value from text    ${coolText}
    ${temp}    create list    ${heatText}    ${coolText}
    RETURN    ${temp}

Update Setpoint Value Using Button HVAC
    [Arguments]    ${button}    ${heatTemp}    ${coolTemp}
    Wait until page contains element    ${button}    ${defaultWaitTime}
    Click element    ${button}
    Sleep    10s
    ${temp}    Get current temperature from mobile app HVAC    ${heatTemp}    ${coolTemp}
    RETURN    ${temp}

Update Cooling Setpoint Value Using Button
    [Arguments]    ${tempHeater}    ${setpointChangeButton}
    Wait until page contains element    ${setpointChangeButton}    ${defaultWaitTime}
    Tap    ${setpointChangeButton}
    Sleep    6s
    ${tempHeaterValue}    Get Text    ${coolTempButton}
    ${tempHeaterValue}    Get Substring    ${tempHeaterValue}    0    -1
    RETURN    ${tempHeaterValue}

Get Setpoint using button on Detail screen
    [Arguments]    ${tempHeater}
    Wait until page contains element    ${tempHeater}    ${defaultWaitTime}
    ${tempHeaterValue}    Get Text    ${tempHeater}
    ${tempHeaterValue}    Get Substring    ${tempHeaterValue}    0    -1
    RETURN    ${tempHeaterValue}

Increment temperature value
    Wait until page contains element    ${setpointIncreaseButton}    ${defaultWaitTime}
    Click Element    ${setpointIncreaseButton}
    Sleep    2s
    Wait until page contains element   ${currentTemp}    ${defaultWaitTime}
    ${updatedTemp}    Get Text    ${currentTemp}
    ${updatedTemp}    Convert to integer    ${updatedTemp}
    RETURN    ${updatedTemp}

Decrement temperature value
    Wait until page contains element    ${setpointDecreaseButton}    ${defaultWaitTime}
    Click Element    ${setpointDecreaseButton}
    Sleep    2s
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${updatedTemp}    Get Text    ${currentTemp}
    ${updatedTemp}    Convert to integer    ${updatedTemp}
    RETURN    ${updatedTemp}

Set max temperature
    Wait until page contains element    ${currentTemp}   ${defaultWaitTime}
    ${temp}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    60
        Scroll Down    ${tempBubble}
        Wait until page contains element     ${currentTemp}  ${defaultWaitTime}
        ${updatedTemp}    Get Text    ${currentTemp}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == 140    BREAK
    END

Temperature Unit in Celsius
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    wait until page contains    General    ${defaultWaitTime}
    Select element using coordinate    General    10    5
    Sleep    2s
    ${status}    Run Keyword and Return Status    wait until page contains    Fahrenheit (°F)     ${defaultWaitTime}
    IF    ${status}==True
        Select element using coordinate    Fahrenheit (°F)      10    5
        Sleep    1s
        Select element using coordinate    Celsius   10    5
    END
    Wait until page contains    ${backButtonDetailPage}    ${defaultWaitTime}
    Click element    ${backButtonDetailPage}


Temperature Unit in Fahrenheit
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    wait until page contains    General    ${defaultWaitTime}
    Select element using coordinate    General    10    5
    ${status}    Run Keyword and Return Status    wait until page contains    Fahrenheit (°F)    ${defaultWaitTime}
    IF    ${status}==False
        Select element using coordinate    Celsius (°C)     10    5
        Select element using coordinate    Fahrenheit      10    5
    END
    Wait until page contains    ${backButtonDetailPage}
    Select element using coordinate    ${backButtonDetailPage}    10    5

Change Temp Unit Fahrenheit From Device
    [Arguments]    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}
    ${changeUnitValue}    Set Variable    0
    ${TempUnit_ED}    Write objvalue From Device
    ...    ${changeUnitValue}
    ...    DISPUNIT
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

Swipe the screen left
    Sleep    5s
    ${width}    Get window width
    ${height}    Get window height
    ${width}    Evaluate    ${width}-10
    ${offsetY}    Evaluate    ${height}/2
    swipe    ${width}    ${offsetY}    20    ${offsetY}
    Sleep    2s

Swipe the equipment card left
    Sleep    10s
    ${location}    Get element location    ${equipmentCard}
    ${x}    Evaluate    str(${location}[x]+300)
    ${offsetX}    Evaluate    str(${location}[x]+100)
    ${y}    Evaluate    str(${location}[y]+100)
    swipe    ${x}    ${y}    100    ${y}
    Sleep    10s

Change Temperature value
    [Arguments]    ${tempElementBubble}
    Wait until page contains element    ${tempElementBubble}    ${defaultWaitTime}
    Scroll Up    ${tempElementBubble}
    Wait until page contains element    ${tempElementBubble}    ${defaultWaitTime}
    ${changed_temp}    Get text    ${tempElementBubble}
    ${temp1}    Get Substring    ${changed_temp}    0    -1
    RETURN    ${temp1}

Enable-Disable Niagara Heater
    [Arguments]    ${requiredMode}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Wait until page contains element    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element    ${waterHeaterStateButton}

    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element    ${requiredMode}
    RETURN    1

Enable-Disable Electric Heater
    [Arguments]    ${requiredMode}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Wait until page contains element    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element    ${waterHeaterStateButton}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element    ${requiredMode}
    RETURN    1

Change mode Electric Water Heater
    [Arguments]    ${requiredMode}

    Wait until page contains element    ${currentTemp}
    Wait until page contains element    ${waterHeaterModeButton}    ${defaultWaitTime}
    Click element    ${waterHeaterModeButton}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element    ${requiredMode}
    Sleep    5s
    Element Value Should Be    ${waterHeaterModeButton}    ${requiredMode}
    RETURN    ${requiredMode}

Navigate from detail screen
    [Arguments]    ${txtModeChange}
    Wait until page contains element    ${txtModeChange}    ${defaultWaitTime}
    Click element    ${txtModeChange}

Change Fan mode
    [Arguments]    ${requiredMode}
    Sleep    5s
    ${height}    Get Window Height
    ${width}     Get Window Width
    ${x}    Evaluate    50
    ${y}    Evaluate    ${height}-30
    Click element At Coordinates    ${x}    ${y}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    ${status}    get element attribute    ${requiredMode}    attribute=visible
    ${status}    convert to boolean    ${status}
    Sleep    3s
    Tap    ${locationNamePrePart}${requiredMode}${locationNamePostPart}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    ${modeVal}    Get text    ${modeNameDetailScreenPrePart}${requiredMode}${modeNameDetailScreenPostPart}
    RETURN    ${modeVal}

Scroll to the lowest mode
    [Arguments]    ${fanAutoMode}

    Wait until page contains element    ${thermostatFanSpeedButton}    ${defaultWaitTime}
    Click element    ${thermostatFanSpeedButton}
    Sleep    2s
    Wait until page contains element    ${thermostatFanSpeedButton}    ${defaultWaitTime}
    Click element    ${thermostatFanSpeedButton}
    Sleep    2s
    Element Value Should be    ${thermostatFanSpeedButton}    ${fanAutoMode}

Scroll down for fanmode Change
    [Arguments]    ${imgBubble}
    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${location}    Get element location    ${imgBubble}
    ${x}       Evaluate    str(${location}[x]+30)
    ${y}       Evaluate    str(${location}[y]+20)
    ${endY}    Evaluate    ${y}+50
    Click element at coordinates    ${x}    ${endY}
    Sleep    10s

Change the FanOnly Fan mode
    [Arguments]    ${requiredMode}

    Wait until page contains element    ${thermostatFanSpeedButton}    ${defaultWaitTime}
    Click element    ${thermostatFanSpeedButton}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element    ${requiredMode}
    Sleep    5s
    Element Value Should be    ${thermostatFanSpeedButton}    ${requiredMode}
    RETURN    ${requiredMode}

Scroll up for fanmode Change
    [Arguments]    ${imgBubble}
    ${location}    Get element location    ${imgBubble}
    ${x}       Evaluate    str(${location}[x]+40)
    ${y}       Evaluate    str(${location}[y]+10)
    ${endY}    Evaluate    ${y}-80
    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${fanSpeedVal}    Get text    ${imgBubble}
    Swipe    ${x}    ${y}    ${x}    ${endY}    2000
    Sleep    6s

Change the mode New ECC
    [Arguments]    ${requiredMode}
    Wait until page contains element    ${eccMode}    ${defaultWaitTime}
    Click element at mid point    ${eccMode}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element at mid point    ${requiredMode}
    Sleep    3s
    Wait until page contains element    ${eccMode}    10s
    ${modeVal}    Get element attribute    ${eccMode}    attribute=value
    RETURN    ${modeVal}

Change the mode Triton
    [Arguments]    ${requiredMode}
    Wait until page contains element    ${waterHeaterStateButton}    ${defaultWaitTime}
    Click element at mid point    ${waterHeaterStateButton}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element    ${requiredMode}
    RETURN    ${requiredMode}

Change the mode Old ECC
    [Arguments]    ${requiredMode}
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Wait until page contains element    ${eccMode}    ${defaultWaitTime}
    Click element at mid point    ${eccMode}
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Click element at mid point    ${requiredMode}
    Wait until page contains element    ${eccMode}    10s
    ${modeVal}    get element attribute    ${eccMode}    attribute=value
    RETURN    ${modeVal}

Set Given max temperature
    [Arguments]    ${maxTemp}
    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    FOR    ${temp}    IN RANGE    10
        ${temp1}    Get Text    ${currentTemp}
        ${temp1}    Get Substring    ${temp1}    0    -1
        IF    ${temp1} >= ${maxTemp}    BREAK
        ${location}    Get element location    ${imgBubble}
        ${x}    Evaluate    str(${location}[x])
        ${y}    Evaluate    str(${location}[y])
        ${endY}    Evaluate    ${y}-120
        Swipe    ${x}    ${y}    ${x}    ${endY}
        Sleep    6s
        ${updatedTemp}    Get Text    ${currentTemp}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} >= ${maxTemp}    BREAK
    END

Scroll to the Max Temperature
    [Arguments]    ${maxTemp}    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}

    FOR    ${temp}    IN RANGE    10
        ${temp1}    Get Text    ${imgBubble}
        Click element    ${setpointIncreaseButton}
        Sleep    5s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${maxTemp}    BREAK
    END

Increment temperature value1
    [Arguments]    ${maxTemp}
    FOR    ${temp}    IN RANGE    50
        ${temp1}    Get Text    ${imgBubble}
        Scroll down    ${imgBubble}
        Sleep    5s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${maxTemp}    BREAK
    END

Scroll to the Max Temperature new ECC
    [Arguments]    ${maxTemp}    ${imgBubble}


    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}

    ${temp1}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    10
        ${temp1}    Get Text    ${imgBubble}
        Scroll Up    ${imgBubble}
        Sleep    2s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${maxTemp}    BREAK
    END

Scroll to the Max Temperature old ECC
    [Arguments]    ${maxTemp}    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}

    FOR    ${temp}    IN RANGE    10
        Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
        ${temp1}    Get Text    ${imgBubble}
        Scroll Up    ${imgBubble}
        Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${maxTemp}    BREAK
    END

Scroll to the min temperature
    [Arguments]    ${minTemp}    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}

    ${temp1}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    15
        IF    ${temp1} == ${minTemp}    BREAK
        Click element    ${setpointDecreaseButton}
        Sleep    2s
        Wait until page contains element   ${currentTemp}    ${defaultWaitTime}
        ${updatedTemp}    Get Text    ${currentTemp}
        IF    ${updatedTemp} == ${minTemp}    BREAK
    END
    Sleep    3s

Scroll to the min temperature new ECC
    [Arguments]    ${minTemp}    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    10
        IF    ${temp1} == ${minTemp}    BREAK
        Scroll Up    ${imgBubble}
        Sleep    2s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${minTemp}    BREAK
    END

Scroll to the min temperature for Zone Device
    [Arguments]    ${minTemp}    ${imgBubble}    ${ButtonLocator}=${HeatingDecrease}

    Wait until page contains element     ${currentTemp}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    10
        IF    ${temp1} == ${minTemp}    BREAK
        ${status}    run keyword and return status    Wait until page contains element    ${buttons_type}    ${defaultWaitTime}
        IF    ${status}==True    Click element    ${buttons_type}
        Wait until page contains element    ${ButtonLocator}    ${defaultWaitTime}
        Click element    ${ButtonLocator}
        Sleep    5s
        ${status}    Run keyword and return status    Wait until page contains element    ${slider_type}    ${defaultWaitTime}
        IF    ${status}==True    Click element    ${slider_type}
        Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${minTemp}    BREAK
    END

Scroll to the Max temperature for Zone Device
    [Arguments]    ${minTemp}    ${imgBubble}    ${ButtonLocator}=${HeatingIncrease}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    10
        IF    ${temp1} == ${minTemp}    BREAK
        ${status}    run keyword and return status    Wait until page contains element    ${buttons_type}    ${defaultWaitTime}
        IF    ${status}==True    Click element    ${buttons_type}
        Wait until page contains element    ${ButtonLocator}    ${defaultWaitTime}
        Click element    ${ButtonLocator}
        Sleep    5s
        ${status}    Run keyword and return status    Wait until page contains element    ${slider_type}    ${defaultWaitTime}
        IF    ${status}==True    Click element    ${slider_type}
        Sleep    2s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${minTemp}    BREAK
    END

Scroll to the min temperature old ECC
    [Arguments]    ${minTemp}    ${imgBubble}
    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    ${temp1}    Get Text    ${currentTemp}

    FOR    ${temp}    IN RANGE    5
        IF    ${temp1} == ${minTemp}    BREAK
        Scroll Up    ${imgBubble}
        Sleep    5s
        ${updatedTemp}    Get Text    ${imgBubble}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == ${minTemp}    BREAK
    END

Swipe Up the bubble
    [Arguments]    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    Scroll Up    ${imgBubble}

Swipe Down the bubble
    [Arguments]    ${imgBubble}

    Wait until page contains element    ${imgBubble}    ${defaultWaitTime}
    Scroll Up    ${imgBubble}
    Sleep    5s

Set the minimum temperature
    [Arguments]    ${minTemp}    ${tempBubble}
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    ${temp}    Get Text    ${tempBubble}
    FOR    ${temp}    IN RANGE    10
        ${location}    Get element location    ${tempBubble}
        ${x}    Evaluate    str(${location}[x])
        ${y}    Evaluate    str(${location}[y])
        ${endY}    Evaluate    ${y}+30
        Sleep    2s
        swipe    ${x}    ${y}    ${x}    ${endY}    500
        Sleep    10s
        ${updatedTemp}    Get Text    ${tempBubble}
        Wait Until Element is Visible    ${tempBubble}
        IF    ${updatedTemp}<=${minTemp}    BREAK
    END

Set the maximum temperature
    [Arguments]    ${maxTemp}    ${tempBubble}
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    ${temp}    Get Text    ${tempBubble}
    FOR    ${temp}    IN RANGE    10
        Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
        ${location}    Get element location    ${tempBubble}
        ${x}    Evaluate    str(${location}[x])
        ${y}    Evaluate    str(${location}[y])
        ${endY}    Evaluate    ${y}-1
        Sleep    2s
        swipe    ${x}    ${y}    ${x}    ${endY}    500
        Sleep    10s
        ${updatedTemp}    Get Text    ${tempBubble}
        Wait until value is not visible    ${tempBubble}
        IF    ${updatedTemp}>=${maxTemp}    BREAK
    END

Set min temperature
    Wait until page contains element    ${tempBubble}    ${defaultWaitTime}
    ${temp}    Get Text    ${currentTemp}
    FOR    ${temp}    IN RANGE    10
        Scroll Up    ${tempBubble}
        Sleep    5s
        ${updatedTemp}    Get Text    ${currentTemp}
        ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
        IF    ${updatedTemp} == 110    BREAK
    END

Click element at mid point
    [Arguments]    ${ele}
    Wait until page contains element    ${ele}    ${defaultWaitTime}
    Click element   ${ele}

Change Mode
    [Arguments]    ${requiredMode}

    Wait until page contains element    ${waterHeaterModeButton}    ${defaultWaitTime}
    Select element using coordinate    ${waterHeaterModeButton}    10    5
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Select element using coordinate    ${requiredMode}    10    5
    Sleep    2s
    RETURN    1

Change Mode for Dragon
    [Arguments]    ${requiredMode}

    Wait until page contains element    ${waterHeaterStateButton}    ${defaultWaitTime}
    Select element using coordinate    ${waterHeaterStateButton}    10    5
    Wait until page contains element    ${requiredMode}    ${defaultWaitTime}
    Select element using coordinate    ${requiredMode}    10    5
    Sleep    2s
    RETURN    1

Select the element in center
    [Arguments]    ${element}
    ${location}    Get element location    ${element}
    ${x}    Evaluate    str(${location}[x]+10)
    ${y}    Evaluate    str(${location}[y]+10)
    Click element At Coordinates    ${x}    ${y}

Set Away Mode First Time
    [Arguments]    ${HeaterType}

    Sleep    10s
    ${present}    Run Keyword And Return Status    Page Should Contain Element    ${txtUserGuide}
    IF    ${present}
        Navigate to Away setting screen from Dashboard    ${HeaterType}
    END
    Wait until element is visible    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}
    Click element    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}

    ${on_off}    Get Element Attribute    ${awaySwitch}    value
    IF    ${on_off}==0    Click element    ${awaySwitch}
    Click element at mid point    ${saveButton}
    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    Sleep    5s
    Click element    ${okButton}
    Sleep    10s
    Navigate Back to the Screen
    Wait until page contains element    ${awayMode}    ${defaultWaitTime}
    Click element    ${awayMode}
    Check Away Mode

Set Away Mode First Time for multiple product
    [Arguments]    ${HeaterType}    ${btn1State}    ${btn2State}

    Wait until element is visible    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}    ${defaultWaitTime}
    Click element    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}
    ${btnStatus}    Get element attribute    ${awaySwitch}    value
    IF    ${btnStatus}==${btn1State}    Click element    ${awaySwitch}
    ${btnStatus}    Get element attribute    ${awaySwitch1}    value
    IF    ${btnStatus}==${btn2State}    Click element    ${awaySwitch1}
    Click element at mid point    ${saveButton}
    Wait until page contains element    ${okButtonAway}    ${defaultWaitTime}
    Sleep    3s
    Click element    ${okButtonAway}
    Sleep    10s
    Navigate Back to the Screen
    Wait until page contains element    ${awayMode}    ${defaultWaitTime}
    Click element at mid point    ${awayMode}
    Check Away Mode

Set Away Mode First Time New ECC
    [Arguments]    ${HeaterType}

    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    Click element    ${txtAwaySettings}
    Sleep    2s
    Wait until page contains element    ${HeaterType}    ${defaultWaitTime}
    Click element    ${HeaterType}
    Sleep    4s
    Scroll Up    ${heatBubble}
    Sleep    2s
    Scroll Up    ${coolBubble}
    Sleep    2s
    ${heatTemp_Mobile}    Get Text    ${heatBubble}
    ${heatTemp_Mobile}    Get Substring    ${heatTemp_Mobile}    0    -1
    ${CoolTemp_Mobile}    Get Text    ${coolBubble}
    ${CoolTemp_Mobile}    Get Substring    ${CoolTemp_Mobile}    0    -1
    Wait until page contains element    ${saveSchedule}    ${defaultWaitTime}
    Click element    ${saveSchedule}
    Sleep    5s
    ${Status}    Run keyword and return status    Wait Until Element is Visible    Ok    ${defaultWaitTime}
    IF    ${Status}==True    Click element    Ok
    Sleep    1s
    Navigate Back to the Screen
    Navigate Back to the Screen
    Sleep    5s
    ${list}    create list    ${heatTemp_Mobile}    ${CoolTemp_Mobile}
    RETURN    ${list}


Set Away Mode Using Button New ECC
    [Arguments]    ${HeaterType}

    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    Click element    ${txtAwaySettings}
    Wait until page contains element
    ...    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}
    ...    ${defaultWaitTime}
    Click element    ${locationAwayPrePart}${HeaterType}${locationAwayPostPart}
    ${scheduledHeat_temp}    Update Cooling Setpoint Using Button    ${coolingIncrease}
    ${scheduledCool_temp}    Update Heating Setpoint Using Button    ${heatingDecrease}
    ${location}    Get element location    ${HeaterType}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-400
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    10s
    ${scheduled_mode}    Get Text    ${modeSchedule}
    Wait until page contains element    ${away_ForwardMode}    ${defaultWaitTime}
    Click element    ${away_ForwardMode}
    Sleep    4s
    ${updated_scheduled_mode}    Get Text    ${modeSchedule}
    Should not be equal as strings    ${updated_scheduled_mode}    ${scheduled_mode}
    ${updated_scheduled_mode}    Evaluate    '${updated_scheduled_mode}'.strip()
    Click element at mid point    ${saveButton}    # ${saveAway}
    Wait until page contains    ${okButton}    ${defaultWaitTime}
    Click element    ${okButton}
    Navigate Back to the Screen
    Wait until page contains element    ${equipmentCard}    ${defaultWaitTime}
    ${location}    Get element location    ${awayMode}
    ${x}    Evaluate    str(${location}[x] + 20)
    ${y}    Evaluate    str(${location}[y] + 20)
    Click element At Coordinates    ${x}    ${y}
    Check Away Mode
    Wait until page contains element    ${awayLogo}    ${defaultWaitTime}
    ${list}    create list    ${scheduledHeat_temp}    ${scheduledCool_temp}    ${updated_scheduled_mode}
    RETURN    ${list}

Check Away Mode
    Wait until page contains element    ${awayText}    ${defaultWaitTime}
    ${data}    Get Text    ${awayText}
    Should be equal as strings    ${data}    ${awayModeText}
    RETURN    1

Set Away Mode
    [Arguments]    ${HeaterType}
    Click element    ${awayMode}
    Sleep    5s
    ${status}    Run Keyword And Ignore Error    Wait Until Page Contains    ${pageTitle}    ${defaultWaitTime}

    ${status}    convert to String    ${status}[0]
    IF    '${status}'=='PASS'
        Set Away Mode First Time    ${HeaterType}
    ELSE
        Check Away Mode
    END
    RETURN    1

Select the Away if Already configured
    Page Should Contain Text    I'm Home
    Click element    ${awayMode}
    Wait until page contains element    ${awayText}    ${defaultWaitTime}
    Page Should Contain Text    I'm Away
    RETURN    1

Set Away Mode for multiple product
    [Arguments]    ${HeaterType}    ${btn1State}    ${btn2State}
    ${status}    Run Keyword And Ignore Error    page should contain text    ${txtImAway}    ${defaultWaitTime}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    Click element    ${txtAwaySettings}
    Set Away Mode First Time for multiple product    ${HeaterType}    ${btn1State}    ${btn2State}
    RETURN    1

Enable Or Disable Away Mode For Multiple Product
    [Documentation]    Pass state value 0 to enable away setting and 1 to disable away setting
    [Arguments]    ${HeaterType}    ${state1}    ${state2}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    Click element    ${txtAwaySettings}
    Sleep    10s
    Wait until page contains element    ${HeaterType}    ${defaultWaitTime}
    Click element    ${HeaterType}
    Click element    ${awaySwitch}
    ${btnStatus}    get element attribute    ${awaySwitch}    value
    IF    ${btnStatus}==${state1}    Click element    ${awaySwitch}
    ${btnStatus}    get element attribute    ${awaySwitch1}    value
    IF    ${btnStatus}==${state2}    Click element    ${awaySwitch1}
    Click element at mid point    btnSave
    Sleep    5s
    Wait until page contains element    ${okButtonAway}    ${defaultWaitTime}
    Click element    ${okButtonAway}
    Navigate Back to the Screen
    Navigate Back to the Screen
    Sleep    5s

Set Away Mode New ECC
    [Arguments]    ${HeaterType}
    Wait until page contains element    ${txtIamAway}    ${defaultWaitTime}
    ${count}    get matching xpath count    ${txtIamAway}
    IF    ${count}>0    Click element    ${awayMode}
    Sleep    3s
    ${list}    Set Away Mode First Time New ECC    ${HeaterType}
    RETURN    ${list}

Set Away Mode New ECC Using Button
    [Arguments]    ${HeaterType}
    ${count}    get matching xpath count    ${txtIamAway}
    IF    ${count}>0    Click element    ${awayMode}
    ${list}    Set Away Mode Using Button New ECC    ${HeaterType}
    RETURN    ${list}

Set Away Mode Old ECC
    [Arguments]    ${HeaterType}
    ${list}    Set Away Mode First Time New ECC    ${HeaterType}
    RETURN    ${list}

Disable Away Mode
    Page Should Contain Text    I'm Away
    Click element    ${awayMode}
    Sleep    2s
    element value should be    ${awayText}    I'm Home
    RETURN    0

Disable Away Mode New ECC
    ${away}    Get element attribute    ${awayText}    value
    Should be equal    ${away}    ${awayModeText}
    Click element    ${awayMode}
    Sleep    3s
    element value should be    ${awayText}    I'm Home
    Sleep    3s
    page should not contain element    ${awayLogo}
    RETURN    0

Set Schedule
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Scroll Up    ${heatBubble}
    Sleep    2s
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    ${saveButton}    ${defaultWaitTime}
    Click element    ${saveButton}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    Navigate Back to the Sub Screen
    Sleep    5s
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${tempDashboard}    Get current temperature from mobile app
    ${list}    Create list    ${scheduled_temp}    ${deviceName}
    RETURN    ${list}

Navigate to schedule screen from Dashboard
    [Arguments]    ${locationName}
    Temporary Keyword
    Sleep    6s
    Select the Device Location    ${locationName}
    Go to Temp Detail Screen
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}

Navigate to Away setting screen from Dashboard
    [Arguments]    ${locationName}
    Temporary Keyword
    Sleep    6s
    Select the Device Location    ${locationName}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Wait until page contains element    ${txtAwaySettings}    ${defaultWaitTime}
    Click element    ${txtAwaySettings}
    Sleep    5s

Navigate to schedule screen from Dashboard for Zonning
    [Arguments]    ${locationName}
    Navigate to the Zoning Overview Screen from Dahboard    ${locationName}
    select the zone    ${zoneVal}    ${locationName}
    Sleep    6s
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}

set schedule New ECC
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    time2
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p

    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${updatedTemp}    Get Text    ${heatbubble}
    ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    ${saveButton}    ${defaultWaitTime}
    Click element    ${saveButton}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${list}    Create list    ${scheduled_temp}    ${deviceName}
    RETURN    ${list}

set schedule zoning
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}

    Sleep    10s
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${updatedTemp}    Get Text    ${heatbubble}
    ${updatedTemp}    Get Substring    ${updatedTemp}    0    -1
    ${coolTemp}    Get Text    ${coolbubble}
    ${coolTemp}    Get Substring    ${coolbubble}    0    -1
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    ${list}    Create list    ${scheduled_temp}    ${coolTemp}
    RETURN    ${list}

set schedule using button ECC
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    5s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${status}    run keyword and return status    Wait until page contains element    ${buttons_type}
    IF    ${status}==True    Click element    ${buttons_type}
    Sleep    2s
    Wait until page contains element    ${heatingPlusButton}    ${defaultWaitTime}
    Click element    ${heatingPlusButton}
    Sleep    10s
    ${status}    run keyword and return status    Wait until page contains element    ${slider_type}
    IF    ${status}==True    Click element    ${slider_type}
    Sleep    2s
    ${coolTemp}    Get Element Attribute    ${coolBubble}    value
    ${coolTemp}    Get Substring    ${coolTemp}    0    -1
    ${heatTemp}    Get Element Attribute    ${heatbubble}    value
    ${heatTemp}    Get Substring    ${heatTemp}    0    -1
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${Status}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    2s
    ${scheduledCool_temp}    Get Element Attribute    ${coolBubble}    value
    ${scheduledCool_temp}    Get Substring    ${scheduledCool_temp}    0    -1
    ${scheduledHeat_temp}    Get Element Attribute    ${heatbubble}    value
    ${scheduledHeat_temp}    Get Substring    ${scheduledHeat_temp}    0    -1
    Sleep    10s
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    Should be equal as integers    ${heatTemp}    ${scheduledHeat_temp}
    Should be equal as integers    ${coolTemp}    ${scheduledCool_temp}
    ${list}    Create list    ${scheduledHeat_temp}    ${scheduledCool_temp}
    RETURN    ${list}

set schedule Zonned ECC
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Navigate to schedule screen from Dashboard for Zonning    ${deviceName}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Sleep    4s
    Swipe    ${x}    ${y}    ${x}    ${endY}
    ${location}    Get element location    ${coolBubble}
    ${x}    Evaluate    str(${location}[x]+20)
    ${y}    Evaluate    str(${location}[y]+17)
    ${endX}    Evaluate    ${x}-30
    Swipe    ${x}    ${y}    ${endX}    ${y}
    Sleep    5s
    ${location}    Get element location    ${heatBubble}
    ${x}    Evaluate    str(${location}[x]+20)
    ${y}    Evaluate    str(${location}[y]+17)
    ${endX}    Evaluate    ${x}+30

    Swipe    ${x}    ${y}    ${endX}    ${y}
    Sleep    5s
    ${scheduled_mode}    Get Text    ${modeSchedule}
    Click element    ${mode_ForwardArrow}
    Sleep    5s
    ${updated_scheduled_mode}    Get Text    ${modeSchedule}
    Should not be equal as strings    ${updated_scheduled_mode}    ${scheduled_mode}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Sleep    2s
    Tap    ${saveSchedule}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Wait until page contains element    ${scheduleButton}     ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    3s
    ${status}    Run Keyword and Return Status
    ...    Wait until page contains element
    ...    ${timeSchedule}
    ...    ${defaultWaitTime}
    Sleep    5s
    ${scheduledCool_temp}    Get Text    ${coolBubble}
    ${scheduledHeat_temp}    Get Text    ${heatBubble}
    ${updated_scheduled_mode}    Evaluate    '${updated_scheduled_mode}'.strip()
    Sleep    2s
    Click element    ${saveSchedule}
    Sleep    3s
    ${status}    Run Keyword and Return Status
    ...    Wait until page contains element
    ...    ${scheduleButton}
    ...    ${defaultWaitTime}
    ${tempDashboard}    Get current temperature from mobile app New ECC
    ${heatTemp_Dash}    get from list    ${tempDashboard}    0
    ${coolTemp_Dash}    get from list    ${tempDashboard}    1
    Should be equal    ${heatTemp_Dash}    ${scheduledHeat_temp}
    Should be equal    ${coolTemp_Dash}    ${scheduledCool_temp}
    ${list}    Create list    ${heatTemp_Dash}    ${coolTemp_Dash}
    RETURN    ${list}

set schedule Old ECC
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${coolTemp}    Get Text    ${HvacScheduleCoolTemp}
    ${coolTemp}    Get substring    ${coolTemp}    0    -1
    ${heatTemp}    Get Text    ${HvacScheduleHeatTemp}
    ${heatTemp}    Get substring    ${heatTemp}    0    -1
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    Run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    10s
    ${coolTempDashboard1}    Get Text    ${coolBubble}
    ${coolTempDashboard1}    Get substring    ${coolTempDashboard1}    0    -1
    ${heatTempDashboard1}    Get Text    ${heatBubble}
    ${heatTempDashboard1}    Get substring    ${heatTempDashboard1}    0    -1
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    Should be equal as integers    ${coolTemp}    ${coolTempDashboard1}
    Should be equal as integers    ${heatTemp}    ${heatTempDashboard1}
    ${list}    Create list    ${heatTemp}    ${coolTemp}
    RETURN    ${list}

Set Schedule Triton
    [Arguments]    ${modeValue}    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    5s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_secondrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    Wait Until Element Is Visible    ${btnOccupieOnOffAttr}    ${defaultWaitTime}
    ${switchstatus}    Get Text    ${btnOccupieOnOffAttr}
    IF    '${switchstatus}' != '${modeValue}'
        Click Element    ${btnOccupieOnOffAttr}
    END
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    Navigate Back to the Sub Screen
    Sleep    10s

Turn On/Off Occupied button
    [Arguments]    ${buttonID}
    Wait until page contains element    ${buttonID}    ${defaultWaitTime}
    Click element    ${buttonID}
    Wait until page contains element    ${save_Copy_screen}    ${defaultWaitTime}
    Click element    ${save_Copy_screen}
    Sleep    3s

set schedule using button New ECC
    Wait until page contains element    ${scheduleButton}    ${deviceName}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    5s
    ${updated_scheduled_mode}    Get Text    ${modeSchedule}
    Should not be equal as strings    ${updated_scheduled_mode}    ${scheduled_mode}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0
        Turn on schedule toggle
    END
    Sleep    5s
    Click element at coordinates    ${x}    ${y}
    Sleep    5s
    Tap    ${saveSchedule}
    Sleep    10s

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    ${scheduledCool_temp}    Get Element Attribute    ${coolTempButton}    value
    ${scheduledHeat_temp}    Get Element Attribute    ${heatTempButton}    value
    ${updated_scheduled_mode}    Evaluate    '${updated_scheduled_mode}'.strip()
    Click element at coordinates    ${x}    ${y}
    Sleep    8s
    Tap    ${saveSchedule}
    Sleep    8s
    ${tempDashboard}    Get current temperature from mobile app New ECC
    ${heatTemp_Dash}    get from list    ${tempDashboard}    0
    ${coolTemp_Dash}    get from list    ${tempDashboard}    1

    ${modeDetailScreen}    Validate and return current Mode    ${updated_scheduled_mode}

    Should be equal    ${heatTemp_Dash}    ${scheduledHeat_temp}
    Should be equal    ${coolTemp_Dash}    ${scheduledCool_temp}
    Should be equal    ${updated_scheduled_mode}    ${modeDetailScreen}

    ${list}    Create list    ${heatTemp_Dash}    ${coolTemp_Dash}    ${updated_scheduled_mode}
    RETURN    ${list}

Set Schedule using button without mode
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${tempDashboard}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Sleep    6s
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    RETURN    ${tempDashboard}

Set Schedule without mode
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    RETURN    ${tempDashboard}

Unfollow Schedule
    Click element    ${scheduleButton}
    Wait until page contains elemet    ${scheduleToggle}    ${defaultWaitTime}
    Tap    ${scheduleToggle}
    Tap    ${saveSchedule}
    wiat until page contains    ${notFollowingScheduleMsg}    ${defaultWaitTime}

Turn on schedule toggle
    Tap    ${scheduleToggle}
    Sleep    2s

Turn on/off the button
    [Arguments]    ${button}

    Tap    ${button}

Verify schedule with changes in timeslot, mode and temperature
    [Arguments]    ${deviceName}
    Click element    ${scheduleButton}
    Sleep    6s
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Click element    ${timeSlot}
    ${datetime}    Manipulate current time
    ${datetimeHour}    set variable    ${datetime.hour}
    Input Text    ${hourPicker}    ${datetimeHour}
    Input text    ${minutePicker}    00
    Tap    ${doneTimePicker}
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    5s
    ${scheduled_temp}    Get Text    ${tempSliderButton}
    ${location}    Get element location    ${tempSliderButton}
    ${x}    Evaluate    str(${location}[x]+20)
    ${y}    Evaluate    str(${location}[y]+17)
    ${endX}    Evaluate    ${x}+50
    Swipe    ${x}    ${y}    ${endX}    ${y}
    Sleep    5s
    ${new_scheduled_temp}    Get Text    ${tempSliderButton}
    ${scheduled_mode}    Get Text    ${modeSchedule}
    Click element    ${mode_ForwardArrow}
    ${updated_scheduled_mode}    Get Text    ${modeSchedule}
    Should not be equal as strings    ${updated_scheduled_mode}    ${scheduled_mode}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Tap    ${saveSchedule}
    Sleep    5s
    ${updated_scheduled_mode}    Evaluate    '${updated_scheduled_mode}'.strip()
    ${tempDashboard}    Get current temperature from mobile app
    ${modeDashboard}    Validate and return current Mode    ${updated_scheduled_mode}
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    Page should contain text    ${followScheduleMsgDashboard}
    Should be equal    ${new_scheduled_temp}    ${tempDashboard}
    Should be equal    ${updated_scheduled_mode}    ${modeDashboard}
    ${list}    Create list    ${new_scheduled_temp}    ${updated_scheduled_mode}
    RETURN    ${list}

Verify schedule with changes in timeslot, temperature
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${saveSchedule}    ${defaultWaitTime}
    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    2s
    Wait until page contains element    ${timeSlot}    ${defaultWaitTime}
    Click element    ${timeSlot}
    ${datetime}    Manipulate current time
    ${datetimeHour}    set variable    ${datetime.hour}
    Input Text    ${hourPicker}    ${datetimeHour}
    Input text    ${minutePicker}    00
    Tap    ${doneTimePicker}
    ${scheduled_temp}    Get Text    ${tempSliderButton}
    ${location}    Get element location    ${tempSliderButton}
    ${x}    Evaluate    str(${location}[x]+20)
    ${y}    Evaluate    str(${location}[y]+17)
    ${endX}    Evaluate    ${x}+50
    Swipe    ${x}    ${y}    ${endX}    ${y}
    Sleep    5s
    ${new_scheduled_temp}    Get Text    ${tempSliderButton}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Tap    ${saveSchedule}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    ${tempDashboard}    Get current temperature from mobile app

    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}

    Page should contain text    ${followScheduleMsgDashboard}
    Should be equal    ${new_scheduled_temp}    ${tempDashboard}
    RETURN    ${new_scheduled_temp}

verify schedule overridden
    [Arguments]    ${modeTempBubble}    ${maxTempVal}
    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${tempVal}    Get text    ${modeTempBubble}
    ${tempVal}    Get substring    ${tempVal}    0    -1
    IF    ${tempVal}==${maxTempVal}
        Decrement temperature value
    ELSE
        Increment temperature value
    END

verify schedule overridden using button
    [Arguments]    ${modeTempBubble}    ${maxTempVal}

    Wait until page contains element    ${modeTempBubble}    ${defaultWaitTime}
    ${tempVal}    Get text    ${modeTempBubble}
    ${tempVal}    Get Substring    ${tempVal}    0    -1
    IF    ${tempVal}==${maxTempVal}
        Update Setpoint Value Using Button    ${setpointDecreaseButton}
    ELSE
        Update Setpoint Value Using Button    ${setpointIncreaseButton}
    END

Unfollow the schedule
    [Arguments]    ${deviceName}

    Sleep    5s
    Wait until page contains element    ${scheduleToggle}    ${defaultWaitTime}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==1    Turn on schedule toggle
    Tap    ${saveSchedule}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}

Unfollow the schedule for zoning
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleToggle}    ${defaultWaitTime}
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==1    Turn on schedule toggle
    Tap    ${saveSchedule}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    ${visible}    Get Element Attribute    ${followScheduleMsg}    visible
    Should Be Equal    ${visible}    false

Manipulate current time
    ${CurrentDate}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S.%f
    ${datetime}    Convert Date    ${CurrentDate}    datetime
    RETURN    ${datetime}

Copy Schedule Data
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}

    Sleep    10s

    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    Click element    ${copyButton}

    ${currentDay}    Get Current Date    result_format=%A

    IF    '${currentDay}'=='Monday'
        Click element    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click element    ${day_Monday}
    END
    Sleep    5s

    Click element    ${save_Copy_screen}
    Sleep    2s
    @{list1}    Get Webelements    ${row1}
    @{list2}    Get Webelements    ${row2}
    @{list3}    Get Webelements    ${row3}
    @{list4}    Get Webelements    ${row4}

    ${text1}    Get Text    ${list1}[0]
    ${text2}    Get Text    ${list1}[1]
    ${text3}    Get Text    ${list2}[0]
    ${text4}    Get Text    ${list2}[1]
    ${text5}    Get Text    ${list3}[0]
    ${text6}    Get Text    ${list3}[1]
    ${text7}    Get Text    ${list4}[0]
    ${text8}    Get Text    ${list4}[1]
    @{data_list1}    create list
    ...    ${text1}
    ...    ${text2}
    ...    ${text3}
    ...    ${text4}
    ...    ${text5}
    ...    ${text6}
    ...    ${text7}
    ...    ${text8}
    IF    '${currentDay}'=='Sunday'
        Click element    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click element    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${sunday}
    END

    Sleep    2s
    @{list5}    Get Webelements    ${row1}
    @{list6}    Get Webelements    ${row2}
    @{list7}    Get Webelements    ${row3}
    @{list8}    Get Webelements    ${row4}
    ${text13}    Get Text    ${list5}[0]
    ${text14}    Get Text    ${list5}[1]
    ${text15}    Get Text    ${list6}[0]
    ${text16}    Get Text    ${list6}[1]
    ${text17}    Get Text    ${list7}[0]
    ${text18}    Get Text    ${list7}[1]
    ${text19}    Get Text    ${list8}[0]
    ${text20}    Get Text    ${list8}[1]
    @{data_list2}    create list
    ...    ${text13}
    ...    ${text14}
    ...    ${text15}
    ...    ${text16}
    ...    ${text17}
    ...    ${text18}
    ...    ${text19}
    ...    ${text20}
    Should be equal    ${data_list1}    ${data_list2}

Copy Schedule Data zoning
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}

    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    Click element    ${copyButton}
    Wait until page contains element    ${copyPageText}    ${defaultWaitTime}
    ${currentDay}    Get Current Date    result_format=%A
    IF    '${currentDay}'=='Monday'
        Click element    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click element    ${day_Monday}
    END
    Sleep    5s
    Click element    ${save_Copy_screen}
    Sleep    3s

    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}+110
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    6s

    Wait until page contains element    ${down_arrow}    ${defaultWaitTime}
    Click element    ${down_arrow}

    ${index}    set variable    1

    FOR    ${temp1}    IN RANGE    1    4
        ${selectarow}    catenate    //XCUIElementTypeTable/XCUIElementTypeOther[${index}]/XCUIElementTypeButton
        ${attribute}    Get element attribute    ${selectarow}    label
        IF    '${attribute}'=='up arrow'    Click element    ${selectarow}
        ${index}    Evaluate    ${index} + 2
    END

    Sleep    2s
    @{list1}    Get Webelements    ${row1}
    @{list2}    Get Webelements    ${row2}
    @{list3}    Get Webelements    ${row3}
    @{list4}    Get Webelements    ${row4}

    ${text1}     Get Text    ${list1}[0]
    ${text2}     Get Text    ${list1}[1]
    ${text3}     Get Text    ${list1}[2]
    ${text4}     Get Text    ${list2}[0]
    ${text5}     Get Text    ${list2}[1]
    ${text6}     Get Text    ${list2}[2]
    ${text7}     Get Text    ${list3}[0]
    ${text8}     Get Text    ${list3}[1]
    ${text9}     Get Text    ${list3}[2]
    ${text10}    Get Text    ${list4}[0]
    ${text11}    Get Text    ${list4}[1]
    ${text12}    Get Text    ${list4}[2]
    @{data_list1}    Create list
    ...    ${text1}
    ...    ${text2}
    ...    ${text3}
    ...    ${text4}
    ...    ${text5}
    ...    ${text6}
    ...    ${text7}
    ...    ${text8}
    ...    ${text9}
    ...    ${text10}
    ...    ${text11}
    ...    ${text12}
    IF    '${currentDay}'=='Sunday'
        Click element    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click element    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${sunday}
    END
    Sleep    2s
    Click element    ${down_arrow}
    Sleep    2s
    @{list5}    Get Webelements    ${row1}
    @{list6}    Get Webelements    ${row2}
    @{list7}    Get Webelements    ${row3}
    @{list8}    Get Webelements    ${row4}

    ${text13}    Get Text    ${list5}[0]
    ${text14}    Get Text    ${list5}[1]
    ${text15}    Get Text    ${list5}[2]
    ${text16}    Get Text    ${list6}[0]
    ${text17}    Get Text    ${list6}[1]
    ${text18}    Get Text    ${list6}[2]
    ${text19}    Get Text    ${list7}[0]
    ${text20}    Get Text    ${list7}[1]
    ${text21}    Get Text    ${list7}[2]
    ${text22}    Get Text    ${list8}[0]
    ${text23}    Get Text    ${list8}[1]
    ${text24}    Get Text    ${list8}[2]
    @{data_list2}    create list
    ...    ${text13}
    ...    ${text14}
    ...    ${text15}
    ...    ${text16}
    ...    ${text17}
    ...    ${text18}
    ...    ${text19}
    ...    ${text20}
    ...    ${text21}
    ...    ${text22}
    ...    ${text23}
    ...    ${text24}
    Should be equal    ${data_list1}    ${data_list2}

Copy Schedule Data without mode
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    Click element    ${copyButton}

    ${currentDay}    Get Current Date    result_format=%A
    IF    '${currentDay}'=='Monday'
        Click element    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click element    ${day_Monday}
    END
    Sleep    5s
    Click element    ${save_Copy_screen}
    Sleep    2s
    @{list1}    Get Webelements    ${row1}
    @{list2}    Get Webelements    ${row2}
    @{list3}    Get Webelements    ${row3}
    @{list4}    Get Webelements    ${row4}

    ${text1}    Get Text    ${list1}[0]
    ${text2}    Get Text    ${list1}[1]
    ${text3}    Get Text    ${list2}[0]
    ${text4}    Get Text    ${list2}[1]
    ${text5}    Get Text    ${list3}[0]
    ${text6}    Get Text    ${list3}[1]
    ${text7}    Get Text    ${list4}[0]
    ${text8}    Get Text    ${list4}[1]
    @{data_list1}    create list
    ...    ${text1}
    ...    ${text2}
    ...    ${text3}
    ...    ${text4}
    ...    ${text5}
    ...    ${text6}
    ...    ${text7}
    ...    ${text8}
    IF    '${currentDay}'=='Sunday'
        Click element    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click element    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${sunday}
    END
    Sleep    2s
    @{list5}    Get Webelements    ${row1}
    @{list6}    Get Webelements    ${row2}
    @{list7}    Get Webelements    ${row3}
    @{list8}    Get Webelements    ${row4}

    ${text13}    Get Text    ${list5}[0]
    ${text14}    Get Text    ${list5}[1]
    ${text15}    Get Text    ${list6}[0]
    ${text16}    Get Text    ${list6}[1]
    ${text17}    Get Text    ${list7}[0]
    ${text18}    Get Text    ${list7}[1]
    ${text19}    Get Text    ${list8}[0]
    ${text20}    Get Text    ${list8}[1]
    @{data_list2}    create list
    ...    ${text13}
    ...    ${text14}
    ...    ${text15}
    ...    ${text16}
    ...    ${text17}
    ...    ${text18}
    ...    ${text19}
    ...    ${text20}
    Should be equal    ${data_list1}    ${data_list2}

Copy Schedule Data triton
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    Click element    ${copyButton}
    ${currentDay}    Get Current Date    result_format=%A
    IF    '${currentDay}'=='Monday'
        Click element    ${day_Tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${day_Wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${day_Thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${day_Friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${day_Saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${day_Sunday}
    ELSE IF    '${currentDay}'=='Sunday'
        Click element    ${day_Monday}
    END
    Click element    ${save_Copy_screen}
    Sleep    2s
    @{list1}    Get Webelements    ${row1}
    @{list2}    Get Webelements    ${row2}
    ${text1}    Get Text    ${list1}[0]
    ${text2}    Get Text    ${list1}[1]
    ${text3}    Get Text    ${list2}[0]
    ${text4}    Get Text    ${list2}[1]
    @{data_list1}    create list    ${text1}    ${text2}    ${text3}    ${text4}
    IF    '${currentDay}'=='Sunday'
        Click element    ${monday}
    ELSE IF    '${currentDay}'=='Monday'
        Click element    ${tuesday}
    ELSE IF    '${currentDay}'=='Tuesday'
        Click element    ${wednesday}
    ELSE IF    '${currentDay}'=='Wednesday'
        Click element    ${thursday}
    ELSE IF    '${currentDay}'=='Thursday'
        Click element    ${friday}
    ELSE IF    '${currentDay}'=='Friday'
        Click element    ${saturday}
    ELSE IF    '${currentDay}'=='Saturday'
        Click element    ${sunday}
    END
    Sleep    2s
    @{list5}    Get Webelements    ${row1}
    @{list6}    Get Webelements    ${row2}
    ${text5}    Get Text    ${list5}[0]
    ${text6}    Get Text    ${list5}[1]
    ${text7}    Get Text    ${list6}[0]
    ${text8}    Get Text    ${list6}[1]
    @{data_list2}    create list    ${text5}    ${text6}    ${text7}    ${text8}
    Should be equal    ${data_list1}    ${data_list2}

verify the Day Off schedule in triton
    Click element    ${scheduleButton}
    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    ${attribute}    Get element attribute    ${btnDayOff}    value
    IF    ${attribute}==0    Turn on/off the button    ${btnDayOff}
    Click element    ${saveSchedule}
    Wait until page contains element    ${equipmentCard}    ${defaultWaitTime}
    # Capture Screenshot
    Click element    ${scheduleButton}
    Wait until page contains element    ${copyButton}    ${defaultWaitTime}
    @{list1}    Get Webelements    ${row1}
    @{list2}    Get Webelements    ${row2}
    ${text1}    Get Text    ${list1}[1]
    ${text2}    Get Text    ${list2}[1]
    @{data_list1}    create list    ${text1}    ${text2}
    @{data_list2}    create list    Unoccupied    Unoccupied
    Should be equal    ${data_list1}    ${data_list2}

On/Off the Shutoff valve
    Wait until page contains element    ${btnSetting}    ${defaultWaitTime}
    Click element    ${btnSetting}
    Wait until page contains element    ${btnWaterShuttOff}    ${defaultWaitTime}
    Click element    ${textShutOff}
    Sleep    3s
    ${attribute}    get element attribute    ${btnWaterShuttOff}    value
    RETURN    ${attribute}

Select button shuttoff Valve
    ${location}    get element location    ${btnWaterShuttOff}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    Click element at coordinates    ${x}    ${y}

Resume Schedule
    Wait until page contains element    ${btnResume}    ${defaultWaitTime}
    Click element    ${btnResume}
    Sleep    10s

Verify Schedule Overridden Message
    [Arguments]    ${msgSchedule}
    Wait until page contains element    ${msgSchedule}    ${defaultWaitTime}
    ${message}    Get text    ${msgSchedule}
    ${status}    check    ${message}    Schedule overridden
    ${verifiedStatus}    convert to boolean    True
    Should be equal    ${status}    ${verifiedStatus}

Get Trmperatre And Mode from Current Schedule New ECC
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}

    ${location}    Get element location    ${timeSchedule}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    ${endY}    Evaluate    ${y}-100
    Swipe    ${x}    ${y}    ${x}    ${endY}
    Sleep    3s
    ${heatTemp}    Get Text    ${heatBubble}
    ${coolTemp}    Get Text    ${coolBubble}
    ${mode}    Get Text    ${modeSchedule}
    ${sclist}    create list    ${heatTemp}    ${coolTemp}    ${mode}

    Navigate Back to the Screen
    RETURN    ${sclist}

Verify and enable energy saving
    wait until page contains    ${energySavingText}    ${defaultWaitTime}
    page should contain element    ${enableTab}
    Click element    ${enableTab}
    Sleep    5s

Set Schedule using button
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}

    ${currentTime}    Get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Scroll Up    ${heatBubble}
    Sleep    2s
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    ${attribute}    Get element attribute    ${scheduleToggle}    value
    IF    ${attribute}==0    Turn on schedule toggle
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    ${savebutton01}
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    ${tempDashboard}    Get current temperature from mobile app
    Wait until page contains element    ${followScheduleMsgDashboard}    ${defaultWaitTime}
    Should be equal    ${scheduled_temp}    ${tempDashboard}
    ${list}    Create list    ${scheduled_temp}    ${deviceName}
    RETURN    ${list}

Get Temperature And Mode From Current Schedule Slot
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    ${updatedTemp}    Get Text    ${currentTempCenter}
    ${scheduled_temp}    Convert To Integer    ${updatedTemp}
    Navigate Back to the Sub Screen
    Navigate Back to the Sub Screen
    Sleep    2s
    RETURN    ${scheduled_temp}


Get Temperature And Mode From Current Schedule Slot without mode
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}

    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    Wait Until Element is Visible    ${currentTemp1}    ${defaultWaitTime}
    ${tempDashboard}    Get Text    ${currentTemp1}
    Sleep    5s
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    Sleep    5s
    ${abc}    run keyword and return status    Click element    ${modebackbuttonidentifier}

    ${tempDashboard}    Convert to integer    ${tempDashboard}
    RETURN    ${tempDashboard}

Get Temperatre And Mode from Current Schedule ECC
    [Arguments]    ${deviceName}
    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}

    Wait until page contains element    ${timeSchedule}    ${defaultWaitTime}
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${coolTemp}    Get Text    ${HvacScheduleCoolTemp}
    ${coolTemp}    Get substring    ${coolTemp}    0    -1
    ${heatTemp}    Get Text    ${HvacScheduleHeatTemp}
    ${heatTemp}    Get substring    ${heatTemp}    0    -1
    Sleep    5s
    Navigate Back to the Sub Screen
    RETURN    ${heatTemp}    ${coolTemp}


Get Temperatre And Mode from Current Schedule New ECC Button Slider
    [Arguments]    ${deviceName}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    time1
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Sleep    2s
    ${scheduledHeat_temp}    Get Text    ${heatBubble}
    ${scheduledHeat_temp}    Get Substring    ${scheduledHeat_temp}    0    -1
    ${scheduledCool_temp}    Get Text    ${coolBubble}
    ${scheduledCool_temp}    Get Substring    ${scheduledCool_temp}    0    -1
    Wait Until Element Is Visible    Save    ${defaultWaitTime}
    Click element    Save
    Sleep    5s
    ${Status}    run keyword and return status    Click element    ${modebackbuttonidentifier}
    ${list}    Create list    ${scheduledHeat_temp}    ${scheduledCool_temp}
    RETURN    ${list}

Update Cooling Setpoint Using Button
    [Arguments]    ${button}

    ${status}    run keyword and return status    Wait until page contains element    ${buttons_type}    ${defaultWaitTime}
    IF    ${status}==True    Click element    ${buttons_type}
    Sleep    2s
    Wait until page contains element    ${button}    ${defaultWaitTime}
    Click element    ${button}
    Sleep    10s
    Navigate Back to the Screen
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    Wait until page contains element    ${coolTempButton}    ${defaultWaitTime}
    ${temp}    Get Text    ${coolTempButton}
    ${status}    run keyword and return status    Wait until page contains element    ${slider_type}    ${defaultWaitTime}
    IF    ${status}==True    Click element    ${slider_type}
    Sleep    2s
    RETURN    ${temp}


Update Heating Setpoint Using Button
    [Arguments]    ${button}

    ${status}    run keyword and return status    Wait until page contains element    ${buttons_type}    ${defaultWaitTime}
    IF    ${status}==True    Click element    ${buttons_type}
    Sleep    2s
    Wait until page contains element    ${button}    ${defaultWaitTime}
    Click element    ${button}
    Sleep    10s
    Navigate Back to the Screen
    Go to Temp Detail Screen    ${thermostatCardCurrentValueIdentifier}
    ${temp}    Get Text    ${heatTempButton}

    ${status}    run keyword and return status    Wait until page contains element    ${slider_type}    ${defaultWaitTime}
    IF    ${status}==True    Click element    ${slider_type}
    Sleep    2s
    RETURN    ${temp}


Update Fanspeed Using Button
    [Arguments]    ${button}
    Wait until page contains element    ${button}    ${defaultWaitTime}
    Click element    ${button}
    Sleep    10s
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    ${temp}    Get Text    ${currentTemp}
    RETURN    ${temp}

Change Humidity ECC
    Wait until page contains element    ${currentTemp}    ${defaultWaitTime}
    Wait until page contains element    thermostatHumidityButton    ${defaultWaitTime}
    Click element    thermostatHumidityButton
    Sleep    2s
    Scroll Up
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeSlider
    Sleep    2s
    ${Humidityvalue}    Get Text
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeSlider/XCUIElementTypeStaticText
    Sleep    2s
    ${Humidityvalue}    Get Substring    ${Humidityvalue}    0    -1
    Click element    ${modebackbuttonidentifier}
    RETURN    ${Humidityvalue}


click at humidity
    [Arguments]    ${locator}
    ${size}    Get Element Size    ${locator}
    ${height}    Get Value From Json    ${size}    $..height
    ${width}    Get Value From Json    ${size}    $..width
    ${location}    Get element location    ${locator}
    ${width_3}    Evaluate    ${width}[0]/3
    ${xHumidity}    Evaluate    ${width}[0] - ${width_3}
    ${x}    Evaluate    str(${xHumidity} + ${width_3}/2)
    ${y}    Evaluate    str(${location}[y] + ${height}[0]/2)
    Click element At Coordinates    ${x}    ${y}

Change Mode Heat Pump G5
    [Arguments]    ${requiredMode}
    wait until page contains    ${waterHeaterModeButton}    ${defaultWaitTime}
    Select element using coordinate    ${waterHeaterModeButton}    10    5
    wait until page contains    ${requiredMode}    ${defaultWaitTime}
    Select element using coordinate    ${requiredMode}    10    5
    RETURN    1

Enable Or Disable HPWH Gen5
    [Arguments]    ${requiredMode}

    wait until page contains    State    ${defaultWaitTime}
    Click element    State
    wait until page contains    ${requiredMode}    ${defaultWaitTime}
    Select element using coordinate    ${requiredMode}    10    5
    RETURN    1


Verify Device Health Status Page
    Click element    ${deviceHealth}
    Wait until page contains element    Compressor Health    ${defaultWaitTime}
    Wait until page contains element    Product Health    ${defaultWaitTime}
    Sleep    2s
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click element    ${modebackbuttonidentifier}
    Sleep    5s

Navigate to General Settings
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

    Wait until page contains element    General    ${defaultWaitTime}
    Click element    General

Click Save button of Away Settings
    Wait until page contains element    ${btnSavechanges}    ${defaultWaitTime}
    Click element at mid point    ${btnSavechanges}
    Sleep    5s
    Run Keyword and Ignore Error    Click element    Ok

Click Edit Delete Contractor and Location Setting
    [Arguments]    ${locator}
    Wait until page contains element    ${locator}    ${defaultWaitTime}
    ${location}    Get element location    ${locator}
    ${x}    Evaluate    str(${location}[x] + 7)
    ${y}    Evaluate    str(${location}[y] + 7)
    Click element At Coordinates    ${x}    ${y}

Change Geofencing Distance Unit
    [Arguments]    ${unit}
    Click element at mid point    ${geoUnitName}
    Click element at mid point    ${unit}
    Wait until page contains element    ${geoUnitName}    ${defaultWaitTime}
    Click Save button of Away Settings
    page should contain element    ${unit}

Change Geofencing Radius
    Wait until page contains element    ${awayGeoFencing}    ${defaultWaitTime}
    ${location}    get element location    ${awayGeoFencing}
    ${x}    Evaluate    str(${location}[x])
    ${y}    Evaluate    str(${location}[y])
    Click element at coordinates    ${x}    ${y}
    Sleep    5s
    Click Element    Radius
    Sleep    2s
    Wait until page contains element    Map pin    ${defaultWaitTime}
    Wait until page contains element    ${GeoFencingSlider}    ${defaultWaitTime}

    ${location}    get element location    ${GeoFencingSlider}
    ${x}    Evaluate    str(${location}[x])
    ${x1}    Evaluate    int(${x}) + int(${x})

    ${y}    Evaluate    str(${location}[y])
    Swipe    ${x}    ${y}    ${x}    ${y}

Enable or Disable Geofencing
    [Arguments]    ${operation}

    Wait until page contains element    ${txtGeofencing}    ${defaultWaitTime}
    Click element    ${txtGeofencing}
    Sleep    2s
    Wait until page contains element    ${geoFenceButton}    ${defaultWaitTime}
    ${on/off}    Get Element Attribute    ${geoFenceButton}    value
    IF    '${operation}'=='On' and '${on/off}'=='Off'
        Click element    ${geoFenceButton}
    ELSE IF    '${operation}'=='Off' and '${on/off}'=='On'
        Click element    ${geoFenceButton}
    END
    Click Save button of Away Settings
    Sleep    10s
    RUN KEYWORD AND IGNORE ERROR    Click element    ${okButton}

Add HomeRouter SSID Manually
    [Arguments]    ${ssid}    ${password}    ${security}
    Wait until page contains element    ${homeWifiConn}    ${defaultWaitTime}
    Click element    ${homeWifiConn}
    Wait until page contains element    ${btnAdd}    ${defaultWaitTime}
    Click element    ${btnAdd}
    Wait until page contains element    ${txtBxAddSSID}    ${defaultWaitTime}
    Sleep    3s
    Input text    ${txtBxAddSSID}    ${ssid}
    Sleep    3s
    Wait until page contains element    Security type    ${defaultWaitTime}
    Click element    Security type

    Wait until page contains element    ${security}    ${defaultWaitTime}
    Click element    ${security}
    Sleep    3s
    IF    '${security}' != 'None'
        Input text    ${ssidPassword}    ${password}
    END
    Sleep    3s
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Click element    ${saveButton1}
    Sleep    3s

Edit HomeRouter SSID name
    [Arguments]    ${name}
    Wait until page contains element    ${homeWifiConn}    ${defaultWaitTime}
    Click element    ${homeWifiConn}
    Wait until page contains element    //XCUIElementTypeButton[@name="editZone"][1]    ${defaultWaitTime}
    Click element    //XCUIElementTypeButton[@name="editZone"][1]
    Wait until page contains element    ${txtBxAddSSID}    ${defaultWaitTime}
    Clear Text    ${txtBxAddSSID}
    Input Text    ${txtBxAddSSID}    ${name}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Wait until page contains element    ${saveButton1}    ${defaultWaitTime}
    Click element    ${saveButton1}
    Sleep    3s

Remove HomeRouter SSID
    Wait until page contains element    ${homeWifiConn}    ${defaultWaitTime}
    Click element    ${homeWifiConn}
    Sleep    3s
    Wait until page contains element    //XCUIElementTypeButton[@name="deleteBin"][1]    ${defaultWaitTime}
    Click element    //XCUIElementTypeButton[@name="deleteBin"][1]

    Wait until page contains element    Are you sure?    ${defaultWaitTime}
    Click element    Yes
    Sleep    2s

Add EcoNet WiFi Connections
    [Arguments]    ${name}

    Wait until page contains element    EcoNet WiFi Connections    ${defaultWaitTime}
    Click element    EcoNet WiFi Connections

    Wait until page contains element    ${btnAdd}    ${defaultWaitTime}
    Click element    ${btnAdd}

    Wait until page contains element    ${txtBxAddSSID}    ${defaultWaitTime}
    Input Text    ${txtBxAddSSID}    ${name}

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Click element    ${saveButton1}
    Sleep    3s

Edit EcoNet WiFi Connections
    Wait until page contains element    EcoNet WiFi Connections    ${defaultWaitTime}
    Click element    EcoNet WiFi Connections
    Wait until page contains element    //XCUIElementTypeButton[@name="editZone"][1]    ${defaultWaitTime}
    Click element    //XCUIElementTypeButton[@name="editZone"][1]
    Wait until page contains element    ${txtBxAddSSID}    ${defaultWaitTime}
    Clear Text    ${txtBxAddSSID}
    ${name}    generate random string    5    [LOWER]
    Input Text    ${txtBxAddSSID}    ${name}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Wait until page contains element    ${saveButton1}    ${defaultWaitTime}
    Click element    ${saveButton1}
    Sleep    3s

Remove EcoNet Wifi connection
    Wait until page contains element    ${homeWifiConn}    ${defaultWaitTime}
    Click element    ${homeWifiConn}
    Sleep    3s
    Wait until page contains element    //XCUIElementTypeButton[@name="deleteBin"][1]    ${defaultWaitTime}
    Click element    //XCUIElementTypeButton[@name="deleteBin"][1]

    Wait until page contains element    Are you sure?     ${defaultWaitTime}
    Click element    Yes
    Sleep    2s

Change shutoff valve configuration
    [Arguments]    ${mode}
    FOR    ${i}    IN RANGE    0    4
        ${value}    get element attribute    ${valveMode}    value
        ${value}    strip string    ${value}
        IF    '${value}' == '${mode}    BREAK
        Click element    ${valveForward}
    END

Change Recirc Pump Configuration
    [Arguments]    ${mode}
    FOR    ${i}    IN RANGE    0    5
        ${value}    get element attribute    ${recircMode}    value
        ${value}    strip string    ${value}
        IF    '${value}' == '${mode}    BREAK
        Click element    ${recircForward}
    END

Change the Status of device if Device is in away mode
    ${Status}    Run keyword and Return Status
    ...    Wait untill Element is visible
    ...    ${awayModeText}
    ...    ${defaultWaitTime}
    IF    ${Status}==True
        Wait untill Element is visible    ${awayModeText}    ${defaultWaitTime}
        Click element    ${awayModeText}
        Wait Until Element is Visible    ${homeModeText}    ${defaultWaitTime}
    END

Navigate to the Product Settings Screen
    Wait until page contains element    ${ProductSetting}    ${defaultWaitTime}
    Click element at mid point    ${ProductSetting}

Enable/Disable Water Save From Product Settings
    [Arguments]    ${valuetoggle}
    Wait until page contains element    ${slotSwitcherIdentifier}    30s
    Click element    ${slotSwitcherIdentifier}
    ${Status}    Get Text    ${slotSwitcherIdentifier}
    IF    "${Status}"=="${valuetoggle}"
        Click element    ${slotSwitcherIdentifier}
    END
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click element    ${modebackbuttonidentifier}

Set Altitude From Product Settings Screen
    [Arguments]    ${AltitudeValue}

    Wait until page contains element    Altitude    ${defaultWaitTime}
    Click element    Altitude
    Sleep    1s
    Wait until page contains element    ${AltitudeValue}
    Click element    ${AltitudeValue}
    Sleep    4s
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

Set Recirc Pump Operations From the Product Settings Screen
    [Arguments]    ${Pumpvalue}

    Wait until page contains element    Mode    ${defaultWaitTime}
    Click element    Mode
    Sleep    1s
    Wait until page contains element    ${Pumpvalue}    ${defaultWaitTime}
    Click element    ${Pumpvalue}
    Sleep    4s
    Wait until page contains element    ${modebackbuttonidentifier}    ${defaultWaitTime}
    Click element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

Verify Burn Time Value
    [Arguments]    ${Burntimevalue}

    Wait until page contains element    ${Burntimevalue}    ${defaultWaitTime}

Enable Away Setting
    [Arguments]    ${LocationName}

    Wait until page contains element    ${okButton}    ${defaultWaitTime}
    Click element    ${okButton}
    Wait until page contains element    ${awaySwitch}    ${defaultWaitTime}
    Click element    ${awaySwitch}
    Wait until page contains element    ${savebutton01}    ${defaultWaitTime}
    Click element    btnSave
    Wait until page contains element    Ok    ${defaultWaitTime}
    Click element    Ok
    Sleep    5s
    Navigate Back to the Screen
    Click element    ${awayText}
    Sleep    2s

Swipe Down
    [Arguments]    ${Locator}
    ${element_size}    Get Element Size    ${Locator}
    ${element_location}    Get Element Location    ${Locator}
    ${start_x}    Evaluate    ${element_location['x']} + (${element_size['width']} * 0.5)
    ${start_y}    Evaluate    ${element_location['y']} + (${element_size['height']} * 0.7)
    ${end_x}    Evaluate    ${element_location['x']} + (${element_size['width']} * 0.5)
    ${end_y}    Evaluate    ${element_location['y']} + (${element_size['height']} * 0.3)
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    500
    Sleep    1

Create Away schedule Event for device
    [Arguments]    ${locationVal}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

    Wait until page contains element    ${txtScheduleAway}    ${defaultWaitTime}
    Click element    ${txtScheduleAway}

    Wait until page contains element    ${locationVal}    ${defaultWaitTime}
    Click element    ${locationVal}

    Wait until page contains element    ${btnStartDate}    ${defaultWaitTime}
    Click element    ${btnStartDate}

    Wait until page contains element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    ...    ${defaultWaitTime}
    Click element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}

    Wait until page contains element    ${btnEndDate}    ${defaultWaitTime}
    Click element    ${btnEndDate}

    Wait until page contains element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    Click element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}

    Wait until page contains element    ${saveButton1}    ${defaultWaitTime}
    Click element    ${saveButton1}

    Wait until page contains element    Ok    ${defaultWaitTime}
    Click element    Ok

    Sleep    5s
    run keyword and ignore error    Click element    ${modebackbuttonidentifier}

    Navigate Back to the Screen

Create Home schedule Event for device
    [Arguments]    ${locationVal}
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

    Wait until page contains element    ${txtScheduleAway}    ${defaultWaitTime}
    Click element    ${txtScheduleAway}

    Wait until page contains element    ${locationVal}    ${defaultWaitTime}
    Click element    ${locationVal}

    Wait until page contains element    State    ${defaultWaitTime}
    Click element    State

    Wait until page contains element    Home    ${defaultWaitTime}
    Click element    Home

    Sleep    5s

    Wait until page contains element    ${btnStartDate}    ${defaultWaitTime}
    Click element    ${btnStartDate}

    Wait until page contains element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    ...    ${defaultWaitTime}
    Click element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}

    Wait until page contains element    ${btnEndDate}    ${defaultWaitTime}
    Click element    ${btnEndDate}

    Wait until page contains element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther
    Click element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther

    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}

    Wait until page contains element    ${saveButton1}    ${defaultWaitTime}
    Click element    ${saveButton1}

    ${Status}    Run Keyword and Return Status    Wait until page contains element    Ok    ${defaultWaitTime}
    IF    ${Status}    Click element    Ok
    Sleep    5s
    run keyword and ignore error    Click element    ${modebackbuttonidentifier}
    Navigate Back to the Screen

Read and verify the text
    ${path}    capture screenshot
    convert_image_text    ${path}

Get setpoint from equipmet card
    [Arguments]    ${tempDashBoard}
    Sleep    5s
    Wait until page contains element    ${tempDashBoard}    ${defaultWaitTime}
    ${text}    Get Text    ${tempDashBoard}
    ${text}    Get Substring    ${text}    0    -1
    ${Setpoint_Equipmet}    Convert To Integer    ${text}
    RETURN    ${Setpoint_Equipmet}

Get dashboard value from equipment card
    [Arguments]    ${valDashBoard}
    Sleep    1s
    Wait until page contains element    ${valDashBoard}    ${defaultWaitTime}
    ${text}    Get Text    ${valDashBoard}
    RETURN    ${text}

Capture Screenshot
    ${filename}    get_filename
    ${filePath}    catenate    ${pathScreenShot}${filename}
    ${pathScreenShot}    get_pathFile    ${filePath}
    Capture Page Screenshot    ${pathScreenShot}
    RETURN    ${pathScreenShot}

Create Account
    [Arguments]    ${emailID}    ${number}    ${password}    ${confirmPassword}

    Wait until page contains element    ${btnCreateAccount}    ${defaultWaitTime}
    Click element    ${btnCreateAccount}
    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}
    Input text    ${txtBxEmailAddress}    ${emailID}
    Input text    ${txtBxPhoneNumber}    ${number}
    Input text    ${txtBxPassword}    ${password}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Sleep    1s
    Input text    ${txtBxCnfrmPasswrd}    ${password}
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}

Enter validation code
    Wait until page contains element    ${OTPScreen}    ${defaultWaitTime}
    Input text    ${OTPScreen}    111111
    Click element    ${ValidateButton}
    Sleep    5s
    Click Element    Ok

Log out from the Application
    Go To Menu
    Wait until page contains element    ${txtLogout}    ${defaultWaitTime}
    Click element    ${txtLogout}
    Wait until page contains element    ${txtOk}    ${defaultWaitTime}
    Click element    ${txtOk}
    Wait until page contains element    ${imageLogo}    ${defaultWaitTime}
    Page should contain element    ${imageLogo}

Manage the zone
    ${i}    Set Variable    1
    FOR    ${temp1}    IN RANGE    1    4
        ${zoneName}    Get text    //XCUIElementTypeOther[${i}]/XCUIElementTypeTextField
        IF    '${zoneName}'=='${locationNameZoning}'
            Click element
            ...    //XCUIElementTypeOther[${i}]/XCUIElementTypeTextField/following-sibling::XCUIElementTypeButton[@name="accordion collasped"]
        END
        Sleep    1s
        ${i}    Evaluate    ${i}+2
        IF    ${i}>4    BREAK
    END

Sign in to the application
    [Arguments]    ${emailId}    ${passwordValue}
    Sleep    3s
    ${present}    Run Keyword And Return Status    Page Should Contain Element    ${txtAllowmsg}
    IF    ${present}    Handle Allow Location popup    ${txtAllowmsg}

    ${present}    Run Keyword And Return Status    Wait until page contains element    ${btnAllow}    5s
    IF    ${present}
        Select element using coordinate    ${btnAllow}    65    20
    END
    Sleep    3s
    ${present}    Run Keyword And Return Status    Page Should Contain Element    ${txtAllowmsg}
    IF    ${present}    Handle Allow Location popup    ${txtAllowmsg}
    Sleep    10s
    Wait until page contains element    ${imageLogo}    ${defaultWaitTime}
    Page Should Contain Element    ${imageLogo}
    Tap    ${imageLogo}    count=3
    Sleep    10s
    Wait until page contains element    Production    ${defaultWaitTime}
    Click element    Production
    Sleep    6s
    Wait until page contains element    Sign In    ${defaultWaitTime}
    Select element using coordinate    Sign In    10    5
    Sleep    3s
    Wait until page contains element    ${txtBxEmailAddress}    ${defaultWaitTime}
    Input Text    ${txtBxEmailAddress}    ${emailId}
    Sleep    3s
    Wait until page contains element    ${txtBxPassword}    ${defaultWaitTime}
    Input Password    ${txtBxPassword}    ${passwordValue}
    Sleep    3s
    Wait until page contains element    ${keyboardDoneButton}    ${defaultWaitTime}
    Click element    ${keyboardDoneButton}
    Wait until page contains element    ${sign_in_link}    ${defaultWaitTime}
    Click element    ${sign_in_link}
    Sleep    5s
    ${status}    run keyword and return status    Wait until page contains element    ${txtNotNow}    120s
    IF    ${status}    Click element    ${txtNotNow}

Go To Menu
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

Sign Out From the Application
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${txtLogout}    ${defaultWaitTime}
    Click element    ${txtLogout}
    Sleep    2s
    Wait until page contains element    Ok    ${defaultWaitTime}
    Click element    Ok
    Sleep    5s

Verify Device Alerts
    [Arguments]    ${name}=DeviceName

    ${Status}    Run Keyword And Return Status
    ...    Wait until page contains element
    ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]
    IF    ${Status}==True
        Wait until page contains element
        ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]
        Click element
        ...    //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[1]
        Wait until page contains element    //XCUIElementTypeStaticText[@name="Forward to Contractor"]
        Wait until page contains element    //XCUIElementTypeStaticText[@name="Clear Alert"]
        Click element    //XCUIElementTypeStaticText[@name="Forward to Contractor"]
        Sleep    5s
        Wait until page contains element
        ...    //XCUIElementTypeSheet[@name="Choose Contractor"]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeScrollView[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]
        Click element    Cancel
        Wait until page contains element    //XCUIElementTypeStaticText[@name="Clear Alert"]
        Click element    //XCUIElementTypeStaticText[@name="Clear Alert"]
        Click element    Ok
        Sleep    5s
    END
    Navigate Back to the Sub Screen

Set Point in Schedule Screen
    [Arguments]    ${SetPoint}    ${Locator}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}
    Wait Until Element is Visible    ${currentTempCenter}    ${defaultWaitTime}
    ${temp}    Get Text    ${currentTempCenter}
    FOR    ${temp}    IN RANGE    60
        ${updatedTemp}    Get Text    ${currentTempCenter}
        IF    ${updatedTemp} == ${SetPoint}    BREAK
        Click element    ${Locator}
        Sleep    2s
    END
    Should be equal as integers    ${updatedTemp}    ${SetPoint}
    Wait Until Element Is Visible    ${saveButton}    ${defaultWaitTime}
    Click element    ${saveButton}
    Navigate Back to the Sub Screen

Set Point in Schedule Screen for HVAC
    [Arguments]    ${heat}    ${cool}    ${HeatLocator}    ${coolLocator}

    Wait until page contains element    ${scheduleButton}    ${defaultWaitTime}
    Click element    ${scheduleButton}
    Sleep    10s
    Wait Until Element is Visible    ${schedule_firstrow_time}    ${defaultWaitTime}
    ${time0}    Get Text    ${schedule_firstrow_time}
    Wait Until Element is Visible    ${schedule_secondrow_time}    ${defaultWaitTime}
    ${time1}    Get Text    ${schedule_secondrow_time}
    Wait Until Element is Visible    ${schedule_thirdrow_time}    ${defaultWaitTime}
    ${time2}    Get Text    ${schedule_thirdrow_time}
    Wait Until Element is Visible    ${schedule_fourthrow_time}    ${defaultWaitTime}
    ${time3}    Get Text    ${schedule_fourthrow_time}
    ${currentTime}    get current date    result_format=%I:%M %p
    ${time024}    timeConversion    ${time0}
    ${time124}    timeConversion    ${time1}
    ${time224}    timeConversion    ${time2}
    ${time324}    timeConversion    ${time3}
    ${currenttime024}    timeConversion    ${currentTime}
    ${time024}    Convert to integer    ${time024}
    IF    ${time024} <= ${currenttime024} < ${time124}
        Set global variable    ${status}    ${schedule_firstrow_time}
    ELSE IF    ${time124} <= ${currenttime024} < ${time224}
        Set global variable    ${status}    ${schedule_secondrow_time}
    ELSE IF    ${time224} <= ${currenttime024} < ${time324}
        Set global variable    ${status}    ${schedule_thirdrow_time}
    ELSE IF    ${time324} <= ${currenttime024} < ${time024}
        Set global variable    ${status}    ${schedule_fourthrow_time}
    ELSE
        Set global variable    ${status}    ${schedule_fourthrow_time}
    END
    Wait Until Element Is Visible    ${status}    ${defaultWaitTime}
    Click element    ${status}

    ${temp}    Get Text    ${heatbubble}
    ${temp}    Get Substring    ${temp}    0    -1
    FOR    ${temp}    IN RANGE    60
        ${heatupdatedTemp}    Get Text    ${heatbubble}
        ${heatupdatedTemp}    Get Substring    ${heatupdatedTemp}    0    -1
        IF    ${heatupdatedTemp} == ${heat}    BREAK
        Wait until page contains element    ${buttons_type}     ${defaultWaitTime}
        Click element    ${buttons_type}
        Wait until page contains element    ${coolLocator}      ${defaultWaitTime}
        Click element    ${coolLocator}
        Wait until page contains element    ${slider_type}      ${defaultWaitTime}
        Click element    ${slider_type}
        Sleep    2s
    END
    ${temp}    Get Text    ${coolBubble}
    ${temp}    Get Substring    ${temp}    0    -1
    FOR    ${temp}    IN RANGE    60
        ${coolupdatedTemp}    Get Text    ${coolBubble}
        ${coolupdatedTemp}    Get Substring    ${coolupdatedTemp}    0    -1
        IF    ${coolupdatedTemp} == ${cool}    BREAK
        Wait until page contains element    ${buttons_type}    ${defaultWaitTime}
        Click element    ${buttons_type}
        Wait until page contains element    ${coolLocator}      ${defaultWaitTime}
        Click element    ${coolLocator}
        Wait until page contains element    ${slider_type}     ${defaultWaitTime}
        Click element    ${slider_type}
        Sleep    2s
    END

    Should be equal as integers    ${coolupdatedTemp}    ${cool}
    Should be equal as integers    ${heatupdatedTemp}    ${heat}
    Wait Until Element Is Visible    ${saveButton}    ${defaultWaitTime}
    Click element    ${saveButton}

Navigate to the Energy & Savings
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}
    Wait until page contains element    ${EnergySavings}    ${defaultWaitTime}
    Click element    ${EnergySavings}

Go to Menubar
    Wait until page contains element    ${btnMenu}    ${defaultWaitTime}
    Click element    ${btnMenu}

Create DR Program Request

    Wait until element is visible    ${DRProgramCard}    10s
    Click Element    ${DRProgramCard}
    Wait until element is visible   programSignUpIdentifier    30s
    Click Element    programSignUpIdentifier
    FOR    ${temp}    IN RANGE    3
        ${Status}    Run Keyword And Return Status    Wait until element is visible    ${DRSignUpCheckbox}    ${defaultwaittime}
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        Sleep    2s
    END
    Wait until element is visible    ${DRSignUpCheckbox}    ${defaultwaittime}
    Click Element    ${DRSignUpCheckbox}
    Click Text    Continue
    Sleep    2s
    FOR    ${temp}    IN RANGE    4
        ${Status}    Run Keyword And Return Status    Element Should Be Enabled    agreeTermsConditionButton
        IF    ${Status} == False
            Swipe    400    1500    400    1000    2000
        ELSE
            BREAK
        END
        sleep    2s
    END

    Click Element   agreeTermsConditionButton

Navigate to the Energy & Savings Page

    Click Text    Energy & Savings
    Sleep    20s

Select Location from Energy & Savings Screen
    [Arguments]    ${locationname}    ${devicename}

    Wait Until Element is visible     ${DRLocationSelection}
    Click Element    ${DRLocationSelection}

    Sleep  2s
    Click Text    ${locationname}
    Click Text    ${devicename}
    Sleep    20s