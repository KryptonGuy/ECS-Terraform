output "repo_name" {
  value = aws_ecr_repository.server-repo.name
}

output "repo_url" {
  value = aws_ecr_repository.server-repo.repository_url
}