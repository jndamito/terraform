resource "aws_eks_cluster" "demo" {
  name = "demo"
  role_arn = data.terraform_remote_state.eks_vpc.outputs.master_role 

  vpc_config {
    subnet_ids = [
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[0],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[1],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[2],
    data.terraform_remote_state.eks_vpc.outputs.private_subnets[3]
    ]
  }
}