# Use Node 18
FROM node:18-slim

# Install Java 21 and unzip
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Railway usually puts apps in /app
WORKDIR /app

# Copy the zip from your GitHub repo
COPY panel.zip .

# Unzip and set permissions
# -o overwrites, -q is quiet
RUN unzip -oq panel.zip && rm panel.zip && chmod -R 755 /app

# Install Node dependencies
RUN npm install --production

# Memory limit for Railway's 512MB/1GB tiers
ENV _JAVA_OPTIONS="-Xmx356M -Xms128M -XX:+UseSerialGC"

# Start the panel
CMD ["node", "app.js"]
