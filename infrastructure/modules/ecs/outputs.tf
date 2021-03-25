output "ecr_repository" {
  value = aws_ecr_repository.this.repository_url
}
