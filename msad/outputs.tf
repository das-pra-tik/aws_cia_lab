output "dns_ip_addresses_1" {
  value = sort(aws_directory_service_directory.cia-lab-msad.dns_ip_addresses)[0]
}

output "dns_ip_addresses_2" {
  value = sort(aws_directory_service_directory.cia-lab-msad.dns_ip_addresses)[1]
}

output "domain_name" {
  value = local.ad_domain
}
