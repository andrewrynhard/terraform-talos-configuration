output "userdata" {
  value = "${data.template_file.join.rendered}"
}
