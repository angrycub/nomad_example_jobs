job "nginx" {
  datacenters = ["dc1"]
  type = "system"

  group "nginx" {
    network {
      port "http" {
        static = 80
      }
    }

    service {
      name = "wp"
      port = "http"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"

        ports = ["http"]

        volumes = [
          "local:/etc/nginx/conf.d",
        ]
      }

      template {
        data = <<EOF
{{- $ServicesByTag := (service "wordpress-sites" | byTag) -}}{{- $I :=0 -}}
{{- /* {{- printf "http {\n" -}} */ -}}
{{- range $ServiceTag, $services := $ServicesByTag -}}
{{- if gt $I 0 -}}{{- printf "\n\n" -}}{{- end -}}
{{- printf "##\n## %s \n##\n" $ServiceTag -}}
{{- printf "  upstream %s {\n" $ServiceTag -}}
    {{- range $services -}}
       {{- printf "    server %s:%d;\n" .Address .Port -}}
    {{- else -}}
       {{- printf "    server 127.0.0.1:65535; # force a 502\n" -}}
    {{- end -}}
{{- printf "  }\n" }}
  server {
    listen 80;
    server_name {{$ServiceTag}}.wp.service.consul;

    location / {
      proxy_pass http://{{$ServiceTag}};
    }
  }
{{- $I = add $I 1 -}}
{{- end -}}
{{- printf "\n" -}}
{{- /* {{- printf "}\n" -}} */ -}}
EOF

        destination   = "local/load-balancer.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
    }
  }
}
