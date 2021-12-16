############################
####      Variables     ####
############################
export DOCKER_COMPOSE := docker-compose -p test-aws-php -f ops/docker/docker-compose.yml
export LOCALSTACK_ENDPOINT=http://dev.localstack.test-aws-php.com:4566

############################
####       Docker       ####
############################

restart: nodev dev
dev: docker-build docker-up localstack-init docker-logs
nodev: docker-down

docker-up:
	@${DOCKER_COMPOSE} up -d ${SERVICE}
docker-run:
	@${DOCKER_COMPOSE} run --rm ${SERVICE} ${CMD}
docker-build:
	@${DOCKER_COMPOSE} build ${SERVICE}
docker-down:
	@${DOCKER_COMPOSE} down --remove-orphans
docker-logs:
	@${DOCKER_COMPOSE} logs -f ${SERVICE}

############################
####     Localstack     ####
############################

localstack-init: terraform-clear-state terraform-init terraform-apply

############################
####     Terraform      ####
############################

terraform-clear-state:
	rm -rf ops/terraform/aws/dev/.terraform && rm -f ops/terraform/aws/dev/terraform.tfstate* && rm -f /tmp/localstack-test-aws-php/*
terraform-init:
	make docker-run SERVICE=terraform CMD="-chdir=/project/ops/terraform/aws/dev init"
terraform-apply:
	make docker-run SERVICE=terraform CMD="-chdir=/project/ops/terraform/aws/dev apply --auto-approve"

############################
####        AWS         ####
############################

# SQS
aws-sqs-list:
	make docker-run SERVICE=aws-cli CMD="--endpoint-url=${LOCALSTACK_ENDPOINT} sqs list-queues"
aws-sqs-get-messages:
	@aws --endpoint-url=${LOCALSTACK_ENDPOINT} sqs receive-message --queue-url=${URL} --max-number-of-messages=10
aws-sqs-send-message:
	make docker-run SERVICE=aws-cli CMD="--endpoint-url=${LOCALSTACK_ENDPOINT} sqs send-message --queue-url ${URL} --message-body ${BODY}"

############################
####        PHP         ####
############################

start-traffic-processor:
	@make docker-run SERVICE=php-cli CMD="echo \" Modify this recipe so it calls your implementation of the traffic processor\""

############################
####      Lambdas       ####
############################

deploy-traffic-agent-lambda:
	cd src/lambdas/traffic-agent && zip -r "../../../dist/dev-traffic-agent-lambda.zip" . && cd - & make docker-run SERVICE=aws-cli CMD="--endpoint-url=${LOCALSTACK_ENDPOINT} --no-cli-pager lambda update-function-code --function-name dev-traffic-agent --zip-file \"fileb:///dist/dev-traffic-agent-lambda.zip\""

create-traffic-direct:
	make docker-run SERVICE=aws-cli CMD="--endpoint-url=${LOCALSTACK_ENDPOINT} lambda invoke --function-name dev-traffic-agent --cli-binary-format raw-in-base64-out --payload '{\"queryStringParameters\": {\"type\": \"direct\", \"ip\": \"127.0.0.1\"}}' /dev/stdout"
create-traffic-referrer:
	make docker-run SERVICE=aws-cli CMD="--endpoint-url=${LOCALSTACK_ENDPOINT} lambda invoke --function-name dev-traffic-agent --cli-binary-format raw-in-base64-out --payload '{\"queryStringParameters\": {\"type\": \"referrer\", \"url\": \"test.com\"}}' /dev/stdout"
