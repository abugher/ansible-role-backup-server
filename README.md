# BUGS

## redeployment

If the OS on the backup server gets redeployed, but the old storage volume remains, there can be UID mismatches preventing backups from succeeding.  Repair like so:

    root@backup:~# for host in $(ls /backup/); do for user in $(ls /backup/"${host}"/); do chown -R "${user}-at-${host}" /backup/"${host}"/"${user}"/; done; done

That action might be a good addition to this role if change status can be reported.

## locking or timing

Currently, snapshots and backups do not lock one another out.  It would be ideal if snapshots were taken between backups.  Locking would introduce more potential to break either the backup process or the snapshot process.  For now, try to stagger the timing so that backups are at least likely to be finished when snapshots happen.

This would be more of a concern if backups were already coordinated with write patterns for their data.  That would be more of a concern if I had a rapidly changing data set.  Things like personal notes don't change very quickly, and if I happen to backup and then snapshot while a file is half-written, that's hard to avoid, and it also doesn't matter very much, since most of the notes are already present.  This is an interesting consideration, but not a priority.

## btrfs

Filesystem deployment and fstab configuration may not be managed at all, currently.  `mkfs.btrfs` options were not recorded.  This line is currently in use in `/etc/fstab`:

    /dev/mapper/backup /backup btrfs noatime,noauto,nodev,nosuid,noexec,compress=zlib:9,skip_balance 0 0

BTRFS management should probably be in a separate role and depended on by this role as well as the general file server role, if the general file server role ever gets updated to use BTRFS.

When and whether to perform a `balance` operation is unclear, but it may be doing more harm than good.  Note `skip_balance` in the mount options.  See [this bug report](https://forum.armbian.com/topic/59928-bug-btrfs-hits-16t-page-cache-limit-on-1t-drive/).
