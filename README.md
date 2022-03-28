# pfsense-cron-reboot-no-internet
My pfsense box was frequently becoming unstable from time to time.  Leaving me no access to either the internet or my local network.

So I found this script that reboots pfsense when a ping to a host doesn't work 
https://forum.netgate.com/topic/64563/pfsense-auto-reboot-script-when-google-is-unreachable/2

I adapted the script to my situation.


## What does it do
So every X minutes the script is launched and it tries to ping google.com.  If less than 3 attempt from the 10 are successfull, it reset my 2 adapter (Wan and Lan).
And then it checks again if the network is up again after that.  And if it's not, it reboots pfsense since this is what I was ultimately doing anyway.
The part with the reboot is commented right now because I want to find the root cause of my problem.


## What needs to be changed 
You NEED to change the adapter (default : ix0, ix1) for yours.

You can can change the host that it pings (default : google.com)
You can alse change the number of ping to do (default 10) and the threshold for detecting a problem (default less or equal to 2)
You can also change the wait time at the beginning if 3 minutes is not enough for you box to be fully started.
You can change the wait time after the flip of the adapters to check again for network if 60 seconds is not enough.

## What is logged and where
At the moment, almost everything is logged on a file (ping_log.dat).  If the file is getting too big, you can comment the logging when everything was working (Ping was ok)
When you add it on cron, the log file will get written to the home directory of the user (root in my case)

## How to add as a cron
https://www.pc2s.fr/pfsense-cron-planification-de-taches/ is already documenting how to do it.  It's in frech, but you should know what to do from the printscreen.  You just need to put you exact script and when you want it to run.

The steps to do it should be : 
- Download and install in the Package Manager the package cron
- In the Services tab, select the new menu "Cron"
- Add your new cron with the scripts and the frequency.

WATCH OUT!! Do net schedule the script too quick (each minutes).  If the script does not work for some reason, it will reset the adapter every minute so you'll have a hard time debugging this.  You whould always test your script on another directory first and then moving it to the script that is scheduled.
