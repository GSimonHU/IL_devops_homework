pipeline {
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/GSimonHU/jenkins_practice.git']]])
      }
    }

    stage('Building image and running it') {
      steps {
        dir("app"){
          script {
            dockerImage = docker.build registry
            sh 'docker run $IMAGE_NAME'
          }
        }
      }
    }

    stage('Pushing to ECR') {
      steps {
        script {
          sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $ECR_PATH'
          sh 'docker push $REGISTRY'
        }

      }
    }

    stage('Deploy Static Website to S3') {
      steps {
        dir("static_website"){
          script {
            sh 'aws s3 cp ./index.html $BUCKET_PATH'
          }
        }
      }
    }

  }
  environment {
    REGISTRY = '129623116923.dkr.ecr.eu-central-1.amazonaws.com/my-python-app-repo'
    IMAGE_NAME = '129623116923.dkr.ecr.eu-central-1.amazonaws.com/my-python-app-repo'
    ECR_PATH = '129623116923.dkr.ecr.eu-central-1.amazonaws.com'
    BUCKET_PATH = 's3://infinite-lambda-static-website-bucket'
  }
}