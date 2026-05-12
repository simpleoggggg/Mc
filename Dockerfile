# 1. Use a standard Ubuntu base
FROM ubuntu:22.04

# 2. Install Node, Java 21, and Unzip
# We add the specific repository for Java 21 to make sure it's found
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 3. Setup Directory
WORKDIR /app

# 4. Copy and Extract
# Ensure your file on GitHub is named mcpanelv1.zip (based on your screenshot)
COPY mcpanelv1.zip .
RUN unzip -oq mcpanelv1.zip && rm mcpanelv1.zip

# 5. Install Node dependencies
RUN npm install --production

# 6. Memory flags for 512MB limit
ENV _JAVA_OPTIONS="-Xmx300M -Xms128M -XX:+UseSerialGC"

# 7. Start
CMD ["node", "app.js"]
