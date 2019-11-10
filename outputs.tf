output "arn" {
  description = "ARN of the task definition."
  value       = aws_ecs_task_definition.main.arn
}

output "name" {
  description = "Name (aka \"family\") of the Task definition."
  value       = aws_ecs_task_definition.main.family
}

output "revision" {
  description = "The revision number of the task definition."
  value       = aws_ecs_task_definition.main.revision
}

output "log_group_name" {
  description = "Name of the log group the containers should ship logs to."
  value       = module.log_group.name
}

output "task_role" {
  description = "The task role object."
  value       = module.task_role
}

output "execution_role" {
  description = "The execution role object."
  value       = module.execution_role
}
