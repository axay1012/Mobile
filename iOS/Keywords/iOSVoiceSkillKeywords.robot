*** Settings ***
Library             /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/src/voiceskill_helper.py

Library             AppiumLibrary    run_on_failure=No Operation
Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             ../src/RheemMqtt.py

Resource            ../Locators/iOSConfig.robot
Resource            ../Locators/iOSLocators.robot
Resource            ../Locators/iOSLabels.robot
Resource            ../Keywords/iOSMobileKeywords.robot
Resource            ../Keywords/MQttKeywords.robot
Resource            ../Keywords/iOSVoiceSkillKeywords.robot


*** Keywords ***
Google Communication with Question
    [Arguments]    ${speaker}    ${question}    ${expected_answer}    ${language}
    Log    \n\n===> Starting commnunication    console=yes
    ${status}    ${response}    alexa_comm   ${question}    ${expected_answer}    ${language}
    Log    Response status: ${status}    console=yes
    RETURN    ${status}    ${response}

Alexa Communiation with Question
    [Arguments]    ${speaker}    ${question}    ${expected_answer}    ${language}
    Log    \n\n===> Starting commnunication    console=yes
    ${status}    ${response}    alexa_comm    ${question}    ${expected_answer}    ${language}
    Log    Response status: ${status}    console=yes
    RETURN    ${status}    ${response}
