### Introduction

This repository is a companion of the ["AWS Lambda for the containers developer" blog post](https://aws.amazon.com/blogs/containers/aws-lambda-for-the-containers-developer/). For proper context, please read the blog post before deploying the prototype below.

This repository includes all the files required to test the workflow promoted in the blog post. In addition to having the bash scripts (`startup.sh` and `businesscode.sh`), the `Dockerfile` as well as the SAM template, the repository also includes a small and basic Hugo website for test purposes (in the [](./src/hugo_web_site) folder).

### Environment setup and prerequisites

To set up the environment please do the following:

1. Install the SAM CLI following [these instructions](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
2. Fork the repository in your own GitHub account
3. Clone your repository in the IDE of your choosing (your IDE must have Docker installed and should have proper AWS credentials configured)

> Important: the SAM template will create an open Amazon S3 bucket with the web hosting feature enabled. If your S3 service is configured to `Block all public access` in the `Block Public Access settings for this accounts` S3 menu (this is the default account configuration), the creation of the bucket will fail. You either have to deploy the stack in a test AWS account where that S3 flag is disabled at the account level (thus allowing SAM to create the public bucket) OR you now need to edit the `sam/template.yaml` file and get rid entirely of the `HugoBucketPolicy` resource and the entire `Properties` section in the `HugoBucket` resource

### Prototype deployment

To deploy our stack we will use the `SAM CLI`. Perform the following steps once you are in the local folder of the cloned repository:

1. `cd sam`
2. `sam build`
3. `sam deploy [ --profile <my_aws_profile> ] --guided`
    1. This will prompt you for some information (accept the defaults unless otherwise noticed here below):
        1. Provide a SAM stack name and region to deploy to
        2. Provide the GitHub username where you forked the repository (your function will use this to `git clone` the repo)
        3. Respond `y` to the question `<function name> may not have authorization defined, Is this okay?`
        4. Let SAM create a managed Amazon ECR repository to host the built container artifacts (unless you would like to provide the ECR repository yourself, accept this)

At the end of the workflow a new CloudFormation stack should have been deployed. This includes the Lambda function, the S3 bucket and all required resources.

### Put the prototype at work

Follow the content of the blog post to experiment with the prototype. Note first how the bucket at the beginning is empty. You can trigger execution of the application in a few different ways. The easiest possible way is to open the Lambda console, open the Lambda function you just created and `Test` it.

You can also trigger the Lambda in the following ways:
1. Make an asynchronous event-based call by putting a message in the SQS queue. You can do that manually in the SQS console, or you can launch this [script](./scripts/call-via-sqs.sh) passing the CloudFormation stack name as the first parameter.
2. Make an HTTP request via API Gateway. You can do that manually either in the Lambda console (clicking on the API Gateway API endpoint link) or you can run this [script](./scripts/call-via-api-gateway.sh) passing the CloudFormation stack name as the first parameter (the script uses `curl` so make sure that's installed).

You can then navigate to the S3 bucket and open its web hosting endpoint (check out `Properties` -> `Static website hosting`).

Optionally you can tweak the `title` in the `src/hugo_web_site/config.toml` file and regenerate the site by re-soliciting the Lambda function (remember to commit the changes back to your fork because the Lambda container will clone it at every event)

### Clean Up

To clean up this deployment run `sam delete` and answer `y` to all the questions.

> Note the bucket that has been created by the `sam deploy` needs to be deleted manually because it has the `DeletionPolicy` set to `Retain`

### License

This library is licensed under the MIT-0 License. See the LICENSE file.

