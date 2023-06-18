#!/bin/sh

# Warning:
## This script is supposed to be used under the instance uses S3 object storage,
## so that this won't backup under `public/` directory.

TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`
BASE_DIR=`echo "temp/$TIMESTAMP"`
OUTPUT_FILE_NAME=`echo "/app/archives/$TIMESTAMP.tar.zst"`

echo "[init] delete old backup"
find /app/archives -maxdepth 1 -mtime +7 -type f -exec rm "{}" \;

echo "[init] create destination directory"
mkdir -p $BASE_DIR
mkdir -p archives

echo "[clone] dump PostgreSQL database"
pg_dump -Fc -U mastodon mastodon > $BASE_DIR/mastodon_db.dump

echo "[clone] copy Redis dump"
cp ./redis/dump.rdb $BASE_DIR/

echo "[finalize] compress backup"
cd /app/$BASE_DIR
tar --preserve-permissions --use-compress-program zstd -cf $OUTPUT_FILE_NAME .

echo "[finalize] delete temporary files"
rm -rf /app/temp/*

echo "Done! ^_^"
