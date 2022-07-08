resource "null_resource" "beforestart" {

  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/beforestart.yml"
  }

  depends_on = [
    local_file.inventory
  ]
}


resource "null_resource" "myplay" {

  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/myplay.yml"
    on_failure = continue
  }

  depends_on = [
    null_resource.beforestart
  ]
}
