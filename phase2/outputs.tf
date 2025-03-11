output "ip_vm1" {
  value = module.webserver1.public_ip
}

output "ip_vm2" {
  value = module.webserver2.public_ip
}

output "rds_endpoint" {
  value = module.db.db_instance_endpoint
}
