#!/bin/bash
Backup_Folder=${1}
TARGET_SERVER=${2}
TARGET_SERVER_PORT=${3}
TARGET_FOLDER=${4}

if [[ $# != 4 ]]; then
    echo "usage ${0} [Source_Folder] [TARGET_FOLDER] [TARGET_SERVER_PORT] [TARGET_FOLDER]"
    exit 1
fi

rsync_folder () {
    FOLDER=${1}
    exit_status=1
    while [[ $exit_status -ne 0 ]] && [[ $exit_status -ne 23 ]]
    #error code 23: Partial transfer due to error
    do
        date
        rsync -avz --delete --progress -e "ssh -p ${TARGET_SERVER_PORT}" ${FOLDER} ${TARGET_SERVER}::NetBackup/${TARGET_FOLDER}
        exit_status=$?
        echo +++++ rsync folder ${FOLDER} with exit code: ${exit_status}
        #sleep 2 seconds for ^c if required
        sleep 2
    done
}

rsync_folder /etc
rsync_folder ${Backup_Folder}


# rsync error code
# 0      Success
# 1      Syntax or usage error
# 2      Protocol incompatibility
# 3      Errors selecting input/output files, dirs
# 4      Requested  action not supported: an attempt was made to manipulate 64-bit files on a platform 
#       that cannot support them; or an option was specified that is supported by the client and not by the server.
# 5      Error starting client-server protocol
# 6      Daemon unable to append to log-file
# 10     Error in socket I/O
# 11     Error in file I/O
# 12     Error in rsync protocol data stream
# 13     Errors with program diagnostics
# 14     Error in IPC code
# 20     Received SIGUSR1 or SIGINT
# 21     Some error returned by waitpid()
# 22     Error allocating core memory buffers
# 23     Partial transfer due to error
# 24     Partial transfer due to vanished source files
# 25     The --max-delete limit stopped deletions
# 30     Timeout in data send/receive
# 35     Timeout waiting for daemon connection
