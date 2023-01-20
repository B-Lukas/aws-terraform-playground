resource "aws_vpc" "main" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "primary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.0.0/24"

  tags = {
    Name = "Primary"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.1.0/24"

  tags = {
    Name = "Secondary"
  }
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_https"
  }
}

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
     security_group_ids = [aws_security_group.allow_https.id]
     subnet_ids = [aws_subnet.primary.id, aws_subnet.secondary.id]
  }
}

# This is the trigger of the Lambda function
resource "aws_s3_bucket_notification" "s3_notification" {
  bucket = "lubi-lambda-test-bucket"

  lambda_function {
    lambda_function_arn = aws_lambda_function.HelloWorld.arn
    events              = ["s3:ObjectCreated:Put"]
  }
}

# This is the destination of the Lambda function
resource "aws_lambda_function_event_invoke_config" "sns_destination" {
  function_name = aws_lambda_function.HelloWorld.function_name
  maximum_retry_attempts = 0

  destination_config {
    on_success {
      destination = "arn:aws:sns:eu-central-1:363529221899:lambda-test.fifo"
    }
  }
}
