# syntax=docker/dockerfile:1
################################################################################
# Stage 1: Build app and generate Maven wrapper
FROM maven:3.8.1-openjdk-11-slim AS builder
WORKDIR /app

# 1. Generate Maven Wrapper inside the container
RUN mvn -N io.takari:maven:wrapper

# 2. Copy project POM and source code (wrapper auto‑generated earlier)
COPY pom.xml ./
COPY src/ ./src/

# 3. Make wrapper executable
RUN chmod +x mvnw

# 4. Pre-download dependencies (speed up rebuilds)
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw dependency:go-offline -B

# 5. Build the app (skip tests)
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw clean package -DskipTests -B

################################################################################
# Stage 2: Final runtime image (lean)
FROM openjdk:11-jre-slim
WORKDIR /app

# Copy the generated jar
COPY --from=builder /app/target/*.jar app.jar

# Run as non‑root user for better security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
