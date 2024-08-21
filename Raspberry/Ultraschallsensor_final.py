# -*- coding: utf-8 -*-

import RPi.GPIO as GPIO
import time
from datetime import datetime
import paho.mqtt.client as mqtt
import ssl
import json
import threading






GPIO.setmode(GPIO.BCM)
GPIO_TRIGGER = 18
GPIO_ECHO = 24

AWS_CONNECTION = False
AWS_DATA_LIST = []

GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)



def on_connect(client, userdata, flags, rc):
    print("Verbunden mit AWS IoT: "+ str(rc))
    global AWS_CONNECTION
    AWS_CONNECTION = True
    global AWS_DATA_LIST
    if len(AWS_DATA_LIST) > 0:
        print("Daten in AWS_DATA_LIST gefunden..")
        for json in AWS_DATA_LIST:
            client.publish("raspi_01/data", payload=json, qos=0, retain=False)
        AWS_DATA_LIST = []
        print("AWS_DATA_LIST vollstaendig gesendet und geloescht..")
        
def on_disconnect(client, userdata, rc):
    print("Verbindung verloren!")
    global AWS_CONNECTION
    AWS_CONNECTION = False

client = mqtt.Client()
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.tls_set(ca_certs='./rootCA.pem', certfile='./certificate.pem.crt', keyfile='./private.pem.key', tls_version=ssl.PROTOCOL_SSLv23)
client.tls_insecure_set(True)
client.connect("a2dup5pdftkpsh-ats.iot.eu-central-1.amazonaws.com", 8883, 60)



def publishData(txt):
    while(True):
        print(txt)
        GPIO.output(GPIO_TRIGGER, True)

        time.sleep(0.00001)
        GPIO.output(GPIO_TRIGGER, False)

        StartTime = time.time()
        StopTime = time.time()

        while GPIO.input(GPIO_ECHO) == 0:
            StartTime = time.time()

        while GPIO.input(GPIO_ECHO) == 1:
            StopTime = time.time()

        TimeElapsed = StopTime - StartTime
        distance = (673 - ((TimeElapsed * 34300) / 2) * 10)
        waterlevel = round(distance, 5)
        
        currentDate = datetime.now().strftime('%y-%m-%d')
        currentTime = datetime.now().strftime('%H:%M:%S')
        
        deviceID = 23
        
        print("Measurement: %.5f" % waterlevel)
        print("Date: %s" % currentDate)
        print("Time: %s" % currentTime)
        
        json_data_waterlvl = json.dumps({"DeviceID": deviceID, "Date": currentDate, "Time": currentTime, "Measurement": waterlevel})
        
        if AWS_CONNECTION:
            client.publish("raspi_01/data", payload=json_data_waterlvl, qos=0, retain=False)
            print("Daten an AWS-IOT gesendet..")
        else:
            global AWS_DATA_LIST
            AWS_DATA_LIST.append(json_data_waterlvl)
            print("Daten in Liste gespeichert..")

        time.sleep(7200)

	
    
	
	
	
thread = threading.Thread(target=publishData, args=("Spin-up neuen Thread...",))

thread.start()
client.loop_forever()





