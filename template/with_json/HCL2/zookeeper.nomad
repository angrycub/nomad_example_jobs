[[- /* Template defaults as json */ -]]
[[- $Defaults := (fileContents "defaults.json" | parseJSON ) -]]

[[- /* Load variables over the defaults. */ -]]
[[- $Values := mergeOverwrite $Defaults . -]]

job "[[ $Values.zookeeper.job_name ]]" {
    datacenters = [[ $Values.zookeeper.datacenters | toJson ]]
    type = "service"

    update {
        max_parallel = 1
    }
[[- range $ID := loop 1 ( int $Values.zookeeper.node_count | add 1) ]]

    group "zk[[ $ID ]]" {
        volume "zk" {
          type      = "host"
          read_only = false
          source    = "[[ $Values.zookeeper.volume.source_prefix ]][[ $ID ]]"
        }
        count = 1

        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

[[- $Protocols := list "client" "peer" "election" "admin" ]]
        network {
[[- range $I, $Protocol := $Protocols -]]
  [[- $To := -1]]
  [[- if eq $Protocol "admin" -]]
    [[- $To = 8080 -]]
  [[- end ]]
  [[- if ne $I 0 -]][[- println "" -]][[- end ]]
            port "[[$Protocol]]" {
                to = [[$To]]
            }
[[- end ]]
        }

[[- range $I, $Protocol := $Protocols -]]
  [[- $Tags := list $Protocol -]]
  [[ if eq $Protocol "client" ]][[- $Tags = append $Tags ( printf "zk%d" $ID ) -]][[- end -]]
  [[ if eq $Protocol "admin" ]][[- $Tags = list ( printf "zk%d-admin" $ID ) -]][[- end -]]
  [[- println "" ]]
        service {
            tags = [[ $Tags | toJson ]]
            name = "[[ $Values.zookeeper.service.name ]]"
            port = "[[ $Protocol ]]"
            meta { ZK_ID = "[[ $ID ]]" }
            address_mode = "host"
        }
[[- end ]]

        task "zookeeper" {
            driver = "docker"

            template {
                destination = "config/zoo.cfg"
                data = <<EOH
[[ fileContents "zoo.cfg" ]]
EOH
            }

            template {
                data=<<EOF
[[fileContents "template.go.tmpl"]]
EOF
                destination = "config/zoo.cfg.dynamic"
                change_mode = "noop"
            }

            env {
                ZOO_MY_ID = [[ $ID ]]
            }

            volume_mount {
                volume      = "zk"
                destination = "/data"
                read_only   = false
            }

            config {
                image = "[[ $Values.zookeeper.image ]]"

                ports = ["client","peer","election","admin"]
                volumes = [
                    "config:/config",
                    "config/zoo.cfg:/conf/zoo.cfg"
                    ]
            }

            resources {
                cpu = [[ $Values.zookeeper.resources.cpu ]]
                memory = [[ $Values.zookeeper.resources.memory ]]
            }
        }
    }
[[- end ]]
}

