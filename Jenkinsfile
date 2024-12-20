pipeline {
    agent any
    
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/NainaGhosh01/docker.git'  # Replace with your GitHub repository URL
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t s3-to-rds-glue .'
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ecr_repository_uri>
                docker tag s3-to-rds-glue:latest <ecr_repository_uri>:latest
                docker push <ecr_repository_uri>:latest
                '''
            }
        }
        
        stage('Terraform Init & Apply') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
        
        stage('Deploy Lambda Function') {
            steps {
                sh '''
                aws lambda update-function-code --function-name s3-to-rds-glue --image-uri <ecr_repository_uri>:latest
                '''
            }
        }
        
        stage('Test Lambda Function') {
            steps {
                sh '''
                aws lambda invoke --function-name s3-to-rds-glue output.json
                cat output.json
                '''
            }
        }
    }
}
