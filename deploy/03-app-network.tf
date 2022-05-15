resource "aws_vpc" "todo" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public_a" {
    vpc_id = "${aws_vpc.todo.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-3a"
}

# resource "aws_subnet" "public_b" {
#     vpc_id = "${aws_vpc.test.id}"
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "eu-west-3b"
# }

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${aws_vpc.todo.id}"
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.todo.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_security_group" "todo" {
    name = "${var.app_name}"
    description = "Allow TLS inbound traffic on port 80 (http)"
    vpc_id = "${aws_vpc.todo.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# WWW configuration
# create a ip elastic
resource "aws_eip" "todo" {
  vpc                       = true
}

# target group for www
resource "aws_lb_target_group" "todo" {
  name        = "${var.app_name}"
  target_type = "ip"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.todo.id
  
}

# create network-lb affect to ip elastic with target group affect private ip of the task
resource "aws_lb" "todo" {
  name               = "${var.app_name}"
  internal           = false
  load_balancer_type = "network"
 # subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnet_mapping {
    subnet_id     = aws_subnet.public_a.id
    allocation_id = aws_eip.todo.id
  }
}
# attach target group to lb
resource "aws_lb_listener" "todo" {
  load_balancer_arn = aws_lb.todo.arn
  port = "80"
  protocol = "TCP"
//  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.todo.id
    type             = "forward"
  }
}
# create record with r53 todolist.lablanchere.fr with alias to network-balancer
data "aws_route53_zone" "todo" {
  name         = "${var.domain_name}"
}

resource "aws_route53_record" "todo-www" {
  zone_id = data.aws_route53_zone.todo.zone_id
  name    = "${var.app_name}"
  type    = "A"
  alias {
    name                   = aws_lb.todo.dns_name
    zone_id                = aws_lb.todo.zone_id
    evaluate_target_health = true
  }
}