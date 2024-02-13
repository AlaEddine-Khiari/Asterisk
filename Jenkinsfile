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
                        sh "cp sip.conf /home/vagrant/Asterisk" 
                        sh "cp voicemail.conf /home/vagrant/Asterisk"
                }
            }
        }
        
        stage('Run SIP Module Test') {
            steps {
                script {
                    // Execute Python script to test SIP module
                    def scriptExitCode = sh(script: "python /home/vagrant/Asterisk/image_test.py", returnStatus: true)

                    // Handle script exit code
                    if (scriptExitCode == 0) {
                        echo "SIP module test passed!"
                    } else {
                        echo "SIP module test failed!"
                         //delete the Docker image if the test fails
                        sh "docker rmi -f your-asterisk-image"
                    }
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

