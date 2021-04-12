job "«job_name»" {
  datacenters = ["«datacenter»"]

  group "«group_name»" {
    task "«job_name»" {
      driver = "«driver_type»"
    }
  }
}