

    resource "aws_s3_bucket" "my_bucket" {
      bucket = "e5tech" # Replace with a globally unique bucket name
      force_destroy = true
      #acl    = "private" # Set the desired Access Control List (e.g., private, public-read)

      tags = {
        Name        = "MyTerraformS3Bucket"
        Environment = "Development"
      }
    }


    #/  aws s3 cp /Users/elnana93/assets/e5foto.jpg s3://e5tech/  #/- this is to upload your stuff to s3 from the terminal/vscode to the cansole
