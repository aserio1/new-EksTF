data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

resource "aws_eks_access_entry" "admin_role" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.admin_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_role_admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.admin_role_arn
  policy_arn    = "arn:aws-us-gov:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "deploy_role" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.iam_role
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "deploy_role_admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.iam_role
  policy_arn    = "arn:aws-us-gov:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
