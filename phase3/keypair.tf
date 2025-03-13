module "key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "key"
  public_key = ""
}
