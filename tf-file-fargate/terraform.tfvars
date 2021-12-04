name                = "my-project-name"
environment         = "test"
availability_zones  = ["ap-southeast-2a","ap-southeast-2b"]
private_subnets     = ["10.0.0.0/20", "10.0.32.0/20"]
public_subnets      = ["10.0.16.0/20", "10.0.48.0/20"]
container_memory    = 512
container_image     = "servian/techchallengeapp:latest"
health_check_path   = "/healthcheck/"
container_port      = 3000
domain_name         = "test.threemay.link"
hosted_zone_name    = "threemay.link."