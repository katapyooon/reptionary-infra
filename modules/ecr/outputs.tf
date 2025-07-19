output "image_url" {
  value = "${aws_ecr_repository.reptionaryApp.repository_url}:latest"
}