module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  iam_role_name   = aws_iam_role.eks_service_role.name
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  

  vpc_id                   = aws_vpc.my-vpc.id
  subnet_ids               = [aws_subnet.my-private-subnet-1.id, aws_subnet.my-private-subnet-2.id]
  control_plane_subnet_ids = [aws_subnet.my-public-subnet-1.id, aws_subnet.my-public-subnet-2.id]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }
depends_on = [aws_iam_role_policy_attachment.attach_eks_policy]
}

resource "aws_iam_role" "eks_service_role" {
  name               = "eks-service-role-eks.cluster_name"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "EKSViewPolicy-eks.cluster_name"
  description = "Allows viewing resources in Amazon EKS cluster"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:ListNodes",
        "eks:ListNodegroups",
        "eks:ListFargateProfiles",
        "eks:AccessKubernetesApi",
        "eks:DescribeNodegroup",
        "eks:DescribeFargateProfile",
        "eks:ListUpdates",
        "eks:ListAddonVersions"
      ]
      Resource = "*"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_eks_policy" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
}