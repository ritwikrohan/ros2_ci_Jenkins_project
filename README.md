# ROS Galactic
# Jenkins Setup for ROS2 CI for ROS waypoint server test

This guide outlines the steps to set up Jenkins for Continuous Integration in the `ros2_ci` repository. Follow these instructions to ensure the automation of building and testing processes.

## GitHub

https://github.com/ritwikrohan/ros2_ci.git

## Prerequisites

0. Firstly check whether git authenticity is established. For this paste the command below in the rosject terminal:
    ```bash
    git ls-remote -h -- git@github.com:ritwikrohan/ros2_ci.git HEAD
    ```
    - if nothing appears that means authenticity is established. You can move forward to step 1.
    - if you get a prompt like below, then please type 'yes' and press enter. This will establish the authenticity.
      
      
          The authenticity of host 'github.com (20.27.177.113)' can't be established.
          ECDSA key fingerprint is SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM.
          Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

1. Install Jenkins on your server. Shell file for latest Jenkins version is already in the rosject. Paste the command below in your rosject terminal. 

    ```bash
    source ~/.bashrc
    cd ~/webpage_ws/ && bash start_jenkins.sh
    ```

2. When you see the output "1. Jenkins is running in the background.", it means jenkins has started. Access Jenkins Webpage using two methods. Follow either of below:
   - Paste the command below in your terminal to get the proxy address and click the link to open jenkins in new tab:
     ```bash
      jenkins_address
     ```
   - Paste the command below in your terminal to open the txt file that contains the link to jenkins.
     ```bash
      cat ~/jenkins__pid__url.txt
     ```

## Jenkins Credentials

1. In jenkins webpage, use below as username and password and sign in:
     ```
        username: admin
        password: ritwikjenkins
     ```
   
## Jenkins

1. In Jenkins dashboard, you will see "ros2_ci" project which you can build manually by pressing build now button in ros2_ci project page or you can commit some changes in the repository which triggers a build for "ros2_ci"

2. Triggering build through pull request:
  - In this repository, add a test.txt file and create a pull request.
  - After the pull request is accepted,Click "ros2_ci" or check build exector tab in jenkins.
  - Please wait for sometime for build to start (< 1minute), you will see that ros2_ci has started building because of the SCM change.
  - Click the build dropdown and select Console Output to check whats happening.
  - Docker will pull the image from dockerhub and build the image and run it automatically.
  - After build is complete. check the rosject tab where
      - Gazebo with tortoisebot playground world will be launched.
      - Waypoint action server is launched.
      - Tortoisebot successfully goes to the pre defined waypoint.
  - When the Tortoisebot reaches the waypoint (robot moves to 1,1), gazebo closes.
  - Now go back to jenkins Console Output page and check the colcon test summary which should be successful.

## NOTE: Sometimes Gazebo doesnt start in time and result might fail. In that case please build the project in jenkins manually.

## NOTE: If robot does not move in gazebo that means, gazebo was not launched properly and you will have to build it again.
   

