# === Stage 1: Build ===
FROM maven:3.8.8-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy Maven build files
COPY pom.xml .
COPY src ./src

# Build the application without running tests
RUN mvn clean compile -DskipTests

# === Stage 2: Runtime ===
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy compiled classes from builder stage
COPY --from=builder /app/target /app/target

# Optional: Set default command
CMD ["java", "-cp", "/app/target/classes", "your.main.ClassName"]
