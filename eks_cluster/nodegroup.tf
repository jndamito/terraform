data "terraform_remote_state" "eks_vpc" {
  backend = "s3"
  config = {
    bucket = "class32devops"
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name = aws_eks_cluster.demo.name
  node_group_name = "private_nodes"
  node_role_arn = data.terraform_remote_state.eks_vpc.outputs.node_role

  subnet_ids = [
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[0],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[1],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[2],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[3]
  ]

  scaling_config {
    desired_size = 2
    max_size = 10
    min_size = 0
  }

  capacity_type = "ON_DEMAND"
  instance_types = ["t2.micro"]

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "devops"
  }

  tags = {
    "k8s.io/cluster-autoscaler/demo"    = "owned"
    "k8s.io/cluster-autoscaler/enabled" = false
  }
}