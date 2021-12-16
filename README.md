# Traffic tracking system

## Requisites:

- Docker
- Docker compose

## Summary

We need to track different types of visits (AKA. traffic) to our websites, we currently support:
- **direct**: Those who write our domain name on the browser directly or come from a search engine
- **referrer**: Those who come from a link on another website 

The traffic usually comes in bursts at peak hours, therefore, we need a design which can easily scale

It consists of the **Traffic Agent** (NodeJS Lambda) which enqueues the visits on the **PIPELINE** (AWS SQS Queue), so that they can be processed later by the **Traffic Processor** (PHP worker)   

```
TRAFFIC    ->    Traffic Agent -\ 
TRAFFIC    ->    Traffic Agent  -->    PIPELINE    ->    Traffic Processor    ->    Database
TRAFFIC    ->    Traffic Agent -/
```

You are provided with a **fully working** development environment where everything is already set up for the **Traffic Processor** to consume the **PIPELINE** messages

It consists of:
- Localstack
- Terraform
- aws-cli
- php-cli


You can find several recipes on the **Makefile**

Some useful examples are:

- `make` Starts/Restarts the environment
- `make deploy-traffic-agent-lambda` Deploys the lambda code to Localstack
- `make create-traffic-type-in` Creates one (1) "type-in" visit
- `make create-traffic-referrer` Creates one (1) "referrer" visit
- `make start-traffic-processor` To be implemented: Triggers your PHP worker to start processing the PIPELINE

## Instructions

We need you to implement **Traffic Processor** on PHP

### Traffic Processor

Will be responsible for processing the visits (AKA. Traffic) from the **PIPELINE**, it's intended to be run as a worker

- Consume the messages from the **PIPELINE** and store them on their corresponding table by type, so they can be analyzed later by the DATA team
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

- We are currently sending only **type** and **created_at** on the payload, but we think adding **ip** (for type-in) and **url** (for referrers) will add a lot of value, they should be sent by the **Traffic Agent** and processed by the **Traffic Processor**
- If you see something can be improved, feel free to do it, we follow the **boyscout rule**

## Delivery

Please create a git patch (https://devconnected.com/how-to-create-and-apply-git-patch-files/) and email your completed test to us
