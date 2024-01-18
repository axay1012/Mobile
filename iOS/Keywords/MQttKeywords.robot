*** Settings ***
Documentation       This file consist Rheem End Device MQTT Keywords.

Library             RequestsLibrary
Library             Collections
Library             String
Library             OperatingSystem
Library             DateTime
Library             /Users/shraddha.shah/Desktop/Reskin_Automation/Reskin_EndToEnd_Automation-QA/src/RheemMqtt.py


*** Variables ***
${logOverConsole}       True


*** Keywords ***
Write objvalue From Mobile Application
    [Documentationz]    Write object value from mobile
    ...    *Args:*
    ...    - ${write_valuel} - Object value that needs to be parse
    ...    - ${objl} - Object name
    ...    - ${Device_Namel} - Device name in str type
    ...    - ${Account_idl} - Account Id
    ...    - ${serial_Number} - End device serial number in str type
    ...
    [Arguments]    ${write_valuel}    ${objl}    ${Device_Namel}    ${Account_idl}    ${serial_Number}

    ${WRITE_JSON}    Catenate
    ...    {"device_name":"${Device_Namel}","serial_number":"${serial_Number}","@${objl}":${write_valuel}}
    ${PUB_TOPIC}    Set Variable    user/${Account_idl}/device/desired
    ${JSON_DATA}    Evaluate    json.loads('''${WRITE_JSON}''')    json
    publish    ${PUB_TOPIC}    ${JSON_DATA}

Read objvalue From Mobile Application
    [Documentation]    Read object value from mobile
    ...    *Args:*
    ...    - ${objl} - Object name
    ...    - ${Device_Namel} - Device name in str type
    ...    - ${Account_idl} - Account Id
    ...
    [Arguments]    ${objl}    ${Device_Namel}    ${Account_idl}

    ${objl}    Catenate    @${objl}
    ${SUB_TOPIC}    Set Variable    user/${Account_idl}/device/reported
    subscribe    ${SUB_TOPIC}
    ${output}    response_message_mobile    ${objl}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get_heater_set_point_mobile    ${output}    ${objl}
    RETURN    ${tempVal}

Read mode objvalue From Mobile Application
    [Documentation]    Read mode object value from mobile
    ...    *Args:*
    ...    - ${objl} - Object name
    ...    - ${Device_Namel} - Device name in str type
    ...    - ${Account_idl} - Account Id
    ...
    [Arguments]    ${objl}    ${Device_Namel}    ${Account_idl}

    ${objl}    Catenate    @${objl}
    ${SUB_TOPIC}    Set Variable    user/${Account_idl}/device/reported
    subscribe    ${SUB_TOPIC}
    ${output}    response_message_mobile    ${objl}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get_heater_mode_mobile    ${output}    ${objl}
    RETURN    ${tempVal}

