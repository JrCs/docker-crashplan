#!/bin/bash

# SIGTERM-handler
term_handler() {

    # Stop crashplan
    /etc/init.d/crashplan stop

    exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill "$tail_pid"; term_handler' INT QUIT KILL TERM

/etc/init.d/crashplan start

LOGS_FILES="/var/crashplan/log/service.log.0"
for file in $LOGS_FILES; do
	[[ ! -f "$file" ]] && touch $file
done

tail -n0 -F $LOGS_FILES &
tail_pid=$!

# wait "indefinitely"
while [[ -e /proc/$tail_pid ]]; do
    wait $tail_pid # Wait for any signals or end of execution of tail
done

# Stop container properly
term_handler
