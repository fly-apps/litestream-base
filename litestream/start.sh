#!/bin/bash
set -e

path_prefix="file:"
export LITESTREAM_DB_URL=${DATABASE_URL#"$path_prefix"}
echo "Primary: $FLY_PRIMARY_REGION, Current: $FLY_REGION, DB URL: ${LITESTREAM_DB_URL}"
# Determine which configuration file to use based on region.
if [ "$FLY_REGION" == "$FLY_PRIMARY_REGION" ]
then
	echo "Configuring Litestream primary"
	cp -f /litestream/etc/litestream.primary.yml /etc/litestream.yml
else
	echo "Configuring Litestream replica"
	cp -f /litestream/etc/litestream.replica.yml /etc/litestream.yml
fi

if [ $# -eq 0 ]
then
	exec /litestream/bin/litestream replicate	
else
	# Run litestream with your app as the subprocess.
	exec /litestream/bin/litestream replicate --exec "$@"
fi

