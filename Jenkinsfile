pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/NainaGhosh01/docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-docker-repo .'
            }
        }
        stage('Apply Terraform') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve > tf_output.txt
                '''
            }
        }
        stage('Extract ECR URL') {
            steps {
                script {
                    def ecrUrl = sh(script: "cd terraform && terraform output -raw ecr_repository_url", returnStdout: true).trim()
                    env.ECR_URL = ecrUrl
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                docker tag my-docker-repo:latest $ECR_URL:latest
                docker push $ECR_URL:latest
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
