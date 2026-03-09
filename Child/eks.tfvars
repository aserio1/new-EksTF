aws_account_id = "262763737219"
aws_region     = "us-gov-west-1"
vpc_id         = "vpc-043fe361"
public_subnets = ["subnet-848ecae1", "subnet-af4729d8"]
private_subnets = ["subnet-848ecae1", "subnet-af4729d8"]

iam_role = "arn:aws-us-gov:iam::262763737219:role/ALFA-Deploy-Role"

alb_access_log_audit_bucket = "sdo-alfa-access-log-audit"

alb_log_reader_arns = [
  "arn:aws-us-gov:iam::262763737219:role/ALFA-Deploy-Role",
  "arn:aws-us-gov:iam::262763737219:role/SDO-ECS-task-role",
  "arn:aws-us-gov:iam::262763737219:role/IADSDC"
]

project_name = "sdo-alfanew"
alert_email  = "Sunday.Ebosele@associates.ice.dhs.gov"

container_image = "262763737219.dkr.ecr.us-gov-west-1.amazonaws.com/alfa/nginx:1.0.1-5"
container_name  = "web-server"
container_port  = 8080
cpu             = 2048
memory          = 4096

desired_count   = 2
max_capacity    = 5
min_capacity    = 1

cluster_version     = "1.29"
node_instance_types = ["m5.large"]

enable_efs         = true
efs_mount_point    = "/usr/share/nginx/html"
efs_container_path = "nginx-data"

certificate_arn = "arn:aws-us-gov:acm:us-gov-west-1:262763737219:certificate/78c717f7-9127-496e-b0be-0a4d650c68a0"

alb_ingress_rules = [
  { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
]

alb_egress_rules = [
  { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
]

eks_node_egress_rules = [
  { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
]

tags = {
  Environment           = "Dev"
  Application           = "alfa-eks"
  Customer              = "ALFA"
  App                   = "Nginx"
  AutoStopStartInstance = "FALSE"
  WeekendStop           = "FALSE"
  RemainStoped          = "False"
  ASBManaged            = "False"
  name_project_org      = "sdo"
  portfolio             = "mlms"
}
