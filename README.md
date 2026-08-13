

# Day 02 Assignment: Deploying a Website on AWS EC2 Using Ansible

## Step 1: Update EC2 Inbound Rules

Updated the EC2 Security Group inbound rules to allow:

- SSH (Port 22)
- HTTP (Port 80)
- ICMP (Ping)

![Inbound Rules](https://github.com/user-attachments/assets/2874d27b-6833-4b77-be2a-47a6931fec87)

---

## Step 2: Add the Instance to the Ansible Inventory

Added the target EC2 instance to the Ansible inventory file.

![Ansible Inventory](https://github.com/user-attachments/assets/9fb3d514-8c97-4972-a6b2-110d9674b9e8)

---

## Step 3: Create an Ansible Playbook

Created a playbook named `aws.yml`.

### Command

```bash
vim aws.yml
```

### Playbook Configuration

```yaml
- hosts: first-Vm
  become: true

  tasks:
    - name: Install nginx and unzip
      ansible.builtin.apt:
        name:
          - nginx
          - unzip
        state: present
        update_cache: true

    - name: Download zip
      ansible.builtin.get_url:
        url: https://github.com/user-attachments/files/30199374/site.zip
        dest: /tmp/site.zip
        mode: "0644"

    - name: Extract site.zip into web root
      ansible.builtin.unarchive:
        src: /tmp/site.zip
        dest: /var/www/html
        remote_src: true
```

---

## Step 4: Execute the Playbook

Run the playbook using:

```bash
ansible-playbook aws.yml
```

### Playbook Execution

![Playbook Execution](https://github.com/user-attachments/assets/de0ad2ab-eb1c-4f2e-8d8c-6745ea8f98e1)

---

## Step 5: Verify the Deployment

After the playbook completed successfully, verified the website deployment through the browser using the EC2 instance's public IP address.

![Website Verification](https://github.com/user-attachments/assets/78854588-65bb-4485-b125-adae1f1706a6)

---
# AWS Load Balanced Web Application Deployment Using Route 53, ACM, EC2, Docker, and Ansible

## Project Overview

This project demonstrates the deployment of a highly available and secure web application infrastructure on AWS using Route 53, AWS Certificate Manager (ACM), Application Load Balancer (ALB), EC2, Docker, and Ansible.

The architecture consists of two Ubuntu EC2 instances running a containerized web application behind an Application Load Balancer. Route 53 provides DNS management, while ACM secures communication using HTTPS.

---

# Architecture

```text
Internet
    │
    ▼
Route 53
(demo.sapanajoshi.com.np)
    │
    ▼
Application Load Balancer
(HTTPS:443)
    │
 ┌──┴──┐
 │     │
 ▼     ▼
web1  web2
EC2   EC2
 │     │
 ▼     ▼
Dockerized Web Application
```

---

# Objectives

- Create a Route 53 Hosted Zone.
- Configure DNS records for a custom domain.
- Request and validate an ACM SSL certificate.
- Launch two EC2 instances.
- Create an internet-facing Application Load Balancer.
- Configure HTTP to HTTPS redirection.
- Register EC2 instances in a Target Group.
- Configure servers using Ansible.
- Deploy the application using Docker containers.
- Verify secure HTTPS access.

---

# AWS Resources Created

## Route 53 Hosted Zone

A public hosted zone was created for:

```text
demo.sapanajoshi.com.np
```

The hosted zone contains:

- Alias A Record
- NS Records
- SOA Record
- ACM Validation CNAME Records

---

## ACM SSL Certificate

A public SSL/TLS certificate was issued for:

```text
demo.sapanajoshi.com.np
```

### Validation Method

```text
DNS Validation
```

### Benefits

- Secure HTTPS communication
- Automatic certificate renewal
- Native AWS integration

---

## EC2 Instances

Two Ubuntu 24.04 EC2 instances were launched.

### Configuration

| Property | Value |
|----------|--------|
| Instance Type | t3.micro |
| Operating System | Ubuntu 24.04 |
| Public IP | Enabled |
| Security Group | SSH (22), HTTP (80) |


---

## Application Load Balancer

An internet-facing Application Load Balancer was created.

### Details

| Setting | Value |
|----------|---------|
| Name | my-first-alb |
| Type | Application Load Balancer |
| Scheme | Internet-facing |
| IP Address Type | IPv4 |

---

# Listener Configuration

## HTTP Listener

```text
Port: 80
```

Action:

```text
Redirect HTTP → HTTPS
Status Code: 301
```

## HTTPS Listener

```text
Port: 443
```

Action:

```text
Forward to Target Group
```

Certificate:

```text
AWS Certificate Manager (ACM)
```

---

# Target Group

### Configuration

```text
Protocol: HTTP
Port: 80
Health Check Path: /
```

### Registered Targets

- web1
- web2

### Health Status

```text
Healthy
```

---

# Route 53 Alias Record

The domain was mapped to the Application Load Balancer using an Alias A Record.

```text
demo.sapanajoshi.com.np
        │
        ▼
   my-first-alb
```

---

# Ansible Automation

The EC2 instances were configured from an Ansible control node.

## Inventory

```ini
[webservers]
web1 ansible_host=<PUBLIC_IP_1>
web2 ansible_host=<PUBLIC_IP_2>

[webservers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=golive.pem
```

---

## Playbook

```yaml
---
- name: Configure Web Servers
  hosts: webservers
  become: true

  tasks:

    - name: Install Docker
      apt:
        name: docker.io
        state: present
        update_cache: yes

    - name: Start Docker Service
      service:
        name: docker
        state: started
        enabled: yes

    - name: Run Nginx Container
      docker_container:
        name: nginx
        image: nginx
        state: started
        restart_policy: always
        ports:
          - "80:80"
```

---



---

# Screenshots

## 1. EC2 Instances

Two EC2 instances (`web1` and `web2`) running as backend application servers.

<img width="1610" alt="EC2 Instances" src="https://github.com/user-attachments/assets/21bb9b22-63aa-4353-b626-948b2758722e" />

---

## 2. Application Load Balancer

Internet-facing ALB configured to distribute traffic across backend servers.

<img width="1574" alt="Application Load Balancer" src="https://github.com/user-attachments/assets/0279c9ae-91a3-4c3b-b2bb-c19a9517d9ca" />

---

## 3. Route 53 Hosted Zone

Hosted zone created for `demo.sapanajoshi.com.np` with Alias, NS, SOA, and ACM validation records.

<img width="1678" alt="Route53 Hosted Zone" src="https://github.com/user-attachments/assets/bcddc8a6-720c-40f1-afc2-ed1b38b5aeb7" />

---

## 4. DNS Configuration Verification

Route 53 domain configuration verification.

<img width="1078" alt="DNS Verification" src="https://github.com/user-attachments/assets/ea8b0463-f6c2-49fb-b183-de71b6569277" />

---

## 5. HTTPS Access Verification

Website successfully accessible through HTTPS using ACM certificate.

<img width="1609" alt="HTTPS Verification" src="https://github.com/user-attachments/assets/ed0f6e56-d689-4d63-9706-f1906f8230f3" />

---

## 6. Application Homepage

Application successfully served through the load balancer.

<img width="937" alt="Application Homepage" src="https://github.com/user-attachments/assets/c875768f-d686-41c9-9537-c2b3f74c3341" />

---

## 7. Final Website Validation

Custom domain verification showing the application running successfully.

<img width="1244" alt="Final Verification" src="https://github.com/user-attachments/assets/4d891f38-a03f-4c93-bb9e-13a7545db5cb" />

---

## 8. HTTP to HTTPS Redirect Rule

Application Load Balancer redirect rule configuration.

<img width="1524" alt="HTTP to HTTPS Redirect" src="https://github.com/user-attachments/assets/f914e737-3642-498a-820f-2aaff5bc2659" />

---

# Validation Checklist

- [x] Route 53 Hosted Zone Created
- [x] DNS Records Configured
- [x] ACM Certificate Issued
- [x] DNS Validation Completed
- [x] Two EC2 Instances Running
- [x] Application Load Balancer Created
- [x] Target Group Configured
- [x] HTTP Redirect to HTTPS Enabled
- [x] Route 53 Alias Record Configured
- [x] Docker Installed Using Ansible
- [x] Application Running Inside Containers
- [x] Health Checks Passing
- [x] HTTPS Website Accessible

---

# Output

### Application URL

```text
https://demo.sapanajoshi.com.np
```

### Result

The application was successfully deployed on AWS using Route 53, ACM, EC2, Docker, Ansible, and an Application Load Balancer. The website is accessible securely over HTTPS, traffic is distributed across multiple EC2 instances, and infrastructure configuration is automated using Ansible.

# Terraform + Ansible AWS Web Stack

## Overview

This assignment recreates the Day 5 AWS architecture entirely using Terraform and configures the web servers using Ansible.

### Infrastructure Created

- 2 Ubuntu 24.04 EC2 Instances
- Application Load Balancer (ALB)
- Target Group
- HTTP & HTTPS Listeners
- ACM SSL Certificate
- Route53 Alias Record
- Security Groups
- Dockerized Nginx Website

---

# Terraform Files

```text
Terraform_assignment/
├── data.tf
├── main.tf
├── security.tf
├── variables.tf
├── output.tf
└── .terraform.lock.hcl
```

---



# Terraform Apply

Infrastructure successfully provisioned using Terraform.

## Screenshot

<img width="1915" height="981" alt="Screenshot 2026-07-27 202225" src="https://github.com/user-attachments/assets/bb8b5385-750e-463c-b4da-cc590b8d86af" />


```text
https://demo.sapanajoshi.com.np
```

## HTTPS Website

The website is accessible through HTTPS and uses the ACM certificate attached to the ALB.

<img width="1534" height="790" alt="Screenshot 2026-07-27 202304" src="https://github.com/user-attachments/assets/ae2392c4-2cf0-4260-b4dc-526f606b12ae" />


---

# Application Load Balancer Verification

The load balancer successfully registers both backend EC2 instances.

## Healthy Target Group

<img width="1571" height="363" alt="Screenshot 2026-07-27 202612" src="https://github.com/user-attachments/assets/63afcc07-f04a-47ef-ad75-1c77e158a535" />


### Verification

Both instances are registered and marked **Healthy**:

- web-1 → Healthy
- web-2 → Healthy

This confirms:

- Route53 points to the ALB
- ALB can reach both EC2 instances
- Health checks pass successfully
- Traffic can be distributed to both backend servers

---

# Terraform Outputs

Terraform outputs showing the ALB DNS name and instance public IPs.

<img width="807" height="142" alt="output" src="https://github.com/user-attachments/assets/45b383e9-6cd7-4e22-b203-8624273c7e2d" />


---

# curl Verification

```bash
curl -s https://demo.sapanajoshi.com.np
```
<img width="1274" height="625" alt="image" src="https://github.com/user-attachments/assets/dd63fa8c-6e31-4abc-866f-8b50b99f130f" />

Both instances are registered and healthy behind the ALB.

Since both servers currently serve identical website content, the response appears the same. The Healthy Target Group screenshot confirms that traffic can be routed to both instances.

---

# Terraform Destroy

```bash
terraform destroy
```

## Screenshot

<img width="1895" height="780" alt="image" src="https://github.com/user-attachments/assets/581b6305-df2b-4ced-b665-fd974b4e2553" />


---

# Conclusion

Successfully completed the full DevOps workflow:

```text
Terraform -> Provision Infrastructure
Ansible -> Configure Servers
ALB -> Load Balancing
ACM -> HTTPS
Route53 -> DNS
Terraform Destroy -> Cleanup
```

---

