# Traffic tracking system

## Requisites:

- Docker
- Docker compose

## Summary

We need to track different types of user visits (AKA. traffic or leads) to our websites, we currently support:
- **direct/organic**: Those who access our websites just writing our url on the browser directly or come from a search engine
- **referrer**: Those who come from a link on another website 

The traffic usually comes in bursts at peak hours, therefore, we need a design which can easily scale.

It consists of the **Traffic Agent** (NodeJS Lambda) which enqueues the visits into the **QUEUE** (AWS SQS Queue), so that they can be processed (pulled) later by the **Traffic Processor** (PHP worker)   

![aws-test](https://user-images.githubusercontent.com/19685680/146401373-ba6a17c8-5448-4497-92d5-62383ce098fc.png)

You are provided with a **fully working** development environment where everything is already set up for the **Traffic Processor** to consume the **QUEUE** messages

It consists of:
- Localstack
- Terraform
- aws-cli
- php-cli


You can find several recipes in the **Makefile**

Some useful examples are:

- `make` Starts/Restarts the environment
- `make deploy-traffic-agent-lambda` Deploys the lambda code to Localstack
- `make create-traffic-type-in` Creates one (1) "organic" visit
- `make create-traffic-referrer` Creates one (1) "referrer" visit
- `make start-traffic-processor` To be implemented: Triggers your PHP worker to start processing the QUEUE

## Instructions

We need you to implement **Traffic Processor** using PHP

### Traffic Processor

Will be responsible for processing the user visits (AKA. traffic) from the **QUEUE**. It's intended to be run as an asynchronous worker

- Consume the messages from the **QUEUE** and store them in their corresponding table by type, so they can be analyzed later by the DATA team
- Make sure we don't process traffic of invalid types
- Do not implement any data persistence code, just provide some dummy classes that echo what they are doing. Keep in mind that the company is planning to switch from MySQL to Cassandra in 4 months.
- Provide at least some unit tests (it is not required to write them for every class). Functional tests are also a plus.
- Provide a short summary as SUMMARY.md detailing anything you think is relevant, for example:
  - Installation steps
  - How to run your code / tests
  - Where to find your code
  - Was it your first time writing a unit test, using a particular framework, etc?
  - What would you have done differently if you had had more time
  - Etc.


## Bonus

- We are currently sending only **type** and **created_at** on the payload, but we are thinking to add in the future new fields **ip** (for the organic traffic) and **url** (for referrers) to be parsed and processed.
- If you see something which can be improved, feel free to do it. We follow the **boyscout rule**.

## Delivery

Please create a git patch (https://devconnected.com/how-to-create-and-apply-git-patch-files/) and email your completed test to us.
