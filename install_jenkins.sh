#!/bin/bash
  sudo apt update -y
  sudo apt install default-jre -y
  sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt update
  sudo apt install jenkins -y
  sudo jenkins --version
  sudo systemctl start jenkins
  echo "get access to jenkins"
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
