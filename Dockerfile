# Dockerfile

# 1) start from Node 18 slim
FROM node:18-slim

# 2) install Python3, pip, dev headers and OpenSSL libs
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       python3 python3-pip python3-dev \
       libssl-dev libssl3 build-essential \
  && rm -rf /var/lib/apt/lists/*

# 3) work in /app
WORKDIR /app

# 4) install Node deps
COPY package*.json ./
RUN npm install --production

# 5) install Python deps
COPY requirements.txt ./
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir -r requirements.txt

# 6) copy the rest of your code
COPY . .

# 7) tell your Node app how to find Python
ENV PYTHON=python3

# 8) expose & run
ENV PORT=8080
EXPOSE 8080
CMD ["npm", "start"]
