*** Variables ***
${logOverConsole}       True


*** Keywords ***
########################### end device Keyword ###########################
Write objvalue From Mobile Application
    [Documentation]    Write object value from mobile
    ...
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
    Log    \nmessage--> ${WRITE_JSON}    console=${logOverConsole}
    ${PUB_TOPIC}    Set Variable    user/${Account_idl}/device/desired
    ${JSON_DATA}    Evaluate    json.loads('''${WRITE_JSON}''')    json
    publish    ${PUB_TOPIC}    ${JSON_DATA}

Read objvalue From Mobile Application
    [Documentation]    Read object value from mobile
    ...
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
    Log    \nresponse_message_mobile--> ${output}    console=${logOverConsole}
    ${tempVal}    get_heater_set_point_mobile    ${output}    ${objl}
    Log    \nget_heater_set_point_mobile--> ${tempVal}    console=${logOverConsole}
    RETURN    ${tempVal}

Read int return type objvalue From Device
    [Documentation]    Read int return type object value from device
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
    ${output}    response message
    unsubscribe    ${SUB_TOPIC}
    ${tempVal}    get heater set point    ${output}
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
    publish    ${PUB_TOPIC}    ${JSON_DATA}
    Sleep    5s
    unsubscribe    ${SUB_TOPIC}
    RETURN    ${write_value}

