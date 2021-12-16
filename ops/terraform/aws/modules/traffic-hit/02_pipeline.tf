resource "aws_sqs_queue" "pipeline" {
  name = "${var.environment}-${local.component}-pipeline"
}
