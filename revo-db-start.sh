#!/bin/bash
docker run --name revo-db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=sekreto -d revo-db
#docker start revo-db

#$(docker ps -aq --filter name=revo-db)


