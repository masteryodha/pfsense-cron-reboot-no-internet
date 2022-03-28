#!/bin/sh


# First sleep for 3 mins so that we don't run this code if box has only just booted
/bin/sleep 180


#Check if log file exist. When scheduled with cron the log file will be at home of root
if [ -e ping_log.dat ]; then
   echo "File exist, nothing to do"
else
   echo "$(date) First execution" > ping_log.dat
fi


# HOSTS can be either you ISP or google.com
HOSTS="google.com"
COUNT=10

echo "Pinging.."
echo "Date : $(date)"
echo "HOSTS: " $HOSTS
echo "COUNT: " $COUNT


do_the_ping() {
   for myHost in $HOSTS
   do
      counting=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )
      echo "counting: " $counting
   done

   return $counting

}

do_the_ping
PING_RC=$?
echo $PING_RC

if [ "$PING_RC" -le "2" ]; then
   echo "$(date) Problem with ping.  Making a backup of rrd" >> ping_log.dat
   /etc/rc.backup_rrd.sh
   echo "$(date) Flipping interfaces" >> ping_log.dat
   /sbin/ifconfig ix0 down
   /sbin/ifconfig ix1 down
   /bin/sleep 10
   /sbin/ifconfig ix0 up
   /bin/sleep 10
   /sbin/ifconfig ix1 up

   #Testing the ping again
   /bin/sleep 60
   do_the_ping
   PING_RC=$?
   if [ "$PING_RC" -le "2" ]; then
      echo "$(date) Problem was not fixed.  Rebooting" >> ping_log.dat
      #reboot
   else
      echo "$(date) Problem was fixed." > ping_log.dat
   fi
else
   echo "$(date) Ping was ok" >> ping_log.dat
fi
