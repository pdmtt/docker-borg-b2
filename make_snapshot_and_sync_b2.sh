#!/bin/bash

echo -e "\n@@@@ Starting backup creation and cloud syncing in  `date` @@@@\n"

# Installing dependencies
apt update && apt install -y --upgrade python3 python3-pip borgbackup
/usr/bin/pip3 install b2

DOTENV_FILE="$(dirname $0)"/.env
if test -f "$DOTENV_FILE"; then
	export $(cat "$DOTENV_FILE" | xargs)

	/usr/bin/docker stop $(/usr/bin/docker ps -q)  # Stopping all active containers to avoid data corruption

	/usr/bin/borg create ::"$(date +%Y%m%d)"_"$BACKUP_NAME" /var/lib/docker/volumes --stats --compression zlib,6  # Creating new snapshot

	if [ $? == 0  ]; then  # If snapshot creation is successful
		/usr/bin/borg prune -v --list --keep-daily=3 --keep-weekly=2 --keep-monthly=2  # Prunning older snapshots
		/usr/bin/borg with-lock b2 sync ${BORG_REPO} b2://"${B2_BUCKET_NAME}"  # Syncing with B2 Cloud Storage's bucket
	fi

	/usr/bin/docker start $(/usr/bin/docker ps -aq)  # Starting all stopped containers

else
	echo "Aborting: dotenv file not found"
fi
