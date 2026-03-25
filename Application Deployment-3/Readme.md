🚀 STEP 1 — Create Dockerfile

🛠 Tool: VS Code

📍 Location:

devops-build/

👉 Create file: Dockerfile

FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy your build files
COPY build/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
🚀 STEP 2 — Build Docker Image

🛠 Tool: Terminal (VS Code or PowerShell)

docker build -t devops-app .
🚀 STEP 3 — Run Container

🛠 Tool: Terminal

docker run -d -p 80:80 devops-app

👉 Open browser:

http://localhost

✅ Your app should work

🚀 STEP 4 — Create docker-compose

🛠 Tool: VS Code

👉 Create: docker-compose.yml

version: '3'

services:
  web:
    image: devops-app
    ports:
      - "80:80"

Run:

docker-compose up -d


🚀 STEP 1 — Initialize Git Project

🛠 Tool: VS Code Terminal (CLI)

git init
🎯 Why?

👉 To track your project changes
👉 Required to push code to GitHub (submission requirement)

🚀 STEP 2 — Create .gitignore

🛠 Tool: VS Code

Create file: .gitignore

node_modules/
.git
🎯 Why?

👉 Prevent unnecessary files from going to GitHub
👉 Keeps repo clean & professional

🚀 STEP 3 — Create .dockerignore

🛠 Tool: VS Code

.git
node_modules
🎯 Why?

👉 Avoid sending unwanted files to Docker build
👉 Makes build faster 🚀

🚀 STEP 4 — Create GitHub Repo

🛠 Tool: Browser (GitHub)

👉 Create new repo:

Name: devops-app
Don’t add README
🚀 STEP 5 — Connect Local to GitHub

🛠 Tool: Terminal

git remote add origin https://github.com/YOUR_USERNAME/devops-app.git



🚀 STEP 6 — Create DEV Branch

🛠 Tool: Terminal

git checkout -b dev

create 2 branches

✅ Required branches:
dev → Development
master (or main) → Production
🎯 Why?

👉 Project requirement:

dev → development
master → production

🧠 WHY 2 BRANCHES?
🔹 dev branch

👉 Used for:

Development code
Testing

👉 Flow:

Code → dev → Jenkins → Docker Hub (dev repo)
🔹 master branch

👉 Used for:

Final stable code
Production deployment

👉 Flow:

dev → merge → master → Jenkins → Docker Hub (prod repo)

HOW TO CREATE (STEP-BY-STEP)

🛠 Tool: Terminal (VS Code)

✅ Step 1: Create dev branch
git checkout -b dev
✅ Step 2: Push dev branch
git push origin dev
✅ Step 3: Create master branch
git checkout -b master
✅ Step 4: Push master
git push origin master

---

dev = working branch

🛠 Tool: VS Code + Git

👉 All your work happens here:

Dockerfile
docker-compose
scripts
build folder
git checkout dev
git add .
git commit -m "update"
git push origin dev







JENKINS SETUP
🧱 STEP 1 — Launch EC2 Instance

🛠 Tool: AWS Console

What to do:
Go to EC2 → Launch Instance
Select:
Ubuntu
t2.micro
🔐 Security Group (VERY IMPORTANT)
Port	Access	Why
22	Your IP	Secure SSH
80	0.0.0.0/0	App access
8080	0.0.0.0/0	Jenkins UI
🎯 Why EC2?

👉 To host:

Jenkins server
Deployment server
🚀 STEP 2 — Connect to EC2

🛠 Tool: Terminal (PowerShell / Git Bash)

ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
🎯 Why?

👉 To control server remotely

🚀 STEP 3 — Install Docker

🛠 Tool: EC2 Terminal

sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu
🎯 Why?

👉 Jenkins will use Docker to:

Build image
Run container
🚀 STEP 4 — Install Jenkins

🛠 Tool: EC2 Terminal

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





Open Docker Hub

🛠 Tool: Browser

👉 Go to:

https://hub.docker.com

👉 Login (or create account)

🚀 STEP 2 — Create DEV Repository

🛠 Tool: Docker Hub (Browser)

Click:
👉 Create Repository

Fill details:
Repository Name:
dev
Visibility:
Public ✅
🎯 Why?

👉 This is for:

Development images
Testing builds from dev branch
🚀 STEP 3 — Create PROD Repository

👉 Click again: Create Repository

Fill details:
Repository Name:
prod
Visibility:
Private 🔒
🎯 Why?

👉 This is for:

Production images
Secure (not public)
🚀 STEP 4 — Verify Repo Names

👉 Your repos should look like:

yourdockerhub/dev
yourdockerhub/prod
🚀 STEP 5 — Login Docker in EC2

🛠 Tool: EC2 Terminal (SSH)

docker login

👉 Enter:

Username
Password



buid.sh
#!/bin/bash

echo "Starting build process..."

# Build Docker image
docker build -t lakshmanhari/dev:latest .

# Push to Docker Hub (dev repo)
docker push lakshmanhari/dev:latest

echo "Build and push completed!"


deploy.sh

#!/bin/bash

echo "Starting deployment..."

# Pull latest production image
docker pull lakshmanhari/prod:latest

# Stop old container (if exists)
docker stop app-container || true
docker rm app-container || true

# Run new container
docker run -d -p 80:80 --name app-container lakshmanhari/prod:latest

echo "Deployment completed!"







🚀 STEP 1 — Login to Jenkins

🛠 Tool: Browser

Open:

http://<EC2-IP>:8080

✔ Enter admin password
✔ Install suggested plugins

🚀 STEP 2 — Create DEV JOB

🛠 Tool: Jenkins UI

👉 Click:

