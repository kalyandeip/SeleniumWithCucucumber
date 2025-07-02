# Stage 1: Build the project with Maven
FROM maven:3.8.8-openjdk-11-slim AS builder

WORKDIR /app

# Copy Maven files first to leverage caching
COPY pom.xml .
COPY mvnw .
COPY .mvn/ .mvn/

# Pre-download dependencies
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src
COPY testng.xml ./src/test/java/

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the built jar with minimal image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the built jar file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Default command to run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
