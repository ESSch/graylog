# The Graylog

## Dev
### Uses
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
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
firefox localhost:9001 # graylog
firefox localhost:8082 # mongo_ui
firefox localhost:5601 # kibana
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

## Mini prod
### Uses (todo)
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.mongo-rs.yml up # todo
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
```bash

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
