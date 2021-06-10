job "jar-test.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  group "java" {
    task "sample" {

      artifact {
        source = "https://github.com/angrycub/nomad_example_jobs/raw/main/java/jar-test/jar/Count.jar"
        destination = "local/artifact/" 
        # mode = "any"
        # options {
        #   archive = false
        # } 
      }

      template {
        destination = "${NOMAD_TASK_DIR}/textfile.text"
        data = <<EOT
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin molestie massa
mi, eget pulvinar purus mollis vitae. Maecenas nec eros a dui tincidunt
condimentum faucibus sed libero. Vivamus ut iaculis elit. Vivamus egestas
ornare magna in aliquet. Nulla eu massa ac magna molestie dignissim. Nunc
venenatis velit at luctus rhoncus. Sed aliquet sit amet ex et rhoncus.
Curabitur faucibus magna eget eros lobortis, eget hendrerit quam auctor.
Vivamus convallis augue quis purus rhoncus scelerisque. Proin dapibus, libero
vitae bibendum facilisis, felis libero molestie ipsum, nec auctor ex purus non
eros. Duis varius malesuada augue interdum tincidunt.

Morbi non rutrum mauris, sed tempus elit. Aenean in gravida mi. Mauris sed
ornare quam, in posuere libero. Donec facilisis orci ac diam molestie rutrum.
Interdum et malesuada fames ac ante ipsum primis in faucibus. Aenean ac nulla
ac mi sollicitudin fringilla interdum eget dui. Maecenas sollicitudin ipsum
sit amet leo tempor feugiat. Pellentesque feugiat enim et urna sollicitudin
fermentum. Ut ornare justo quis quam sagittis porta eu quis tellus. Duis vel
orci quis purus facilisis dignissim. Praesent pulvinar egestas nisi, in
vehicula nunc suscipit at. Nunc vulputate libero eget dictum viverra. Mauris
augue nisi, sodales vel rutrum vel, tincidunt sit amet sapien. Mauris
vulputate, ante nec cursus venenatis, lorem tellus consequat tellus, at
aliquam nisl tortor ut sapien. Proin pharetra blandit erat pretium lobortis.
In sit amet sodales odio.       
EOT
      }

      driver = "java"

      config {
        class_path = "local/artifact/Count.jar"
        class      = "Count"
        args       = ["local/textfile.text"]
      }
    }
  }
}
