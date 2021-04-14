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
        dir(path: 'app') {
          script {
            sh 'docker build -t $IMAGE_NAME .'
            sh 'docker run $IMAGE_NAME'
          }
        }
      }
    }

    stage('Pushing to ECR') {
      steps {
        script {
          sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $ECR_PATH'
          sh 'docker tag $IMAGE_NAME:latest $ECR_PATH/$IMAGE_NAME:latest'
          sh 'docker push $ECR_PATH/$IMAGE_NAME:latest'
        }

      }
    }

    stage('Deploy Static Website to S3') {
      steps {
        dir(path: 'static_website') {
          script {
            sh 'aws s3 cp ./index.html $BUCKET_PATH'
          }
        }
      }
    }

  }
  environment {
    IMAGE_NAME = 'my-python-app-repo'
    ECR_PATH = '129623116923.dkr.ecr.eu-central-1.amazonaws.com'
    BUCKET_PATH = 's3://infinite-lambda-static-website-bucket'
  }
}