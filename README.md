If the OS on the backup server gets redeployed, but the old storage volume remains, there can be UID mismatches preventing backups from succeeding.  Repair like so:

    root@backup:~# for host in $(ls /backup/); do for user in $(ls /backup/"${host}"/); do chown -R "${user}-at-${host}" /backup/"${host}"/"${user}"/; done; done

That action might be a good addition to this role if change status can be reported.
