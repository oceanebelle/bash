# This script updates PostGreSQL pg_hba.conf file to allow single network (with dynamic ip) to access the postgres database regardless of the changes in the ip. 

# Alternative script for getting ip: dig +short myserver.com
export DYN_IP=`host myserver.com | awk '{print $4}'`
echo "
-- `date` --------------------------------------------
Setting $DYN_IP as client ip for PostGresSQL"

export PG_CONFIG_DIR=/etc/postgresql/9.1/main

echo Updating: $PG_CONFIG_DIR/pg_hba.conf

# Replace the old ip with the new ip.
sed -i -r "/# HOME_DYN_IP/I {n; s/([0-9]{1,3}\.){3}[0-9]{1,3}/$DYN_IP/}" $PG_CONFIG_DIR/pg_hba.conf

service postgresql restart
