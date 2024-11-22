output "luster_endpoint" {
  value = module.eks.cluster_endpoint
  description = "EKS Cluster endpoint URL"
}
output "cluster_name" {
  value = module.eks.cluster_name
  description = "EKS Cluster name"
}
output "node_group_role_name" {
  value = module.eks.eks_managed_node_groups["eks_nodes"].iam_role_name
  description = "IAM role name for EKS worker nodes"
}