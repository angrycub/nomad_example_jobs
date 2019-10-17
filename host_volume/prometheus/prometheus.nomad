job "prometheus" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
  group "monitoring" {
    volume "prometheus" { type="host" config { source="prometheus" } }
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    ephemeral_disk { size = 1000 }
    task "grafana" {
      volume_mount { volume="prometheus" destination="/mnt/prometheus" }
      artifact {
        source="https://gist.githubusercontent.com/angrycub/046cee11bd3d8c4ab9a3819646c9660c/raw/c699095c2cb25b896e2c709da588b668ce82f8b5/prometheus_nomad.json"
        destination="local/provisioning/dashboards/dashs"
      }
      template {
        change_mode="noop"
        destination="local/provisioning/dashboards/file_provider.yml"
        data = <<EOH
apiVersion: 1

providers:
- name: 'default'
  orgId: 1
  folder: ''
  type: file
  disableDeletion: false
  updateIntervalSeconds: 10 #how often Grafana will scan for changed dashboards
  options:
    path: {{ env "NOMAD_TASK_DIR" }}/provisioning/dashboards/dashs
EOH

      }
      template {
        change_mode="noop"
        destination="local/provisioning/datasources/prometheus_datasource.yml"
        data = <<EOH
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://{{ env "NOMAD_ADDR_prometheus_prometheus_ui" }}
EOH
      }
      env {
        "GF_SERVER_ROOT_URL"="http://127.0.0.1:9999/grafana/"
        "GF_PATHS_PROVISIONING"="/${NOMAD_TASK_DIR}/provisioning"
      }
      driver = "docker"
      config {
        image = "grafana/grafana:6.1.4"
        port_map { grafana_ui = 3000 }
      }
      resources {
        network { port "grafana_ui" {} }
      }
      service {
        name = "grafana-ui"
        port = "grafana_ui"
        tags = ["urlprefix-/grafana strip=/grafana"] 
        check {
          name     = "grafana-ui port alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "prometheus" {
      volume_mount { volume="prometheus" destination="/prometheus/data" }
      template  {
        change_mode = "noop"
        destination="local/prometheus.yml"
        data = <<EOH
---
global:
  scrape_interval:     15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'nomad'
    scrape_interval: 10s
    metrics_path: /v1/metrics
    params:
        format: ['prometheus']
    consul_sd_configs:
      - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
        token: "3ef34421-1b20-e543-65d4-54067560d377"
        services:
          - "nomad"
          - "nomad-client"
    relabel_configs:
      - source_labels: ['__meta_consul_tags']
        regex: .*,http,.*
        action: keep
EOH

      }

      driver = "docker"
      config {
        image = "prom/prometheus:v2.9.1"
        args = [
          "--web.external-url=http://127.0.0.1:9999/prometheus",
          "--web.route-prefix=/",
          "--config.file=/local/prometheus.yml"     
        ]
        port_map { prometheus_ui = 9090 }
      }
      resources {
        cpu    = 500
        memory = 256
        network { port "prometheus_ui" {} }
      }
      service {
        name = "prometheus-ui"
        #tags = ["urlprefix-/prometheus"]
        tags = ["urlprefix-/prometheus strip=/prometheus"]
        port = "prometheus_ui"
        check {
          name     = "prometheus_ui port alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
