# AWS ECS Task Definition module

This module is a simple wrapper around the aws resource `aws_ecs_task_definition`. It creates a FARGATE task definition,
and a log group for that task to push logs to.

## Usage

```hcl
/**
 * Initialize the project
 */
module "project" {
  source  = "PGBI/project/aws"
  version = "~>0.1.0"

  name     = "myproject"
  vcs_repo = "github.com/account/project"
}

/**
 * Define the container that will belong to the task
 */
module "container_definition" {
  source  = "PGBI/ecs-container-definition/aws"
  version = "~>0.2.0"
  
  (...)
}

/**
 * The task definition
 */
module "task_definition" {
  source  = "PGBI/ecs-task-definition/aws"
  version = "~>0.1.0"

  container_definitions = [
    module.container_definition.definition
  ]
  cpu = 2048
  memory = 7168
  name = "main"
  project = module.project
}
```
