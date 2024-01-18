#!/usr/bin/env python

##################################################################
#
# RheemMQTT Library includes Rheem Specific MQTT functions
# used by Framework
#
##################################################################

from robot.libraries.BuiltIn import BuiltIn
from clearblade.ClearBladeCore import System
import time
import json
from robot.api import logger


class RheemMqtt:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.auth = None
        self.mySystem = None
        self.mqtt = None
        self.flag = 1
        self.resp = None

    def on_message(self, client, userData, message):
        # When we receive a message, print it out
        self.resp = str(message.payload)
        # logger.console("Response received On_msg---- %s" %self.resp)
        # self.flag = 0

    def connect(self, email, pwd, sysKey, secKey, url):
        # Connect to ClearBlade
        try:
            self.mySystem = System(sysKey, secKey, url)
            self.auth = self.mySystem.User(email, pwd)
            self.mqtt = self.mySystem.Messaging(self.auth)
            self.mqtt.on_message = self.on_message
            self.mqtt.connect()
        except Exception as e:
            BuiltIn.log_to_console('\nExeception Error -->--> ', e)
            return False

    def publish(self, topic, inputJson):
        # Publish over specific topic
        # logger.console("Publishing ---- %s" % inputJson)
        self.mqtt.publish(topic, json.dumps(inputJson))

    def subscribe(self, topic):
        # Subscribe over specific topic
        # logger.console("Subscribing ---- %s" % topic)
        self.mqtt.subscribe(topic)

    def unsubscribe(self, topic):
        # Unsubscribe over specific topic
        # logger.console("Unsubscribing ---- %s" % topic)
        self.mqtt.unsubscribe(topic)

    def response_message(self, timeout=60):
        # Collect MQTT message
        # logger.console("In Response func Before ---- %s" % self.resp)
        self.resp = None
        while timeout:
            self.mqtt.on_message = self.on_message
            # logger.console("In Response func after message read ---- %s" % self.resp)
            ret = None
            if self.resp:
                ret = self.resp
                # logger.console("In Response ---- %s" % self.resp)
                self.resp = None
                return ret
            # logger.console("Response Received ---- %s" % self.resp)
            time.sleep(1)
            timeout -= 1
        # logger.console("In Response func after message read1 ---- %s" % self.resp)
        return self.resp

    def response_message_mobile(self, obj, timeout=60):
        # Collect User Reported Topic Message
        self.flag = 1
        self.resp = None
        while self.flag and timeout:
            self.mqtt.on_message = self.on_message
            time.sleep(1)
            timeout -= 1
            if self.resp is not None:
                try:

                    value = str(json.loads(eval(self.resp
                                                ).decode('utf-8')).get(obj))

                except Exception as e:
                    BuiltIn.log_to_console('\nresponse_message_mobile Exception -->--> ', self.resp)
                    BuiltIn.log_to_console('\nExeception Error -->--> ', e)
                    value = 'None'
                if (value != 'None'):
                    return self.resp
                self.flag = 1
                self.resp = None
        return self.resp

    def disconnect(self):
        # Disconnect from ClearBlade
        self.mqtt.disconnect()

    def get_heater_set_point(self, heaterJson):
        # Get Reported Topic Message
        try:
            return str(eval(eval(heaterJson).decode('utf-8'))[0]['value'])
        except Exception:
            return None

    def get_mode(self, heaterJson):
        # Get Specific Mode
        try:
            return str(eval(eval(heaterJson)
                            .decode('utf-8'))[0]['enum_texts_value'])

        except Exception as e:
            BuiltIn.log_to_console('\nget_mode -->--> ', heaterJson)
            BuiltIn.log_to_console('\nExeception Error -->--> ', e)
            return None

    def get_heater_set_point_mobile(self, jsonData, obj):
        # Get Reported Topic Message
        try:
            return str(eval(eval(jsonData).decode('utf-8'))[obj])
        except Exception as e:
            BuiltIn.log_to_console('\nget_heater_set_point_mobile -->--> ', jsonData)
            BuiltIn.log_to_console('\nExeception Error -->--> ', e)
            return None

    def get_heater_mode_mobile(self, Jsondata, obj):
        # Get user Reported Topic Message
        try:
            return str(json.loads(eval(Jsondata).decode('utf-8')).get(obj)['value'])

        except Exception as e:
            BuiltIn.log_to_console('\nget_heater_mode_mobile -->--> ', Jsondata)
            BuiltIn.log_to_console('\nExeception Error -->--> ', e)
            return None

    def get_heater_set_point_mobile_1(self, jsonData, obj):
        # Collect User Reported Topic Message for specific object
        try:
            return json.loads(eval(jsonData).decode('utf-8'))[obj]
        except Exception as e:
            BuiltIn.log_to_console('\nget_heater_set_point_mobile_1 -->--> ', jsonData)
            BuiltIn.log_to_console('\nExeception Error -->--> ', e)
            return None
