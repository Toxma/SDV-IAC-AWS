module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.1"

  repository_name = join("-", [var.project, var.env, "ecr"])
  repository_type = "public" # easier for testing
}
