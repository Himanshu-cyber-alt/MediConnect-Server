# MediConnect Backend

This is the backend server for **MediConnect**, an AI-powered healthcare assistance platform.

The backend is built with **Node.js and Express.js** and provides APIs for authentication, patient and doctor management, appointments, medical records, and communication between users.

The backend also integrates with the AI/ML component of the application and supports real-time communication using **Socket.IO and WebRTC**.

The main focus of this project was not only building the backend, but also deploying it on AWS and setting up an automated CI/CD pipeline using **Docker, Amazon ECR, Amazon EC2, GitHub Actions, GitHub OIDC, IAM, and PostgreSQL**.

---

# Architecture

The backend is deployed using the following architecture:

```text id="5g8d2p"
                     React Frontend
                           │
                           │ HTTP / WebSocket
                           ▼
                  Node.js + Express
                   Docker Container
                           │
                         EC2
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       PostgreSQL Database          AI/ML Service
          Amazon RDS                Python / Flask
              │                         │
              └────────────┬────────────┘
                           │
                           ▼
                    Application Logic
```

---

# Deployment Architecture

The Docker image is built by GitHub Actions and stored in Amazon ECR.

```text id="w6d4n2"
Developer
    │
    │ git push origin main
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Checkout code
    ├── Authenticate with AWS using OIDC
    ├── Login to ECR
    ├── Build Docker image
    ├── Tag Docker image
    └── Push image to ECR
            │
            ▼
      Amazon ECR
            │
            │ SSH
            ▼
        Amazon EC2
            │
            ├── Login to ECR
            ├── Pull latest image
            ├── Stop old container
            ├── Remove old container
            └── Start new container
                    │
                    ▼
              MediConnect API
```

---

# Tech Stack

## Backend

* Node.js
* Express.js
* REST APIs
* PostgreSQL
* JWT Authentication
* Role-Based Access Control
* Socket.IO
* WebRTC

## AI / ML

* Python
* Flask
* scikit-learn

## Containerization

* Docker
* Dockerfile
* Amazon ECR

## AWS

* Amazon EC2
* Amazon ECR
* Amazon RDS
* Amazon VPC
* IAM
* IAM Roles
* Security Groups
* Subnets
* Route Tables

## CI/CD

* GitHub Actions
* GitHub OIDC
* AWS CLI
* SSH
* Linux

---

# 1. Running the Backend Locally

I first developed and tested the backend locally before moving it to AWS.

Clone the repository:

```bash id="8a6g9x"
git clone https://github.com/Himanshu-cyber-alt/MediConnect-Server.git
```

Move into the project:

```bash id="6w4k1p"
cd MediConnect-Server
```

Install dependencies:

```bash id="9z3j0v"
npm install
```

The backend uses environment variables for things such as:

* Database connection
* JWT configuration
* Application configuration
* Other service credentials

These values are stored in a local `.env` file.

The `.env` file is not committed to GitHub.

---

# 2. Database

MediConnect uses **PostgreSQL** as its database.

During deployment, PostgreSQL is hosted using **Amazon RDS** instead of running the database directly on the EC2 instance.

The application connects to RDS using the database connection string stored in an environment variable.

```text id="1j4q6x"
Node.js Backend
      │
      │ DATABASE_URL
      ▼
Amazon RDS
PostgreSQL
```

This separates the application server from the database.

---

# 3. AWS Network

The application is deployed inside an AWS VPC.

The basic structure is:

```text id="1m9c5a"
VPC
 │
 ├── Public Subnet
 │      │
 │      └── EC2
 │
 └── Private Subnet
        │
        └── RDS
```

The EC2 instance runs the backend application.

The PostgreSQL database is placed in the private part of the network so that it does not need to be directly exposed to the internet.

---

# 4. Security Groups

The EC2 and RDS instances use security groups to control network traffic.

The important database rule is:

```text id="q2h6b4"
EC2 Security Group
        │
        │ PostgreSQL : 5432
        ▼
RDS Security Group
```

