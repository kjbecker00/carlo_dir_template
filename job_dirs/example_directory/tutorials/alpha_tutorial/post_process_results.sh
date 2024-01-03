#!/bin/bash
#-------------------------------------------------------------- 
# Author: Kevin Becker
# Date: 12/21/2023
# Example sript for mission alpha: post_process_results.sh
#-------------------------------------------------------------- 
# Part 1: Convenience functions
#-------------------------------------------------------------- 
ME=$(basename "$0")
VERBOSE=0
vecho() { if [[ "$VERBOSE" -ge "$2" || -z "$2" ]]; then echo $(tput setaf 245)"$ME: $1" $(tput sgr0); fi }

RESULTS_DIR=""
#-------------------------------------------------------
#  Part 2: Handle command-line arguments
#-------------------------------------------------------
for ARGI; do
    if [[ "${ARGI}" =~ "--job_file=" ]]; then
        JOB_FILE="${ARGI#*=}"
    elif [[ "${ARGI}" =~ "--job_args=" ]]; then
        JOB_ARGS="${ARGI#*=}"
    elif [[ "${ARGI}" =~ "--local_results_dir=" ]]; then
        RESULTS_DIR="${ARGI#*=}"
    elif [[ "${ARGI}" =~ "--local_results_dir=" ]]; then
        RESULTS_DIR="${ARGI#*=}"
    else
        echo "Unrecognized option: $ARGI"
        exit 1
    fi
done

. ${JOB_FILE} $JOB_ARGS
mkdir -p $RESULTS_DIR/web



#-------------------------------------------------------
# Part 3: Write the result of one run to a csv.
#-------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get what we want from the alog
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Find the shore alog file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -d "${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/${SHORE_MISSION}" ]; then
    FULL_MISSION_DIR="${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/${SHORE_MISSION}"
elif [ -d "${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/trunk/${SHORE_MISSION}" ]; then
    FULL_MISSION_DIR="${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/trunk/${SHORE_MISSION}"
else
    echo "Error, could not find shore mission directory at ${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/${SHORE_MISSION} or ${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/trunk/${SHORE_MISSION}. Exiting..."
    exit 1
fi
SHORE_ALOG=$(find "${FULL_MISSION_DIR}" -maxdepth 3 -type f -iname "*SHORE*.alog" 2>/dev/null | head -1)
if [ ! -f "$SHORE_ALOG" ]; then
    vecho "shore alog not found in ${FULL_MISSION_DIR} -maxdepth 3 -type f -iname *SHORE*.alog" 2
    SHORE_ALOG=$(find "${FULL_MISSION_DIR}" -maxdepth 3 -type f -iname "*.alog" 2>/dev/null | head -1)
    if [ ! -f "$SHORE_ALOG" ]; then
        vecho "No alogs found using: find ${FULL_MISSION_DIR} -maxdepth 3 -type f -iname *.alog" 2
        SHORE_ALOG=$(find "${MONTE_MOOS_CLIENT_REPOS_DIR}/${SHORE_REPO}/trunk/${SHORE_MISSION}"  -maxdepth 3 -type f -iname "*SHORE*.alog" 2>/dev/null | head -1)
    fi
fi
echo "SHORE ALOG = $SHORE_ALOG"
MOOS_KEY="WPT_EFF_DIST_ALL"
MOOS_KEY2="WPT_EFF_TIME_ALL"
MOOS_KEY3="CYCLE_INDEX"
MOOS_KEY4="WPT_INDEX"

MOOS_VALUE=$(aloggrep ${SHORE_ALOG} ${MOOS_KEY} --final -q --v)
MOOS_VALUE2=$(aloggrep ${SHORE_ALOG} ${MOOS_KEY2} --final -q --v)
MOOS_VALUE3=$(aloggrep ${SHORE_ALOG} ${MOOS_KEY3} --final -q --v)
MOOS_VALUE4=$(aloggrep ${SHORE_ALOG} ${MOOS_KEY4} --final -q --v)


KEYS="${MOOS_KEY},${MOOS_KEY2},${MOOS_KEY3},${MOOS_KEY4}"
VALUES="$MOOS_VALUE,$MOOS_VALUE2,$MOOS_VALUE3,$MOOS_VALUE4"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Write to the main output file: results.csv
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "$KEYS" >> $RESULTS_DIR/results.csv
echo "$VALUES" >> $RESULTS_DIR/results.csv




#-------------------------------------------------------
#  Part 4: Post-process the files on the *local* machine
#          NOTE: be sure to direct all files to the
#          directory $RESULTS_DIR
#-------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate a track, showing each vehicle
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
vecho "RUNNING ${MONTE_MOOS_BASE_DIR}/scripts/alog2image.py -a -i --fname=${RESULTS_DIR}/web/track.png " 1
${MONTE_MOOS_BASE_DIR}/scripts/alog2image.py -i --fname=$RESULTS_DIR/web/track.png $SHORE_ALOG
if [[ $? -ne 0 ]]; then
    echo "Error, could not run alog2image.py with shore alog $SHORE_ALOG Exit code: $EXIT_CODE. Continuing..."
fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Include some informaiton on the client
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "Ran on host:  $(cat ${CARLO_DIR_LOCATION}/myname.txt)" > $RESULTS_DIR/machine_info.txt
echo "Username:     $(id -un)"     >> $RESULTS_DIR/machine_info.txt



