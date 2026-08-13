

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
