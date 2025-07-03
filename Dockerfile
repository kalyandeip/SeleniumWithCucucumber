# Base image with Maven and JDK 17 (Eclipse Temurin)
FROM maven:3.9.4-eclipse-temurin-17

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required system dependencies including browsers and drivers
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    unzip \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libgbm1 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    chromium-browser \
    firefox \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN CHROMEDRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install GeckoDriver
RUN GECKODRIVER_VERSION=v0.33.0 && \
    wget -O /tmp/geckodriver.tar.gz "https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz" && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/geckodriver && \
    rm /tmp/geckodriver.tar.gz

# Default workdir inside container
WORKDIR /app

# Copy the source code into container (if needed)
# COPY . /app

# Run Maven clean and compile when container is started (optional override in Jenkinsfile)
# CMD ["mvn", "clean", "compile"]
