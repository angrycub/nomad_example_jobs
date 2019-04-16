job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "command" {
      resources { network { port "export" {} port "exstat" { static=8080 } } }
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "cat local/template.out"]
      }
      template {
        data = <<EOH
Constructive Play
{{ printf "%q" ( services | byTag ) }}
---
{{ $tags := services | byTag }}
{{ ( len $tags.standby ) }}
---
Get Service By Tag.  0utput Alternate if None found
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len $nomad.http) 0 -}}
no services
{{- else -}}
    {{- range $service := $nomad.http -}}
       {{- $service.Address }}
    {{ end -}}
{{ end }}
---
Get Service By Tag.  0utput Alternate if None found
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len $nomad.notATag) 0 -}}
no services
{{ else -}}
    {{- range $service := $nomad.notATag }}
        {{ $service.Address }}
    {{ end -}}
{{ end }}
---
Get Service By Tag.  0utput Alternate if None found
{{ $tag := "notATag" }}
{{ $nomad := service "nomad" | byTag }}
{{- if eq (len (index $nomad $tag) ) 0 -}}
no services
{{ else -}}
    {{- range $service := index $nomad $tag }}
        {{ $service.Address }}
    {{ end -}}
{{ end }}

EOH

        destination = "local/template.out"
      }
    }
  }
}
