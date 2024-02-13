pipeline {
    agent any

    stages {
        stage('Getting project from Git') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/AlaEddine-Khiari/Asterisk']]])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                  sh "docker build -t asterisk-image:latest ."
                }
            }
        }

        stage('Copy Files from Container to Local Machine') {
            steps {
                script {
                        sh "sudo cp sip.conf /home/vagrant/Asterisk_Volume"
                        sh "sudo cp other_file.conf /home/vagrant/Asterisk_Volume"
                }
            }
        }
    }
    post {
        always {
            // Send email notification
            emailext(body: "", attachLog: true, subject: "Pipeline ${currentBuild.result}: ${env.JOB_NAME}", to: 'hyperrftw29@gmail.com')
        }
    }
 }

