The run Kibana of localhost:5601 and Graylog of localhost:9001

```bash
ulimit -n 65536
# reboot
```

### Dev
```bash
docker-compose -f docker-compose -f ../graylog/docker-compose.yml -f ../graylog//docker-compose.dev.yml down
firefox localhost:8082 # mongo_ui
firefox localhost:9001 # graylog
firefox localhost:5601 # kibana
```
### Prod
```bash
cd ..
git clone https://github.com/senssei/mongo-cluster-docker.git
cd mongo-cluster-docker
docker-compose -f docker-compose.1.yml -f docker-compose.2.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml -f ../graylog/docker-compose.yml -f ../graylog/docker-compose.prod.yml ps
firefox localhost:9004 # graylog
firefox localhost:5601 # kibana
firefox localhost:5000 # elasticsearch-hq 
firefox localhost:9004/haproxy # graylog stat

```

### Uses in terraform

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
