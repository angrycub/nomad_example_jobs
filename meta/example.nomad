job "meta-stanza-test-job" {

  type = "service"
  datacenters = ["dc1"]

  meta {
    TEST_NUMBER = 1
    TEST_STRING = "string"
    # Interpolation here fails for both node attributes (e.g. ${node.datacenter}) and runtime environment variables
    TEST_INTERPOLATION = "{{ env NOMAD_DC }}-{{ env NOMAD_JOB_NAME }}"
  }

  group "meta-stanza-test-group" {

    task "meta-stanza-test-task" {

      env {
        TEST_NUMBER = "${NOMAD_META_TEST_NUMBER}"
        TEST_STRING = "${NOMAD_META_TEST_STRING}"
        TEST_INTERPOLATION = "${NOMAD_META_TEST_INTERPOLATION}"
        ENV_TEST_INTERPOLATION = "${NOMAD_DC}-${NOMAD_JOB_NAME}"
      }

      driver = "docker"

      config {
        image = "registry:latest"

        port_map {
          http = 5000
        }
      }

      resources {
        cpu    = 500
        memory = 512 

        network {
          mbits = 25

          port "http" {
          }
        }
      }
    }
  }
}