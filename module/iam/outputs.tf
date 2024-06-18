output "codebuild_iam_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codepipeline_iam_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "ecs_service_iam_arn" {
  value = aws_iam_role.ecs_service.arn
}

output "container_role_arn" {
  value = aws_iam_role.container_role.arn
}

output "instance_role_arn" {
  value = aws_iam_role.ecs_instance_role.arn
}

output "ec2_profile_arn" {
  value = aws_iam_instance_profile.ec2_profile.arn
}
