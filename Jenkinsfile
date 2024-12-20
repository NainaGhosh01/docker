pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/NainaGhosh01/docker.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-docker-image:latest .'
            }
        }
        stage('Push to ECR') {
            steps {
                sh '''
                $(aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com)
                docker tag your-repo/your-image:latest your-account-id.dkr.ecr.your-region.amazonaws.com/your-image:latest
                docker push your-account-id.dkr.ecr.your-region.amazonaws.com/your-image:latest
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
                sh 'aws lambda update-function-code --function-name your-lambda-function --image-uri your-account-id.dkr.ecr.your-region.amazonaws.com/your-image:latest'
            }
        }
        stage('Test Lambda Function') {
            steps {
                sh 'aws lambda invoke --function-name your-lambda-function response.json'
            }
        }
    }
}
