# DynamoDB table for state lock
# resource "aws_dynamodb_table" "tf_lock" {
#   name           = "terraform-locks"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }