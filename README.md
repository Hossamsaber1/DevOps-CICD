🚀 CI/CD Pipeline with Jenkins & Docker
📌 Overview

This project demonstrates a complete CI/CD pipeline using Jenkins and Docker.
The pipeline automates building, testing, and deploying a containerized application.

🏗️ Architecture
GitHub Repository
        ↓
     Jenkins
        ↓
   Docker Build
        ↓
   Docker Hub
        ↓
   Deploy Container

⚙️ Tech Stack
Jenkins (CI/CD)
Docker
GitHub
Linux
Python (Flask)
📁 Project Structure
.
├── app.py
├── requirements.txt
├── Dockerfile
├── Jenkinsfile
🧪 Application

Simple Flask app:

from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from Jenkins CI/CD 🚀"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

🐳 Docker Setup

FROM python:3.10

WORKDIR /app
COPY . .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
🔄 Jenkins Pipeline
pipeline {
    agent any

    environment {
        IMAGE_NAME = "yourdockerhubusername/myapp"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Running tests..."'
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push') {
            steps {
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop myapp || true
                docker rm myapp || true
                docker run -d -p 5000:5000 --name myapp $IMAGE_NAME:latest
                '''
            }
        }
    }
}
🔐 Jenkins Credentials Setup
Go to: Manage Jenkins → Credentials
Add:
Kind: Username with password
ID: dockerhub-creds
Username: Docker Hub username
Password: Docker Hub password or token
▶️ How to Run
1. Run Jenkins with Docker
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
2. Create Pipeline Job
New Item → Pipeline
Add GitHub repo
Set script path: Jenkinsfile

3. Run Build

Click Build Now

📊 Expected Output
Docker image built successfully
Image pushed to Docker Hub
Container deployed on port 5000
⚠️ Notes
Ensure Docker is installed on host
Make sure Jenkins has access to docker.sock
Use Docker Hub token if 2FA is enabled