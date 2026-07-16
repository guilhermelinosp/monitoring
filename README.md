# monitoring

GitOps para o stack de observabilidade do cluster.

## Stack

- **Alloy** — coleta e roteamento (métricas, logs, traces)
- **Prometheus** — métricas + Grafana
- **Loki** — logs
- **Tempo** — tracing

## Workflow

Push na main → GitHub Action → ArgoCD sync.
# trigger CI runner
# runner test 1784167019
