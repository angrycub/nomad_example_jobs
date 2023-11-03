job "example" {
  datacenters = ["*"]

  group "g1" {
    task "pt1" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      template {
        destination = "${NOMAD_ALLOC_DIR}/traefik.toml"
        data = <<EOT
# I'm a config file
EOT
      }

      driver = "docker"

      config {
        image   = "alpine"
        entrypoint = ["/bin/sh", "-c", "exit 0"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    task "t1" {
      driver = "docker"

      config {
        image   = "alpine"
        entrypoint = ["/bin/sh", "-c"]
        args = [ <<EOH
cat /plugins-local/traefik.toml
while true; do
  sleep 0.5
done
EOH
        ]
        volumes = ["../alloc/traefik.toml:/plugins-local/traefik.toml"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