The RDS security group allows PostgreSQL traffic from the EC2 security group.

This means the backend can communicate with the database while the database itself is not publicly accessible.

---

# 5. Preparing EC2

After creating the EC2 instance, I connected to it using SSH.

I updated the system packages:

```bash id="x1f3p9"
sudo dnf update -y
```

This updates installed packages and available security fixes.

I installed Git:

```bash id="h7x9c2"
sudo dnf install git -y
```

Then checked the installation:

```bash id="f0k4s8"
git --version
```

---

# 6. Initial Backend Setup on EC2

For the initial deployment/testing, I cloned the backend repository onto EC2:

```bash id="b5m7q1"
git clone https://github.com/Himanshu-cyber-alt/MediConnect-Server.git
```

I then configured the production environment variables in:

```text id="v6n3r8"
/home/ec2-user/MediConnect-Server/.env
```

The `.env` file contains the production configuration and secrets required by the application.

It is kept on the EC2 server instead of being included in the Docker image.

---

# 7. Dockerizing the Backend

I created a Dockerfile for the backend.

The purpose of Docker is to package the application together with its runtime and dependencies.

The deployment then becomes:

```text id="7h3x5m"
Node.js Application
       +
Dependencies
       +
Dockerfile
       ↓
Docker Image
       ↓
Docker Container
```

This makes the application easier to deploy consistently across environments.

---

# 8. Building the Docker Image

The Docker image can be created with:

```bash id="5z8n2c"
docker build -t mediconnect-server-img .
```

Here:

```text
docker build
```

tells Docker to create an image.

```text
-t mediconnect-server-img
```

gives the image a name.

```text
.
```

means Docker should use the current directory as the build context.

---

# 9. Running the Backend Container

The backend runs on port `5000`.

A container can be started using:

```bash id="k3d7p1"
docker run -d \
  --name mediconnect-container \
  --env-file .env \
  -p 5000:5000 \
  mediconnect-server-img
```

### What these options mean

`-d`

Runs the container in the background.

`--name mediconnect-container`

Gives the container a fixed name.

`--env-file .env`

Loads the production environment variables.

`-p 5000:5000`

Maps the EC2 host port to the Docker container port.

```text id="x6p2q8"
EC2 Port 5000
      ↓
Container Port 5000
      ↓
Node.js Server
```

---

# 10. Testing the Backend

After starting the container, I tested the backend from the EC2 instance.

```bash id="n5k7v2"
curl http://localhost:5000
```

I could also test the API through the EC2 public address:

```text id="c8m2z5"
http://<EC2_PUBLIC_IP>:5000
```

This verifies that the application is actually reachable through the EC2 server.

---

# 11. Why Amazon ECR?

After successfully running the backend using Docker, I needed a way to store the Docker image so that the deployment pipeline could use it.

For this I used **Amazon Elastic Container Registry (ECR)**.

The flow is:

```text id="h4r7m1"
GitHub Actions
      │
      │ docker push
      ▼
Amazon ECR
      │
      │ docker pull
      ▼
Amazon EC2
```

ECR acts as the private Docker image registry for the MediConnect backend.

---

# 12. ECR Repository

I created an ECR repository for the MediConnect backend:

```text id="q8n2s4"
mediconnect-server-image
```

The Docker image is stored in the repository using:

```text id="v3x7k9"
541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

The repository is private.

---

# 13. GitHub Actions CI/CD

Once the manual deployment was working, I automated the process using GitHub Actions.

The workflow runs whenever code is pushed to the `main` branch:

```yaml id="r4y8p2"
on:
  push:
    branches:
      - main
```

So instead of manually building and copying the backend every time, I can simply:

```bash id="m7k2x9"
git add .
git commit -m "Update backend"
git push origin main
```

GitHub Actions then handles the deployment.

---

# 14. GitHub OIDC Authentication

GitHub Actions needs permission to interact with AWS.

Instead of storing long-lived AWS access keys, I used **GitHub OIDC**.

The authentication flow is:

```text id="s3p8w6"
GitHub Actions
      │
      │ OIDC Token
      ▼
