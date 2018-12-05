Installation: 
	1. Configure pull_pcap.sh
		a. PCAPDURATION: Set to average duration of your FPC pcap files (3 hours, 1 day, etc.)
		b. PCAP_FOLDER: Set to FULL path of folder containing FPC pcap files
	2. Copy pull_pcap.sh to a safe place on your sensor (like your pcap storage directory, or /home/user).  
	3. Copy get_pcap.sh to a subdirectory of your home folder (/home/user/getpcap/ for example)
	4. Configure get_pcap.sh 
		a. SENSOR_ADDRESS: IP or address of sensor
		b. PULL_PCAP_SH_LOCATION: Wherever you put pull_pcap.sh on step 2
		c. AUTO_SHARK: true or false if you want Wireshark to start automatically upon download
		d. WIRESHARK_BIN: Location of Wireshark executable (used for autoshark)
		e. USERNAME: Select one of the username schemas


Usage:
	1. Navigate to folder where get_pcap.sh is located.
	2. Run ./get_pcap.sh "{STARTTIME}" "{ENDTIME}" "{BPF}"
		a. For example, ./get_pcap.sh "2018-12-05 01:00" "2018-12-05 08:00" "port 80 or port 53"
		b. Note the quotes around the parameters.
		c. Put the span that you are actually looking in, the PCAPDURATION var in pull_pcap.sh will handle the padding.
		d. BPF can be any valid Berkeley Packet Filter.  Be smart about this, you don't want a 2 Terabyte pcap.
	3. If Autoshark is enabled, Wireshark will automatically open.  Otherwise, open your downloaded file manually.
	4. There's basically no error checking on this, so if you bork the dates or BPF you're on your own.  Double check your command.
	5. Throughout the process, you will be asked for your password 3 times (Once to create the remote pcap file, once to download the file, and once to remove the file).  The password prompts can be avoided by using SSH keys to authenticate to the sensor rather than username/pass.
