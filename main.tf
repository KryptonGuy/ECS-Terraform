
data "aws_caller_identity" "current" {}

# Get all availability zones in the region
data "aws_availability_zones" "available" {}

module "vpc" {

  source = "./module/vpc"

  environment = var.environment
  projectname = var.projectname

  vpc_name           = "${var.projectname}-${var.environment}-vpc"
  availability_zones = data.aws_availability_zones.available.names

  vpc_cidr = var.vpc_cidr

}


module "code_build" {
  source = "./module/codebuild"

  build_project_name = "${var.projectname}-${var.environment}-build"
  stage_test_name    = "${var.projectname}-${var.environment}-stage-test"
  code_build_iam_arn = module.iam_roles.codebuild_iam_role_arn
  account_id         = data.aws_caller_identity.current.account_id
  ecr_repo_name      = module.ecr_repo.repo_name
  region             = var.region

}
module "s3_buckets" {
  source = "./module/s3"

  codepipeline_bucket_name = "${var.projectname}-${var.environment}-codepipelinebucket"
  software_bucket_name     = "${var.projectname}-${var.environment}-softwarebucket"
  public_bucket_name       = "${var.projectname}-${var.environment}-publicbucket"
}

module "codepipeline" {
  source = "./module/codepipeline"

  codepipelinename      = "${var.projectname}-${var.environment}-codepipeline"
  code_pipeline_iam_arn = module.iam_roles.codepipeline_iam_role_arn
  codepipelinebucket_id = module.s3_buckets.codepipelinebucket_id
  ecs_cluster_name      = module.app_server_ecs.ecs_cluster_name
  ecs_service_name      = module.app_server_ecs.ecs_service_name
  code_build_name       = module.code_build.code_build_name
  branch                = var.githubBranch
  FullRepositoryId      = var.FullRepositoryId
  ConnectionArn         = var.github_connection_arn
}

module "security_groups" {
  source = "./module/securitygroups"

  vpc_id = module.vpc.vpc_id

}

module "load_balancer" {
  source = "./module/alb"

  vpc_id          = module.vpc.vpc_id
  alb_name        = "${var.projectname}-${var.environment}-alb"
  public_subnets  = module.vpc.public_subnets
  tg_name         = var.projectname
  ecs_service-sg  = module.security_groups.ecs_service-sg
  server-lb-sg    = module.security_groups.server-lb-sg
  ssl_certificate = var.ssl_certificate_arn

}

module "app_server_ecs" {
  source = "./module/ecs"

  ecs_cluster_name        = "${var.projectname}-${var.environment}-ecs-cluster"
  ecs_service_iam_arn     = module.iam_roles.ecs_service_iam_arn
  container_role_arn      = module.iam_roles.container_role_arn
  ec2_launch_template_arn = module.ec2module.ec2_launch_template_arn
  server_task_cpu         = 512
  server_task_memory      = 1024
  ecs_server_service_name = "${var.projectname}-service"
  prod_container_name     = module.ecr_repo.repo_name
  stage_container_name    = "${module.ecr_repo.repo_name}-stage"
  public_subnets          = module.vpc.public_subnets
  repo_url                = module.ecr_repo.repo_url
  ecs_service-sg          = module.security_groups.ecs_service-sg
  alb_ecs_prod_tg         = module.load_balancer.ecs_service_prod_tg
  alb_ecs_stage_tg        = module.load_balancer.ecs_service_stage_tg
  ec2_asg_arn             = module.ecs_autoscaling.ec2_asg_arn
  aws_ecs_cp_name         = "${var.projectname}-${var.environment}-capacity-provider"
  td_name                 = "${var.projectname}-${var.environment}-td"
  public_bucket_name      = module.s3_buckets.public_bucket_id
  private_bucket_name     = module.s3_buckets.software_bucket_id

}

module "ec2module" {
  source = "./module/ec2"

  ec2_instance_type        = var.ec2_instance_type
  ec2_ami_id               = var.ec2_ami_id
  ec2_launch_template_name = "${var.projectname}-${var.environment}-launch-template"
  ec2_role_arn             = module.iam_roles.ec2_profile_arn
  ec2_security_group       = [module.security_groups.ec2_security_group_id]
  ecs_cluster_name         = module.app_server_ecs.ecs_cluster_name
  private_subnets          = module.vpc.private_subnets
  db_ami_id                = var.db_ami_id
  db_instance_type         = var.db_instance_type
  db_key_name              = var.db_key_name
  db_security_groups       = [module.security_groups.db_security_group_id]

}
module "ecs_autoscaling" {
  source = "./module/autoscaling"

  availability_zones     = data.aws_availability_zones.available.names
  desired_capacity       = var.desired_capacity
  max_capacity           = var.max_capacity
  min_capacity           = var.min_capacity
  ec2_launch_template_id = module.ec2module.ec2_launch_template_id
  ecs_cluster_name       = module.app_server_ecs.ecs_cluster_name
  ecs_service_name       = module.app_server_ecs.ecs_service_name
  public_subnets         = module.vpc.public_subnets
}

module "iam_roles" {
  source = "./module/iam"

  alb_arn     = module.load_balancer.alb_arn
  role_prefix = "${var.projectname}-${var.environment}-iam"
}

module "ecr_repo" {
  source = "./module/ecr"

  repo_name = "${var.projectname}-${var.environment}"
}