#!/bin/bash

if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then echo -e "Missing Argument(s).\nUsage is ./getpcap.sh \"2018-11-27 22:00\" \"2018-11-27 23:59\" \"net 192.168.0.0/16 and (port 80 or port 53)\" \n" ; exit 1; fi


SENSOR_ADDRESS=127.0.0.1
PULL_PCAP_SH_LOCATION=/home/nick/drake/pull_pcap.sh
AUTO_SHARK=true
WIRESHARK_BIN=/usr/bin/wireshark

USERNAME=nick # if a static username
# OR
USERNAME=$(whoami) #automatically grab username from Linux

START=$1
END=$2
BPF=$3

echo "Creating remote pcap file..."
FILE_TO_DOWNLOAD=$(ssh ${USERNAME}@${SENSOR_ADDRESS} ${PULL_PCAP_SH_LOCATION} \"${START}\" \"${END}\" \"${BPF}\" 2>/dev/null)
echo "Copying remote file to local directory..."
scp ${USERNAME}@${SENSOR_ADDRESS}:${FILE_TO_DOWNLOAD} .
echo "Removing remote file..."
ssh ${USERNAME}@${SENSOR_ADDRESS} rm -f ${FILE_TO_DOWNLOAD}

FNAME=$(echo "${FILE_TO_DOWNLOAD}" | sed 's/^.*\///g')
echo "Downloaded file ${FNAME} to local directory."
if [ "${AUTO_SHARK}" = true ] ; then
	echo "Starting Wireshark..."
	${WIRESHARK_BIN} ./${FNAME}
fi