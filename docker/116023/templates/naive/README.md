# A naive attempt

You might be tempted to fetch the template content from a dependency source, like Consul KV or Nomad variables, into a template created with `define`, like the following:

```tf
      template {
        destination = "${NOMAD_TASK_DIR}/runtime_config/runtime.yml"
        perms       = "777"
        change_mode = "noop"
        data        = <<EOH
{{ define "content" }}{{ with nomadVar "nomad/jobs/example/g1/template" }}{{.template}}{{end}}{{end}}
{{ template "content" . }}
EOH
      }
```

Unfortunately, when you run the job, you will see that the template
that you retrieved is written to the `/local` folder unrendered.

```plaintext
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
```

This is because consul-template does not run an additional rendering
pass after content is fetched from the dependency source, be it Consul KV or a Nomad variable, for safety reasons.
