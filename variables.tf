variable "project" {
  description = "Reference to a \"project\" module. See: https://registry.terraform.io/modules/PGBI/project/aws/"
}

variable "name" {
  type        = string
  description = "Name for the task definition."
}

variable "cpu" {
  type        = number
  description = "The number of cpu units used by the task. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for a list of valid values."
}

variable "memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the task. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for a list of valid values."
}

variable "container_definitions" {
  type        = "list"
  description = "List of objects obtained using the module ecs-container-definition."
}
