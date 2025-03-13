provider "aws" {
  region     = local.region
  access_key = "ASIARDIAU5BKVXMCZHDN"
  secret_key = "WjjJufhEwnj+hy5rqrCl+uGtlOYkyeByN4nfUpdv"
  token      = "IQoJb3JpZ2luX2VjEIr//////////wEaCXVzLXdlc3QtMiJHMEUCIQD5xVGNmwPqMyoHe3PfZLna7w8+OBd+XNLtJUXPJ516MQIgFKfvijrBUCXyw2EZF/0+OGM33NJZEJ1s4s0/QlqA3aIqsQII0v//////////ARAAGgwwNzU3MDAxNjg3ODkiDKA9hRbWHCKyxwPwmiqFAsX6pK20wKe/EaEFFCoUT+CU+Tz58ZBXv3kYaHlYV3Xr4UGcVTrCKjQmIbFV9gGEyWslNJUocxA0iUdCo8QUTmSkFoxYDFyvODoBa93OVA/BNU7DZSgAz8eEonE7cpfEJdHGIg165Yv9Wg6SoMnqyEPeCjSib1MQFdjHyXwGtqo43nvmCeE2NslbGyKrFDZ+3whTd7MdwDlyZd4jtsbOm1R4oNLsyGaGb5mCQsmS5j3Q3HxXjcozDptrdn4W15nSYX63rVa2OEqKoroxbxCaKTeM+q8+SARsmt57JJDrR+gY4eY5okCxfuAbJ016iJKWVaehIDKxjg21JM7RCGttB1EYiqHITjDkxcq+BjqdATxUzYQZAU7XN6PdfcHRQ188+HAdCArWpw2bFzr2gr+5zAv9JNAQ+L9O/xpFQtjVTiaKFkpEKTv4SJd68WLsTTYez4Dw4opZpvZlIq4N1L1DzdTdDiSxTRgrSNIG60Dcut/7KfOGQ6J8LIANxbmD5IvQIBN9lKzcoWhgkVn9thcXMSzozqYxF+zcppukuPem++60uT1CslUkcIWY4VE="
}

locals {
  name     = "nodeapp-dev"
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example = local.name
  }
}
