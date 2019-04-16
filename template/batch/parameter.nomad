job "parameter" {
  parameterized {
    payload       = "optional"
    meta_optional = ["CLIENT","APP"]
  }
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "command" {
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "cat local/template.out"]
      }
      template {
        data = <<EOH
{{- $myKey := printf "secret/endpoints/%s/%s/info" (env "NOMAD_META_CLIENT") (env "NOMAD_META_APP") -}}
CLIENT_ID="{{ with secret $myKey }}{{ .Data.clientID }}{{ end }}" 
CLIENT_PWD="{{ with secret $myKey }}{{ .Data.clientPWD }}{{ end }}" 
APP_ENDPOINT="{{ with secret $myKey }}{{ .Data.uriFQDN }}{{ end }}" 
  EOH

        destination = "local/template.out"
      }
    }
  }
}
