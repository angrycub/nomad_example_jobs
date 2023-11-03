job "example" {
  type        = "batch"
  datacenters = var.datacenters

  group "template" {
    task "cat" {
      driver = "docker"

      config {
        image   = "alpine:latest"
        command = "cat"
        args = ["/local/template.out"]
      }

      env = {
        JSON = var.json
      }
      template {
        destination = "local/template.out"
        data        = <<EOT
Some Template!
env.JSON = {{env "JSON"}}
{{sprig_now}}
Parsed:
{{- spew_sprintf "%v\n" (env "JSON" | parseJSON) }}

EOT
      }
    }
  }
}

variable "datacenters" {
  type    = list(string)
  default = ["dc1"]
}

variable "json" {
  type    = string
  default = "{\"map\": { \"foo\":\"bar\", \"a\": 1 } }"
}