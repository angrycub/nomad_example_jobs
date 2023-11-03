## Goal

```
template {
  data = <<EOH
overrides:
  fake:
# set limits based off environment
{{ if eq "dev" (env "NOMAD_META_environment") }}
    ingestion_rate: 150000
    ingestion_burst_size: 1550000
    ingester_limits:
    max_inflight_push_requests: 30000
    max_ingestion_rate: 100000
    max_series: 1250000
    max_tenants: 1
{{ else }}
    ingestion_rate: 200000
    ingestion_burst_size: 2500000
{{ end }}

distributor_limits:
  max_ingestion_rate: 75000
  max_inflight_push_requests: 1500
  max_inflight_push_requests_bytes: 314572800

EOH

  destination = "local/runtime_config/runtime.yml"
  perms       = "777"
  change_mode = "noop"
}
```