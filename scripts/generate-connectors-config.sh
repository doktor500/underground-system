#!/bin/bash

source .env.local

rm kafka/ksql/connectors/postgres-source.json
rm kafka/ksql/connectors/postgres-sink.json

ENV_VARS=`cat .env.local | sed 's/[^ ]* //' | sed 's;=.*;;' | sed 's/^/$/' | tr '\n' ','`

envsubst $ENV_VARS < kafka/ksql/connectors/templates/postgres-source.json > kafka/ksql/connectors/postgres-source.json
envsubst $ENV_VARS < kafka/ksql/connectors/templates/postgres-sink.json > kafka/ksql/connectors/postgres-sink.json
