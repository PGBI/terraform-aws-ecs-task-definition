terraform {
  required_version = ">= 0.12"
}

/**
 * Cloudwatch log group that will receive the containers' logs
 */
module "log_group" {
  source  = "PGBI/cloudwatch-log-group/aws"
  version = "~>0.1.0"

  name              = "${var.name}-ecstask"
  retention_in_days = 90

  project = var.project
}

module "task_role" {
  source  = "PGBI/iam-role/aws"
  version = "~>0.2.0"

  description = "Role assumed by the containers running in the the task \"${var.project.name_prefix}-${var.name}\""
  name        = "${var.name}-container"
  project     = var.project

  trusted_services = ["ecs-tasks.amazonaws.com"]
}

/**
 * Create the Role that the ECS container agent will assume.
 */
module "execution_role" {
  source  = "PGBI/iam-role/aws"
  version = "~>0.2.0"

  description = "Role assumed by the ECS container agent for the task \"${var.project.name_prefix}-${var.name}\""
  name        = "${var.name}-ecsagent"
  project     = var.project
  policies = {
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
    pull_from_ecr = {
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      Resource = ["*"]
      Effect   = "Allow"
    }
    ship_logs = {
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect = "Allow"
      Resource = [
        module.log_group.arn
      ]
    }
  }

  trusted_services = ["ecs-tasks.amazonaws.com"]
}

/**
 * The Task definition.
 */
resource "aws_ecs_task_definition" "main" {
  family             = "${var.project.name_prefix}-${var.name}"
  task_role_arn      = module.task_role.arn
  execution_role_arn = module.execution_role.arn

  lifecycle {
    create_before_destroy = true
  }

  cpu    = var.cpu
  memory = var.memory

  network_mode             = "awsvpc" # only mode supported by Fargate.
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode(var.container_definitions)

  tags = var.project.tags
}
