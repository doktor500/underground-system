#!/bin/bash

source .env.local

sh scripts/generate-connectors-config.sh

docker-compose down && docker-compose up -d

sh scripts/wait-for-postgres-table.sh $DB_STATS_TABLE && profile=integration rspec

docker-compose down