AWS IAM
      │
      │ Assume IAM Role
      ▼
Temporary AWS Credentials
      │
      ▼
Amazon ECR
```

The workflow uses:

```yaml id="v7m2k5"
permissions:
  id-token: write
  contents: read
```

`contents: read` allows the workflow to access the repository.

`id-token: write` allows GitHub Actions to request the OIDC token required for AWS authentication.

---

# 15. GitHub Actions — Build and Push

The first part of the pipeline is:

```text id="n6c4x1"
GitHub
   ↓
Checkout
   ↓
AWS Authentication
   ↓
ECR Login
   ↓
Docker Build
   ↓
Docker Tag
   ↓
Docker Push
   ↓
ECR
```

The image is built using:

```bash id="u2r6m8"
docker build -t mediconnect-server-img .
```

Then tagged with the ECR repository:

```bash id="w4x8k2"
docker tag mediconnect-server-img:latest \
541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

Then pushed:

```bash id="c6p1z7"
docker push \
541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

Now the latest version of the backend image is available in ECR.

---

# 16. EC2 IAM Role

The EC2 server also needs permission to pull the private Docker image from ECR.

I attached an IAM role to the EC2 instance with the required ECR read permissions.

The flow becomes:

```text id="z5m8q3"
EC2
 │
 │ IAM Role
 ▼
ECR Read Permissions
 │
 ▼
Amazon ECR
```

I can verify the AWS identity from EC2 using:

```bash id="r9x3v6"
aws sts get-caller-identity
```

---

# 17. Deploying From GitHub Actions to EC2

After GitHub Actions pushes the image to ECR, the workflow connects to EC2 using SSH.

The connection uses GitHub Secrets:

```text id="b8n5w2"
EC2_HOST
EC2_SSH_KEY
```

The private SSH key is never stored directly in the repository.

---

# 18. ECR Login on EC2

After connecting to EC2, the workflow authenticates Docker with ECR:

```bash id="p4k8s1"
aws ecr get-login-password --region ap-south-1 | \
sudo docker login --username AWS --password-stdin \
541739391357.dkr.ecr.ap-south-1.amazonaws.com
```

This allows Docker on EC2 to pull the private image.

---

# 19. Pull the Latest Image

The workflow then downloads the latest image:

```bash id="x7m2q9"
sudo docker pull \
541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

At this point, EC2 has the latest version of the backend.

---

# 20. Replace the Existing Container

The existing container is stopped:

```bash id="h5r8n3"
sudo docker stop mediconnect-container || true
```

Then removed:

```bash id="f2q6w7"
sudo docker rm mediconnect-container || true
```

The `|| true` prevents the deployment from failing if the container does not exist.

This is useful for the first deployment or if the previous container has already been removed.

---

# 21. Start the New Container

The latest image is then started:

```bash id="m9x4k2"
sudo docker run -d \
  --name mediconnect-container \
  --env-file /home/ec2-user/MediConnect-Server/.env \
  -p 5000:5000 \
  541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

The production environment file remains on EC2.

The Docker image itself does not contain the production secrets.

---

# 22. Complete GitHub Actions Workflow

The complete deployment pipeline is:

```yaml id="q6v8n1"
name: Pipeline For Mediconnect Backend

on:
  push:
    branches:
      - main

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:

      - name: Get code from repo
        uses: actions/checkout@v4

      - name: Connect to AWS
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ap-south-1

      - name: Login to AWS ECR
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build Docker image
        run: |
          docker build -t mediconnect-server-img .

      - name: Tag Docker image
        run: |
          docker tag mediconnect-server-img:latest \
            541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest

      - name: Push image to ECR
        run: |
          docker push \
            541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest

      - name: Deploy to EC2
        uses: appleboy/ssh-action@v1.2.0
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ec2-user
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |

            aws ecr get-login-password --region ap-south-1 | \
            sudo docker login --username AWS --password-stdin \
            541739391357.dkr.ecr.ap-south-1.amazonaws.com

            sudo docker pull \
            541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest

            sudo docker stop mediconnect-container || true
            sudo docker rm mediconnect-container || true

            sudo docker run -d \
              --name mediconnect-container \
              --env-file /home/ec2-user/MediConnect-Server/.env \
              -p 5000:5000 \
              541739391357.dkr.ecr.ap-south-1.amazonaws.com/mediconnect-server-image:latest
