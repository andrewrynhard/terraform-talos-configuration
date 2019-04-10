output "userdata" {
  value = [ "${data.template_file.init.rendered}", "${data.template_file.join.*.rendered}" ]
}
