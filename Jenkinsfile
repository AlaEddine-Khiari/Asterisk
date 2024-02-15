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

        stage('Test') {
            steps {
                script {
                    // Execute shell script to test Asterisk image
                    def scriptExitCode = sh(script: "./Test/image_test.sh", returnStatus: true)

                    // Handle script exit code
                    if (scriptExitCode != 0) {
                        sh "docker rmi -f asterisk-image"
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
                 body: ''' Dear Mr Ala, 
                 we are happy to inform you that your pipeline build was successful. 
                                         Great work! 
                                         
                 Best regards,
                -Jenkins Team-'''
        }
        
        failure {
            mail to: 'khiarialaa@gmail.com',
                 from: 'zizoutejdin02@gmail.com',
                 subject: 'Build Finished - Failure',
                 body: ''' Dear Mr Ala, 
                 we are sorry to inform you that your pipeline build failed. 
                                     Keep working! 

                 Best regards,
                -Jenkins Team-'''
        }

        always {
            cleanWs()
        }
    }
}
