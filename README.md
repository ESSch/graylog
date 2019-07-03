The run Kibana of localhost:5601 and Graylog of localhost:9001

### Uses in docker compose
```bash
docker-compose up
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
