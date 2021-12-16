resource "aws_sqs_queue" "queue" {
  name = "${var.environment}-${local.component}-queue"
}
