#!/bin/bash

# example usage
# ./pull_pcap.sh "{START_TIME}" "{END TIME}" "{BPF}"
# ./pull_pcap.sh "2018-11-11 01:23:45" "2018-11-12 02:34:56" "net 192.168.0.0/16 and (port 80 or port 443)"

if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then echo -e "Missing Argument(s).\nUsage is ./pull_pcap.sh \"2018-11-27 22:00\" \"2018-11-27 23:59\" \"net 192.168.0.0/16 and (port 80 or port 53)\" \n" ; exit 1; fi

# Datetime format is "YYYY-MM-DD HH:MM:SS".  Everything after YYYY-MM-DD is optional.  Enter time as granularly as you like.
# Note the + and - 1 day: Change this to the duration of your fpc pcap files. For example, if one file covers an hour on average, change to +/-1 hour.
PCAPDURATION="1 day"
PCAP_FOLDER=/home/nick/drake/pcaps/

STARTDATETIME=$(date -d "${1} -${PCAPDURATION}")
ENDDATETIME=$(date -d "${2} +${PCAPDURATION}")

# Filter format is Berkeley Packet Filter
FILTER=$3

CUREPOCH=$(date +%s)

TEMP_FOLDER=/tmp/${CUREPOCH}/
OUTPUT_FOLDER=/tmp/pull_pcap/

mkdir -p ${TEMP_FOLDER}
mkdir -p ${OUTPUT_FOLDER}

cd ${PCAP_FOLDER}
find . -type f -newermt "${STARTDATETIME}" ! -newermt "${ENDDATETIME}" -exec bash -c 'tcpdump -nnr $0 $1 -w $2/$0' "{}" "${FILTER}" "${TEMP_FOLDER}" \;

cd ${TEMP_FOLDER}
mergecap -w ${OUTPUT_FOLDER}/${CUREPOCH}.pcap *.pcap
cd
rm -rf ${TEMP_FOLDER}

echo "${OUTPUT_FOLDER}${CUREPOCH}.pcap "