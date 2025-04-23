# ─── Stage 1: Python environment ─────────────────────────────
FROM python:3.10-slim AS python-env

# Install any OS‐level build tools you need
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy & install your ML-model requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only the models folder so Docker layer caching works
COPY ml-models ./ml-models


# ─── Stage 2: Node environment ──────────────────────────────
FROM node:18-slim AS node-env

# Install Python runtime from the previous stage
COPY --from=python-env /usr/local /usr/local

WORKDIR /app

# Install your Node dependencies
COPY package*.json ./
RUN npm install --production

# Copy the rest of your application code
COPY . .

# Expose your app’s port
ENV PORT=3000
EXPOSE 3000

# Tell Railway (and Docker) how to start
CMD ["npm", "start"]
