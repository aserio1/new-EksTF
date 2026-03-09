region             = "us-gov-west-1"
environment        = "primary"
name_prefix        = "alfa"
vpc_id             = "vpc-xxxxxxxx"
private_subnet_ids = ["subnet-aaaaaaa", "subnet-bbbbbbb", "subnet-ccccccc"]
public_subnet_ids  = ["subnet-ddddddd", "subnet-eeeeeee", "subnet-fffffff"]

cluster_version    = "1.29"

node_instance_types = ["m5.large"]
node_desired_size   = 2
node_min_size       = 2
node_max_size       = 5

tags = {
  CostCenter = "platform"
  Application = "eks-primary"
}
