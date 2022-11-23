job "handoff" {
  datacenters = ["dc1"]

  group "template-job" {
    task "render-template" {
      driver = "exec"

      config {
        command = "bash"
        args = ["-c", "echo \"This would be a great place to upload the template from\"; cat /alloc/template.out; while true; do sleep 300; done"]
      }

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      template {
        destination = "../alloc/template.out"
        change_mode = "restart"
        data        = <<EOF
This is a {{ printf "%s %s" "template" ". yay!" }}
EOF
      }

      resources {
        cpu = 100
        memory = 100
      }
    }

    task "main" {
      driver = "exec"

      config {
        command = "bash"
        args = ["-c", "while true; do echo $(date); sleep 30; done"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
