variable "datacenters" {
    type = list(string)
    default = ["dc1"]
}

variable "ports" {
  type = list(object({
    name     = string
    internal = number
    external = number
  }))
  default = [
    {
      name     = "db"
      internal = 8300
      external = 8300
    },
    {
      name     = "db2"
      internal = 8301
      external = 8301
    }
  ]
}

job "example" {
  datacenters = var.datacenters
  type = "batch"

  group "group" {
    task "task" {
        driver = "exec"

        config {
          command = "bash"
          args    = ["-c", "cat template.out"]
        }

        template {
          destination = "template.out"
          data        = <<EOT
{{ $ports := parseJSON `${jsonencode(var.ports)}` }}
{{range $ports}}{{.name}}:{{.external}}->{{.internal}}{{println}}{{end}}
EOT
        }
    }
  }
}
