pipeline {
  agent any
  

  stages {

stage('Teardown Container') {
  steps {
    script {
      sshPublisher(
        continueOnError: true, // Allow the pipeline to continue even if the commands fail
        publishers: [
          sshPublisherDesc(
            configName: "dockerhost", // Replace with your SSH configuration name
            transfers: [
              sshTransfer(
                execCommand: '''
                  docker stop test_app || true
                  docker rm test_app || true
                '''
              )
            ]
          )
        ]
      )
    }
  }
}

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
    sh 'docker build -t briangomezdevops0/basic_flask_app:latest .'
    sh 'docker tag briangomezdevops0/basic_flask_app:latest $DOCKER_BFLASK_IMAGE'
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
          sh 'docker push docker.io/briangomezdevops0/basic_flask_app:latest'
        }
        
        sshPublisher(
          continueOnError: false, 
          failOnError: true,
          publishers: [
            sshPublisherDesc(
              configName: "dockerhost", 
              transfers: [
               sshTransfer(
  sourceFiles: "**/*",
  remoteDirectory: "/home/dockeradmin/my_flask_app", 
  execCommand: '''
    docker pull briangomezdevops0/basic_flask_app:latest 
    docker run -d -p 6035:5000 --name test_app briangomezdevops0/basic_flask_app:latest
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
