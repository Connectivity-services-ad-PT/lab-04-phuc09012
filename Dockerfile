FROM python:3.11-slim

# Tạo user non-root để chạy app bảo mật
RUN useradd --create-home appuser
WORKDIR /home/appuser

# Cài đặt dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code vào đúng thư mục làm việc
COPY src/ /home/appuser/src/

# Chuyển sang dùng user non-root
USER appuser

EXPOSE 8000

# Chỉ định rõ PYTHONPATH để Python tìm thấy module iot_app bên trong src
ENV PYTHONPATH=/home/appuser/src

# Lệnh khởi chạy API chuẩn đét không bao giờ sập ngầm
CMD ["uvicorn", "iot_app.main:app", "--host", "0.0.0.0", "--port", "8000"]