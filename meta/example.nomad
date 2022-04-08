job "meta-stanza-test-job" {
  datacenters = ["dc1"]

  meta {
    TEST_NUMBER = 1
    TEST_STRING = "string"
    # Interpolation here fails for both node attributes (e.g. ${node.datacenter}) and runtime environment variables
    TEST_INTERPOLATION = "{{ env NOMAD_DC }}-{{ env NOMAD_JOB_NAME }}"
  }

  group "meta-stanza-test-group" {
    network {
      port "http" {
        to = 5000
      }
    }

    task "meta-stanza-test-task" {
      driver = "docker"

      config {
        image = "registry:latest"
        ports = ["http"]
      }

      env {
        TEST_NUMBER = "${NOMAD_META_TEST_NUMBER}"
        TEST_STRING = "${NOMAD_META_TEST_STRING}"
        TEST_INTERPOLATION = "${NOMAD_META_TEST_INTERPOLATION}"
        ENV_TEST_INTERPOLATION = "${NOMAD_DC}-${NOMAD_JOB_NAME}"
      }
    }
  }
}