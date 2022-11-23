job "mariadb" {
  datacenters = ["dc1"]
  type = "service"
  group "bootstrap" {
    count = 1

    network {
       mode = "bridge"
       port "mysql" {
         to     = 3306
       }
    }

    service {
      name = "mariadb-${NOMAD_ALLOC_ID}"
      port = "mysql"
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"        
      }
    }

    task "mariadb-bootstrap" {
      driver = "docker"
      user = "root"
      config {
        image = "bitnami/mariadb-galera:10.5"
      }
      env {
        MARIADB_GALERA_NODE_NAME = "localhost"
        MARIADB_GALERA_NODE_ADDRESS = "${NOMAD_ADDRESS_mariadb-bootstrap}"
        MARIADB_GALERA_CLUSTER_BOOTSTRAP = "yes"
        MARIADB_GALERA_CLUSTER_ADDRESS = "${NOMAD_ADDRESS_mariadb-bootstrap}"
        MARIADB_GALERA_CLUSTER_NAME = "my_galera"
        MARIADB_GALERA_MARIABACKUP_USER = "my_mariabackup_user"
        MARIADB_GALERA_MARIABACKUP_PASSWORD = "my_mariabackup_password"
        MARIADB_ROOT_PASSWORD = "my_root_password"
        MARIADB_USER = "my_user"
        MARIADB_PASSWORD = "my_password"
        MARIADB_DATABASE = "my_database"
      }
    }
  }
}
