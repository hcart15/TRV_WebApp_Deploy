FROM python:3.11-slim

# Install any necessary system dependencies (adjust as needed)
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# Set a working directory
WORKDIR /app

# Copy the requirements file and the wheelhouse directory into the container
COPY requirements.txt .
COPY wheelhouse/ ./wheelhouse/

# Upgrade pip and install dependencies.
# The --find-links option tells pip to look in the wheelhouse first.
# Since pyarrow is not in wheelhouse, pip will download it from PyPI.
RUN pip install --upgrade pip && \
    pip install --find-links=wheelhouse -r requirements.txt

# Copy the rest of your application code into the container
COPY . .

# Set environment variables if necessary
ENV PORT=10000

# Run the application using Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000"]

