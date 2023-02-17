# task creation
resource "aws_ecs_task_definition" "task_definition" {
  family                = "any_name"
  container_definitions = file("task_definition/micro.tpl") # tpl file location
  requires_compatibilities = ["EC2"]
  memory                   = 512
  cpu                      = 1024
  tags = {
    "Name" = "same as family"
  }
}