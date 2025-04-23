# Use a slim Node base
FROM node:18-slim

# Install Python3 & pip
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-dev build-essential \
 && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy & install Python deps first
COPY ml-models/stock_prediction/requirements.txt ./ml-models/stock_prediction/
RUN pip3 install --no-cache-dir -r ml-models/stock_prediction/requirements.txt

COPY ml-models/sentiment_analysis/requirements.txt ./ml-models/sentiment_analysis/
RUN pip3 install --no-cache-dir -r ml-models/sentiment_analysis/requirements.txt

# Copy package.json & install Node deps
COPY package*.json ./
RUN npm install --production

# Copy the rest of your code
COPY . .

# Expose the port Railway will use
ENV PORT 8080
EXPOSE 8080

# Start your server
CMD ["node", "backend/server.js"]
