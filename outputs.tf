output "name_servers_apex" {
  value = data.aws_route53_zone.master_apex_hosted_zone.name_servers
}
