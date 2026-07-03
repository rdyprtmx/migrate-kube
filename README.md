# metrics-infra

testing prometheus + grafana for cluster k3s internal

## notes

This is just for testing purposes not for production. Do not deploy it to the production cluster before it has been reviewed.

Intended only for the GKE team that needs monitoring for development clusters.

## setup

```bash
# clone
git clone git@github.com:natanz-dev/metrics-infra.git
cd metrics-infra

# deploy
./scripts/deploy.sh
```

## struktur

```
metrics-infra/
├── prometheus/        # config prometheus
├── grafana/           # dashboards + datasource
├── alertmanager/      # alert rules
├── scripts/           # deploy + backup
├── certs/             # certs
└── docs/              # dokumentasi
```

## TODO

- [ ] tambahin alert buat pod restart
- [ ] grafana dashboard buat node resources
- [ ] auto backup etcd via cron

## contact

slack: #natanz-gke-dev
