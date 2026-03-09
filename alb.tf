resource "aws_lb" "internal" {
  name               = substr(replace("${local.cluster_name}-alb", "/[^a-zA-Z0-9-]/", ""), 0, 32)
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_nodes.id]
  subnets            = var.private_subnet_ids

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    prefix  = "alb"
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.cluster_name}-alb"
  })
}
