pipeline {
  options {
    disableConcurrentBuilds()
  }  
  agent {
    label "jenkins-maven-java11"
  }
  environment {
    ORG               = 'activiti'
    APP_NAME          = 'activiti-cloud-full-example'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    GITHUB_CHARTS_REPO    = "https://github.com/Activiti/activiti-cloud-helm-charts.git"
    GITHUB_HELM_REPO_URL = "https://activiti.github.io/activiti-cloud-helm-charts/"
    HELM_RELEASE_NAME = "example-$BRANCH_NAME-$BUILD_NUMBER".toLowerCase()

    PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
    PREVIEW_NAMESPACE = "example-$BRANCH_NAME-$BUILD_NUMBER".toLowerCase()
    GLOBAL_GATEWAY_DOMAIN="35.228.195.195.nip.io"
    REALM = "activiti"    
    LOGGING_LEVEL_ORG_ACTIVITI_CLOUD_ACC_CORE_SERVICES = "INFO" 
  }
  stages {
    stage('Create Preview Environment') {
      options {
        timeout(time: 30, unit: 'MINUTES') 
      }        
      when {
        branch 'feature-*'
      }
      environment {
        HELM_RELEASE_NAME = "$BRANCH_NAME".toLowerCase()
        PREVIEW_NAMESPACE = "$BRANCH_NAME".toLowerCase()
        GATEWAY_HOST = "gateway.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
        SSO_HOST = "identity.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
      }
      steps {
        container('maven') {
          dir ("./charts/$APP_NAME") {
            sh 'make install'
          }
          print_environment()
          input "Click Abort to delete preview environment: ${HELM_RELEASE_NAME}"
        }
      }
      post{ 
        aborted {
          delete_deployment()
        }
      }
    }
    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      steps {
        container('maven') {
          dir ("./charts/$APP_NAME") {
             sh 'make build'
          }
        }
      }
    }
    stage('Build Release') {
      when {
        branch 'master'
        not {
          changelog '.*\\[ci skip\\].*'
        }
      }
      environment {
        GATEWAY_HOST = "gateway.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
        SSO_HOST = "identity.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
      }      
      steps {
        container('maven') {
          // ensure we're not on a detached head
          sh "git checkout master"
          sh "git config --global credential.helper store"
          sh "jx step git credentials"
          sh "echo \$(jx-release-version) > VERSION"
          dir ("./charts/$APP_NAME") {
            sh 'make build'
          }
          dir ("./charts/$APP_NAME") {
            retry(5) {
              sh 'make tag'
            }
            sh 'make release'
            retry(5) {
              sh 'make github'
            }            
            retry(5) {  
              sh 'make updatebot/push-version'
            }
          }
        }
      }
    }

    stage('Promote to Environments') {
      when {
        branch 'master'
        not {
          changelog '^.*\\[ci skip\\].*$'
        }
      }
      steps {
        container('maven') {
          dir ("./charts/$APP_NAME") {
            sh 'make changelog'
            retry(5) {	
              sh 'jx promote -b --all-auto --helm-repo-url=$GITHUB_HELM_REPO_URL --timeout 1h --version \$(cat ../../VERSION) --no-wait'
            }
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}

def delete_deployment() {
  container('maven') {
    dir("./charts/$APP_NAME") {
      sh "make delete"
    }
    sh "kubectl delete namespace $PREVIEW_NAMESPACE" 
  }
}

def print_environment() {
  print """Preview environment detais:
HELM_RELEASE_NAME=${HELM_RELEASE_NAME}
export REALM=${REALM}
export GATEWAY_HOST=${GATEWAY_HOST}
export SSO_HOST=${SSO_HOST}
  """  
}

def jx_release_version() {
  container('maven') {
      return sh( script: "echo \$(jx-release-version)", returnStdout: true).trim()
  }
}
