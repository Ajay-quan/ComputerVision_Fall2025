# Use a lightweight Python image
FROM python:3.11-slim

# Install system dependencies (useful for OpenCV, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

# Copy project files
COPY . .

# Environment variables
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1

# Expose the port your app runs on
EXPOSE 5000

# Start the app with Gunicorn
# If your main file or app name is different, update "app:app"
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]