resource "aws_ecs_service" "worker" {
  name            = "any_name"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
}