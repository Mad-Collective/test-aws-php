const AWS = require('aws-sdk');

AWS.config.update({
    logger: console,
    endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566`
})

const TRAFFIC_QUEUE_URL = process.env.TRAFFIC_QUEUE_URL

exports.handler = async function (event) {
    const payload = {
        type: event.queryStringParameters.type,
        created_at: Date.now()
    }

    const sqsClient = new AWS.SQS({apiVersion: '2012-11-05'})

    await sqsClient.sendMessage({
        QueueUrl: TRAFFIC_QUEUE_URL,
        MessageBody: JSON.stringify(payload)
    }).promise()
};
