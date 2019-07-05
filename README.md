The run Kibana of localhost:5601 and Graylog of localhost:9001

## Dev
### run dev
```bash
docker-compose -f docker-compose -f ../graylog/docker-compose.yml -f ../graylog//docker-compose.dev.yml down
```
### Dev result
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
### Watch result
```bash
firefox localhost:9001 # graylog
firefox localhost:8082 # mongo_ui
firefox localhost:5601 # kibana
```

## Prod
### run prod
```bash
cd ..
git clone https://github.com/senssei/mongo-cluster-docker.git
cd mongo-cluster-docker
docker-compose -f docker-compose.1.yml -f docker-compose.2.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml -f ../graylog/docker-compose.yml -f ../graylog/docker-compose.prod.yml ps
```
### Prod result
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
### Watch result 
```bash
firefox localhost:9004 # graylog
firefox localhost:5601 # kibana
firefox localhost:5000 # elasticsearch-hq 
firefox localhost:9004/haproxy # graylog stat
```

## Prod infrastructure
### Make config for Terraform
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
### Create (todo)
```bash
terraform init
terraform apply
```
