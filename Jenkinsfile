pipeline {
  agent any

  stages {
stage('Clone GitHub Repository') {
  steps {
    git branch: 'main', url: 'https://github.com/automationgeekx/AWS-Jenkins-Project.git'
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
        sh 'docker run my-flask-app python -m pytest AWS-Jenkins-Project/app/tests/'
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
              configName: "dockeradmin@54.224.237.99", 
              transfers: [
                sshTransfer(
                  sourceFiles: "AWS-Jenkins-Project/app/*", 
                  removePrefix: "AWS-Jenkins-Project", 
                  remoteDirectory: "/home/dockeradmin/my_flask_app", 
                  execCommand: '''
                    docker pull tomcatserver:latest 
                    docker run -d -p 6001:8080 -v /home/dockeradmin/my_flask_app:/usr/local/tomcat/webapps/ROOT tomcatserver:latest
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
