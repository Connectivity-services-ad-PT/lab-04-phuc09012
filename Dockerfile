FROM python:3.11-slim

# Tạo một user non-root tên là appuser để chạy app bảo mật (tránh lỗi hack quyền root)
RUN useradd --create-home appuser
WORKDIR /home/appuser

# Copy và cài đặt thư viện trước để tối ưu hóa bộ nhớ đệm (Docker Layer Caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn của thư mục src vào container
COPY src/ ./src

# Chuyển quyền chạy container từ root sang user thường
USER appuser

# Mở cổng 8000 trong container để đón request từ ngoài vào
EXPOSE 8000

# Lệnh khởi chạy API Uvicorn bên trong container
CMD ["uvicorn", "iot_app.main:app", "--app-dir", "src", "--host", "0.0.0.0", "--port", "8000"]