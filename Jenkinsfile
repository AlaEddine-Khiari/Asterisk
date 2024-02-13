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
                    // Define the mount point for the container
                    def mountpoint = sh(script: "docker inspect --format='{{ range .Mounts }}{{ .Source }}{{ end }}' container_name", returnStdout: true).trim()
                    
                    // Copy the files from the volume mountpoint to the local machine
                    sh "cp ${mountpoint}/sip.conf /home/vagrant/Asterisk_Volume"
                    sh "cp ${mountpoint}/other_file.conf /home/vagrant/Asterisk_Volume"
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
