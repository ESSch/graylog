#!/bin/sh

docker run --name graylog_mongo -d mongo:3
sudo sysctl -w vm.max_map_count=262144
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf
docker run --name graylog_elasticsearch \
    -e "http.host=0.0.0.0" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -d docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.1
sudo docker run --name graylog --link graylog_mongo:mongo --link graylog_elasticsearch:elasticsearch \
    -p 9001:9000 -p 12201:12201 -p 1514:1514 -p 555:555 \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://127.0.0.1:9001/" \
    -d graylog/graylog:3.0
echo 'First log message' | nc localhost 5555
echo -n -e '{ "version": "1.1", "host": "example.org", "short_message": "A short message", "level": 5, "_some_info": "foo" }'"\0" | nc -w0 localhost 12201
firefox http://localhost:9001/ # login: admin, password: admin
