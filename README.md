# Traffic tracking system

## Requisites:

- Docker
- Docker compose

## Summary

We need to track different types of user visits (AKA. traffic) to our websites, we currently support:
- **direct**: Those who access our websites by writing the url on the browser directly or come from a search engine
- **referrer**: Those who come from a link on another website.

The traffic usually comes in bursts at peak hours, therefore, we need a design which can easily scale.

It consists of the **Traffic agent** (NodeJS Lambda) which enqueues the visits into the **Traffic queue** (AWS SQS Queue), so that they can be processed (consumed / pulled from the queue) later by the **Traffic processor** (PHP worker)   

![aws-test drawio](https://user-images.githubusercontent.com/49157280/146408001-e62c2cf6-8e09-491c-bbd6-860fc43e7505.png)

You are provided with a **fully working** development environment where everything is already set up for the **Traffic processor** to consume the **Traffic queue** messages.

It consists of:
- Localstack
- Terraform
- aws-cli
- php-cli


You can find several recipes in the **Makefile**.

Some useful examples are:

To start/stop the environment, run:
- `make dev` Starts the environment.
- `make nodev` Stops the environment.

To create traffic, run:
- `make create-traffic-direct` Creates one (1) **direct** visit.
- `make create-traffic-referrer` Creates one (1) **referrer** visit.

To process traffic, run:
- `make start-traffic-processor` To be implemented: Triggers your PHP worker to start processing the **Traffic queue**.

To deploy any lambda change, run:
- `make deploy-traffic-agent-lambda` Deploys the lambda code to Localstack.

## Instructions

We need you to implement **Traffic processor** on PHP.

### Traffic Processor

Will be responsible for processing the user visits (AKA. traffic) from the **Traffic queue**, it's intended to be run as an asynchronous worker.

- Consume the messages from the **Traffic queue** and store them on their corresponding table by type, so they can be analyzed later by the DATA team.
- Make sure we don't process traffic of invalid types.
- Do not implement any data persistence code, just provide some dummy classes that echo what they are doing. Keep in mind that the company is planning to switch from MySQL to Cassandra in 4 months.
- Provide at least some unit tests (it is not required to write them for every class). Functional tests are also a plus.
- Provide a short summary as SUMMARY.md detailing anything you think is relevant, for example:
  - Installation steps.
  - How to run your code / tests.
  - Where to find your code.
  - Was it your first time writing a unit test, using a particular framework, etc?.
  - What would you have done differently if you had had more time.
  - Etc.


## Bonus

- We are currently sending only **type** and **created_at** on the payload, but we are thinking to add new fields in the future: **ip** (for direct traffic) and **url** (for referrers traffic) to be parsed and processed.
- If you see something which can be improved, feel free to do it. We follow the **boyscout rule**.

## Delivery

Please create a git patch (https://devconnected.com/how-to-create-and-apply-git-patch-files/) and email your completed test to us.
