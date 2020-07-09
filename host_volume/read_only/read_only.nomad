job "example" {
  datacenters = ["dc1"]

  group "database" {
    volume "mysql" { type="host" config { source="mysql" } }
    volume "certs" { type="host" read_only=true config { source="certs" } }  
    task "maria" {
      driver = "docker"
      volume_mount { volume="mysql" destination="/var/lib/mysql" }
      volume_mount { volume="certs" destination="/certs" }
      env {
        "MYSQL_ROOT_PASSWORD" ="mypass"
      }
      config {
        image = "mariadb/server:10.3"
        port_map { db=3306 }
      }

      resources {
        cpu=500 memory=256 network { port "db" {} }
      }

      service {
        name = "mariadb"
        tags = ["persist"]
        port = "db"
        check { name="alive" type="tcp" interval="10s" timeout="2s" }
      }
    }
  }
}
