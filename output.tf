
output "ssh-command" {
  value = "ssh -i keypair.pem ec2-user@${aws_instance.DockerInstance.public_dns}"
}

output "public-ip" {
  value = aws_instance.DockerInstance.public_ip
}

output "u5bt2023_ip" {
  value = aws_lightsail_instance.u5bt2023.public_ip_address
}

