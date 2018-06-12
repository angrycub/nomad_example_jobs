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
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 1000
    }


    task "grafana" {
      driver = "docker"
      config {
        image = "grafana/grafana:5.0.4"
        port_map {
          grafana_ui = 3000
        }        
      }
      resources {
        network {
          port "grafana_ui" {}
        }
      }
      service {
        name = "grafana-ui"
        port = "grafana_ui"
        check {
          name     = "grafana-ui port alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }




    task "prometheus" {
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
      - server: '10.0.0.52:8500'
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
        image = "prom/prometheus:v2.2.1"
        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]       
        port_map {
          prometheus_ui = 9090
        }

      }
      resources {
        cpu    = 500 
        memory = 256 
        network {
          port "prometheus_ui" {}
        }
      }
      service {
        name = "prometheus-ui"
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