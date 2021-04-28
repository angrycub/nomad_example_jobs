job "handoff" {
  datacenters = ["dc1"]
  type = "service"
  group "template-job" {
    task "render-template" {
      lifecycle {
        hook = "prestart"
        sidecar = true
      }
      template {
        data=<<EOF
This is a {{ printf "%s %s" "template" ". yay!" }}
EOF
        destination = "../alloc/template.out"
        change_mode = "restart"
      }
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "echo \"This would be a great place to upload the template from\"; cat /alloc/template.out; while true; do sleep 300; done"]
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
