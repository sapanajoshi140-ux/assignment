output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}
