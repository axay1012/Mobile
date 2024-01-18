from datetime import *
import requests
import json
import re

SystemKey = 'B6D7F2E20B9CA8BBF4EDB0BDFEAE01'
SystemSecret = 'b6d7f2e20bf0dbbf9aa0c7f2d430'
Content = 'application/json'
appid = 'cmhlZW0ud3d3LmVjb25ldGF1dG9tYXRpb250ZXN0aW5nOnJ3aG5aeGVaVHR0NVoyN0I1NnhM'

def timeConversion(time):
    try:
        time24hour = datetime.strptime(time, '%I:%M %p')
    except:
        pass
    return time24hour.hour


def ApprovedRequest(mac_address, status):
    UserToken = authToken()

    url = "https://dr-staging.rheemconnect.com/partnerOptAction"

    payload = json.dumps([
        {
            "enroll_state": status,
            "mac_address": "{0}".format(mac_address)
        }
    ])
    headers = {
        'Authorization': 'Bearer {0}'.format(UserToken),
        'Content-Type': 'application/json',
        'appid': appid
    }

    response = requests.request("POST", url, headers=headers, data=payload)
    print(response.text)
    if response.status_code == 200:
        return True
    else:
        return False


def authToken():
    url = "https://rheemstaging.clearblade.com/api/v/1/user/auth"

    payload = json.dumps({
        "email": "admin@rheem.com",
        "password": "Rh33mT3@mAdm1n"
    })
    headers = {
        'ClearBlade-SystemKey': SystemSecret,
        'ClearBlade-SystemSecret': SystemKey,
        'Content-Type': Content
    }

    response = requests.request("POST", url, headers=headers, data=payload)
    data = json.loads(response.text)

    user_token = data["user_token"]

    return user_token

def PartnerAuthToken():

    url = "https://dr-staging.rheemconnect.com/auth/token"

    payload = 'username=akshay.suthar1012%40gmail.com&password=rheem123&grant_type=password'
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer {0}'.format(appid)
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    data = json.loads(response.text)

    access_token = data["access_token"]

    return  access_token

def getEquipmentid(ProgramToken):

    url = "https://dr-staging.rheemconnect.com/partnerLocations"

    payload = {}
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {0}'.format(ProgramToken)
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    pattern = r'"cloud2_equipment_id":(\d+)'
    match = re.search(pattern, response.text)
    cloud2_equipment_id = match.group(1)
    return cloud2_equipment_id

def startDREvent():

    ProgramToken = PartnerAuthToken()
    equipmentid = getEquipmentid(ProgramToken)

    url = "https://dr-staging.rheemconnect.com/drEvent"

    payload = json.dumps({
        "command": 'startLoadShed',
        "setPoint": 110,
        "mode": "",
        "equipmentsDetail": [
            {
                "id": equipmentid
            }
        ]
    })
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {0}'.format(ProgramToken)
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    if response.status_code == 200:
        return True
    else:
        return False

def stopDREvent():

    ProgramToken = PartnerAuthToken()
    equipmentid = getEquipmentid(ProgramToken)

    url = "https://dr-staging.rheemconnect.com/drEvent"

    payload = json.dumps({
        "command": 'stopLoadShed',
        "equipmentsDetail": [
            {
                "id": int(equipmentid)
            }
        ]
    })
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {0}'.format(ProgramToken)
    }
    response = requests.request("POST", url, headers=headers, data=payload)
    if response.status_code == 200:
        return True
    else:
        return False
