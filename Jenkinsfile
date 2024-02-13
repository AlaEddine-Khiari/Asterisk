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
                    def mountpoint = sh(script: "docker inspect --format='{{ range .Mounts }}{{ .Source }}{{ end }}' container_name", returnStdout: true).trim()
                    // Check if mountpoint is not empty before copying files
                    if (mountpoint) {
                        sh "cp sip.conf /home/vagrant/Asterisk_Volume"
                        sh "cp other_file.conf /home/vagrant/Asterisk_Volume"
                    } else {
                        error "Failed to determine the copy"
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

