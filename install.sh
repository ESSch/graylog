#!/bin/sh

docker run --name graylog_mongo -d mongo:3
sudo sysctl -w vm.max_map_count=262144
docker run --name graylog_elasticsearch \
    -e "http.host=0.0.0.0" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -d docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.1
sudo docker run --name graylog --link graylog_mongo:mongo --link graylog_elasticsearch:elasticsearch \
    -p 9001:9000 -p 12201:12201 -p 1514:1514 \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://127.0.0.1:9001/" \
    -d graylog/graylog:3.0