```

---

# 23. Complete Deployment Flow

The complete process can be summarized as:

```text id="e4n7p2"
                    Developer
                        │
                        │ git push
                        ▼
                GitHub Repository
                        │
                        ▼
                 GitHub Actions
                        │
              ┌─────────┴─────────┐
              │                   │
          Checkout            OIDC Auth
              │                   │
              └─────────┬─────────┘
                        ▼
                   Login to ECR
                        │
                        ▼
                 Docker Build
                        │
                        ▼
                  Docker Tag
                        │
                        ▼
                  Docker Push
                        │
                        ▼
                  Amazon ECR
                        │
                        │ SSH
                        ▼
                    EC2
                        │
                 Docker Login
                        │
                 Docker Pull
                        │
               Stop Old Container
                        │
               Remove Old Container
                        │
                Start New Container
                        │
                        ▼
                MediConnect API
                        │
             ┌──────────┴──────────┐
             ▼                     ▼
       Amazon RDS              AI/ML Service
        PostgreSQL             Python/Flask
```

---

# 24. Useful Docker Commands

### Check running containers

```bash id="p7x2m4"
sudo docker ps
```

### Check all containers

```bash id="z4k8n6"
sudo docker ps -a
```

### Check images

```bash id="q1v5s9"
sudo docker images
```

### View application logs

```bash id="n8c3r6"
sudo docker logs mediconnect-container
```

### Follow logs

```bash id="x6m2p7"
sudo docker logs -f mediconnect-container
```

### Stop container

```bash id="w9k4d2"
sudo docker stop mediconnect-container
```

### Remove container

```bash id="b3q7v1"
sudo docker rm mediconnect-container
```

### Check AWS identity

```bash id="r5n8x3"
aws sts get-caller-identity
```

---

# 25. Security

Sensitive information is kept outside the repository.

The following are not committed to GitHub:

* Database credentials
* JWT secrets
* SSH private key
* Production `.env`
* Other private credentials

GitHub Actions authenticates with AWS using **OIDC and an IAM role** instead of long-lived AWS access keys.

EC2 uses an IAM role to access the private ECR repository.

The PostgreSQL database is hosted on RDS and access is controlled through AWS security groups.

---

# 26. What I Learned

This deployment helped me understand the complete path from application development to cloud deployment.

I worked with:

* Node.js backend deployment
* Dockerizing a backend application
* Creating and managing Docker images
* Amazon ECR
* Amazon EC2
* Amazon RDS
* AWS VPC and networking
* Security Groups
* IAM roles
* GitHub OIDC
* GitHub Actions
* CI/CD pipelines
* SSH-based deployment
* AWS CLI
* Linux server administration
* Environment variables and secrets
* PostgreSQL connectivity

The biggest improvement was moving from a manual deployment process to an automated one.

Before:

```text id="a8f2k6"
Change Code
    ↓
Build Manually
    ↓
Copy/Deploy Manually
    ↓
Restart Backend
```

After:

```text id="r4m8x2"
Change Code
    ↓
git push origin main
    ↓
GitHub Actions
    ↓
Docker Build
    ↓
Push to ECR
    ↓
SSH to EC2
    ↓
Pull Latest Image
    ↓
Replace Container
    ↓
Backend Updated
```

---

## Repository

**MediConnect Backend:**
https://github.com/Himanshu-cyber-alt/MediConnect-Server

## Author

**Himanshu Pagare**
