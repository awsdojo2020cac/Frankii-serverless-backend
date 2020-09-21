# Frankii-serverless-backend
The backend code including Terraform for infrastructure and the application code (lambda functions in node.js)

## File Structure 
```
├── app      //Node js application code for the Lambda functions 
├── terraform        //Terraform code for backend infrastucture 
├── README.md
├── frankii-api.yaml    //The OpenAPI definitions of Frankii's APIs 

```

A full working backend will be created upon terraform apply in /terraform.
Just take the base_url output from Terraform, refer to frankii-api.yaml, and you can use Frankii's API from any frontend.   