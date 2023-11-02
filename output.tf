output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = aws_subnet.prodpublic.*.id
}

output "node_role" {
  value = aws_iam_role.nodes.arn
}

output "master_role" {
  value = aws_iam_role.master.arn
}

