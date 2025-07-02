# syntax=docker/dockerfile:1.4

### 🛠️ 1. Build Stage: Compile and Package the Java Project
FROM maven:3.8.8-openjdk-11-slim AS builder

WORKDIR /app

# Copy Maven configuration and source files
COPY pom.xml .
COPY mvnw .
COPY .mvn/ .mvn/

# Optional: Preload dependencies (avoids redownloading every build)
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Now copy the actual source
COPY src ./src
COPY testng.xml ./src/test/java/

# Package the project, skipping tests (remove -DskipTests to include them)
RUN ./mvnw clean package -DskipTests

---

### ☕ 2. Runtime Stage: Run only the jar with minimal Java image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Default command to run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
