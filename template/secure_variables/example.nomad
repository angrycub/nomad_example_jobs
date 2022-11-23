job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image          = "redis:7"
        ports          = ["db"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500
        memory = 256
      }

      template {
        destination = "local/template.out"
        data = <<EOH
{{ define "Header" }}{{- if eq "string" (printf "%T" .) -}}
{{- $t := sprig_default "          " . -}}{{$l := len $t}}
{{ $b1 := sprig_repeat $l "━" }}
{{ $b2 := sprig_repeat (sprig_sub 74 $l | sprig_int ) "━" }}
{{- printf "  ┏━%s━┓\n" $b1 -}}{{- printf "  ┃ %s ┃\n" $t -}}
{{- printf "━━┻━%s━┻%s\n" $b1 $b2 }}{{- end -}}{{- end -}}
{{ define "Splitter" }}{{ sprig_repeat 80 "─" | println }}{{ end }}
{{ define "Footer" }}{{ sprig_repeat 80 "━" | println }}{{ end }}

{{template "Header" "Fake List Keys" }}
{{- with nomadVarList "my" -}}
  {{- range . -}}
    {{- println .Path -}}
    {{- with nomadVar .Path  -}}
      {{- with .Metadata -}}
        {{- printf " - Namespace: %s\n" .Namespace -}}
        {{- printf " - Path: %s\n" .Path -}}
        {{- printf " - CreateTime: %s\n" .CreateTime -}}
        {{- printf " - CreateIndex: %v\n" .CreateIndex -}}
        {{- printf " - ModifyTime: %s\n" .ModifyTime -}}
        {{- printf " - ModifyIndex: %v\n" .ModifyIndex -}}
      {{- end -}}
      {{- println "Items:" -}}
      {{- range . -}}
        {{- printf "    - %s: %q\n" .Key .Value -}}
      {{- end -}}
      {{- template "Footer" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
EOH
      }

      template {
        destination = "local/template.json"
        data = <<EOH
{{ with nomadVar "my/var/a" }}{{ printf "Type: %T\n" . }}{{ sprig_toPrettyJson . }}{{end}}

{{ with nomadVar "my/var/a" }}{{ printf "Type: %T\n" .Parent }}{{ .Parent | sprig_toPrettyJson }}{{end}}

{{ with nomadVar "my/var/a" }}{{ printf "Type: %T\n" .Metadata }}{{ .Metadata | sprig_toPrettyJson }}{{end}}

{{ with nomadVar "my/var/a" }}{{ printf "Type: %T\n" .Tuples }}{{ .Tuples | sprig_toPrettyJson }}{{end}}

EOH
      }
    }
  }
}
