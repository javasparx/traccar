ECHO OFF
CLS
ECHO.

if %1.==. (
    echo Required argument DB_NAME is not set. Usage: recreate-db.bat DB_NAME [USERNAME].
    GOTO done
) else (
    set DB_NAME=%1
    echo DB_NAME is set to '%DB_NAME%'
)

if %2.==. (
    echo Optional argument USERNAME is not set. '%1' will be used as USERNAME.
    set USERNAME=%1
    echo USERNAME is set to '%1'
) else (
    set USERNAME=%2
    echo USERNAME is set to '%2'
)

REM http://www.postgresql.org/docs/9.1/static/app-dropdb.html
REM DROP DATABASE %1

echo Droping db '%DB_NAME%' if exists...
dropuser -h localhost -p 5432 -U postgres -w %USERNAME%
echo Dropped db '%DB_NAME%'

echo Creating user '%USERNAME%'...
(echo 123)|createuser -h localhost -p 5432 -U postgres -w --no-createdb --encrypted --no-createrole --superuser --no-replication --pwprompt %USERNAME%
echo Created user '%USERNAME%'

echo Creating db '%DB_NAME%'...
createdb -h localhost -p 5432 -O %USERNAME% -U postgres -w -E UTF8 -e %DB_NAME%
echo Created db '%DB_NAME%'

echo Recreating username and database is completed

GOTO DONE

:DONE

ECHO Done!
