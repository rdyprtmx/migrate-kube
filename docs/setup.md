# setup guide

## requirements

- k3s cluster (udah ada)
- kubectl configured

## cara deploy

1. clone repo ini
2. jalankan `./scripts/deploy.sh`
3. cek pods: `kubectl get pods -n monitoring`

## testing

```bash
# test prometheus scrape
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
# buka http://localhost:9090/targets
```

## backup

buat backup etcd:
```bash
./scripts/backup-etcd.sh
```

## troubleshooting

### prometheus ga bisa scrape etcd

cek certs bener ga, cek logs:
```
kubectl logs -l app=prometheus -n monitoring
```

### grafana ga ada data

cek datasource config di `grafana/datasources/`

## notes

ini buat dev cluster doang. jangan pake di prod.
