resource "aws_lambda_function" "HelloWorld" {
  function_name = "HelloWorld"
  role          = "arn:aws:iam::363529221899:role/service-role/HelloWorld-role-5gvipgn6"
  handler = "example.Hello::handleRequest"
  runtime = "java11"
  memory_size = 512
  publish = false
  tags = {
    Env = "test"
  }
  timeout = 15
  vpc_config {
     security_group_ids = ["sg-01972fdbdf92efebc"]
     subnet_ids = ["subnet-034f59074b7c0cf46", "subnet-04bfd92a49a800fc2", "subnet-088328f7fc9f48af5"]
  }
}
