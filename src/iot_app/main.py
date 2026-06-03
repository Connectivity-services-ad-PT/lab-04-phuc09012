from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

app = FastAPI(
    title="Smart Campus — IoT Ingestion API",
    version="0.3.0",
    description="Service thật nhận dữ liệu cảm biến cho Lab 04"
)

# 1. Định nghĩa cấu trúc Schema dữ liệu đầu vào (Validation)
class ReadingRequest(BaseModel):
    device_id: str = Field(..., min_length=3, examples=["ESP32-LAB-A01"])
    metric: str = Field("temperature", examples=["temperature"])
    value: float = Field(..., ge=-40.0, le=80.0, examples=[31.5])  # Boundary: -40 đến 80
    unit: str = Field("celsius", examples=["celsius"])
    timestamp: str = Field(..., examples=["2026-05-13T08:30:00+07:00"])

# 2. Endpoint GET /health (Bắt buộc phải có để Docker check trạng thái sống chết)
@app.get("/health", status_code=status.HTTP_200_OK)
def health_check():
    return {"status": "ok", "service": "iot-ingestion"}

# 3. Endpoint POST /readings (Nhận và xử lý dữ liệu cảm biến thật)
@app.post("/readings", status_code=status.HTTP_200_OK)
def create_reading(payload: ReadingRequest):
    # Trả về đúng cấu trúc success giống như mô tả đề bài
    return {
        "status": "success",
        "message": "Data ingested successfully",
        "data": {
            "device_id": payload.device_id,
            "metric": payload.metric,
            "value": payload.value,
            "unit": payload.unit,
            "timestamp": payload.timestamp
        }
    }