output "Webserver1_IP" {
  value = module.webserver1.public_ip
}

output "Webserver2_IP" {
  value = module.webserver2.public_ip
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}
