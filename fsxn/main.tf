resource "aws_fsx_ontap_file_system" "cia_lab_FsxnFs" {

  subnet_ids          = var.private_subnet_ids
  preferred_subnet_id = var.private_subnet_ids[0]
  security_group_ids  = [aws_security_group.fsxn.id]
  deployment_type     = var.deployment_type
  storage_type        = var.storage_type
  storage_capacity    = var.storage_capacity
  throughput_capacity = var.throughput_capacity
  //kms_key_id          = var.kms_key

  fsx_admin_password = var.fsx_admin_password

  lifecycle {
    ignore_changes = [
      storage_capacity,
      throughput_capacity
    ]
  }
}

resource "aws_fsx_ontap_storage_virtual_machine" "FsxnSvm" {
  depends_on                 = [aws_fsx_ontap_file_system.cia_lab_FsxnFs]
  file_system_id             = aws_fsx_ontap_file_system.cia_lab_FsxnFs.id
  count                      = length(var.svm_names)
  name                       = var.svm_names[count.index]
  root_volume_security_style = "UNIX"
  svm_admin_password         = var.svm_admin_password

  active_directory_configuration {
    netbios_name = var.svm_names[count.index]
    self_managed_active_directory_configuration {
      dns_ips     = var.dns_ips
      domain_name = var.domain_name
      password    = var.domain_password
      username    = "Admin"
    }
  }
  tags = {
    adjoin = "true"
  }
}

resource "aws_fsx_ontap_volume" "test" {
  depends_on                 = [aws_fsx_ontap_file_system.cia_lab_FsxnFs, aws_fsx_ontap_storage_virtual_machine.FsxnSvm]
  count                      = length(var.svm_names)
  name                       = "test"
  junction_path              = "/test"
  size_in_megabytes          = 1024
  storage_efficiency_enabled = true
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.FsxnSvm[count.index].id

  tiering_policy {
    name           = "AUTO"
    cooling_period = 2
  }
}
