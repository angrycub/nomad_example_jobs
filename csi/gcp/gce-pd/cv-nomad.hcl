# volume registration
type = "csi"
id = "myVolume"
name = "cv-nomad"
external_id = "projects/cv-nomad-gcp-csi/zones/us-central1-a/disks/cv-disk-1"
access_mode = "single-node-writer"
attachment_mode = "file-system"
plugin_id = "gcepd"
