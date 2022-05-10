# WIP
[![master](https://github.com/Adrien35240/serverless-todo-list/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/Adrien35240/serverless-todo-list/actions/workflows/main.yml)
[![master](https://github.com/Adrien35240/serverless-todo-list/actions/workflows/ecr_push.yml/badge.svg?branch=master)](https://github.com/Adrien35240/serverless-todo-list/actions/workflows/ecr_push.yml)
## A Serverless Todo-list React-App deploy on aws with terraform , CI/CD with github action and docker
 - S3 Bucket
 - Lambda
 - RDS
 - Api Gateway
 - ECR 
 - Fargate
 
 
### CMD
### compile ts lambdas file
    npm run compile
### RUN Container
    docker compose up -d
### CMD Terraform
    terraform init
    terraform plan
    terraform apply
    terraform destroy