*** Settings ***
Library   AppiumLibrary
Library    ../../src/common/Android_Handler.py

*** Variables ***
${SYSKEY}    		    84ed919e0bd6f5edf6d2f79fae28
${SECKEY}    		    D0CDDCAF0BC4D18F94AC89EEC6D501
${URL}    		        https://rheemdev.clearblade.com
${PLATFORM_NAME}        %{PlatformName}
${APP_LOCATION}         %{AppPath}
${APP_ACTIVITY}         %{APP_ACTIVITY}
${App_Package}          com.rheem.econetconsumerandroid
${AUTOMATION_NAME}      uiautomator2
${SCREENSHOT_FOLDER}    ../screenshots/
${TIME_OUT}             100000
${Default_Timeout}      10s
${REMOTE_URL}           http://localhost:${AppiumPort}/wd/hub
${appiumPort}           ${AppiumPort}
${DeviceName}           ${DeviceName}


*** Keywords ***

Open App
    start_appium  ${AppiumPort}
    open application   ${REMOTE_URL}
    ...  platformName=${PLATFORM_NAME}
    ...  platformVersion=${PLATFORMVERSION}
    ...  deviceName=${DeviceName}
    ...  appPackage=${App_Package}
    ...  appActivity=${APP_ACTIVITY}
    ...  automationName=${AUTOMATION_NAME}
    ...  newCommandTimeout=${TIME_OUT}

open App again
    open application   ${REMOTE_URL}
    ...  platformName=${PLATFORM_NAME}
    ...  platformVersion=13
    ...  deviceName=${DeviceName}
    ...  appPackage=${App_Package}
    ...  appActivity=${APP_ACTIVITY}
    ...  automationName=${AUTOMATION_NAME}
Close All Apps
   Quit application
   Close All Applications
   stop appium  ${AppiumPort}

Get Android Platform Version
    ${PLATFORM_VERSION}       getAndroidVersion
    set global variable       ${PLATFORM_VERSION}     ${PLATFORM_VERSION}