output "name_servers_shams" {
  value = aws_route53_zone.zone_shams.name_servers
}

output "name_servers_apex" {
  value = data.aws_route53_zone.master_apex_hosted_zone.name_servers
}
