pipeline {
    agent any
    environment {
        DOCKER_TAG = "v1"
    }
    stages {
        stage('Clonado repo Git') {
            steps {
                git credentialsId: 'GitHubCred',
                url: 'https://github.com/enmanuelmoreira/angular-10-registration-login-example'
            }
        }
        stage('Empaquetando app en Docker') {
            steps {
                sh "docker build . -t enmanuelmoreira/angular-10-registration-login-example:${DOCKER_TAG}"
            }
        }
        stage('Push a DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPassword')]) {
                    sh 'docker login -u enmanuelmoreira -p ${dockerHubPassword}'
                }

                sh "docker push enmanuelmoreira/angular-10-registration-login-example:${DOCKER_TAG}"
            }
        }
        stage('Desplegando app') {
            steps {
                ansiblePlaybook colorized: true,
                                credentialsId: 'web',
                                disableHostKeyChecking: true,
                                extras: "-e DOCKER_TAG=${DOCKER_TAG}",
                                installation: 'ansible',
                                inventory: 'inventory',
                                playbook: 'deploy.yml'
            }    
        }
        stage('Haciendo Limpieza') {
            steps {
                sh "echo Limpiando contenedores no usados..."
                sh "docker system prune"
            }
        }
    }
}