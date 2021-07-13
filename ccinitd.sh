#!/bin/sh

### BEGIN INIT INFO
# Provides:          ccmodule
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: call cabinet repository control daemon
# Description:       This script controls the starting and stopping of the call cabinet 
#                    repository control module, aka ccmodule. The ccmodule runs as a daemon
#                    started at boot by init.d. It consists of a parent daemon and one
#                    worker thread to manage the repository. The parent daemon encrypts any #                    new files entering the repository and cleans up old files as scheduled.
#                    The worker thread will transfer encrypted files to an external location #                    using the configured WSDL schema. 
### END INIT INFO

# Change the next 3 lines to suit where you install your script and what you want to call it
DIR=/home/callcabinet/
DAEMON_NAME=64bit20201103
DAEMON=$DIR/$DAEMON_NAME

# This next line determines what user the script runs as.
# Root generally not recommended but necessary if you are using the Raspberry Pi GPIO from Python.
DAEMON_USER=root

# The process ID of the script when it runs is stored here:
PIDFILE=/var/run/$DAEMON_NAME.pid

#. /lib/rc/sh/functions.sh
. /lib/lsb/init-functions.d

depend() {
	use net
}

start () {
    ebegin "Starting system $DAEMON_NAME daemon"
    start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile --user $DAEMON_USER --chuid $DAEMON_USER --startas $DAEMON --chdir $DIR
#    eend $?
}
stop () {
    ebegin "Stopping system $DAEMON_NAME daemon"
    start-stop-daemon --stop --pidfile $PIDFILE --retry 10
    eend $?
}

case "$1" in

    start|stop)
        ${1}
        ;;

    restart|reload|force-reload)
        stop
        start
        ;;

    status)
        status_of_proc "$DAEMON_NAME" "$DAEMON" && exit 0 || exit $?
        ;;
    *)
        echo "Usage: /etc/init.d/$DAEMON_NAME {start|stop|restart|status}"
        exit 1
        ;;

esac
exit 0
