#!/bin/bash

# note the start time of script
start_time=$(date +%s)

# store arg values
duration_in_seconds=$1
interval_in_seconds=$2
output_file_path=$3

# keep log file open(append mode) until script finishes using a file descriptor 47
exec 47>> "$output_file_path"

# function to log output of command
logger() {
    current_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    # command=$(ps aux --sort=-%cpu | awk 'NR==1 || $3>0 || $4>0' | awk '{print $1, $3, $4, $8, $10, $11}' | column -t)
    command=$(ps aux --sort=-%cpu)
    # command=$(kubectl get pod | grep "aosp")
    # append the timestamp and command output to log file
    printf "%s\n%s\n\n" "$current_timestamp" "$command" >&47
}

# loop that runs until duration value is reached
while true; do
    current_time=$(date +%s)
    time_elapsed=$((current_time-start_time))
    if [ $time_elapsed -ge $duration_in_seconds ]; then
        break
    else
        logger
        # wait for interval time
        sleep $interval_in_seconds
    fi
done

# Close the file descriptor
exec 47>&-

printf "Logging complete. Logs are saved in file $output_file.\n"
