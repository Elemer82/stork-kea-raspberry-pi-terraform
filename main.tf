provider "null" {}

resource "null_resource" "deploy_stork_kea" {
  provisioner "local-exec" {
    command = "docker-compose up -d"
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}