# =========================================
# 1️⃣ Create the OIDC provider for GitHub Actions
# =========================================
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# =========================================
# 2️⃣ IAM Policy for S3 access
# =========================================
resource "aws_iam_policy" "github_s3_policy" {
  name        = "GitHubActionsS3Access"
  description = "Policy for GitHub Actions to access e5tech bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::e5tech"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::e5tech/*"
      }
    ]
  })
}

# =========================================
# 3️⃣ IAM Role for GitHub Actions
# =========================================
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::676373376093:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:elnana93/lab2.2:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# =========================================
# 4️⃣ Attach S3 Policy to the role
# =========================================
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_s3_policy.arn
}

# =========================================
# 5️⃣ Output the Role ARN for GitHub Actions
# =========================================
output "actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "Role ARN to use in GitHub Actions"
}












/* 
resource "aws_s3_bucket_policy" "assets_public" {
  bucket = "e5tech"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadAssetsFolder"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::e5tech/assets/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "assets_folder" {
  bucket = "e5tech"

  block_public_acls       = true   # keep other public ACLs blocked
  block_public_policy     = false  # allow bucket policy to make assets/ public
  ignore_public_acls      = true
  restrict_public_buckets = true
}
 */









































/* resource "aws_s3_bucket_policy" "assets_public" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadAssetsFolder"
        Effect    = "Allow"
        Principal = "*"               
        Action    = ["s3:GetObject"] 
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/assets/*"]
      }
    ]
  })
} */

























































/* 


resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = data.aws_iam_policy_document.allow_assets_public_read.json
}

data "aws_iam_policy_document" "allow_assets_public_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/assets/*"]  # Only allow access to assets folder

    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]  # Allow public access
    }
  }
}
 */