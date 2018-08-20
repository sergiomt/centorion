#!/bin/bash

if getent passwd clocial > /dev/null 2>&1; then
	echo "clocial user already exists"
else
	echo "Creating clocial user"
	# Do not set any password for Linux user clocial
	adduser clocialexit
	
	su postgres -c "psql -c \"create role clocial with password 'clocial' superuser login;\""
fi

echo "Creating clocialdev database"
su postgres -c "psql -c \"create database clocialdev with owner=clocial\""
su postgres -c "psql -c \"grant all privileges on database clocialdev to clocial\""

# Create PostGIS 2.3 tables and functions in clocialdev database
echo "Creating PostGIS spatial extensions at clocialdev database"
su postgres -c "psql -d clocialdev -f /usr/pgsql-9.6/share/contrib/postgis-2.4/postgis.sql" > /dev/null
su postgres -c "psql -d clocialdev -f /usr/pgsql-9.6/share/contrib/postgis-2.4/postgis_comments.sql" > /dev/null
su postgres -c "psql -d clocialdev -f /usr/pgsql-9.6/share/contrib/postgis-2.4/spatial_ref_sys.sql" > /dev/null
su postgres -c "psql -d clocialdev -f /usr/pgsql-9.6/share/contrib/postgis-2.4/topology.sql" > /dev/null
su postgres -c "psql -d clocialdev -f /usr/pgsql-9.6/share/contrib/postgis-2.4/topology_comments.sql" > /dev/null

echo "Creating openfire database"
su postgres -c "psql -c \"create database openfire with owner=clocial\""
su postgres -c "psql -c \"grant all privileges on database openfire to clocial\""
cat /opt/openfire/resources/database/openfire_postgresql.sql | su postgres -c "psql -d openfire"

