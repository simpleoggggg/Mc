# 1. Use an image with Java 21 already installed
FROM eclipse-temurin:21-jre-jammy

# 2. Install Node.js 18 and Unzip
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 3. Setup Working Directory
WORKDIR /app

# 4. Copy your zip (Matching 'panel.zip' exactly)
COPY panel.zip .

# 5. Extract and cleanup
RUN unzip -oq panel.zip && rm panel.zip

# 6. Install Node dependencies
RUN npm install --production

# 7. Memory limits for Railway Trial (512MB)
ENV _JAVA_OPTIONS="-Xmx300M -Xms128M -XX:+UseSerialGC"

# 8. Start the panel
CMD ["node", "app.js"]
