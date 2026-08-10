variable "conf" {
  default = "https://gist.githubusercontent.com/darkslategrey/37620fab3f5922240d73ba8185519176/raw/02552253e3630ea55e7e52fc70756285cfdc2875/gistfile1.txt"
}

job "airflow" {
  datacenters = ["dc1"]
  type        = "service"

  meta {
    deploy = uuidv4()
  }

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = false
    canary            = 0
  }

  constraint {
    attribute  = "${node.unique.name}"
    value = "client-1"
    operator = "="
    # weight    = 100
  }

  group "airflow" {

    volume "airflow" {
      type      = "host"
      source    = "airflow"
      read_only = false
    }
    volume "airflow-inputs" {
      type      = "host"
      source    = "airflow-inputs"
      read_only = false
    }
    volume "csi" {
      type      = "host"
      source    = "csi"
      read_only = false
    }

    network{
      dns {
        servers = ["${attr.unique.network.ip-address}"]
      }
      port "afwebserver"{
        #static = 8080
        to = 8080
      }
    }

    task "chown-opt-airflow" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      volume_mount {
        volume = "airflow"
        destination = "/opt/airflow"
        read_only = false
      }
      driver = "docker"
      user = "root"
      template {
        data = <<EOH
#!/bin/bash -x

# for d in config logs dags plugins
for d in config plugins
do
  [ -d /opt/airflow/$d ] && rm -rf /opt/airflow/$d
  mkdir /opt/airflow/$d
done

chown -R airflow:0 /opt/airflow

for i in /opt/airflow/airflow-webserver.pid  \
  /opt/airflow/airflow-worker.pid \
  /opt/airflow/airflow.cfg
do
  [ -f $i ] && rm $i
done
touch /opt/airflow/plugins/__init__.py
EOH
        destination = "local/init.sh"
        perms = "755"
      }

      config {
        image = "apache/airflow:2.2.5"
        entrypoint = ["/bin/bash"]
        volumes = [
          "local/init.sh:/init.sh"
        ]
        # command = "/init.sh"
        args = [
          "-c",
          "/init.sh"
        ]
      }
    }
    task "airflow-webserver" {
      restart {
        attempts = 2
        interval = "10m"
        delay    = "15s"
        mode     = "fail"
      }

      service {
        name = "airflow"
        port = "afwebserver"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.airflow.rule=Host(`airflow.domain.com`)"
        ]

        check {
          type     = "http"
          # type     = "tcp"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
      driver = "docker"
      user = "50000:0"
      env {
        AIRFLOW__CORE__EXECUTOR= "CeleryExecutor"
        AIRFLOW__CORE__SQL_ALCHEMY_CONN= "postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__RESULT_BACKEND= "db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__BROKER_URL= "redis://:@redis.service.consul:6379/0"
        AIRFLOW__CORE__FERNET_KEY= ""
        AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION= "true"
        AIRFLOW__CORE__LOAD_EXAMPLES= "false"
        AIRFLOW__API__AUTH_BACKEND= "airflow.api.auth.backend.basic_auth"
        _PIP_ADDITIONAL_REQUIREMENTS= "environs influxdb_client"
        AIRFLOW__SMTP__SMTP_HOST= "smtp.service.consul"
        AIRFLOW__SMTP__SMTP_USER= ""
        AIRFLOW__SMTP__SMTP_PASSWORD= ""
        AIRFLOW__SMTP__SMTP_MAIL_FROM= ""
        LM_EXPORTS_TOKEN= "${LM_EXPORTS_TOKEN}"
        LM_EXPORTS_COMPANIES= "${LM_EXPORTS_COMPANIES}"
        LM_EXPORTS_EMAILS= "${LM_EXPORTS_EMAILS}"
        WEEKLY_ALERTS = ""
        DAILY_ALERTS = ""
        RS_PREPROD=1
        # AIRFLOW__WEBSERVER__BASE_URL="http://localhost:8080/airflow"
        # AIRFLOW__CLI__ENDPOINT_URL="http://localhost:8080/airflow"
      }

      volume_mount {
        volume = "airflow"
        destination = "/opt/airflow"
        read_only = false
      }
      volume_mount {
        volume = "airflow-inputs"
        destination = "/airflow-tmp"
        read_only = false
      }
      volume_mount {
        volume = "csi"
        destination = "/csi"
        read_only = false
      }

      artifact {
        source      = "${var.conf}"
        destination = "local/airflow.cfg"
      }

      template  {
        data = <<EOD
# pyton content
EOD
        destination = "local/file.py"
      }
      config {
        image = "apache/airflow:2.2.5"
        entrypoint = ["/entrypoint"]
        args = ["airflow", "webserver"]
        # command="webserver"
        ports=["afwebserver"]
        volumes = [
          "local/airflow.cfg/gistfile1.txt:/opt/airflow/airflow.cfg",
        ]
      }
      resources {
        cpu    = 100
        memory = 1300
      }
    }
    task "airflow-worker" {
      restart {
        attempts = 2
        interval = "10m"
        delay    = "15s"
        mode     = "fail"
      }

      driver = "docker"
      user = "50000:0"

      # TODO: in `.env-preprod` file
      env {
        AIRFLOW__CORE__EXECUTOR= "CeleryExecutor"
        AIRFLOW__CORE__SQL_ALCHEMY_CONN= "postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__RESULT_BACKEND= "db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__BROKER_URL= "redis://:@redis.service.consul:6379/0"
        AIRFLOW__CORE__FERNET_KEY= ""
        AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION= "true"
        AIRFLOW__CORE__LOAD_EXAMPLES= "false"
        AIRFLOW__API__AUTH_BACKEND= "airflow.api.auth.backend.basic_auth"
        _PIP_ADDITIONAL_REQUIREMENTS= "environs influxdb_client"
        AIRFLOW__SMTP__SMTP_HOST= "smtp.service.consul"
        AIRFLOW__SMTP__SMTP_USER= ""
        AIRFLOW__SMTP__SMTP_PASSWORD= ""
        AIRFLOW__SMTP__SMTP_MAIL_FROM= "airflow@domain.com"
        LM_EXPORTS_TOKEN= "${LM_EXPORTS_TOKEN}"
        LM_EXPORTS_COMPANIES= "${LM_EXPORTS_COMPANIES}"
        LM_EXPORTS_EMAILS= "${LM_EXPORTS_EMAILS}"
        WEEKLY_ALERTS = ""
        DAILY_ALERTS = ""
        DUMB_INIT_SETSID = "0"
        AIRFLOW_UID=50000
        GOOGLE_APPLICATION_CREDENTIALS = "/secrets/creds.json"

        # AIRFLOW__CORE__EXECUTOR="CeleryExecutor"
        # AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        # AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        # AIRFLOW__CELERY__BROKER_URL="redis://:@redis.service.consul:6379/0"
        # AIRFLOW__CORE__FERNET_KEY=""
        # AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION="true"
        # AIRFLOW__CORE__LOAD_EXAMPLES="false"
        # AIRFLOW__API__AUTH_BACKENDS="airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"
        # AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK="true"
        # AIRFLOW__LOGGING__CELERY_LOGGING_LEVEL="DEBUG"
      }
      volume_mount {
        volume = "airflow"
        destination = "/opt/airflow"
        read_only = false
      }

      volume_mount {
        volume = "airflow-inputs"
        destination = "/airflow-tmp"
        read_only = false
      }
      volume_mount {
        volume = "csi"
        destination = "/csi"
        read_only = false
      }

      artifact {
        source      = "${var.conf}"
        destination = "local/airflow.cfg"
      }

      config {
        image = "apache/airflow:2.2.5"
        entrypoint = ["/entrypoint"]
        args = ["airflow", "celery", "worker"]
        volumes = [
          "local/airflow.cfg/gistfile1.txt:/opt/airflow/airflow.cfg",
        ]
      }
      resources {
        cpu    = 100
        memory = 2300
      }
    }
    task "airflow-scheduler" {
      restart {
        attempts = 2
        interval = "10m"
        delay    = "15s"
        mode     = "fail"
      }

      driver = "docker"
      user = "50000:0"

      env {
        AIRFLOW__CORE__EXECUTOR= "CeleryExecutor"
        AIRFLOW__CORE__SQL_ALCHEMY_CONN= "postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__RESULT_BACKEND= "db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__BROKER_URL= "redis://:@redis.service.consul:6379/0"
        AIRFLOW__CORE__FERNET_KEY= ""
        AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION= "true"
        AIRFLOW__CORE__LOAD_EXAMPLES= "false"
        AIRFLOW__API__AUTH_BACKEND= "airflow.api.auth.backend.basic_auth"
        _PIP_ADDITIONAL_REQUIREMENTS= "environs influxdb_client"
        AIRFLOW__SMTP__SMTP_HOST= "smtp.service.consul"
        AIRFLOW__SMTP__SMTP_USER= ""
        AIRFLOW__SMTP__SMTP_PASSWORD= ""
        AIRFLOW__SMTP__SMTP_MAIL_FROM= "airflow@domain.com"
        LM_EXPORTS_TOKEN= "${LM_EXPORTS_TOKEN}"
        LM_EXPORTS_COMPANIES= "${LM_EXPORTS_COMPANIES}"
        LM_EXPORTS_EMAILS= "${LM_EXPORTS_EMAILS}"
        WEEKLY_ALERTS = ""
        DAILY_ALERTS = ""
        AIRFLOW_UID=50000

        # AIRFLOW__CORE__EXECUTOR="CeleryExecutor"
        # AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        # AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        # AIRFLOW__CELERY__BROKER_URL="redis://:@redis.service.consul:6379/0"
        # AIRFLOW__CORE__FERNET_KEY=""
        # AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION="true"
        # AIRFLOW__CORE__LOAD_EXAMPLES="false"
        # AIRFLOW__API__AUTH_BACKENDS="airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"
        # AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK="true"
      }
      volume_mount {
        volume = "airflow"
        destination = "/opt/airflow"
        read_only = false
      }

      volume_mount {
        volume = "airflow-inputs"
        destination = "/airflow-tmp"
        read_only = false
      }
      volume_mount {
        volume = "csi"
        destination = "/csi"
        read_only = false
      }

      artifact {
        source      = "${var.conf}"
        destination = "local/airflow.cfg"
      }

      config {
        image = "apache/airflow:2.2.5"
        entrypoint = ["/entrypoint"]
        # command = "scheduler"
        args=["airflow", "scheduler"]
        volumes = [
          "local/airflow.cfg/gistfile1.txt:/opt/airflow/airflow.cfg",
        ]
      }
      resources {
        cpu    = 100
        memory = 1300
      }
    }
    task "airflow-triggerer" {
      restart {
        attempts = 2
        interval = "10m"
        delay    = "15s"
        mode     = "fail"
      }

      driver = "docker"
      user = "50000:0"

      env {
        AIRFLOW__CORE__EXECUTOR= "CeleryExecutor"
        AIRFLOW__CORE__SQL_ALCHEMY_CONN= "postgresql+psycopg2://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__RESULT_BACKEND= "db+postgresql://airflow:airflow@postgres.service.consul/airflow"
        AIRFLOW__CELERY__BROKER_URL= "redis://:@redis.service.consul:6379/0"
        AIRFLOW__CORE__FERNET_KEY= ""
        AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION= "true"
        AIRFLOW__CORE__LOAD_EXAMPLES= "false"
        AIRFLOW__API__AUTH_BACKEND= "airflow.api.auth.backend.basic_auth"
        _PIP_ADDITIONAL_REQUIREMENTS= "environs influxdb_client"
        AIRFLOW__SMTP__SMTP_HOST= "smtp.service.consul"
        AIRFLOW__SMTP__SMTP_USER= ""
        AIRFLOW__SMTP__SMTP_PASSWORD= ""
        AIRFLOW__SMTP__SMTP_MAIL_FROM= "airflow@domain.com"
        LM_EXPORTS_TOKEN= "${LM_EXPORTS_TOKEN}"
        LM_EXPORTS_COMPANIES= "${LM_EXPORTS_COMPANIES}"
        LM_EXPORTS_EMAILS= "${LM_EXPORTS_EMAILS}"
        WEEKLY_ALERTS = ""
        DAILY_ALERTS = ""

        AIRFLOW_UID=50000
      }

      volume_mount {
        volume = "airflow"
        destination = "/opt/airflow"
        read_only = false
      }

      volume_mount {
        volume = "airflow-inputs"
        destination = "/airflow-tmp"
        read_only = false
      }

      volume_mount {
        volume = "csi"
        destination = "/csi"
        read_only = false
      }

      artifact {
        source      = "${var.conf}"
        destination = "local/airflow.cfg"
      }

      config {
        image = "apache/airflow:2.2.5"
        entrypoint = ["/entrypoint"]
        args=["airflow", "scheduler"]
        # command = "airflow"
        # args = ["triggerer"]
        volumes = [
          "local/airflow.cfg/gistfile1.txt:/opt/airflow/airflow.cfg",
        ]
      }
      resources {
        cpu    = 100
        memory = 1300
      }
    }
  }
}