Read objvalue From Mobile Application error topic
    [Documentation]    Read object value from mobile for ERROR topic
    ...    *Args:*
    ...    - ${objl} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]    ${objl}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${SUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/error
    subscribe    ${SUB_TOPIC}
    ${output}    response_message    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get_heater_set_point_mobile_1    ${output}    ${objl}
    RETURN    ${tempVal}

Read int return type objvalue From Device
    [Documentation]    Read int return type object value from device
    ...    *Args:*
    ...    - ${obj} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]    ${obj}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${READ_JSON}    Catenate    {"action": "read_object_value","data":[{"name":"${obj}"}]}
    ${JSON_DATA}    Evaluate    json.loads('''${READ_JSON}''')    json
    ${PUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/request
    ${SUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/response

    subscribe    ${SUB_TOPIC}
    publish    ${PUB_TOPIC}    ${JSON_DATA}
    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    Get heater set point    ${output}
    sleep    2s
    IF    '${tempVal}'!='None'
        ${tempVal}    Convert To Number    ${tempVal}
    ELSE
        ${tempVal}    Set Variable    ${None}
    END
    sleep    2s
    IF    '${tempVal}'!='None'
        ${tempVal}    Convert to integer    ${tempVal}
    ELSE
        ${tempVal}    Set Variable    ${None}
    END
    RETURN    ${tempVal}

Read str return type objvalue From Device
    [Documentation]    Read str return type object value from device
    ...
    ...    *Args:*
    ...    - ${obj} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]    ${obj}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${READ_JSON}    Catenate    {"action": "read_object_value","data":[{"name":"${obj}"}]}
    ${JSON_DATA}    Evaluate    json.loads('''${READ_JSON}''')    json
    ${PUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/request
    ${SUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/response
    subscribe    ${SUB_TOPIC}
    publish    ${PUB_TOPIC}    ${JSON_DATA}
    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get heater set point    ${output}
    RETURN    ${tempVal}

Write objvalue From Device
    [Documentation]    Write object value from device
    ...
    ...    *Args:*
    ...    - ${write_value} - Object value that needs to be parse
    ...    - ${obj} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]
    ...    ${write_value}
    ...    ${obj}
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}

    ${WRITE_JSON}    Catenate
    ...    {"action": "write_object_value","data":[{"name":"${obj}","value":"${write_value}","data_type":0,"force_code":6}]}
    ${PUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/request
    ${SUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address_In_Formate}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/response
    ${JSON_DATA}    Evaluate    json.loads('''${WRITE_JSON}''')    json
    subscribe    ${SUB_TOPIC}
    publish      ${PUB_TOPIC}    ${JSON_DATA}
    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    sleep    4s
    unsubscribe    ${SUB_TOPIC}
    RETURN    ${write_value}

Write objvalue for Provisning
    [Documentation]    Write object value from device
    ...
    ...    *Args:*
    ...    - ${device_name} - Device name in str type
    ...    - ${device_identity} - Location Id
    ...    - ${device_key} - Device Active Key in str type
    ...    - ${wifi_ssid} - Object name
    ...    - ${wifi_password} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]
    ...    ${Device_Mac_Address}
    ...    ${Device_Mac_Address_In_Formate}
    ...    ${EndDevice_id}
    ...    ${wifi_ssid}
    ...    ${wifi_password}
    ...    ${device_name}
    ...    ${device_key}
    ...    ${device_identity}

    ${WRITE_JSON}    Catenate
    ...    {"action": "provision_device","data":{"ssid": "${wifi_ssid}","password": "${wifi_password}","device_name": "${device_name}","device_key": "${device_key}","device_identity": "${device_identity}"}}
    ${PUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address1}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/request
    ${SUB_TOPIC}    Set Variable
    ...    device/${Device_Mac_Address1}/SN${Device_Mac_Address}${EndDevice_id}/${EndDevice_id}/response
    subscribe    ${SUB_TOPIC}
    ${JSON_DATA}    Evaluate    json.loads('''${WRITE_JSON}''')    json
    publish    ${PUB_TOPIC}    ${JSON_DATA}
    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get_heater_set_point_mobile    ${output}    status


Test
    [Documentation]    Read int return type object value from device
    ...    *Args:*
    ...    - ${obj} - Object name
    ...    - ${Device_Mac_Address} - Device MAC address without any "-" or space (Ex: FCAA14D09C14)
    ...    - ${Device_Mac_Address_In_Formate} - Device MAC address in MAC address formate (EX: FC-AA-14-D0-9C-14)
    ...    - ${EndDevice_id} - End device id
    ...
    [Arguments]    ${obj}    ${Device_Mac_Address}    ${Device_Mac_Address_In_Formate}    ${EndDevice_id}

    ${READ_JSON}    Catenate    {"action": "read_object_value","data":[{"name":"${obj}"}]}
    log to console   ${READ_JSON}
    ${JSON_DATA}    Evaluate    json.loads('''${READ_JSON}''')    json
    log to console   ${JSON_DATA}
    ${PUB_TOPIC}    Set Variable
    ...    device/F0-03-8C-C3-D1-D7/0c-16-11-17-0e-02-47-31-01/4544/request
    ${SUB_TOPIC}    Set Variable
    ...    device/F0-03-8C-C3-D1-D7/0c-16-11-17-0e-02-47-31-01/4544/response

    Log to Console    ${PUB_TOPIC}
    Log to Console    ${SUB_TOPIC}
    subscribe    ${SUB_TOPIC}
    publish    ${PUB_TOPIC}    ${JSON_DATA}
    ${deviceResponseWaitTime}    set variable    ${deviceResponseWaitTime}
    ${output}    response message    ${deviceResponseWaitTime}
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    Get heater set point    ${output}
    sleep    2s
    IF    '${tempVal}'!='None'
        ${tempVal}    Convert To Number    ${tempVal}
    ELSE
        ${tempVal}    Set Variable    ${None}
    END
    sleep    2s
    IF    '${tempVal}'!='None'
        ${tempVal}    Convert to integer    ${tempVal}
    ELSE
        ${tempVal}    Set Variable    ${None}
    END
    RETURN    ${tempVal}