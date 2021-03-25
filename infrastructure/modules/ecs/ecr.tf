resource "aws_ecr_repository" "this" {
  name                 = "leaderboard-${var.region}"
  image_tag_mutability = "MUTABLE"
  tags                 = local.tags
}
