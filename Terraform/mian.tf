provider "aws" {
    region = "us-east-1"

  
}

#VPC creation
module "VPC" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.19.0"

    name = "eks-vpc"
    cidr = "10.0.0.0/16"

    azs = ["us-east-1a", "us-east-1b"]
    public_subnets = ["10.0.1.0/24","10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24","10.0.4.0/24"]

    enable_nat_gateway = true
  
}

#IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = jsonencode({
    version = "2012-10-17"
    statements =[
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {Service = "eks.amazonaws.com"}
        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"

}

#IAM role for worker nodes
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    version = "2012-10-17"
    statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {Service = "ec2.amazonaws.com"}

        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#EKS Cluster
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "18.29.0"
    cluster_name = "eks-demo"
    cluster_version = "1.27"
    subnet_ids = module.vpc.private_subnets.subnet_ids
    vpc_id = module.vpc.vpc_id
    

    eks_managed_node_groups = {
        eks_nodes = {
            desired_capacity = 2
            maximum_capacity = 3
            minimum_capacity = 1

            instance_types = ["t2.micro"]
            key_name = "your-key-pair-name"
        }
    }
  
}

output "eks_cluster_endpoint" {
    value = module.eks.cluster_endpoint
  
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_node_group_role_name" {
  value = module.eks.eks_managed_node_groups["eks_nodes"].iam_role_name
}