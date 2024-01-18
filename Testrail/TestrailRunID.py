import sys
from Testrail.testrail import *


def create_testrun(USER, PASSWORD, TESTRAIL_UPDATE):
    client = APIClient('https://rheem.testrail.io')
    client.user = USER
    client.password = PASSWORD

    ###################### For End To End Rheem Automation ########################

    argument_list = sys.argv
    component_index = argument_list.index('-c')
    if argument_list[component_index + 1] == "iOS" and int(TESTRAIL_UPDATE) == 1:
        run = client.send_post('add_run/22', {'suite_id': 796})
    elif argument_list[component_index + 1] == "Android" and int(TESTRAIL_UPDATE) == 1:
        run = client.send_post('add_run/23', {'suite_id': 10766})

    ######################### Get Run Id value from the Dictionary #######################
    if int(TESTRAIL_UPDATE) == 1:
       if "id" in run:
           value = run["id"]
           return value
