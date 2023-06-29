# docker-borg-b2
Automatic off-site, deduplicated, encrypted, compressed backup strategy of Docker volumes using BorgBackup and Backblaze's B2 Cloud Storage.

You can use this script to create a snapshot of your Docker volumes and sync your BorgBackup repository with a Backblaze's B2 Cloud Storage bucket.

This script assumes you already: 
1. created a BorgBackup repository using the `repokey` encryption mode. Please refer to [their documentation](https://borgbackup.readthedocs.io/en/stable/) for more information.
2. have a [Backblaze](https://www.backblaze.com/) account with an application key set up. 

## How to use
`sudo bash <path>/docker-borg-b2/make_snapshot_and_sync_b2.sh`

To automate it, make a cronjob i.e `/usr/bin/bash <path>/docker-borg-b2/make_snapshot_and_sync_b2.sh >> <log_file_path> 2>&1` 

> **Warning**: root privileges are necessary to stop and start Docker containers


