# monitoring

GitOps para o stack de observabilidade do cluster Talos.

## Stack

- **Prometheus** — métricas + Grafana
- **Loki** — logs
- **Tempo** — tracing
- **Pyroscope** — profiling contínuo
- **Alloy** — coleta e roteamento (métricas, logs, traces, profiles)

## Workflow

Push na main → GitHub Action no ARC → Helm upgrade de cada chart.
