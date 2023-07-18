# Gen2 Cloud function Pubsub with Terraform

This simple cloud function gets triggered on a pubsub message and prints a greeting. If the message passed is "fail", the function code will raise an exception which will force the function to exit ungracefully.
After configuring the dead-letter, every run that fails to complete will be retried and will end up in the dead-letter topic once the retries are exhausted.

### Deploy Cloud Function  

**CD into main terraform directory**
```shell
cd infrastructure/environments/demo
```

**Deploy function**

```shell
## initiralise terraform
terraform init -input=false

## output terraform plan
terraform plan -out=plan.txt

## apply terraform plan
terraform apply "plan.txt"

```

**Trigger the function to pass**  
*function will run and print the greeting*
```shell
gcloud pubsub topics publish demo-pubsub-topic --message="World"
```

**Trigger the function to fail**  
*this will cause the code to raise an uncaught exception and exit the function*
```shell
gcloud pubsub topics publish demo-pubsub-topic --message="fail"
```

**Read logs**
```shell
gcloud beta functions logs read  demo-pubsub-function --region=europe-west2 --gen2
```

**Trigger the function to fail**  
*this will cause the code to raise an uncaught exception and exit the function, message should then end up in the dead-letter topic*
```shell
gcloud pubsub topics publish demo-pubsub-topic --message="fail"
```

**Check pubsub dead-letter for failed messages**  
*due to retry and backoff mechanism, this might take a couple of minutes to come through*
```shell
gcloud pubsub subscriptions pull demo-deadletter-subscription
```

**Prerequisite**  
* Gcloud  
* Python 3.10  
* Terraform > 1.0.0