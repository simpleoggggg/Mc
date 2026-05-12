# 1. Use a pre-built image that has both Node and Java 21
FROM ghcr.io/railwayapp-templates/node-java-21:latest

# 2. Set the working directory
WORKDIR /app

# 3. Copy your zip file (Must be named panel.zip in GitHub)
COPY panel.zip .

# 4. Install unzip, extract files, and cleanup
USER root
RUN apt-get update && apt-get install -y unzip && \
    unzip -oq panel.zip && \
    rm panel.zip && \
    chmod -R 755 /app

# 5. Install Node dependencies
RUN npm install --production

# 6. Memory flags to stop the "OOM Kill" (512MB limit)
ENV _JAVA_OPTIONS="-Xmx300M -Xms128M -XX:+UseSerialGC"

# 7. Start your panel
CMD ["node", "app.js"]
