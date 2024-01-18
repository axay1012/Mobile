import datetime
import os
import time
import subprocess
import re
from multiprocessing import Process
import glob
import robot
from robot.api import logger


class Android_Handler():

    def __init__(self):
        self.portNum = 4723

    def get_filename(self):
        basename = "Screenshot"
        suffix = datetime.datetime.now().strftime("%y%m%d_%H%M%S")
        filename = "_".join([basename, suffix, ".png"])
        return filename

    def start_appium(self, port_number):
        """
        Starts the Appium server on specific port
        """
        port = int(port_number)
        output = subprocess.Popen(["appium -p {0}".format(port)],
                                  shell=True,
                                  stdout=subprocess.PIPE)
        while True:
            time.sleep(3)
            break
        return True

    def killProcess(self, port_number):
        """
        Kill the process over specific port
        Argument: port_number
        Return: "True" if process over given port terminated succesfuly
        """
        try:
            killCmd = 'kill -9 $(lsof -t -i:{0} -sTCP:LISTEN)'. \
                format(int(port_number))
            retCode = os.system(killCmd + "> /dev/null 2>&1")
            if int(retCode) != 0:
                return False
            return True
        except Exception as err:
            print("ERROR : ", err)
            return False

    def getAndroidVersion(self, deviceName):
        try:
            androidVersion = subprocess.check_output(
                ["adb", "-s", deviceName, "shell", "getprop", "ro.build.version.release"])
            return androidVersion.decode("UTF-8").split(".")[0].strip()
        except Exception as Interrupt_Error1:
            print("Get Android Device version Error --> ", Interrupt_Error1)
            return False

    def getAndroidDeviceName(self):
        try:
            androidDeviceName = os.system()
            return androidDeviceName

        except Exception as Interrupt_Error1:
            print("Get Android Device Device Error --> ", Interrupt_Error1)
            return False

    def stop_appium(self, port_number):
        """
        Stops the Appium server from specific port
        """
        try:
            if self.killProcess(port_number):
                print("STOP")
                self.logfile.close()
                return True
            else:
                return False
        except Exception as err:
            print("ERROR : ", err)
            return False

    def check(self, string, sub_str):
        if (string.find(sub_str) == -1):
            return False
        else:
            return True

    def _adbDevices(self):
        """
        Gives the list of connected android devices
        """
        devices = []
        AndroidDeviceId = subprocess.Popen(["adb", "devices"], stdout=subprocess.PIPE)
        getdevices = AndroidDeviceId.communicate()[0].decode("utf-8").split()
        print(getdevices)
        for data in getdevices[4:]:
            if "device" not in data and "unauthorized" not in data:
                print(data)
                deviceStatus = re.split(r'\s+', data, maxsplit=1)
                devices.append(deviceStatus[0])
        return devices

    def robotSuites(self, argument_list, exec_command):
        """
        start execution of robot script
        """

        iOSDeviceId = self._adbDevices()
        appiumPortNum = 4792

        list1 = []
        try:
            if '-s' in argument_list:
                index = argument_list.index('-s')
                allSuitelists = argument_list[index + 1].split()
            suitesremaining = len(allSuitelists) % len(iOSDeviceId)
            index = len(allSuitelists) - suitesremaining
            remaining = int(index) / int(len(iOSDeviceId))
            print("Remaining", remaining)
            count = 0
            last_device = iOSDeviceId[-1]
            for device in iOSDeviceId:
                if last_device == device:
                    remaining = len(allSuitelists)
                list3 = allSuitelists[count:int(remaining)]
                del allSuitelists[count:int(remaining)]
                list1.append(list3)
            print("Sequence of command : ", list1)
        except:
            print("Please Provide Proper Suite Name and Componemt Value.")

        if (isinstance(iOSDeviceId, list)):
            try:
                for index, deviceName in enumerate(iOSDeviceId):
                    PlatformVersion = self.getAndroidVersion(deviceName)
                    print(PlatformVersion)
                    appiumPortNum = int(appiumPortNum) + 3

                    globals()['process%s' % index] = Process(target=self.execute_testsuite,
                                                             args=(argument_list, list1[index], appiumPortNum,
                                                                   PlatformVersion,
                                                                   deviceName, exec_command))
                    globals()['process%s' % index].start()
            except Exception as err:
                print("ERROR: ", err)
                return False
        else:
            print("\nPlease connect Android Device...\n")
            return False

        # Wait till forked process completion
        [globals()['process%s' % index].join() for index, device in enumerate(iOSDeviceId)]

        return True

    def execute_testsuite(self, argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command, flag=0):
        """
        start execution of robot script
        """

        exec_command1 = exec_command

        exec_command.append(
            "-v PLATFORMVERSION:{1} -v AppiumPort:{0} -v DeviceName:{2}".format(appiumPortNum, wdaPort, deviceName))
        print("Appium", appiumPortNum)

        try:
            component_index = argument_list.index('-c')
            if argument_list[component_index + 1] == "iOS":
                path = "iOS/Testsuite/"
            else:
                path = "Android/Testsuite/"

            if '-i' in argument_list:
                tag_index = argument_list.index('-i')
                TagList = argument_list[tag_index + 1]
                print("TagList", TagList)
                exec_command.append("-i {0}".format(TagList))

            for index in suites:
                suiteLists = path + index
                exec_command.append(suiteLists)

            command_exec = ''
            for ele in exec_command:
                command_exec += ele
                command_exec += ' '

            print("Command :", command_exec)
            os.system(command_exec)
            # self.rerun_failed(self, argument_list, suites, appiumPortNum, wdaPort, deviceName)
            if flag == 0:
                self.rerun_failed(argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command1)
        except KeyboardInterrupt:
            print("Process interrupted...Goodbye!!")
            exit(0)

    def check_appium_status(self):
        """
        verify appium status on port 4731 , if already running kill the process and then start execution
        """
        proc = subprocess.Popen(['pkill', '-9', '-f', 'appium'], stdout=subprocess.PIPE)
        while True:
            time.sleep(3)
            break
        return True

    def rerun_failed(self, argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command):
        """
            robot --output original.xml tests                          # first execute all tests
            robot --rerunfailed original.xml --output rerun.xml tests  # then re-execute failing
            rebot --merge original.xml rerun.xml                       # finally merge results
        """

        opdir = exec_command[4] + os.sep + "rerun_result"

        print("OpDir:-", opdir)
        main_output_xml = glob.glob(exec_command[4] + os.sep + "*.xml")[0]
        print("Main Output xml:-", main_output_xml)

        try:
            failed_testcases = robot.conf.gatherfailed.gather_failed_tests(main_output_xml)
            print(failed_testcases)
            failed = True
        except:
            failed = False
        if failed:
            rerun_output_xml = "rerun_output.xml"
            merged_txt = main_output_xml.split("output")
            merged_txt = 'output' + merged_txt[1]

            print("Overridden File Path:", merged_txt)

            exec_command = ['robot', exec_command[1], '-T', '-d', opdir,
                            '--rerunfailed', main_output_xml, ' --output', rerun_output_xml]

            # merge results
            flag = 1
            self.execute_testsuite(argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command,
                                   flag)  # Failed test
            rerun_output_xml = glob.glob(opdir + os.sep + "rerun_*.xml")[0]
            merge_command1 = "rebot -d " + exec_command[4] + " --merge " + " --output" + " " + merged_txt + " " + \
                             main_output_xml + " " + rerun_output_xml
            os.system(merge_command1)