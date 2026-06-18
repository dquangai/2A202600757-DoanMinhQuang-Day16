@echo off
cd /d D:\Users\quang\2A202600757-DoanMinhQuang-Day16\terraform
C:\Windows\System32\OpenSSH\ssh.exe -i lab-key -o StrictHostKeyChecking=no ubuntu@32.196.119.184 "ssh -i /home/ubuntu/lab-key -o StrictHostKeyChecking=no ubuntu@10.0.10.99 'echo OK'"
