#!/bin/bash

Backup_Folder=${1}
TARGET_SERVER=${2}
TARGET_SERVER_PORT=${3}
TARGET_FOLDER=${4}

if [[ $# != 4 ]]; then
	echo "usage ${0} [Source_Folder] [TARGET_SERVER] [TARGET_SERVER_PORT] [TARGET_FOLDER]"
	exit 1
fi

rsync_folder () {
	FOLDER=${1}
	exit_status=1
	while [ $exit_status -ne 0 ]; do
	    rsync -avz --progress -e "ssh -p ${TARGET_SERVER_PORT}" ${FOLDER} ${TARGET_SERVER}::NetBackup/${TARGET_FOLDER}
	    exit_status=$?
	    echo +++++ rsync folder ${FOLDER} with exit code: ${exit_status}
	    #sleep 2 seconds for ^c if required
	    sleep 2
	done
}

rsync_folder /etc
rsync_folder ${Backup_Folder}