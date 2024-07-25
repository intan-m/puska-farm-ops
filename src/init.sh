#!/bin/bash

# Initiate Table
ls /src/ddl/table | while read query
do
  psql -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-postgres} -f /src/ddl/table/$query
done

# Initiate View
ls /src/ddl/view | while read query
do
  psql -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-postgres} -f /src/ddl/view/$query
done