New Item

👉 Enter:
Name: dev-job
Type: Freestyle Project
🚀 STEP 3 — Configure GitHub

🛠 Tool: Jenkins UI

🔹 Source Code Management

✔ Select: Git

👉 Paste your repo:

https://github.com/YOUR_USERNAME/YOUR_REPO.git

👉 Branch:

*/dev
🎯 Why?

👉 This job will run only when:

Code is pushed to dev branch

🚀 STEP 4 — Add Build Step

🛠 Tool: Jenkins UI

👉 Add → Execute shell
bash build.sh

🎯 Why?

👉 Jenkins will:

Build Docker image
Push to Docker Hub (dev repo)
🚀 STEP 5 — Docker Login (IMPORTANT)

🛠 Tool: EC2 Terminal

docker login
🎯 Why?

👉 Without login → push will FAIL ❌

🚀 STEP 6 — Save & Build

🛠 Tool: Jenkins UI

👉 Click:

Build Now
🔍 Verify:

👉 Console Output should show:

docker build ✅
docker push ✅
🚀 STEP 7 — Create PROD JOB

🛠 Tool: Jenkins UI

👉 New Item:
Name: prod-job
Type: Freestyle Project
🔹 Git config:
Branch: */master
🔹 Build Step:
bash build.sh

🎯 Why?

👉 When code reaches master:

It becomes production
Push goes to private prod repo

🚀 STEP 8 — AUTO TRIGGER

🛠 Tool: Jenkins + GitHub

In Jenkins:

✔ Enable:

GitHub hook trigger for GITScm polling
In GitHub:
Go → Settings → Webhooks
Add:
http://<EC2-IP>:8080/github-webhook/
🎯 Why?



error solved while running

sudo usermod -aG docker jenkins
👉 Gives Jenkins permission to run Docker commands

Restart Jenkins

🛠 Tool: EC2 Terminal

sudo systemctl restart Jenkins


Reload group permissions
sudo systemctl restart docker


-----------
Jenkins is NOT logged into Docker Hub ❌
So push is denied

Login Docker as Jenkins user

🛠 Tool: EC2 Terminal

Switch to Jenkins user:
sudo su - jenkins
Login Docker:
docker login

👉 Enter:

Username: lakshmanhari
Password: (your Docker Hub password)

🎯 Why?

👉 Jenkins runs as jenkins user, not ubuntu
👉 So login must be done for jenkins user


🚀 STEP 2 — Verify Login
docker info

👉 Check:

Username: lakshmanhari
🚀 STEP 3 — Exit Jenkins user
exit
🚀 STEP 4 — Run Jenkins Job Again

🛠 Tool: Jenkins UI

👉 Click:

Build Now

--------

🚀 WHAT WE ARE BUILDING
Node Exporter → Prometheus → Grafana Dashboard

👉 This will show:

CPU usage
Memory
Server health
🚀 STEP 1 — Run Node Exporter

🛠 Tool: EC2 Terminal

docker run -d -p 9100:9100 prom/node-exporter
WHY?

👉 Node Exporter gives:

CPU usage
Memory usage
System metrics

🚀 STEP 2 — Create Prometheus Config
nano prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['172.31.45.113:9100']   # 🔥 replace with your private IP

rule_files:
  - "alert.rules.yml"

Save:

👉 CTRL + X → Y → Enter

🚀 STEP 3 — Run Prometheus
docker run -d \
-p 9090:9090 \
-v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
prom/prometheus
🎯 Open:
CHECK PROMETHEUS TARGET

http://<EC2-IP>:9090
http://13.233.85.5:9090
Open:

http://13.233.85.5:9090/targets

You must see:

localhost:9100 → UP ✅









error solved which is it didn't show up
RUN THIS
docker stop a5825c5d9057
docker rm a5825c5d9057
🚫 DO NOT STOP

❌ node-exporter
❌ your app container

👉 Otherwise monitoring will break

RUN NODE EXPORTER

🛠 Tool: EC2 Terminal

docker run -d -p 9100:9100 prom/node-exporter

Run Prometheus again (with fix):

docker run -d \
-p 9090:9090 \
-v /home/ubuntu/prometheus.yml:/etc/prometheus/prometheus.yml \
--add-host=host.docker.internal:host-gateway \
prom/prometheus
🎯 FINAL CHECK

Open:

http://13.233.85.5:9090/targets

👉 You should see:

UP ✅


alert

nano alert.rules.yml

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
          description: "Node Exporter is down or not reachable"




🚀 3. RESTART PROMETHEUS

👉 Run:

docker ps

👉 Find Prometheus container ID, then:

docker restart <container-id>
🚀 4. VERIFY ALERT

👉 Open:

http://13.233.85.5:9090/alerts
✅ You should see:
InstanceDown → INACTIVE
🚀 5. TEST ALERT (IMPORTANT)

👉 Stop node exporter:

docker stop <node-exporter-container-id>

👉 Wait 1 minute

👉 Refresh:

http://13.233.85.5:9090/alerts
🔥 Now you will see:
InstanceDown → FIRING

🚀 3. RESTART PROMETHEUS

👉 Run:

docker ps

👉 Find Prometheus container ID, then:

docker restart <container-id>
🚀 4. VERIFY ALERT

👉 Open:

http://13.233.85.5:9090/alerts
✅ You should see:
InstanceDown → INACTIVE
🚀 5. TEST ALERT (IMPORTANT)

👉 Stop node exporter:

docker stop <node-exporter-container-id>

👉 Wait 1 minute

👉 Refresh:

http://13.233.85.5:9090/alerts
🔥 Now you will see:
InstanceDown → FIRING