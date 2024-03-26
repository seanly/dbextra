#!/bin/bash

SCRIPT_PATH=`realpath "$0"`
SCRIPT_DIR=`dirname "$SCRIPT_PATH"`

echo $SCRIPT_DIR;

cd $SCRIPT_DIR

# where to backup
dest="/var/mysql/backups"
full_backup_path=${dest}/full-backup

# create backup folder if not exist
mkdir -p $dest

# create archive filenames
today=$(date +%FT%H_%M_%S)

# create date backup dir
mkdir -p $full_backup_path/$today
full_backup_file="$today.tar.gz"

# mysql backup
pushd $dest

# full backup
xtrabackup --backup --compress --target-dir=${full_backup_path}/${today} \
    --host=mysql --port=3306 --user=root --password=${MYSQL_ROOT_PASSWORD}

tar czvf ${full_backup_path}/$full_backup_file ${full_backup_path}/${today} --remove-files

pushd

# print end status message
echo "... Backup SUCCESS!"
date

echo ""
echo "Delete old files !"
find $dest/full-backup -mtime +15 -type f
find $dest/full-backup -mtime +15 -type f -exec rm -f {} \;
echo ""

# echo generated files
echo "Files generated"
ls -lh $dest
dir