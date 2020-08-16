### Prerequsites 
1. The s3 bucket defined in ./s3 that has the zip of .js files for this code's lambda.
Uploaded manually currently, will add to terraform later.
 Manual Instructions: 
 https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
 2. Dynamodb tables setup manually 
 

### Getting Started

Configure aws credentials, then run terraform commands
```
terraform init 
terraform apply   
```

At the end of the command, there should be something like
```
 Outputs:
 
 base_url = https://1111111.execute-api.ap-northeast-1.amazonaws.com/dev 
```

Go to the link
https://1111111.execute-api.ap-northeast-1.amazonaws.com/dev/user/question-categories
and you can get a response. 
