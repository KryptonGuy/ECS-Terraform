
# Docker Image Build

resource "aws_codebuild_project" "build" {
  name           = var.build_project_name
  description    = "Builds the docker iamge for the application."
  build_timeout  = 30
  queued_timeout = 300

  service_role = var.code_build_iam_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ACCOUNT_ID"
      value = var.account_id

    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "IMAGE_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "REGION"
      value = var.region
    }


  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

# Staging Test Build

resource "aws_codebuild_project" "stage_test" {
  name           = var.stage_test_name
  description    = "Runs the tests for the application."
  build_timeout  = 30
  queued_timeout = 300

  service_role = var.code_build_iam_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "stagetest.yml"
  }
}