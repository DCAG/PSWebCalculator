pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Build'
      }
    }
    stage('Deploy Int') {
      steps {
        echo 'Integration'
      }
    }
    stage('Deploy Stage') {
      steps {
        input(message: 'Deploy To Stage?', id: '1', ok: 'Approve', submitter: 'Submitter', submitterParameter: 'SubmitterParam')
        echo 'Stage'
      }
    }
    stage('Deploy Prod') {
      agent any
      steps {
        input(message: 'Deploy Prod?', id: '2', ok: 'Approve', submitter: 'SubmitterProd', submitterParameter: 'SubmitterParamProd')
        echo 'Production'
      }
    }
  }
}