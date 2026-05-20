def appname = "test-app"
def repo = "kfire312"  // Replace with your DockerHub username
def appimage = "${repo}/${appname}"
def apptag = "${env.BUILD_NUMBER}"

podTemplate(containers: [
      containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', ttyEnabled: true),
      containerTemplate(name: 'docker', image: 'gcr.io/kaniko-project/executor:v1.23.0-debug', command: '/busybox/cat', ttyEnabled: true)
  ])
  {
    node(POD_LABEL) {
        stage('checkout') {
            container('jnlp') {
            sh '/usr/bin/git config --global http.sslVerify false'
	    checkout scm
          }
        } // end checkout

        stage('Build and run docker image') {
            container('docker') {
              echo "Building docker image..."
              sh 'docker build -t $appimage:$apptag .'
              sleep 2
             // sh 'docker run -exec -itd --name ${appname} ${appimage}:${apptag}'
            }
        } //end build
    }
}

