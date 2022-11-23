job "handoff" {
  datacenters = ["dc1"]
  type = "batch"

  group "template-job" {
    task "render-template" {
      driver = "exec"

      config {
        command = "bash"
        args = ["-c", "echo \"This would be a great place to upload the template from\"; cat /alloc/template.out"]
      }

      lifecycle {
        hook = "prestart"
      }

      template {
        data=<<EOF
This allocation is running on {{ env "attr.unique.network.ip-address" }}
EOF
        destination = "../alloc/template.out"
      }
    }

    task "main" {
      driver = "raw_exec"

      config {
        command = "bash"
        args = ["-c", "cat $NOMAD_ALLOC_DIR/template.out"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
