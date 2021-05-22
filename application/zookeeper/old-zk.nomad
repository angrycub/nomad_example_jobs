job "zookeeper" {
    datacenters = ["dc1"]
    type = "service"

    update {
        max_parallel = 1
    }

    group "zk1" {
        volume "zk" {
          type      = "host"
          read_only = false
          source    = "zk1"
        }
        count = 1

        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

        network {
            port "client" {
                to = -1
            }

            port "peer" {
                to = -1
            }

            port "election" {
                to = -1
            }

            port "admin" {
                to = 8080
            }

        }

        service {
            tags = ["client","zk1"]
            name = "zookeeper"
            port = "client"
            meta { ZK_ID = "1" }
            address_mode = "host"
        }

        service {
            tags = ["peer"]
            name = "zookeeper"
            port = "peer"
            meta { ZK_ID = "1" }
            address_mode = "host"
        }

        service {
            tags = ["election"]
            name = "zookeeper"
            port = "election"
            meta { ZK_ID = "1" }
            address_mode = "host"
        }

        service {
            tags = ["zk1-admin"]
            name = "zookeeper"
            port = "admin"
            meta { ZK_ID = "1" }
            address_mode = "host"
        }

        task "zookeeper" {
            driver = "docker"

            template {
                data=<<EOF
{{- $MY_ID := "1" -}}
{{- range $tag, $services := service "zookeeper" | byTag -}}
  {{- range $services -}}
    {{- $ID := split "-" .ID -}}
    {{- $ALLOC := join "-" (slice $ID 0 (subtract 1 (len $ID ))) -}}
    {{- if .ServiceMeta.ZK_ID -}}
      {{- scratch.MapSet "allocs" $ALLOC $ALLOC -}}
      {{- scratch.MapSet "tags" $tag $tag -}}
      {{- scratch.MapSet $ALLOC "ZK_ID" .ServiceMeta.ZK_ID -}}
      {{- scratch.MapSet $ALLOC (printf "%s_%s" $tag "address") .Address -}}
      {{- scratch.MapSet $ALLOC (printf "%s_%s" $tag "port") .Port -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- range $ai, $a := scratch.MapValues "allocs" -}}
  {{- $alloc := scratch.Get $a -}}
  {{- with $alloc -}}
server.{{ .ZK_ID }} = {{ .peer_address }}:{{ .peer_port }}:{{ .election_port }};{{.client_port}}{{println ""}}
  {{- end -}}
{{- end -}}
EOF
                destination = "config/zoo.cfg.dynamic"
                change_mode = "noop"
            }

            template {
                destination = "config/zoo.cfg"
                data = <<EOH
tickTime=2000
initLimit=30
syncLimit=2
reconfigEnabled=true
dynamicConfigFile=/config/zoo.cfg.dynamic
dataDir=/data
standaloneEnabled=false
quorumListenOnAllIPs=true
EOH
            }

            env {
                ZOO_MY_ID = 1
            }

            volume_mount {
                volume      = "zk"
                destination = "/data"
                read_only   = false
            }

            config {
                image = "zookeeper:3.6.1"

                ports = ["client","peer","election","admin"]
                volumes = [
                    "config:/config",
                    "config/zoo.cfg:/conf/zoo.cfg"
                    ]
            }

            resources {
                cpu = 300
                memory = 256
            }
        }
    }
}