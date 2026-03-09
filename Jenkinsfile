pipeline {
    agent any
    parameters {
        string(name: 'ROLLBACK_VERSION', defaultValue: '', description: 'Build Number to rollback')
    }
    environment {
        DOCKER_HUB_USER = 'romeokiller' // เปลี่ยนเป็นของตนเอง
        IMAGE_NAME = "cicd-pro-guestbook"
        REGISTRY_IMAGE = "${DOCKER_HUB_USER}/${IMAGE_NAME}"
        IMAGE_TAG = "${params.ROLLBACK_VERSION ?: env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        
        stage('Prepare & Scan') {
            when { expression { params.ROLLBACK_VERSION == '' } }
            steps {
                sh "sed -i 's/BUILD_NUMBER_PLACEHOLDER/${BUILD_NUMBER}/g' index.html"
                sh "docker build -t ${REGISTRY_IMAGE}:${BUILD_NUMBER} ."
                sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity HIGH,CRITICAL --exit-code 1 ${REGISTRY_IMAGE}:${BUILD_NUMBER}"
            }
        }

        stage('Push') {
            when { expression { params.ROLLBACK_VERSION == '' } }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PW', usernameVariable: 'USER')]) {
                    sh "echo \$PW | docker login -u \$USER --password-stdin"
                    sh "docker push ${REGISTRY_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy') {
            steps {
                // ส่งตัวแปรเข้าไปใน docker-compose
                sh "IMAGE_TAG=${IMAGE_TAG} REGISTRY_IMAGE=${REGISTRY_IMAGE} docker-compose up -d --force-recreate"
            }
        }
    }
}
