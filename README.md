The run Kibana of localhost:5601 and Graylog of localhost:9001

```bash
ulimit -n 65536
# reboot
```

### Dev
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
firefox localhost:8082 # mongo_ui
firefox localhost:9001 # graylog
firefox localhost:5601 # kibana
```
### Prod
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
firefox localhost:9004 # graylog
firefox localhost:5601 # kibana
firefox localhost:5000 # elasticsearch-hq 
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
