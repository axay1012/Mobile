# from atlassian import Confluence
import xmltodict
import sys
import datetime
import os
import glob
import shutil
from Testrail.TestrailRunID import create_testrun
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
from xml.dom import minidom
# import robot
from src.common.iOS_Handler import iOS_Handler
from src.common.Android_Handler import Android_Handler
from multiprocessing import Process

# import ConfluenceIntegration

CONFIG_FILE_PATH = "Config.xml"
TEST_COMPONENT = None
TESTRAIL_USERNAME = None
TESTRAIL_PASSWORD = None
EMAIL_PASSWORD = None
EMAIL_ID = None
TESTRAIL_UPDATE = None


class Executable():

    def __init__(self):
        self.getConfigData()
        self.portNum = ':4731'
        self.basename = 'Results/Reports/'
        self.suffix = datetime.datetime.now().strftime("%y%m%d_%H%M%S")

        # print("fileName:", "_" + self.suffix)
        self.url = 'rheem.testrail.io'
        self.user = TESTRAIL_USERNAME
        print("USER :", self.user)
        self.password = TESTRAIL_PASSWORD
        self.https = 'https://'
        self.update = TESTRAIL_UPDATE
        merged_txt = 'output.xml'
        self.run_id = 14098
        self.filename = "_".join([self.basename, self.suffix, str(self.run_id)])
        # self.run_id = create_testrun(TESTRAIL_USERNAME, TESTRAIL_PASSWORD, TESTRAIL_UPDATE)
        self.testrail_link = "https://rheem.testrail.io/index.php?/runs/view/" + str(self.run_id)
        # print("Testrail Report:", self.testrail_link)
        self.exec_command = ['robot', '--listener Testrail/TestRailListener.py:' + str(self.url) + ':' + str(self.user)
                             + ':' + str(self.password) + ':' + str(self.run_id) + ':' + str(self.https) + ':' + str(
            self.update)
                             + ':None:None:None:None', '-T', '-d', self.filename]
        self.sender_address = EMAIL_ID
        self.sender_password = EMAIL_PASSWORD
        self.receiver_address = ["craig.jones@rheem.com", "elizaveta.burdaeva@orioninc.com",
                                 "garvish.raval@volansys.com", "vyom.joshi@volansys.com", "ritesh.gajjar@volansys.com",
                                 "akshay.suthar@volansys.com", "jignesh.parekh@volansys.com", ]

    def getConfigData(self):
        """
        Parse config data from Config dict
         """
        global TESTRAIL_USERNAME
        global TESTRAIL_PASSWORD
        global EMAIL_ID
        global EMAIL_PASSWORD
        global TESTRAIL_UPDATE

        with open(CONFIG_FILE_PATH, 'r', encoding='utf-8') as file:
            my_xml = file.read()
        configDict = xmltodict.parse(my_xml)

        TESTRAIL_USERNAME = configDict["Configuration"]["Testrail"]["username"]
        TESTRAIL_PASSWORD = configDict["Configuration"]["Testrail"]["password"]
        TESTRAIL_UPDATE = configDict["Configuration"]["Testrail"]["testrailUpdate"]

        EMAIL_ID = configDict["Configuration"]["Email"]["EmailID"]
        EMAIL_PASSWORD = configDict["Configuration"]["Email"]["Password"]

        # HPWHGen5 Device Details
        os.environ["HPWHGen5_Email"] = configDict["Configuration"]["Products"]["HPWHGen5"]["Email"]
        os.environ["HPWHGen5_Password"] = configDict["Configuration"]["Products"]["HPWHGen5"]["Password"]
        os.environ["HPWHGen5_Location_Name"] = configDict["Configuration"]["Products"]["HPWHGen5"]["LocationName"]
        os.environ["HPWHGen5_DeviceID"] = configDict["Configuration"]["Products"]["HPWHGen5"]["DeviceID"]

        # HPWH Device Details
        os.environ["HPWH_Email"] = configDict["Configuration"]["Products"]["HPWH"]["Email"]
        os.environ["HPWH_Password"] = configDict["Configuration"]["Products"]["HPWH"]["Password"]
        os.environ["HPWH_Location_Name"] = configDict["Configuration"]["Products"]["HPWH"]["LocationName"]
        os.environ["HPWH_DeviceID"] = configDict["Configuration"]["Products"]["HPWH"]["DeviceID"]

        # Triton Device Details
        os.environ["Triton_Email"] = configDict["Configuration"]["Products"]["Triton"]["Email"]
        os.environ["Triton_Password"] = configDict["Configuration"]["Products"]["Triton"]["Password"]
        os.environ["Triton_Location_Name"] = configDict["Configuration"]["Products"]["Triton"]["LocationName"]
        os.environ["Triton_DeviceID"] = configDict["Configuration"]["Products"]["Triton"]["DeviceID"]

        # Dragon Device Details
        os.environ["Dragon_Email"] = configDict["Configuration"]["Products"]["Dragon"]["Email"]
        os.environ["Dragon_Password"] = configDict["Configuration"]["Products"]["Dragon"]["Password"]
        os.environ["Dragon_Location_Name"] = configDict["Configuration"]["Products"]["Dragon"]["LocationName"]
        os.environ["Dragon_DeviceID"] = configDict["Configuration"]["Products"]["Dragon"]["DeviceID"]

        # Gladiator Device Details
        os.environ["HotSpring_Email"] = configDict["Configuration"]["Products"]["HotSpring"]["Email"]
        os.environ["HotSpring_Password"] = configDict["Configuration"]["Products"]["HotSpring"]["Password"]
        os.environ["HotSpring_Location_Name"] = configDict["Configuration"]["Products"]["HotSpring"]["LocationName"]
        os.environ["HotSpring_DeviceID"] = configDict["Configuration"]["Products"]["HotSpring"]["DeviceID"]

        # Tankless Device Details
        os.environ["Niagra_Email"] = configDict["Configuration"]["Products"]["Niagra"]["Email"]
        os.environ["Niagra_Password"] = configDict["Configuration"]["Products"]["Niagra"]["Password"]
        os.environ["Niagra_Location_Name"] = configDict["Configuration"]["Products"]["Niagra"]["LocationName"]
        os.environ["Niagra_DeviceID"] = configDict["Configuration"]["Products"]["Niagra"]["DeviceID"]

        # NewECC Device Details
        os.environ["NewECC_Email"] = configDict["Configuration"]["Products"]["NewECC"]["Email"]
        os.environ["NewECC_Password"] = configDict["Configuration"]["Products"]["NewECC"]["Password"]
        os.environ["NewECC_Location_Name"] = configDict["Configuration"]["Products"]["NewECC"]["LocationName"]
        os.environ["NewECC_DeviceID"] = configDict["Configuration"]["Products"]["NewECC"]["DeviceID"]

        # OldECC Device Details
        os.environ["OldECC_Email"] = configDict["Configuration"]["Products"]["OldECC"]["Email"]
        os.environ["OldECC_Password"] = configDict["Configuration"]["Products"]["OldECC"]["Password"]
        os.environ["OldECC_Location_Name"] = configDict["Configuration"]["Products"]["OldECC"]["LocationName"]
        os.environ["OldECC_DeviceID"] = configDict["Configuration"]["Products"]["OldECC"]["DeviceID"]

        # Electric Device Details
        os.environ["Electric_Email"] = configDict["Configuration"]["Products"]["Electric"]["Email"]
        os.environ["Electric_Password"] = configDict["Configuration"]["Products"]["Electric"]["Password"]
        os.environ["Electric_Location_Name"] = configDict["Configuration"]["Products"]["Electric"]["LocationName"]
        os.environ["Electric_DeviceID"] = configDict["Configuration"]["Products"]["Electric"]["DeviceID"]

        # Zone Device Details
        os.environ["Zone_Email"] = configDict["Configuration"]["Products"]["Zone"]["Email"]
        os.environ["Zone_Password"] = configDict["Configuration"]["Products"]["Zone"]["Password"]
        os.environ["Zone_Location_Name"] = configDict["Configuration"]["Products"]["Zone"]["LocationName"]
        os.environ["Zone_DeviceID"] = configDict["Configuration"]["Products"]["Zone"]["DeviceID"]

        # Thor Device Details
        os.environ["Thor_Email"] = configDict["Configuration"]["Products"]["Thor"]["Email"]
        os.environ["Thor_Password"] = configDict["Configuration"]["Products"]["Thor"]["Password"]
        os.environ["Thor_Location_Name"] = configDict["Configuration"]["Products"]["Thor"]["LocationName"]
        os.environ["Thor_DeviceID"] = configDict["Configuration"]["Products"]["Thor"]["DeviceID"]

        # Eagle Device Details
        os.environ["Eagle_Email"] = configDict["Configuration"]["Products"]["Eagle"]["Email"]
        os.environ["Eagle_Password"] = configDict["Configuration"]["Products"]["Eagle"]["Password"]
        os.environ["Eagle_Location_Name"] = configDict["Configuration"]["Products"]["Eagle"]["LocationName"]
        os.environ["Eagle_DeviceID"] = configDict["Configuration"]["Products"]["Eagle"]["DeviceID"]

        test_component_index = argument_list.index('-c')
        if argument_list[test_component_index + 1] == "iOS":
            try:
                os.environ["AppPath"] = configDict["Configuration"]["iOS"]["AppPath"]
                os.environ["PlatformName"] = configDict["Configuration"]["iOS"]["PlatformName"]
                os.environ["DeviceName"] = configDict["Configuration"]["iOS"]["DeviceName"]
                os.environ["PLATFORM_VERSION"] = configDict["Configuration"]["iOS"]["PLATFORM_VERSION"]

            except Exception as err:
                print("ERROR: Please Provide Correct Information For iOS In Configuration File.", err)
                sys.exit(1)

        else:
            try:
                os.environ["PlatformName"] = configDict["Configuration"]["Android"]["PlatformName"]
                # os.environ["DeviceName"] = configDict["Configuration"]["Android"]["DeviceName"]
                os.environ["AppPath"] = configDict["Configuration"]["Android"]["AppPath"]
                os.environ["APP_ACTIVITY"] = configDict["Configuration"]["Android"]["APP_ACTIVITY"]
                os.environ["AppiumPort"] = configDict["Configuration"]["Android"]["AppiumPort"]
            except Exception as err:
                print("ERROR: Please Provide Correct Information For Android In Configuration File.", err)
                sys.exit(1)

    def parallel_execution(self, argument_list, objiOS_Handler):
        objiOS_Handler.robotSuites(argument_list, self.exec_command)

    def send_report_email(self, filename, pass_, fail, status, colour):
        print("Sending Email...")
        curr_dir = os.getcwd()
        message = MIMEMultipart()
        message['From'] = self.sender_address
        message['To'] = ", ".join(self.receiver_address)
        message['Subject'] = "Rheem Econet Reskin Automation Smoke Report of Test Environment Release " + str(
            datetime.datetime.now().strftime(
                "%Y%m%d-%H:%M")) + " with iOS App. Bitrise Build Number #6695 [v6.0.4 (7021)]"
        mail_content = """\
        <html>
          <body>
            <p>Hi,<br><br>
               Please find an automated Smoke test report for the iOS Econet Reskin Application attached.<br>
            </p>
            <table style="border:1px solid black; width:20%;text-align: center;">
            <tr style="border:1px solid black">
            <th style="border:1px solid black;">Status </th>
            <th style="border:1px solid black;background-color:{colour};">{status}</th>
            </table>
            <br>
            <table style="border:1px solid black; width:40%;text-align: left;">
          <tr style="border:1px solid black">
            <th style="border:1px solid black;">Release Version &nbsp;  </th>
            <th style="border:1px solid black">v6.0.4(6857)</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Device  </th>
            <th style="border:1px solid black">iPhone 12mini  </th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">iOS Version</th>
            <th style="border:1px solid black">14.6</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Cloud Version  </th>
            <th style="border:1px solid black">4.3.2.0</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Environment</th>
            <th style="border:1px solid black">Test</th>
          </tr>
        </table><br>
           <table>
           <tr>
            <th>Smoke Execution Status :</th>
          </tr>
           </table>
            <table style="border:1px solid black; width:40%;text-align: center;">
          <tr style="border:1px solid black">
            <th style="border:1px solid black; background-color:MediumSeaGreen;">PASS</th>
            <th style="border:1px solid black;background-color:Tomato">FAIL</th>
            <th style="border:1px solid black; background-color:LightGray;">TOTAL  </th>
          </tr>
          <tr style="border:1px solid black">
            <td style="border:1px solid black">{Pass}</td>
            <td style="border:1px solid black">{Fail}</td>
            <td style="border:1px solid black">{Total}</td>
          </tr>
        </table><br>
         <p font-weight: bold;>
               Testrail Link: https://rheem.testrail.io/index.php?/runs/view/{run_id}.<br><br>
               <p>
                <b>Note:</b>
                <ul>
                <li>FYI: we can now successfully log into the Test environment, and as a result, we have re-executed the smoke testing. The previous issue with "Test environment login" has been resolved.</li>
                <li> If any test is getting fail will mark the entire execution status as “Off Track”. </li>
                <li> Detailed reports are attached in Zip File. </li>
                </ul>
                Please let us know if you need more information from our end.<br>
         </p>
          </body>
        </html>
        """.format(Pass=pass_, Fail=fail, Total=int(pass_) + int(fail), status=status, colour=colour,
                   run_id=self.run_id)
        message.attach(MIMEText(mail_content, 'html'))
        zip_name = self.create_zip_file(filename)
        attachment = open(zip_name, "rb")

        p = MIMEBase('application', 'octet-stream')
        p.set_payload((attachment).read())
        encoders.encode_base64(p)
        p.add_header('Content-Disposition', 'attachment', filename=zip_name)
        message.attach(p)
        attachment.close()

        try:
            s = smtplib.SMTP('smtp.gmail.com', 587)
            s.starttls()
            s.login(self.sender_address, self.sender_password)
            text = message.as_string()
            # sending the mail
            s.sendmail(self.sender_address, self.receiver_address, text)
            # terminating the session
            s.quit()
            os.chdir(curr_dir)
            print("Email sent successfully..")
        except Exception as e:
            print("exception : ", e)

    def create_zip_file(self, dir_name):
        base = os.path.basename(dir_name)
        archive_from = os.path.dirname(dir_name)
        os.chdir(archive_from)
        archive_to = os.path.basename(dir_name.strip(os.sep))
        shutil.make_archive(base, 'zip', base)
        return base + '.zip'

    def read_date(self):
        status = ""
        main_output_xml = glob.glob(self.filename + os.sep + "*.xml")[0]
        file = minidom.parse(main_output_xml)
        models = file.getElementsByTagName('stat')
        for elem in models:
            pass_value = elem.getAttribute("pass")
            fail_value = elem.getAttribute("fail")

        if int(fail_value) == 0:
            status = "On Track"
            colour = "green"
        else:
            status = "Off Track"
            colour = "red"

        return pass_value, fail_value, status, colour


if __name__ == "__main__":
    argument_list = sys.argv
    print(argument_list)
    objExecutable = Executable()

    component_index = argument_list.index('-c')
    if argument_list[component_index + 1] == "iOS":
        objiOS_Handler = iOS_Handler()
        objiOS_Handler.check_appium_status()
        # objiOS_Handler.check_ping()
        objExecutable.parallel_execution(argument_list, objiOS_Handler)
    else:
        objAndroid_Handler = Android_Handler()
        objAndroid_Handler.check_appium_status()
        objExecutable.parallel_execution(argument_list, objAndroid_Handler)
    # data = objExecutable.read_date()
    # for i in range(len(argument_list)):
    #     if argument_list[i] == "-e":
    #         objExecutable.send_report_email(objExecutable.filename, data[0], data[1], data[2], data[3])
