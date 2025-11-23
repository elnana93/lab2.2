

    resource "aws_s3_bucket" "my_bucket" {
      bucket = "e5tech" # Replace with a globally unique bucket name
      #acl    = "private" # Set the desired Access Control List (e.g., private, public-read)

      tags = {
        Name        = "MyTerraformS3Bucket"
        Environment = "Development"
      }
    }