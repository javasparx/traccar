#!/usr/bin/env bash

echo "################";

if [ -z "$1" ];
then
    printf "Required argument DB_NAME is not set. \nUsage: ./recreate-db.sh DB_NAME [USERNAME].\n";
    exit 1;
else
    DB_NAME=$1;
    echo "DB_NAME is set to '$1'.";
fi

echo;

if [ -z "$2" ];
then
    echo "Optional argument USERNAME is not set. '$1' will be used as USERNAME.";
    USERNAME=$1;
    echo "USERNAME is set to '$1'.";
else
    USERNAME=$2;
    echo "USERNAME is set to '$2'.";
fi

echo;

# http://www.postgresql.org/docs/9.1/static/app-dropdb.html
# DROP DATABASE $1
echo "Droping db '$DB_NAME' if exists...";
dropdb -h localhost -p 5432 -U postgres -w -e ${DB_NAME};
echo;

# http://www.postgresql.org/docs/current/static/app-dropuser.html
# DROP user sugurta
echo "Droping user '$USERNAME' if exists...";
dropuser -h localhost -p 5432 -U postgres -w ${USERNAME};
echo;

# http://www.postgresql.org/docs/current/static/app-createuser.html
echo "Creating user '$USERNAME'...";
postgres psql -c "CREATE ROLE ${USERNAME} LOGIN ENCRYPTED PASSWORD 'md5d5db82ebff9cf696dd30d35b54fbfed9' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;";
#createuser -h localhost -p 5432 -U postgres -w --no-createdb --encrypted --no-createrole --superuser --no-replication --pwprompt ${USERNAME};

# http://www.postgresql.org/docs/9.1/static/app-createdb.html
# CREATE DATABASE ipos-dev ENCODING 'UTF8'
echo "Creating db '$DB_NAME'...";
createdb -h localhost -p 5432 -O ${USERNAME} -U postgres -w -E UTF8 -e ${DB_NAME};
echo;
echo "Recreating username and database is completed.";
echo "################";
