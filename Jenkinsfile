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
                    if (scriptExitCode != 0) {
                        error "Test Failed!"
                    }
                }
            }
        }
    }

    post {
        success {
            mail to: 'khiarialaa@gmail.com',
                 from: 'zizoutejdin02@gmail.com',
                 subject: 'Build Finished - Success',
                 body: '''Dear Mr Ala, 
                          we are happy to inform you that your pipeline build was successful. 
                          Great work! 
                          -Jenkins Team-'''
        }
        
        failure {
            mail to: 'khiarialaa@gmail.com',
                 from: 'zizoutejdin02@gmail.com',
                 subject: 'Build Finished - Failure',
                 body: '''Dear Mr Ala, 
                          we are sorry to inform you that your pipeline build failed. 
                          Keep working! 
                          -Jenkins Team-'''
        }

        always {
            cleanWs()
        }
    }
}
