job "test" {
  datacenters = ["dc1"]
  type = "service"
  group "testgroup" {
    count = 1
    task "testtask" {
      driver = "docker"
      config {
        mounts = [
          {
            type = "bind"
            target = "C:\\OutMount"
            source = "C:\\Users\\Administrator\\Desktop\\output"
            readonly = false
          }
        ]
        image = "voiselle/sleepyecho:1.1"
      }
    }
  }
}