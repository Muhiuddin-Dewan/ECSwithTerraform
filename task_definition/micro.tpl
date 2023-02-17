{* Container Definition. Here need to specify the name, image_location, container_port_value, host_port_value *}
[
  {
    "essential": true,
    "name": "your_task_name",
    "memory": 512,
    "image": "Your_Image_Location",
    "portMappings": [
    { "containerPort": container_port_value, "hostPort": host_port_value, "protocol": "tcp" }
    ],
    "environment": []
  }
]