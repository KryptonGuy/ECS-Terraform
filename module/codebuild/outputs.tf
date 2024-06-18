output "code_build_name" {
  value = aws_codebuild_project.build.name
}

output "stage_test_name" {
  value = aws_codebuild_project.stage_test.name
}