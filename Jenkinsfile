def appname = "test-app"
def repo = "kfirbros123"  // Replace with your DockerHub username
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

        stage('Hello') {
            container('docker') {
              echo "Building docker image..."
              sh "echo docker push $appimage"
            }
        } //end hello
    }
}

