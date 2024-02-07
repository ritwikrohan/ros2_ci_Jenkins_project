pipeline {
    agent any 
    stages {
        stage('Print + list current directory') {
            steps {
                sh 'pwd'
                sh 'ls -al'
            }
        }
        stage('Show ROS environment variables') {
            steps {
                sh 'env | grep ROS'
            }
        }
        stage('Install Docker') {
            steps {
                sh 'sudo apt-get update'
                sh 'sudo apt-get install -y docker.io docker-compose'
                sh 'sudo service docker start'
                sh 'sudo usermod -aG docker $USER'
                sh 'newgrp docker'
            }
        }
        stage('Start Docker Compose') {
            steps {
                sh 'cd ~/ros2_ws/src/ros2_ci'
                sh 'sudo docker-compose up -d'
            }
        }
        stage('Wait for Docker Compose to Complete') {
            steps {
                script {
                    def maxRetries = 30
                    def retryCount = 0

                    while (retryCount < maxRetries) {
                        def result = sh(script: 'sudo docker-compose ps', returnStatus: true)

                        if (result == 0) {
                            echo 'Docker Compose services are ready!'
                            break
                        }

                        echo 'Waiting for Docker Compose services to be ready...'
                        sleep 10
                        retryCount++
                    }

                    if (retryCount >= maxRetries) {
                        error 'Timed out waiting for Docker Compose services to be ready'
                    }
                }
            }
        }
        stage('Run colcon tests for tortoisebot_waypoints') {
            steps {
                sh '''
                sudo docker exec tortoisebot-test-ros2 bash -c "source install/setup.bash && colcon test --packages-select tortoisebot_waypoints --event-handler=console_direct+"
                '''
            }
        }
        stage('Wait for colcon tests to complete') {
            steps {
                sleep 30
            }
        }
        stage('Print colcon test results') {
            steps {
                sh 'sudo docker exec tortoisebot-test-ros2 bash -c "source install/setup.bash && colcon test-result --verbose"'
            }
        }
        stage('Done') {
            steps {
                sh 'sudo docker-compose down'
                echo 'Pipeline completed'
            }
        }
    }
}
