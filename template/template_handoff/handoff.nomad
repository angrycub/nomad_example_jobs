job "handoff" {
  datacenters = ["dc1"]
  type = "batch"
  group "template-job" {
    task "render-template" {
      lifecycle {
        hook = "prestart"
      }
      template {
        data=<<EOF
This is a {{ printf "%s %s" "template" ". yay!" }}
EOF
        destination = "../alloc/template.out"
      }
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "echo \"This would be a great place to upload the template from\"; cat /alloc/template.out"]
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
