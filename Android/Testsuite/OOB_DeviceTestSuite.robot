*** Settings ***
Documentation       Contains Test cases for OOB Device.

Library             OperatingSystem
Library             Process
Resource             /Users/shraddha.shah/Desktop/gitReskin/Reskin_Automation_Master/Reskin_EndToEnd_Automation-QA/Android/Locators/Androidconfig.robot

Resource            EloKeywords.robot

*** Test Cases ***

TC-01:Verify the Online Device and Email Address from Diagnostics Screen
    Androidconfig.Open App
    Unlock Control Panel
    Select the Right Left Option button
    Select the Admin option
    Enter the Admin Password
    Click on the Settings Button
    Choose the Settings Diagnostics
    Check the Device Online status or not
    Verify Registered Email ID on Diagnostics Page
