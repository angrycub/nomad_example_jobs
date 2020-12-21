job "template" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    count = 1

    task "command" {
      driver = "raw_exec"

      artifact {
        source      = "http://consul.service.consul:8500/v1/kv/template/test?raw"
        destination = "local/template.out"
        mode        = "file"
## You might need to pass a consul token for the API request.
#        headers {
#          X-Consul-Token = "«a consul token with access to the kv path»"
#        }
      }

      config {
        command = "bash"
        args    = ["-c", "cat local/rendered.out"]
      }

      template {
        source      = "local/template.out"
        destination = "local/rendered.out"
      }
    }
  }
}
