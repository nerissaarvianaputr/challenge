pipeline {
    agent any

    tools {
        maven 'Maven 3.8.8'
        jdk 'Temurin JDK 17'
    }

    environment {
        APP_NAME = 'my-app'
        APP_VERSION = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
        DOCKER_NAMESPACE = 'nerissaarviana04'
        DOCKER_IMAGE = "${DOCKER_NAMESPACE}/${APP_NAME}:${APP_VERSION}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/nerissaarvianaputr/challenge', branch: 'main'
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'mvn clean test'
            }
        }

        stage('Static Code Analysis - SonarQube') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=my-app \
                            -Dsonar.host.url=http://sonarqube:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

    //     stage('Deploy to Cloud Run with Terraform') {
    //         steps {
    //             withCredentials([file(credentialsId: 'gcp-service-account', variable: 'GCP_KEY')]) {
    //                 sh """
    //                     echo "\$GCP_KEY" > account.json
    //                     export GOOGLE_APPLICATION_CREDENTIALS=\$(pwd)/account.json
                        
    //                     terraform init
    //                     terraform apply -auto-approve \\
    //                         -var="image=${DOCKER_IMAGE}" \\
    //                         -var="service_name=${APP_NAME}"
    //                 """
    //             }
    //         }
    //     }
    // }

    // post {
    //     success {
    //         script {
    //             withCredentials([
    //                 string(credentialsId: 'telegram-bot-token', variable: 'TELEGRAM_TOKEN'),
    //                 string(credentialsId: 'telegram-chat-id', variable: 'TELEGRAM_CHAT_ID')
    //             ]) {
    //                 sh """
    //                 curl -s -X POST https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage \\
    //                     -d chat_id=${TELEGRAM_CHAT_ID} \\
    //                     -d text="✅ Deployment ${APP_NAME} versi ${APP_VERSION} sukses!"
    //                 """
    //             }
    //         }
    //     }
    //     failure {
    //         script {
    //             withCredentials([
    //                 string(credentialsId: 'telegram-bot-token', variable: 'TELEGRAM_TOKEN'),
    //                 string(credentialsId: 'telegram-chat-id', variable: 'TELEGRAM_CHAT_ID')
    //             ]) {
    //                 sh """
    //                 curl -s -X POST https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage \\
    //                     -d chat_id=${TELEGRAM_CHAT_ID} \\
    //                     -d text="❌ Deployment ${APP_NAME} versi ${APP_VERSION} gagal!"
    //                 """
    //             }
    //         }
    //     }
    // }
}
