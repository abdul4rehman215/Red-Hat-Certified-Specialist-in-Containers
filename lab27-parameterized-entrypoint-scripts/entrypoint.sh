#!/bin/bash
# Process arguments
case "$1" in
 start)
 echo "Starting application with config: ${2:-default}"
 ;;
 stop)
 echo "Stopping application gracefully"
 ;;
 *)
 echo "Usage: $0 {start|stop} [config]"
 exit 1
esac
