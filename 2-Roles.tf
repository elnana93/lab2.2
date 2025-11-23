

# 1️⃣ Create the OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# 2️⃣ Create the IAM Policy for S3 access
resource "aws_iam_policy" "github_s3_policy" {
  name        = "GitHubActionsS3Access"
  description = "Policy for GitHub Actions to access e5tech bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::e5tech"
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::e5tech/*"
      }
    ]
  })
}

# 3️⃣ Create the IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:elnana93/lab2.2:*"
          }
        }
      }
    ]
  })
}

# 4️⃣ Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_s3_policy.arn
}

# 5️⃣ Output the role ARN
output "actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "Role ARN to use in GitHub Actions"
}
