job "example" {
  datacenters = ["*"]
  type        = "batch"

  group "g1" {
    task "init" {
      driver = "docker"

      config {
        image          = "alpine:3.19"
        auth_soft_fail = true
        entrypoint     = [
          "sh",
          "-c",
          <<-EOS
          echo "$(date) - Writing env file..."
          echo "ENV_FROM_INIT=1" >> $NOMAD_ALLOC_DIR/env
          echo "$(date) - Sleeping for 30 seconds..."
          sleep 30
          echo "$(date) - Done."
          EOS
        ]
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }

    task "main" {
      driver = "docker"

      template {
        source = "${NOMAD_ALLOC_DIR}/env"
        env = true
        destination = "${NOMAD_SECRETS_DIR}/env.copy"
      }
      
      config {
        image          = "alpine:3.19"
        auth_soft_fail = true
        command        = "env"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
