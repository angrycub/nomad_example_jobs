job "nginx" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
  group "group" {
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    task "nginx_docker" {
      template {
        destination   = "local/nginx.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
        data = <<EOH
{{ range $tag, $services := services | byTag }}{{ if $tag | regexMatch "urlprefix-[^:]" }}{{ range $services }} {{ $name := .Name }} {{ $service := service .Name }}
upstream {{ $name }} {
  zone upstream-{{$name}} 64k;
  {{range $service}}server {{.Address}}:{{.Port}} max_fails=3 fail_timeout=60 weight=1;
  {{else}}server 127.0.0.1:65535; # force a 502{{end}}
} {{end}}{{end}}{{end}}

server {
  listen 80 default_server;

  location / {
    root /usr/share/nginx/html/;
    index index.html;
  }

  location /stub_status {
    stub_status;
  }

{{ range $tag, $services := services | byTag }}{{ if $tag | regexMatch "urlprefix-[^:]" }}{{ $path := $tag | replaceAll "urlprefix-" "" }}{{ range $services }}{{with service .Name}}{{ with index . 0}}
  location {{$path}} {
    proxy_pass http://{{.Name}};
  }
{{end}}{{end}}{{end}}{{end}}{{end}}
}
EOH

      }
      driver = "docker"
      config {
        image = "nginx:1.13.11"
        volumes = [ "local/nginx.conf:/etc/nginx/conf.d/default.conf"]
        port_map {
          http = 80
        }
      }
      resources {
        memory = 128 
        network {
          mbits = 10
          port "http" {}
        }
      }
      service {
        name = "nginx"
        tags = ["lb"]
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
