module "lambda" {
  source      = "terraform-aws-modules/lambda/aws"
  version     = "~> 2.0"

  function_name    = "lambda-db-init"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_path      = "${path.module}/lambda"
  environment_variables = {
    DB_HOST = module.aurora_mysql.cluster_endpoint
    DB_USER = "root"
    DB_PASS = random_password.aurora_mysql_master_password.result
  }
}

resource "null_resource" "invoke_lambda" {
  depends_on = [module.aurora_mysql]

  provisioner "local-exec" {
    command = <<EOT
      aws lambda invoke --function-name ${module.lambda.lambda_function_name} output.json
    EOT
  }
}
