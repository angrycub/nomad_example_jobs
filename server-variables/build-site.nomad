job "build-site" {
  datacenters = ["dc1"]
  type        = "batch"

  parameterized {
    meta_required = ["site_name"]
  }

  group "sitebuilder" {
    task "generate-password" {
      driver = "raw_exec"

      config {
        command = "secret/generate_keys.sh"
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      template {
        destination = "secret/generate_keys.sh"
        env         = true
        data        = <<EOT
#!/bin/bash
{{- $NMSN := env "NOMAD_META_site_name" -}}
{{- $UUID := "${uuidv4}" -}}
Site={{ $NMSN }}
UUID={{ $UUID }}
CONSUL_HTTP_TOKEN=c62d8564-c0c5-8dfe-3e75-005debbd0e40
echo "Creating credentials for site $Site..."
consul kv put wordpress/sites/$Site/db/user wp-site-$Site
consul kv put wordpress/sites/$Site/db/pass $UUID
consul kv put wordpress/sites/$Site/db/name wordpress-$Site
EOT
      }
    }

    task "make-database" {
      driver = "docker"

      config {
        image = "arey/mysql-client"
        args = [
          "--host=${MYSQL_HOST}",
          "--port=${MYSQL_PORT}",
          "--user=root",
          "--password=${MYSQL_PASSWORD}",
          "--execute=\"source /local/run.sql\""
        ]
      }

      template {
        destination = "local/run.sql"
        data        = <<EOT
CREATE DATABASE {{ printf "wordpress-%s" .Name }};
CREATE USER {{ .User }} identified by {{ .Pass }};
EOT
      }

      template {
        destination = "secrets/env.txt"
        env         = true
        data        = <<EOT
MYSQL_PASSWORD=somewordpress
EOT
      }
    }
  }
}
