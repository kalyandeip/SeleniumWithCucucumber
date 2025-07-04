FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install core utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install minimal browser dependencies in smaller layers
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 🧪 Optional: Headless Firefox using ESR
RUN apt-get update && \
    apt-get install -y --no-install-recommends firefox-esr || true && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 🧪 Optional: Use Chromium in headless mode
# RUN apt-get update && \
#     apt-get install -y chromium-browser chromium-chromedriver && \
#     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
