job "java-driver-test.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "="
    value     = "nomad-client-1.node.consul"
  }

  group "test" {
    task "test" {
      template {
        destination = "secrets/env.txt"
        env = true
        data =<<EOT
{{- $DIVIDER = ":" }}{{ $FS_SEP = "/" -}}
{{- $TD := env "NOMAD_TASK_DIR" -}}

{{- $isWin := eq (env "attr.kernel.name") "windows" -}}
{{- if $isWin }}{{ $DIVIDER = ";" }}{{ $FS_SEP = `\` }}{{ end -}}

{{- $MEMBRANE_HOME := print $TD $FS_SEP "membrane-service-proxy-4.7.3" -}}
{{- $CP := print $MEMBRANE_HOME $FS_SEP "conf" $DIVIDER $MEMBRANE_HOME $FS_SEP "starter.jar" -}}

{{- if $isWin -}}
{{- $CP = replace `\` `\\` $CP -}}
{{- $MEMBRANE_HOME = replace `\` `\\` $MEMBRANE_HOME -}}
{{- end -}}

MEMBRANE_HOME="{{ $MEMBRANE_HOME }}"
CLASSPATH="{{ $CP }}"
EOT
      }

      artifact {
        source = "https://github.com/angrycub/JavaDriverTest/releases/download/v0.0.2/JavaDriverTest.jar"
        destination = "local/"
      }

      driver = "java"

      config {
        class = "JavaDriverTest"
        class_path = "${CLASSPATH}"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
