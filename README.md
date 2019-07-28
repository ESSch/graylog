# The Graylog

## Common
### Start
```bash
git clone https://github.com/ESSch/graylog.git
cd graylog/
```
### Connect
Simple connect 
```yaml
    logging:
    driver: "gelf"
    options:
      gelf-address: "udp://graylog:12201"
      tag: "api"
```
or common connect 
```bash
cp daemon.json /etc/docker/
systemctl restart docker
```
## Dev
### Preparation
```bash
export GRAYLOG_HOST=YOUR_HOST
```
### Uses
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d;
sleep 140;
docker-compose -f docker-compose.yml -f docker-compose.dev.yml ps;
```
or
```bash
docker stack deploy -c docker-compose.yml -c docker-compose.dev.yml graylog;
sleep 140;
docker stack ps graylog;
```
```bash
firefox YOUR_HOST:9001
```
### Whath logs
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs
```
or
```bash
docker service logs graylog_graylog
```
### Check a result
```
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml ps
         Name                        Command                       State                                                        Ports                                             
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
graylog_elasticsearch_1   /usr/local/bin/docker-entr ...   Up (healthy)            0.0.0.0:9200->9200/tcp, 9300/tcp                                                               
graylog_graylog_1         /docker-entrypoint.sh graylog    Up (healthy)            0.0.0.0:12201->12201/tcp, 0.0.0.0:12201->12201/udp, 0.0.0.0:1514->1514/tcp,                    
                                                                                   0.0.0.0:1514->1514/udp, 0.0.0.0:9001->9000/tcp                                                 
graylog_kibana_1          /usr/local/bin/kibana-docker     Up (healthy)            0.0.0.0:5601->5601/tcp                                                                         
graylog_mongo-express_1   tini -- /docker-entrypoint ...   Up (health: starting)   0.0.0.0:8082->8081/tcp                                                                         
graylog_mongodb_1         docker-entrypoint.sh mongod      Up (healthy)            27017/tcp                
```
### Watch a result
```bash
firefox localhost:9001 # graylog: logon "admin" and password "admin"
firefox localhost:8082 # mongo_ui
firefox localhost:5601 # kibana
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs mongo-express
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f
```
### Resources
CPU usage is 7% of Laptop. RAM usage is 2076.33MiB.
```bash
docker ps --filter="network=graylog_default" -q | docker stats
CONTAINER ID        NAME                                     CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
44d179290028        graylog_graylog_1                        0.49%               517MiB / 15.55GiB     3.25%               2.62MB / 1.65MB     396MB / 639kB       126
45215941e56d        graylog_mongo-express_1                  0.01%               26.14MiB / 15.55GiB   0.16%               40.7kB / 22.1kB     53.1MB / 8.19kB     11
65edf640be3c        graylog_kibana_1                         0.44%               98.74MiB / 15.55GiB   0.62%               121kB / 145kB       154MB / 8.19kB      11
ac29a0f9c36c        graylog_mongodb_1                        0.87%               47.45MiB / 15.55GiB   0.30%               1.55MB / 2.44MB     160MB / 13.8MB      35
e81cf680b4b1        graylog_elasticsearch_1                  5.19%               1.384GiB / 15.55GiB   8.90%               290kB / 304kB       168MB / 942kB       69
```
### Update
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```
or 
```bash
# docker service rollback graylog_mongodb 
```
### Test Graylog
#### GEFL at local
```bash
echo -n '{ "version": "1.1", "host": "example.org", "short_message": "A short message", "level": 5, "_some_info": "foo" }' | nc -w0 -u localhost 12201
```
#### GEFL of a container
```bash
docker run --rm --log-driver gelf --log-opt gelf-address='udp://127.0.0.1:12201' alpine echo 'message for Graylog'
```

## Prod
### Uses
```bash
cd ..
git clone https://github.com/senssei/mongo-cluster-docker.git
cd mongo-cluster-docker
docker-compose -f docker-compose.1.yml -f docker-compose.2.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml \
-f ../graylog/docker-compose.yml -f ../graylog/docker-compose.prod.yml up 
```
### Check a result
```
$ docker-compose -f docker-compose.1.yml -f docker-compose.2.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml -f ../graylog/docker-compose.yml -f ../graylog/docker-compose.prod.yml ps
                 Name                               Command                       State                                                Ports                                      
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mongo-1-1                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30011->27017/tcp                                                        
mongo-1-2                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30012->27017/tcp                                                        
mongo-1-3                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30013->27017/tcp                                                        
mongo-2-1                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30021->27017/tcp                                                        
mongo-2-2                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30022->27017/tcp                                                        
mongo-2-3                                docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30023->27017/tcp                                                        
mongo-cluster-docker_balancer_1          /docker-entrypoint.sh hapr ...   Up (health: starting)   0.0.0.0:9004->80/tcp                                                            
mongo-cluster-docker_elastichq_1         supervisord -c /etc/superv ...   Up (healthy)            0.0.0.0:5000->5000/tcp                                                          
mongo-cluster-docker_elasticsearch_1     /usr/local/bin/docker-entr ...   Up (healthy)            0.0.0.0:9200->9200/tcp, 9300/tcp                                                
mongo-cluster-docker_elasticsearch_2_1   /usr/local/bin/docker-entr ...   Up (healthy)            0.0.0.0:9201->9200/tcp, 9300/tcp                                                
mongo-cluster-docker_elasticsearch_3_1   /usr/local/bin/docker-entr ...   Up (healthy)            0.0.0.0:9202->9200/tcp, 9300/tcp                                                
mongo-cluster-docker_graylog_1           /docker-entrypoint.sh graylog    Up (health: starting)   0.0.0.0:12201->12201/tcp, 0.0.0.0:12201->12201/udp, 0.0.0.0:1514->1514/tcp,     
                                                                                                  0.0.0.0:1514->1514/udp, 0.0.0.0:9001->9000/tcp                                  
