
def appname = "test-app"
def repo = "kfire312"  // Replace with your DockerHub username
def appimage = "${repo}/${appname}"
def apptag = "${env.BUILD_NUMBER}"

podTemplate(cloud: 'kubernetes', containers: [
    containerTemplate(
        name: 'jnlp', 
        image: 'jenkins/inbound-agent:latest'
    ),
     containerTemplate(
        name: 'docker', 
        image: 'docker:26-dind', // Use the latest stable DinD image
        privileged: true,      // Essential for Docker daemon to run
        args: '--storage-driver=vfs' // VFS is safest for K8s, though slower
    )], 
  volumes: [
    emptyDirVolume(mountPath: '/var/lib/docker', memory: false) // Q: Why do we need this volume?
  ]) {
    node(POD_LABEL) {
        stage('checkout') {
            container('jnlp') {
            sh '/usr/bin/git config --global http.sslVerify false'
	    checkout scm
          }
        } // end checkout
container('docker') {
        stage('Install Tools') {
        sh '''
            apk add --no-cache yamllint shellcheck bash git curl
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        '''
    }
        stage('Linting') {
           container('docker') {

              stage('Linting') {
                  parallel(
                    'YAML Lint': {
                        sh 'yamllint . || true'
            },

                    'ShellCheck': {
                            sh '''
                                  files=$(find . -name "*.sh" -type f)
                                if [ -n "$files" ]; then
                                    shellcheck $files
                                else
                                    echo "No shell scripts found"
                                fi
                                 '''
                }
            )
        }
    }
}
        stage("build docker image ${appimage}:${apptag}") {
            
              echo "--------------------------------------------------------------"
              echo "Building docker image..."
              echo "--------------------------------------------------------------"
              sh " docker build -t ${appimage}:${apptag} ."
              sleep 5
              echo "--------------------------------------------------------------"
              echo "Docker image built successfully: ${appimage}:${apptag}"
              echo "--------------------------------------------------------------"

             // sh 'docker run -exec -itd --name ${appname} ${appimage}:${apptag}'
            }
            
        stage('Docker Image scan') {
            sh """
                trivy image --severity CRITICAL --exit-code 1  ${appimage}:${apptag} || true
               """
        }    

        stage('Login and Push') {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_TOKEN'
                )]) {

                sh """
                    echo $DOCKER_TOKEN | docker login -u $DOCKER_USER --password-stdin
                    docker push $appimage:$apptag
                """
                    
                }
            }
            stage('install helm') {
            sh """ 
                curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 
                chmod 700 get_helm.sh 
                ./get_helm.sh
                echo  image.repository: ${appimage}:${apptag} > myvalues.yaml
                helm template ${appname} helm-charts/ -f myvalues.yaml >test-app-template.yaml
                cat test-app-template.yaml
                """
        
        }
        }
    }
  }
