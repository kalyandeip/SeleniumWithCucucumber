# syntax=docker/dockerfile:1

################################################################################
# Stage 1: Generate mvnw + compile JAR using Maven CLI
FROM maven:3.8.1-openjdk-11-slim AS builder

WORKDIR /app

# 1. Generate Maven wrapper
RUN mvn -N io.takari:maven:wrapper

# 2. Copy pom and wrapper scripts
COPY pom.xml .mvn/ mvnw mvnw.cmd ./

# Ensure mvnw is executable
RUN chmod +x mvnw \
    # Fix line endings if needed
    && apt-get update \
    && apt-get install -y dos2unix \
    && dos2unix mvnw

# 3. Pre-download dependencies (cached by Docker)
RUN ./mvnw dependency:go-offline -B

# 4. Copy source and build
COPY src ./src
RUN ./mvnw clean package -DskipTests -B

################################################################################
# Stage 2: Runtime image with JRE only
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy final JAR from builder
COPY --from=builder /app/target/*.jar app.jar

# Run app
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080
