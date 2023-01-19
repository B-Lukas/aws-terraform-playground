resource "aws_lambda_function" "HelloWorld" {
  function_name = "HelloWorld"
  role          = "arn:aws:iam::363529221899:role/service-role/HelloWorld-role-5gvipgn6"
  handler = "Main.class"
  runtime = "java11"
}
