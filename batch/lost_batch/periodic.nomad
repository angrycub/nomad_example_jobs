job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  periodic {
    crons = [
      "*/1 * * * * *"
    ]

    prohibit_overlap = true
  }

  group "sleepers" {
    task "wait" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "-c",
          "echo Starting; sleep=`shuf -i30-200 -n1`; echo Sleeping $sleep seconds.; sleep $sleep; echo Done; exit 0"
        ]
      }
    }
  }
}
