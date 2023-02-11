#!/bin/sh
DATE=`date +%Y_%m_%d`
BASE_DIR=`echo "backup/$DATE"`
OUTPUT_FILE_NAME=`echo "compressed/$DATE.tar.zst"`

echo "[init] create destination directory: backup/${DATE}"
mkdir -p $BASE_DIR
mkdir -p compressed

echo "[clone] dump PostgreSQL database"
pg_dump -Fc -U mastodon mastodon > $BASE_DIR/mastodon_docker.dump

echo "[clone] clone .env.production"
cp ./.env.production $BASE_DIR/

echo "[clone] copy public/ (excluding cache)"
rsync -ax --exclude 'public/system/cache' public $BASE_DIR/

echo "[clone] copy Redis dump"
cp ./redis/dump.rdb $BASE_DIR/

echo "[finalize] compress backup"
tar --preserve-permissions --use-compress-program zstd -cf $OUTPUT_FILE_NAME $BASE_DIR

echo "[finalize] delete temporary files"
rm -rf /app/backup/*

echo "Done! ^_^"
