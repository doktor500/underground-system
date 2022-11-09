#!/bin/bash

table="$1"
query="SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog';"

container_name="postgres"
container_id=`docker container ls -aqf "name=$container_name"`

while true; do
  docker exec -it "$container_id" psql -v -U "${DB_USER}" -d "${DB_NAME}" -c "$query" | grep "$table" > /dev/null
  if [ $? -eq 0 ]; then
    break
  fi
  echo "Waiting for table $table to be created..."
  sleep 5
done
