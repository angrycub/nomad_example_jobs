job "template" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    network {
      port "export" {}
      port "exstat" {
        static = 8080
      }
    }

    task "command" {
      driver = "exec"

      config {
        command = "bash"
        args    = ["-c", "cat local/template.out"]
      }

      template {
        destination = "local/template.out"
        data        = <<EOH
Constructive Play
{{ spew_sdump ( services | byTag ) }}
---
{{ $tags := services | byTag }}{{ ( len $tags.standby ) }}
---
Get Service By Tag.  Output Alternate if None found
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len $nomad.http) 0 -}}
no services
{{- else -}}
    {{- range $service := $nomad.http -}}
       {{- println $service.Address -}}
    {{- end -}}
{{ end }}
---
Get Service By Tag.  Output Alternate if None found
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len $nomad.notATag) 0 -}}
no services
{{ else -}}
    {{- range $service := $nomad.notATag }}
        {{- println $service.Address -}}
    {{- end -}}
{{ end }}
---
Get Service By Tag.  Output Alternate if None found
{{ $tag := "notATag" }}
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len (index $nomad $tag) ) 0 -}}
no services
{{ else -}}
    {{- range $service := index $nomad $tag }}
        {{- println $service.Address -}}
    {{- end -}}
{{ end }}

EOH
      }
    }
  }
}
