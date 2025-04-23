# ┌─────────────────────────────────────────────────────────────────────────────┐
# │  Build image                                                              │
# └─────────────────────────────────────────────────────────────────────────────┘
FROM node:18-slim AS build

# Install Python3, venv & build tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        python3 python3-venv python3-pip build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ──────────────────────────────────────────────────────────────────────────────
#  1) Set up Python venv & install Python deps
# ──────────────────────────────────────────────────────────────────────────────
# Copy only requirements first (caches layer)
COPY requirements.txt .

# Create & activate venv
RUN python3 -m venv venv

# Put venv's bin on PATH
ENV PATH="/app/venv/bin:$PATH"

# Upgrade pip & install
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# ──────────────────────────────────────────────────────────────────────────────
#  2) Install Node dependencies
# ──────────────────────────────────────────────────────────────────────────────
# Copy only package files to leverage Docker cache
COPY package*.json ./

# Ensure your package.json includes:
#   "scripts": { "start": "node backend/server.js", … }
RUN npm install --production

# ──────────────────────────────────────────────────────────────────────────────
#  3) Copy the rest of your code
# ──────────────────────────────────────────────────────────────────────────────
COPY . .

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │  Runtime image                                                             │
# └─────────────────────────────────────────────────────────────────────────────┘
FROM node:18-slim

# Copy venv+node_modules+app from build stage
WORKDIR /app
COPY --from=build /app /app

# Make sure our venv and node live on PATH
ENV PATH="/app/venv/bin:/app/node_modules/.bin:$PATH"
# Let your Node app read this
ENV PORT=3000

# Expose the port your Express server listens on
EXPOSE 3000

# Run via npm start
CMD ["npm", "start"]
