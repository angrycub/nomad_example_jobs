variable "body" {
  type    = string
  default = "Template Rendered"
}

job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    task "output" {
      driver = "docker"

      config {
        image          = "busybox"
        auth_soft_fail = true
        command        = "cat"
        args           = ["/local/template.out"]
      }
     
      template {
        destination = "${NOMAD_TASK_DIR}/template.out"
        data        = var.body
      }
    }
  }
}
