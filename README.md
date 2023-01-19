# aws-terraform-playground
A simple repository for testing and showcasing terraform with AWS


### How to Import existing AWS Resources (Lambda) with minimum Effort 
Use `Terraform plan` or `Terraform show` to get the diff between the current AWS Lambda function.

The diff will look something like this
```
  # aws_lambda_function.HelloWorld will be updated in-place
  ~ resource "aws_lambda_function" "HelloWorld" {
      ~ handler                        = "example.Hello::handleRequest" -> "Main.class"
        id                             = "HelloWorld"
      ~ memory_size                    = 512 -> 128
      + publish                        = false
      ~ tags                           = {
          - "Env" = "test" -> null
        }
      ~ tags_all                       = {
          - "Env" = "test"
        } -> (known after apply)
      ~ timeout                        = 15 -> 3
        # (15 unchanged attributes hidden)

      - vpc_config {
          - security_group_ids = [
              - "sg-xxx",
            ] -> null
          - subnet_ids         = [
              - "subnet-xxx",
              - "subnet-xxx",
              - "subnet-xxx",
            ] -> null
          - vpc_id             = "vpc-xxx" -> null
        }

        # (3 unchanged blocks hidden)
    }




```