resource "aws_ssm_document" "ad_join_domain" {
  name          = "ad-join-domain"
  document_type = "Command"
  content = jsonencode(
    {
      "schemaVersion" = "2.2"
      "description"   = "aws:domainJoin"
      "mainSteps" = [
        {
          "action" = "aws:domainJoin",
          "name"   = "domainJoin",
          "inputs" = {
            "directoryId"    = aws_directory_service_directory.cia-lab-msad.id,
            "directoryName"  = aws_directory_service_directory.cia-lab-msad.name,
            "dnsIpAddresses" = aws_directory_service_directory.cia-lab-msad.dns_ip_addresses
          }
        }
      ]
    }
  )
}

resource "aws_ssm_association" "ad_client" {
  name = aws_ssm_document.ad_join_domain.name
  targets {
    key    = "tag:adjoin"
    values = ["true"]
  }
}

resource "aws_iam_role" "ad_autojoin" {
  name = "ad-autojoin"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

# required it seems
resource "aws_iam_role_policy_attachment" "ssm-instance" {
  role       = aws_iam_role.ad_autojoin.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# required it seems
resource "aws_iam_role_policy_attachment" "ssm-ad" {
  role       = aws_iam_role.ad_autojoin.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_instance_profile" "ad_autojoin" {
  name = "ad-autojoin"
  role = aws_iam_role.ad_autojoin.name
}
