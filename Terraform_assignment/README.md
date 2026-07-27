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

