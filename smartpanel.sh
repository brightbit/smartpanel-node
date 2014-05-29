#!/bin/bash

### BEGIN INIT INFO
# Provides:          smartpanel
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

PID=/var/run/smartpanel.pid

sig () {
  test -s "$PID" && kill -s $1 `cat $PID`
}

case "$1" in
  start)
    sig 0 && echo >&2 "Already running..." && exit 1
    echo "Starting smartpanel..."
    /usr/bin/env ruby /etc/smartpanel/lib/smartpanel-node.rb > /var/smartpanel.log 2>&1 &
    echo $! > $PID
    ;;
  stop)
    sig KILL && rm $PID && exit 0
    test -s "$PID" && rm $PID
    echo >&2 "Not running"
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    sig USR1 && echo "Status signal sent. Check the smartpanel.log."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    ;;
esac
