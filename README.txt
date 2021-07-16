The general structure of this Lambda folder:

We'll be creating a handful of Lambda endpoints over the span of this API development.
This package uses Terraform to handle orchestration of these methods and their
required AWS permissions and integrations, and uses simple bash scripts leveraging the AWS CLI
to handle packaging and deployment of the functions themselves.

The deployment scripts will be stored in a folder, deployment-scripts,
Terraform configuration will be stored in another folder, terraform-config
The Golang implementations of the lambda functions will be packaged up by broad feature
A folder, like "member-elligibility" will store all functions related to member eligibility,
including sandbox methods used to create and destroy members on the database.

This package:
/
-- deployment-scripts/    # Bash scripts handling (generally) aws cli commands
-- terraform-config/      # Terraform package orchestrating aws permissions
-- <function-group-one>/  # Go package handling one broad group aws functions
-- <function-group-two>/  # "    "

Terraform configuration gleaned from this Terraform/APIGateway/Lambda walkthrough:
https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway

Note on some "Gotcha!"s I hit:
- Build the Go modules to a linux distribution for execution on AWS; use "GOOS=linux go build ..."
