# instance profile create for used in launch configuration to attach role to ec2
resource "aws_iam_instance_profile" "ecs_agent" {
  depends_on = [aws_iam_role.ecs_agent]
  name = "any_name"
  role = aws_iam_role.ecs_agent.name
}

# role creation 
resource "aws_iam_role" "ecs_agent" {
  name               = "any_name"
  assume_role_policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid": "",
      "Effect":"Allow",
      "Principal":{
        "Service": "ec2.amazonaws.com"
      },
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF

}

# attaching policy with role
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
