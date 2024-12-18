#!/bin/bash
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

source $FUSEKI_HOME/logging.sh
set -e

# Check if $LOG_FORMAT contains any invalid specifiers
# The regex ^((%[aAbBcdHIjmMpSUwWxXyYZFT%])|[^%])+$ matches strings that consist
# of valid strftime format specifiers (% followed by a valid character), any non-% character.
# It ensures the string contains valid format elements, including literals and percent signs.
# Valid examples, please date(1) manpage for information on the valid format:
# LOG_FORMAT="%y%m%d%H%M%S"             ## 241214174530
# LOG_FORMAT="%Y-%m-%d %H:%M:%S"        ## 2024-12-14 17:45:30
# LOG_FORMAT="%y-%m-%d %H:%M:%S %% %Z"  ## 24-12-14 17:45:30 % UTC

if [ ! -z "$LOG_FORMAT" ] && ! echo -n "$LOG_FORMAT" | grep -qE '^((%[aAbBcdHIjmMpSUwWxXyYZFT%])|[^%])+$'; then
    invalid_strfttime_format=$LOG_FORMAT
    unset LOG_FORMAT
    log "WARN" "Invalid strfttime date format specifier in '$invalid_strfttime_format'."
fi

if [ ! -f "$FUSEKI_BASE/shiro.ini" ] ; then
  # First time
  log "INFO" "###################################"
  log "INFO" "Initializing Apache Jena Fuseki"

  cp ${FUSEKI_HOME}/shiro.ini ${FUSEKI_BASE}/shiro.ini
  
  if [ -z "$ADMIN_PASSWORD" ] ; then
    ADMIN_PASSWORD=$(pwgen -s 15)
    log "INFO" "Randomly generated admin password:"
    log "INFO" "admin=$ADMIN_PASSWORD"
  fi
  log "INFO" "###################################"
fi

if [ -d "/fuseki-extra" ] && [ ! -d "$FUSEKI_BASE/extra" ] ; then
  ln -s "/fuseki-extra" "$FUSEKI_BASE/extra" 
fi

if [ ! -z "$LOG_FORMAT" ]; then
    cp ${FUSEKI_HOME}/log4j2.properties.templ ${FUSEKI_BASE}/log4j2.properties
    # translate the format to so it works with Log4j2
    LOG4J2_FORMAT="%d{$(translate_to_log4j2_format "$LOG_FORMAT")}"
    export LOG4J2_FORMAT
    envsubst '${LOG4J2_FORMAT}' < "$FUSEKI_BASE/log4j2.properties" > "$FUSEKI_BASE/log4j2.properties.$$" && \
        mv "$FUSEKI_BASE/log4j2.properties.$$" "$FUSEKI_BASE/log4j2.properties"
    unset LOG4J2_FORMAT
    export LOGGING="-Dlog4j2.configurationFile=$FUSEKI_BASE/log4j2.properties"
fi

# $ADMIN_PASSWORD only modifies if ${ADMIN_PASSWORD}
# is in shiro.ini
if [ -n "$ADMIN_PASSWORD" ] ; then
  export ADMIN_PASSWORD
  envsubst '${ADMIN_PASSWORD}' < "$FUSEKI_BASE/shiro.ini" > "$FUSEKI_BASE/shiro.ini.$$" && \
    mv "$FUSEKI_BASE/shiro.ini.$$" "$FUSEKI_BASE/shiro.ini"
  export ADMIN_PASSWORD
fi

# fork 
exec "$@" &

TDB_VERSION=''
if [ ! -z ${TDB+x} ] && [ "${TDB}" = "2" ] ; then 
  TDB_VERSION='tdb2'
else
  TDB_VERSION='tdb'
fi

# Wait until server is up
log "INFO" "Waiting for Fuseki to finish starting up..."
until $(curl --output /dev/null --silent --head --fail http://localhost:3030); do
  sleep 1s
done

# Convert env to datasets
printenv | egrep "^FUSEKI_DATASET_" | while read env_var
do
    dataset=$(echo $env_var | egrep -o "=.*$" | sed 's/^=//g')
    log "INFO" "Creating dataset $dataset"
    curl -s 'http://localhost:3030/$/datasets'\
         -u admin:${ADMIN_PASSWORD}\
         -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'\
         --data "dbName=${dataset}&dbType=${TDB_VERSION}"
done
log "INFO" "Fuseki is available :-)"
unset ADMIN_PASSWORD # Don't keep it in memory

# rejoin our exec
wait
