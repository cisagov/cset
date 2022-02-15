# Executes the database startup script, and then run the service in the container

/bin/bash /data/database.sh & /opt/mssql/bin/sqlservr