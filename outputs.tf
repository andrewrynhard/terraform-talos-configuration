output "masters" {
  value = [ "${data.template_file.init_master.rendered}", "${data.template_file.join_master.*.rendered}" ]
}

output "worker" {
  value = "${data.template_file.worker.rendered}"
}
