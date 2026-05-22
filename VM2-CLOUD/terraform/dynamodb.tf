resource "aws_dynamodb_table" "muestra_dynamodb" {
  name         = var.muestra_dynamodb
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockeID"
    type = "S"
  }
}