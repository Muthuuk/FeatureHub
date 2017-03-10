#!/usr/bin/env bash

set -e

# These environment variables are local
source .env
source .env.local >/dev/null 2>&1 || true

if [ "$#" != "1" ]; then
    echo "usage: ./delete_user.sh username"
    exit 1
fi

FF_USERNAME=$1

docker exec -i $HUB_CONTAINER_NAME \
    bash <<EOF
userdel -f $FF_USERNAME
EOF

rm -rf $FF_DATA_DIR/users/$FF_USERNAME

docker exec -i $MYSQL_CONTAINER_NAME \
    mysql \
        --user=$MYSQL_ROOT_USERNAME \
        --password=$MYSQL_ROOT_PASSWORD <<EOF
DROP USER IF EXISTS '$FF_USERNAME'@'%';
EOF
