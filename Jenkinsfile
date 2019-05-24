pipeline {
    options {
      disableConcurrentBuilds()
    }  
    agent {
      label "jenkins-maven-java11"
    }
    environment {
      ORG               = 'activiti'
      APP_NAME          = 'activiti-cloud-identity'
      CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
      GITHUB_CHARTS_REPO    = "https://github.com/Activiti/activiti-cloud-helm-charts.git"
      GITHUB_HELM_REPO_URL = "https://activiti.github.io/activiti-cloud-helm-charts/"
      HELM_RELEASE_NAME = "example-$BRANCH_NAME-$BUILD_NUMBER".toLowerCase()
      PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
      PREVIEW_NAMESPACE = "example-$BRANCH_NAME-$BUILD_NUMBER".toLowerCase()
      REALM = "activiti"

    }
    stages {
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
        }
        steps {
          container('maven') {
            // ensure we're not on a detached head
            sh "git checkout master"
            sh "git config --global credential.helper store"

            sh "jx step git credentials"
            // so we can retrieve the version in later steps
            sh "echo \$(jx-release-version) > VERSION"
            dir ("./charts/$APP_NAME") {
	       sh 'make build'
              //sh 'make install'
            }
            dir ("./charts/$APP_NAME") {
	     // retry(5) {    
              sh 'make tag'
              //}
              sh 'make release'
	      //retry(5) {    
              sh 'make github'
              //}
              sh 'jx step git credentials'
              //sh 'sleep 30'
              //retry(5) {
              sh 'make updatebot/push-version'
              //}
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
