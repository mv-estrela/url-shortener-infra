output "ips" {
  value = {
    for name, vm in local.vms :
    name => "192.168.0.${vm.id}"
  }
}
