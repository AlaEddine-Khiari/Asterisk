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

        stage('Set Up For Testing') {
            steps {
                script {
                         sh "cp Test/image_test.py /home/vagrant/Asterisk"
                }
            }
        }
        
        stage('Test Asterisk Config') {
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
                        sh "docker rmi -f asterisk-image:latest"
                    }
                }
            }
        }
     
    }
    
    post {
        always {
            script {
                def subject = "Build ${currentBuild.result}: ${env.JOB_NAME}"
                def body = ""

                if (currentBuild.result == 'SUCCESS') {
                    body += "The pipeline was successful.\n"
                    body += "Docker image was created successfully.\n"
                } else {
                    body += "The pipeline failed.\n"
                    body += "Error: ${currentBuild.rawBuild.log}\n" // Include error message from Jenkins build log
                }

                emailext(
                    subject: subject,
                    body: body,
                    to: "khiarialaa@gmail.com"
                )
            }
            cleanWs() // clean workspace
        }
    }
}
