#!/bin/bash

# Build and push Docker image to ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin your-account-id.dkr.ecr.us-west-2.amazonaws.com
docker build -t ai-resume-screener .
docker tag ai-resume-screener:latest your-account-id.dkr.ecr.us-west-2.amazonaws.com/ai-resume-screener:latest
docker push your-account-id.dkr.ecr.us-west-2.amazonaws.com/ai-resume-screener:latest

# Update Lambda function
aws lambda update-function-code --function-name ai-resume-screener --image-uri your-account-id.dkr.ecr.us-west-2.amazonaws.com/ai-resume-screener:latest

# Deploy frontend to S3 (assuming you're using S3 for static website hosting)
npm run build
aws s3 sync build/ s3://your-bucket-name --delete

