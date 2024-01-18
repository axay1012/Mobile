*** Settings ***
Library     AppiumLibrary


*** Variables ***
${REMOTE_URL}           http://localhost:4732/wd/hub
${PLATFORM_NAME}        iOS
${DEVICE_NAME}          iPhone
${APP_LOCATION}         %{AppPath}
${BUNDLE_ID}            com.rheem.econetprods
${AUTOMATION_NAME}      XCUITest
${PLATFORM_VERSION}     14.6
${bootstrapPath}        /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent
${agentPath}            /usr/local/lib/node_modules/appium/node_modules/appium-webdriveragent/WebDriverAgent.xcodeproj
${SCREENSHOT_FOLDER}    ../screenshots/
${noReset}              false
${fullReset}            false
${TIME_OUT}             120000
${pathScreenShot}       /results/screenshots/
${iPhone}               iPhone


*** Keywords ***
Open App
    start appium    4732
    Open Application
    ...    remote_url=${REMOTE_URL}
    ...    newCommandTimeout=${TIME_OUT}
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${iPhone}
    ...    app=${APP_LOCATION}
    ...    udid=${DeviceName}
    ...    bootstrapPath=${bootstrapPath}
    ...    agentPath=${agentPath}
    ...    noReset=${noReset}
    ...    fullReset=${fullReset}
    ...    wdaLocalPort=${wdaLocalPort}

Open App again
    Open Application
    ...    remote_url=${REMOTE_URL}
    ...    newCommandTimeout=${TIME_OUT}
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_LOCATION}
    ...    udid=${DeviceName}
    ...    bootstrapPath=${bootstrapPath}
    ...    agentPath=${agentPath}
    ...    noReset=${noReset}
    ...    fullReset=${fullReset}
    ...    wdaLocalPort=${wdaLocalPort}

Close All Apps
    close_application
    stop appium    ${AppiumPort}
