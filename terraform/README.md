### Prerequsites 
1.  Manually zip any updated .js files in ../app into the same folder (overwrite old zips files)
 2. Dynamodb tables are currently setup manually 
 

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

References:
https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway