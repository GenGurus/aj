#!/usr/bin/env python3

import subprocess
import time
import datetime
from threading import Thread

#-------------------------- edit settings below -------------------------------
max_wakeupduration = 20              # max time the song will play (minutes)
wakeup_hour = 14                     # wake up hour (0-24)
wakeup_minute = 39                  # wake up minute
wakeup_song = "/home/RenderHam/Music/Gehirn_EP/Balthazar.mp3"   # path to wake up song
#------------------------------------------------------------------------------

def stop_wakeup():
    time1 = int(time.time()); time2 = time1
    last_idle = 0
    playtime = max_wakeupduration*60
    while time2 - time1 < playtime:
        get_idle = subprocess.Popen(["xprintidle"], stdout=subprocess.PIPE)
        curr_idle = int(get_idle.communicate()[0].decode("utf-8"))
        if curr_idle < last_idle:
            break
        else:
            last_idle = curr_idle
            time.sleep(1)
            time2 = int(time.time())
    subprocess.Popen(["pkill", "rhythmbox"])

def calculate_time():
    currtime = str(datetime.datetime.now().time()).split(":")[:2]
    minutes_set = wakeup_hour*60 + wakeup_minute
    minutes_curr = int(currtime[0])*60 + int(currtime[1])
    if minutes_curr < minutes_set:
        minutes_togo = minutes_set - minutes_curr
    else:
        minutes_togo = minutes_set + 1440-minutes_curr
    return minutes_togo*60

def go_asleep():
    sleeptime = calculate_time()   
    run = "rtcwake -m disk -s "+str(sleeptime)+" && "+"sleep 20"
    subprocess.call(['/bin/bash', '-c', run])
    combined_actions()

def play_song():
    command = "rhythmbox "+wakeup_song
    subprocess.Popen(['/bin/bash', '-c', command])
