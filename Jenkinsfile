pipeline {
  agent any

  environment {
    DOCKER_BFLASK_IMAGE = 'briangomezdevops0/basic_flask_app:latest'
  }

  stages {
    stage('Clone GitHub Repository') {
      steps {
        git branch: 'main', url: 'https://github.com/automationgeekx/AWS-Jenkins-Project.git'
      }
    }

    stage('Show Workspace') {
      steps {
        echo "Workspace path is: ${env.WORKSPACE}"
      }
    }

    stage('List Workspace Contents') {
      steps {
        sh 'ls -la ${WORKSPACE}'
      }
    }

    stage('Build') {
      steps {
        sh 'docker build -t my-flask-app .'
        sh 'docker tag my-flask-app $DOCKER_BFLASK_IMAGE'
      }
    }

    stage('Test') {
      steps {
        sh 'docker run my-flask-app python -m pytest /flask_app/tests/'
      }
    }

    stage('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin docker.io"
          sh 'docker push $DOCKER_BFLASK_IMAGE'
        }

        sshPublisher(
          continueOnError: false, 
          failOnError: true,
          publishers: [
            sshPublisherDesc(
              configName: "dockerhost", 
              transfers: [
                sshTransfer(
                  sourceFiles: "app/*", 
                  removePrefix: "app", 
                  remoteDirectory: "/home/dockeradmin/my_flask_app", 
                  execCommand: '''
                    docker pull briangomezdevops0/basic_flask_app:latest 
                    docker run -d -p 6012:5000 -v /home/dockeradmin/my_flask_app:/flask_app/app briangomezdevops0/basic_flask_app:latest
                  '''
                )
              ]
            )
          ]
        )
      }
    }
  }

  post {
    always {
      sh 'docker logout'
    }
  }
}
