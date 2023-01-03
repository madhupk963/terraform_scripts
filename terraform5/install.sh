#!/bin/bash
sudo apt update -y
sudo apt install default-jre -y
sudo apt update -y
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz
sudo tar -xvzf apache-tomcat-10.0.27.tar.gz
sudo rm -rf apache-tomcat-10.0.27.tar.gz
sudo mv apache-tomcat-10.0.27 tomcat
sudo sh tomcat/bin/startup.sh
sudo rm -rf conf-and-webapps-file
sudo git clone https://github.com/syedwaliuddin/conf-and-webapps-file.git
sudo rm -rf tomcat/conf/tomcat-users.xml
sudo cp conf-and-webapps-file/tomcat-users.xml tomcat/conf/
sudo sh tomcat/bin/startup.sh
sudo rm -rf tomcat/webapps/manager/META-INF/context.xml
sudo cp conf-and-webapps-file/context.xml tomcat/webapps/manager/META-INF/
sudo rm -rf tomcat/webapps/host-manager/META-INF/context.xml
sudo cp conf-and-webapps-file/contexthm.xml tomcat/webapps/host-manager/META-INF/
sudo sh tomcat/bin/startup.sh
