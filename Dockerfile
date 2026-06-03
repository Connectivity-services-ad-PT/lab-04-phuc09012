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

# Thêm tham số --app-dir để ép Uvicorn nhảy thẳng vào thư mục src tìm module
CMD ["uvicorn", "iot_app.main:app", "--app-dir", "src", "--host", "0.0.0.0", "--port", "8000"]