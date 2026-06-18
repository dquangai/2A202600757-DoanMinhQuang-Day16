# Báo cáo bài tập DevOps / AI Inference

- Họ tên: Doan Minh Quang
- Mã học viên: 2A202600757
- Môn học: Triển khai hạ tầng và AI inference

## 1. Mục tiêu

Xây dựng hạ tầng Terraform để triển khai dịch vụ AI inference trên AWS, kèm theo:
- VPC với public/private subnet
- Bastion host để truy cập private node
- ALB (Application Load Balancer) đưa traffic HTTP đến backend
- EC2 instance chạy AI inference container
- Endpoint có thể test qua HTTP

## 2. Cấu trúc repo

- `terraform/`: mã Terraform cho AWS
- `terraform-gcp/`: mã Terraform dự phòng cho GCP
- `report.md`: báo cáo nộp bài

## 3. Thiết kế và thành phần chính

### 3.1 Terraform

- `main.tf`: định nghĩa VPC, subnet, route table, security group, bastion, inference node, ALB và target group.
- `variables.tf`: định nghĩa biến đầu vào, gồm `aws_region`, `hf_token`, `model_id`.
- `outputs.tf`: xuất `alb_dns_name`, `endpoint_url`, `bastion_public_ip`, `gpu_private_ip`.
- `user_data.sh`: script khởi tạo EC2 để cài Docker, deploy container inference, pull model và mở port.

### 3.2 Giải pháp inference

- Ban đầu mục tiêu model lớn `google/gemma-4-E2B-it`, nhưng trên EC2 `t3.micro` không phù hợp.
- Tối ưu bằng cách sử dụng model nhỏ hơn: `TinyLlama/TinyLlama-1.1B-Chat-v1.0`.
- Chuyển sang giải pháp CPU-friendly bằng Docker và Ollama để tránh lỗi device inference của vLLM.

## 4. Triển khai và chạy

### 4.1 Yêu cầu trước khi chạy

- AWS credentials đã cấu hình
- Terraform đã cài đặt
- Có token Hugging Face nếu cần model private

### 4.2 Các bước cơ bản

1. Vào thư mục `terraform/`
2. Khởi tạo Terraform: `terraform init`
3. Áp dụng: `terraform apply -auto-approve`
4. Kiểm tra output `alb_dns_name` và endpoint
5. Test health: `curl http://<alb_dns_name>/health`

## 5. Kết quả và kiểm thử

- Hạ tầng AWS đã xác định rõ ràng với ALB, bastion, private EC2.
- Mô hình inference được chuyển sang TinyLlama 1.1B phù hợp với cấu hình `t3.micro`.
- Có endpoint OpenAI-compatible `/v1/completions` thông qua ALB.

## 6. Khó khăn và cách giải quyết

### 6.1 GPU không khả dụng

- G4dn.xlarge bị chặn hoặc không lấy được trong tài khoản hiện tại.
- Giải pháp: dùng CPU instance và model nhỏ.

### 6.2 vLLM lỗi phát hiện thiết bị

- vLLM trên CPU gặp lỗi `Failed to infer device type`.
- Giải pháp: chuyển sang Ollama hoặc cấu hình container rõ ràng, tránh dùng GPU runtime.

### 6.3 Giới hạn tài nguyên `t3.micro`

- 1 vCPU + 1 GB RAM là rất hạn chế cho model lớn.
- Chọn model nhỏ và tối ưu cấu hình container để giảm tải.

## 7. Ghi chú quan trọng

- Không lưu thông tin nhạy cảm trong repo: không commit file private key, không commit `terraform.tfstate` chứa secrets.
- Các giá trị token nên truyền qua biến môi trường khi chạy Terraform.
- `report.md` này tổng hợp toàn bộ nội dung để chấm điểm.

## 8. Kết luận

Bài tập đã hoàn thành với hạ tầng AWS đầy đủ và phương án inference khả thi trên CPU. Repo có đủ cấu trúc, hướng dẫn và giải pháp cho việc chạy lại.
