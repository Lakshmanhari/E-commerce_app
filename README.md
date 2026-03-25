# 🚀 DevOps Application Deployment Project

## 📌 Project Overview
This project demonstrates a complete **CI/CD pipeline** for deploying a React application using:

- Docker 🐳
- Jenkins ⚙️
- AWS EC2 ☁️
- Prometheus & Grafana 📊

---

# 🚀 APPLICATION SETUP

## 🔹 STEP 1 — Create Dockerfile
🛠 Tool: VS Code  
📍 Location: `devops-build/`

Create file: `Dockerfile`

```dockerfile
FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy your build files
COPY build/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

🔹 STEP 2 — Build Docker Image

🛠 Tool: Terminal
docker build -t devops-app .

🔹 STEP 3 — Run Container
docker run -d -p 80:80 devops-app

👉 Open in browser:
http://localhost

🔹 STEP 4 — Docker Compose

Create docker-compose.yml

version: '3'

services:
  web:
    image: devops-app
    ports:
      - "80:80"

Run:

docker-compose up -d


🚀 VERSION CONTROL (GIT)
 Create GitHub Repo
👉 Create new repo:

 Name: devops-app

🔹 Initialize Git
git init

🔹 Create .gitignore
node_modules/
.git

🔹 Create .dockerignore
.git
node_modules

🔹 Create Branches

✅ Step 1: Create dev branch
git checkout -b dev

✅ Step 2: push dev branch
git push origin dev

✅ Step 3: Create master branch
git checkout -b master

✅ Step 4:push master branch
git push origin master

🎯 Branch Strategy
dev → Development & testing
master → Production and Final stable code  Production deployment

🚀 DOCKER HUB SETUP
🔹 Create Repositories
yourdockerhub/dev → Public
yourdockerhub/prod → Private

🔹 Login Docker
docker login

🚀 BASH SCRIPTS
🔹 build.sh
#!/bin/bash

echo "Starting build process..."

docker build -t lakshmanhari/dev:latest .
docker push lakshmanhari/dev:latest

echo "Build and push completed!"

🔹 deploy.sh
#!/bin/bash

echo "Starting deployment..."

docker pull lakshmanhari/prod:latest

docker stop app-container || true
docker rm app-container || true

docker run -d -p 80:80 --name app-container lakshmanhari/prod:latest

echo "Deployment completed!"

🚀 JENKINS SETUP
🔹 Install Jenkins & Docker (EC2)
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker

🔹Install Jenkins
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version

Long Term Support release

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install Jenkins

🔹 Fix Docker Permission
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

🔹 Docker Login for Jenkins
sudo su - jenkins
docker login
exit

🔹 DEV JOB
Branch: dev
Build Step:
bash build.sh

🔹 PROD JOB
Branch: master
Build Step:
bash build.sh

🔹 Enable Webhook

GitHub → Settings → Webhooks

http://<EC2-IP>:8080/github-webhook/


🚀 AWS EC2 SETUP
 Launched :linux (Ec2)
 instance type: t2.micro

🔹 Instance Security Group Configuration
Port  | Access
______|__________    
22	  | Your IP
80	  |  0.0.0.0/0
8080	| 0.0.0.0/0
9090	| 0.0.0.0/0
3000	| 0.0.0.0/0

🚀 MONITORING (PROMETHEUS + GRAFANA)
🔹 STEP 1 — Node Exporter
docker run -d -p 9100:9100 prom/node-exporter
🔹 STEP 2 — Prometheus Config

Create prometheus.yml

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['172.31.45.113:9100']

rule_files:
  - "alert.rules.yml"
🔹 STEP 3 — Run Prometheus
docker run -d \
-p 9090:9090 \
-v /home/ubuntu/prometheus.yml:/etc/prometheus/prometheus.yml \
-v /home/ubuntu/alert.rules.yml:/etc/prometheus/alert.rules.yml \
prom/prometheus
🔹 STEP 4 — Run Grafana
docker run -d -p 3000:3000 grafana/grafana

👉 Open:
http://<EC2-IP>:3000

🔹 STEP 5 — Import Dashboard
Go to Grafana → Import
Enter ID: 1860
Select datasource → Prometheus
🚀 ALERTING (PROMETHEUS)
🔹 Create Alert File

alert.rules.yml

groups:
  - name: node-alerts
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Instance Down"
          description: "Node Exporter is down"
🔹 Verify Alerts

👉 Open:

http://<EC2-IP>:9090/alerts
🔹 Test Alert
docker stop <node-exporter-id>

👉 After 1 min:

InstanceDown → FIRING

🎉 FINAL RESULT

✔ CI/CD Pipeline (Jenkins)
✔ Dockerized Application
✔ AWS Deployment
✔ Monitoring (Prometheus + Grafana)
✔ Alerting System
