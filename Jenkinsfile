pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/NainaGhosh01/docker.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-docker-repo .'
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR_REPO_URL>
                docker tag my-docker-repo:latest <ECR_REPO_URL>:latest
                docker push <ECR_REPO_URL>:latest
                '''
            }
        }
        stage('Apply Terraform') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
        stage('Test Lambda Function') {
            steps {
                sh 'aws lambda invoke --function-name s3-to-rds-glue out.txt'
                sh 'cat out.txt'
            }
        }
    }
}
