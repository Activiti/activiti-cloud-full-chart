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
        sh 'make validate'
          dir ("./charts/$APP_NAME") {
            sh 'make install'
          }
          print "Preview environment detais:"
          print "HELM_RELEASE_NAME=${HELM_RELEASE_NAME}"
          print "GATEWAY_HOST=${GATEWAY_HOST}"
          print "SSO_HOST=${SSO_HOST}"

          input "Click Abort to delete preview environment: ${HELM_RELEASE_NAME}"
        }
      }
      aborted {
        container('maven') {
          dir("./charts/$APP_NAME") {
            sh "make delete"
            sh "kubectl delete namespace $PREVIEW_NAMESPACE" 
          }
        }          
      }        
    }
    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        GATEWAY_HOST = "gateway.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
        SSO_HOST = "identity.$PREVIEW_NAMESPACE.$GLOBAL_GATEWAY_DOMAIN"
      }
      steps {
        container('maven') {
        sh 'make validate'
          dir ("./charts/$APP_NAME") {
            // sh 'make build'
            sh 'make install'
          }

          dir("./activiti-cloud-acceptance-scenarios") {
            git 'https://github.com/Activiti/activiti-cloud-acceptance-scenarios.git'
            sh 'sleep 30'
            sh "mvn clean install -DskipTests && mvn -pl 'runtime-acceptance-tests,modeling-acceptance-tests' clean verify"
          }
        }
      }
      post {
        always {
          container('maven') {
            dir("./charts/$APP_NAME") {
              sh "make delete"
            }
            sh "kubectl delete namespace $PREVIEW_NAMESPACE" 
          }
        }
      }
    }
    stage('Build Release') {
      when {
        branch 'master'
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
          // so we can retrieve the version in later steps
          sh "echo \$(jx-release-version) > VERSION"
          //RUNTIME bundle tests
          dir ("./charts/$APP_NAME") {
          // sh 'make build'
          retry(5) {	    
            sh 'make install'
            }
          }
          //run RB and modeling tests
          dir("./activiti-cloud-acceptance-scenarios") {
            git 'https://github.com/Activiti/activiti-cloud-acceptance-scenarios.git'
            sh 'sleep 30'
            sh "mvn clean install -DskipTests && mvn -pl 'runtime-acceptance-tests,modeling-acceptance-tests' clean verify"
            // sh "mvn clean install -DskipTests && mvn -pl 'runtime-acceptance-tests' clean verify"
          }
          //end run RB and modeling tests
          //dir ("./charts/$APP_NAME") {
          //   sh 'make delete'
          //}
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
      post {
        always {
          container('maven') {
            dir("./charts/$APP_NAME") {
              sh "make delete"
            }
            sh "kubectl delete namespace $PREVIEW_NAMESPACE" 
          }
        }
      }
    }

    stage('Promote to Environments') {
      when {
        branch 'master'
      }
      steps {
        container('maven') {
          dir ("./charts/$APP_NAME") {
            sh 'jx step changelog --version v\$(cat ../../VERSION)'
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
