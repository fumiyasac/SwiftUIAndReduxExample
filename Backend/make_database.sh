#!/bin/sh
docker-compose exec db bash -c "chmod 0775 docker-initdb/initdb.sh" 
docker-compose exec db bash -c "./docker-initdb/initdb.sh"
