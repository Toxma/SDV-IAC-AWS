resource "aws_cloud9_environment_ec2" "cloud9" {
  instance_type = "t2.micro"
  name          = "cloud9-env"
  image_id      = "amazonlinux-2023-x86_64"
  subnet_id     = module.vpc.public_subnets[0]
}
