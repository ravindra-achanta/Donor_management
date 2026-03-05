pipeline {
    agent { label 'flutter_agent' }

    environment {
        DOCKER_IMAGE = 'vikas_web_app:dev'
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh 'ls -la'
            }
        }
        stage('Checkout') {
            steps {
                git credentialsId: 'git-credentials', url: 'https://github.com/corporate-bytesedge/vikas-web-app.git' , branch: 'master'
            }
        }
        stage('Check Git Status') {
            steps {
                script {
                    sh 'git status'
                    sh 'git log --oneline -n 5'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build --no-cache -t ${DOCKER_IMAGE} -f Dockerfile ."
                    echo 'Docker image built successfully.'
                }
            }
        }
        stage('Deploy Docker Container') {
            steps {
                script {
                    echo 'Deploying Docker container locally...'
                    sh """
                        docker stop vikas_web_app || true
                        docker rm vikas_web_app || true
                        docker run -d --name vikas_web_app -p 4001:4001 ${DOCKER_IMAGE}
                        docker network connect vidyaranyam-net vikas_web_app || true
                    """
                }
            }
        }
        stage('Cleanup Dangling Images') {
            steps {
                echo 'Cleaning up dangling Docker images...'
                script {
                    def danglingImages = sh(script: 'docker images -qf "dangling=true"', returnStdout: true).trim()
                    if (danglingImages) {
                        danglingImages.split('\n').each { image ->
                            def result = sh(script: "docker rmi ${image}", returnStatus: true)
                            if (result != 0) {
                                echo "Failed to remove image ${image}."
                            } else {
                                echo "Successfully removed image ${image}."
                            }
                        }
                    } else {
                        echo 'No dangling images found.'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
