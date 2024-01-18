import datetime
import time
import subprocess
from multiprocessing import Process
import robot
import os
import glob
from robot.api import logger

class iOS_Handler():
    def __init__(self):
        self.portNum = ':4731'
        self.logfile = None


    def get_filename(self):
        basename = "screenshots"
        suffix = datetime.datetime.now().strftime("%y%m%d_%H%M%S")
        filename = "_".join([basename, suffix, ".png"])
        return filename

    def get_pathFile(self, screenShot):
        rootDir = os.path.abspath(os.curdir)
        return rootDir + screenShot

    def write_Text_To_File(self, text):
        filename = open('../../Desktop/dump.txt', 'w')
        filename.write(text)
        filename.close()

    def readImage(self, text):
        count = 0
        filename = open('../../Desktop/dump.txt', 'r+')
        line = filename.readline()
        while line:
            print(line)
            line = filename.readline()
            if line == text:
                logger.console(line)
                count = count + 1
                return count
        filename.close()

    def start_appium(self, port_number):
        """
        Starts the Appium server on specific port
        """
        try:
            port = int(port_number)
            self.logfile = open("results/appium_" + str(port_number) + ".log", "w+")
            output = subprocess.Popen(["appium -p {0}".format(port)],
                                      shell=True,
                                      stderr=self.logfile,
                                      stdout=self.logfile)
            while True:
                time.sleep(3)
                break
            return True
        except Exception as err:
            print("Error:", err)
            return False

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

    def check_appium_status(self):
        """
        verify appium status on port 4731 , if already running kill the process and then start execution
        """
        proc = subprocess.Popen(['lsof', '-t', '-i', self.portNum], stdout=subprocess.PIPE)
        tmp = proc.stdout.read()
        length = len(tmp)
        if (length != 0):
            pid = str(tmp)
            pid = pid[2:-3]
            subprocess.call(['kill', '-9', str(pid)], stdout=subprocess.PIPE)

    def check(self, string, sub_str):
        if (string.find(sub_str) == -1):
            return False
        else:
            return True

    def iOSDeviceProductId(self):
        """
        Give the List of UDIDs of connected iPhone Devices
        """
        try:
            iOSDeviceId = subprocess.Popen(["idevice_id", "-l"], stdout=subprocess.PIPE)
            iOSDeviceId = iOSDeviceId.communicate()[0].decode("utf-8").split()
            return iOSDeviceId
        except Exception as err:
            print("Error:", err)
            return False

    def robotSuites(self, argument_list, exec_command):
        """
        start execution of robot script
        """

        iOSDeviceId = self.iOSDeviceProductId()
        appiumPortNum = 4790
        wdaPort = 8367

        list1 = []
        try:

            if '-s' in argument_list:
                index = argument_list.index('-s')
                allSuitelists = argument_list[index + 1].split()
            suitesremaining = len(allSuitelists) % len(iOSDeviceId)
            index = len(allSuitelists) - suitesremaining
            remaining = int(index) / int(len(iOSDeviceId))
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
            print("Error")

        if (isinstance(iOSDeviceId, list)):
            try:
                for index, deviceName in enumerate(iOSDeviceId):
                    # objExecutable = TestDriver.Executable()
                    appiumPortNum = int(appiumPortNum) + 5
                    wdaPort = int(wdaPort) + 8

                    globals()['process%s' % index] = Process(target=self.execute_testsuite,
                                                             args=(argument_list, list1[index], appiumPortNum, wdaPort,
                                                                   deviceName, exec_command))
                    globals()['process%s' % index].start()
            except Exception as err:
                print("ERROR: ", err)
                return False
        else:
            print("\nPlease connect iOS Device.\n")
            return False

        # Wait till forked process completion
        [globals()['process%s' % index].join() for index, device in enumerate(iOSDeviceId)]

        return True

    def execute_testsuite(self, argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command, flag=0):
        """
                start execution of robot script
                """

        exec_command1 = exec_command
        print("Appium", appiumPortNum)
        exec_command.append("-v AppiumPort:'{0}' -v wdaLocalPort:{1} -v DeviceName:{2}".format(
            appiumPortNum, wdaPort, deviceName))

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
                print(suites)
                suiteLists = path + index
                exec_command.append(suiteLists)

            command_exec = ''
            for ele in exec_command:
                command_exec += ele
                command_exec += ' '
            print("Command :", command_exec)
            os.system(command_exec)
            if flag == 0:
                self.rerun_failed(argument_list, suites, appiumPortNum, wdaPort, deviceName, exec_command1)

        except KeyboardInterrupt:
            print("Process interrupted...Goodbye!!")
            exit(0)

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