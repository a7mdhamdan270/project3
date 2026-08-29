FROM python:3.12-slim

# تحديث حزم النظام لإصلاح الثغرات الأمنية (OpenSSL)
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# باقي الأوامر الخاصة بك (COPY, RUN pip install ... إلخ)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
