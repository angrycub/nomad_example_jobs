job "java_files" {
  datacenters = ["dc1"],
  group "exec" {
    ephemeral_disk {
      migrate = true
      size    = "500"
      sticky  = true
    }
    task "graalvm_run_camel" {
      driver = "java"
      config {
        jar_path = "local/camel-standalone-helloworld-1.0-SNAPSHOT.jar"
        jvm_options = ["-Xmx1024m", "-Xms256m"]
      }
      # Location of artifact
      artifact {
        source = "http://nomad-server-1:8888/camel-standalone-helloworld-1.0-SNAPSHOT.jar"
      }
    }
  }
}
