# ECS Cluster Creation
resource "aws_ecs_cluster" "cluster" {
  name = "your_cluster_name"
  tags = {
    Name = "your_cluster_name"
  }
}

# EC2 Configuration Template
resource "aws_launch_configuration" "ecs_launch_config" {
  name                 = "any_name"
  image_id             = "ami_of_ec2_instance"                  # example = ami-030493a647e0ba449
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=your_cluster_name >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  key_name = "your_key_pair_name"
}

# auto scaling to trigger the launch configuration
resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name                      = "your_autoScaling_group_name"
  vpc_zone_identifier       = [aws_subnet.pub_subnet.id]
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
}





