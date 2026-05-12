FROM eclipse-temurin:21-jre-jammy

# 1. Install Node and Unzip
RUN apt-get update && apt-get install -y \
    curl unzip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Copy and Unzip
COPY panel.zip .
RUN unzip -oq panel.zip && rm panel.zip

# 3. THE FIX: Force app.js to listen on 0.0.0.0 instead of localhost
# This uses 'sed' to find "localhost" or "127.0.0.1" and replace it
RUN sed -i 's/localhost/0.0.0.0/g' app.js && \
    sed -i 's/127.0.0.1/0.0.0.0/g' app.js

# 4. Install dependencies
RUN npm install --production

# 5. Environment & Memory
ENV _JAVA_OPTIONS="-Xmx300M -Xms128M -XX:+UseSerialGC"
ENV PORT=8080

# 6. Start
CMD ["node", "app.js"]
