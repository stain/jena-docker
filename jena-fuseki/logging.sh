#!/bin/sh

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    if [ -z "$LOG_FORMAT" ]; then
        LOG_FORMAT="%H:%M:%S"
    fi
    timestamp=$(date +"$LOG_FORMAT")  # Get current time in HH:MM:SS format, which is used by Fuseki logging
    printf "%s %-5s %-15s :: %s\n" "$timestamp" "$level" Entrypoint "$message"
}

translate_to_log4j2_format() {
    local strfttime_format="$1"
    # Define translation patterns using Bash parameter substitutions
    local log4j_format="$strfttime_format"
    log4j_format="${log4j_format//%a/EEE}"         # Abbreviated weekday name
    log4j_format="${log4j_format//%A/EEEE}"        # Full weekday name
    log4j_format="${log4j_format//%b/MMM}"         # Abbreviated month name
    log4j_format="${log4j_format//%B/MMMM}"        # Full month name
    log4j_format="${log4j_format//%d/dd}"          # Day of the month
    log4j_format="${log4j_format//%H/HH}"          # Hour (00-23)
    log4j_format="${log4j_format//%I/hh}"          # Hour (01-12)
    log4j_format="${log4j_format//%j/DDD}"         # Day of the year
    log4j_format="${log4j_format//%m/MM}"          # Month
    log4j_format="${log4j_format//%M/mm}"          # Minute
    log4j_format="${log4j_format//%p/a}"           # AM or PM
    log4j_format="${log4j_format//%S/ss}"          # Second
    log4j_format="${log4j_format//%y/yy}"          # Year (last two digits)
    log4j_format="${log4j_format//%Y/yyyy}"        # Full year
    log4j_format="${log4j_format//%Z/z}"           # Time zone
    log4j_format="${log4j_format//%F/yyyy-MM-dd}"  # Full date
    log4j_format="${log4j_format//%T/HH:mm:ss}"    # Full time
    log4j_format="${log4j_format//%%/%}"           # A escaped %

    echo $log4j_format
}
