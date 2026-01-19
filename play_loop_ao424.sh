#!/usr/bin/env bash
# usage:
# ./play_loop_ao422.sh UUT [DELAY [ PATTERNS]]

UUT=${1:-acq1001_084}
DELAY=${2:-1}
PATTERNS=${3:-ao424_patterns}

wait_for_uut_ready() {
	while true; do
		STATE=$(echo rc_local_complete | nc $UUT 4220)
		echo STATE $STATE
		if echo $STATE | grep -q 'rclc UP acq...._... ..:..:.. up'; then
			echo UUT is ready!
			break
		fi
		sleep 1
	done
}

wait_for_uut_ready

set -e

while true; do
    for file in $PATTERNS/*; do
        cat $file
	sleep $DELAY
    done
done | pv | nc $UUT 54207
