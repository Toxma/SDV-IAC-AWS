data "aws_availability_zones" "available" {}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}