mongo-cluster-docker_graylog_slave_1     /docker-entrypoint.sh graylog    Up (healthy)            0.0.0.0:9002->9000/tcp                                                          
mongo-cluster-docker_kibana_1            /usr/local/bin/kibana-docker     Up (healthy)            0.0.0.0:5601->5601/tcp                                                          
mongo-cnf-1                              docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30101->27017/tcp                                                        
mongo-cnf-2                              docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30102->27017/tcp                                                        
mongo-cnf-3                              docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30103->27017/tcp                                                        
mongo-cnf-setup                          /scripts/setup-cnf.sh            Exit 0                                                                                                  
mongo-router                             docker-entrypoint.sh mongo ...   Up                      0.0.0.0:30001->27017/tcp                                                        
mongo-rs1-setup                          /scripts/setup.sh                Exit 0                                                                                                  
mongo-rs2-setup                          /scripts/setup.sh                Exit 0                                                                                                  
mongo-shard-setup                        /scripts/init-shard.sh           Exit 0       
```
### Watch a result 
```bash
firefox localhost:9004 # graylog
firefox localhost:5601 # kibana
firefox localhost:5000 # elasticsearch-hq 
firefox localhost:9004/haproxy # graylog stat
```
### Resources
CPU usage is 26.89%. Memory usage is 5.2GiB.
```bash
CONTAINER ID        NAME                                     CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
118e5db16f22        mongo-2-1                                0.54%               17.73MiB / 15.55GiB   0.11%               1.16MB / 2.37MB     25.4MB / 6.05MB     85
591cfcdcada1        mongo-cnf-3                              1.69%               22.84MiB / 15.55GiB   0.14%               1.4MB / 1.41MB      15.2MB / 11.7MB     84
106c25cf52df        mongo-cluster-docker_elasticsearch_1     0.35%               1.375GiB / 15.55GiB   8.84%               198kB / 145kB       132MB / 1.18MB      67
6b9f3f702e0f        mongo-1-2                                0.87%               24.28MiB / 15.55GiB   0.15%               2.25MB / 1.98MB     22.9MB / 16.7MB     80
362e1768989a        mongo-cluster-docker_elasticsearch_2_1   0.23%               1.375GiB / 15.55GiB   8.84%               11.6kB / 306B       136MB / 319kB       54
1a61c853373a        mongo-2-2                                0.61%               18.15MiB / 15.55GiB   0.11%               944kB / 900kB       8.45MB / 6.68MB     79
9ad1bd827660        mongo-1-3                                1.49%               24.2MiB / 15.55GiB    0.15%               2.26MB / 1.98MB     12.5MB / 16.9MB     80
d60a08c4def5        mongo-cnf-2                              1.65%               22.02MiB / 15.55GiB   0.14%               1.56MB / 1.49MB     33.6MB / 11.2MB     84
d6d28f6793df        mongo-2-3                                0.59%               18.14MiB / 15.55GiB   0.11%               944kB / 898kB       16.8MB / 6.85MB     78
b44bc1e09af8        mongo-cluster-docker_elasticsearch_3_1   0.25%               1.398GiB / 15.55GiB   8.99%               14.6kB / 306B       463MB / 991kB       54
be6b471528bb        mongo-cluster-docker_elastichq_1         0.04%               30.92MiB / 15.55GiB   0.19%               10.7kB / 0B         123MB / 90.1kB      3
1364451db688        mongo-1-1                                1.03%               25.41MiB / 15.55GiB   0.16%               5MB / 8.2MB         82MB / 16.7MB       96
aeef6e8d554a        mongo-cluster-docker_graylog_1           15.39%              258.2MiB / 15.55GiB   1.62%               969kB / 399kB       442MB / 770kB       75
a20b0f2525b0        mongo-cluster-docker_kibana_1            0.00%               78.82MiB / 15.55GiB   0.50%               153kB / 186kB       239MB / 57.3kB      11
19b04071bcc5        mongo-cnf-1                              1.47%               34.2MiB / 15.55GiB    0.21%               4.44MB / 2.23MB     81.1MB / 10.6MB     93
ca5e65ea4229        mongo-cluster-docker_balancer_1          0.01%               12.86MiB / 15.55GiB   0.08%               15MB / 292kB        189MB / 88.4MB      3
949f16663868        mongo-cluster-docker_graylog_slave_1     0.37%               484.6MiB / 15.55GiB   3.04%               2.53MB / 1.57MB     450MB / 1.65MB      129
9337d601b7a1        mongo-router                             0.31%               7.344MiB / 15.55GiB   0.05%               396kB / 312kB       71.9MB / 0B         19
```

## Prod infrastructure
### Example a config for Google Cloud Platform
```yaml
provider "google" {
  credentials = file("./kubernetes_key.json")
  project     = "node-cluster-243923"
  region      = "europe-west2"
}

module "kubernetes" {
  source  = "ESSch/kubernetes/graylog"
  version = "~>0.0.1"
}
```
### Create a infrastructure for the micro-services (todo)
```bash
terraform init
terraform apply
```

### Deploy
```bash
docker deploy -c docker-compose.yml app
```
