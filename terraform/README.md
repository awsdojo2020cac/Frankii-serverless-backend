### Prerequsites 
An s3 bucket that has the .js files for this code's lambda.
Uploaded manually currently, will add to terraform later.
 Manual Instructions: 
 https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway

### Getting Started

Configure aws credentials, then run terraform commands
```
terraform init 
terraform apply   
```

At the end of the command, there should be something like
```
 Outputs:
 
 base_url = https://1111111.execute-api.ap-northeast-1.amazonaws.com/test   
```

Go to this link and you can get a response. 
