# WIP
## A Serverless Todo-list React-App deploy on aws with terraform , CI/CD with github action and docker
 - S3 Bucket
 - Lambda
 - RDS
 - Api Gateway
 - ECR 
 
 

### RUN Container
    docker build -t <name> .
    docker run -p 3000:3000 -d <name>
### CMD Terraform
    terraform init
    terraform plan
    terraform apply
    terraform destroy