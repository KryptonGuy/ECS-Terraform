
resource "aws_codepipeline" "pipeline" {
  name          = var.codepipelinename
  pipeline_type = "V2"
  role_arn      = var.code_pipeline_iam_arn

  artifact_store {
    location = var.codepipelinebucket_id
    type     = "S3"
  }

  execution_mode = "QUEUED"

  # trigger  {
  #   provider_type = "CodeStarSourceConnection"
  #   git_configuration {
  #     source_action_name = "Source"
  #     push {
  #       branches { 
  #         includes = ["master"]
  #       }
  #   }
  #   }
  # }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        BranchName           = var.branch
        FullRepositoryId     = var.FullRepositoryId
        ConnectionArn        = var.ConnectionArn
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["artifact"]
      version          = "1"

      configuration = {
        ProjectName = var.code_build_name
      }
    }
  }

  stage {
    name = "DeployProduction"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["artifact"]

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
      }

    }
  }

}