
resource "aws_ebs_volume" "vol1" {
  availability_zone = aws_instance.server1.availability_zone
  size              = 10

  tags = {
    Name       = "terraform volume"
    Team       = "Cloud"
    created-by = "Terraform"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vol1.id
  instance_id = aws_instance.server1.id
}



  
resource "aws_iam_user" "lb" {
  name = "simon2050"
 }