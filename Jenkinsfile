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
                   def dockerImage = docker.build("asterisk-image:latest", ".")
                   // Check if dockerImage is null or an error occurred during the build
                   if (dockerImage == null) {
                       error "Docker image build failed"
                   }
                }
            }
        }

        stage('Copy Files from Container to Local Machine') {
            steps {
                script {
                    def mountpoint = sh(script: "docker inspect --format='{{ range .Mounts }}{{ .Source }}{{ end }}' container_name", returnStdout: true).trim()
                    // Check if mountpoint is not empty before copying files
                    if (mountpoint) {
                        sh "cp ${mountpoint}/sip.conf /home/vagrant/Asterisk_Volume"
                        sh "cp ${mountpoint}/other_file.conf /home/vagrant/Asterisk_Volume"
                    } else {
                        error "Failed to determine container mountpoint"
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
