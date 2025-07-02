# Stage 1: Build the project with Maven
FROM maven:3.8.8-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy Maven wrapper and config first
COPY pom.xml .
COPY mvnw .
COPY .mvn/ .mvn/

# Preload dependencies
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Copy the actual source code
COPY src ./src
COPY testng.xml ./src/test/java/

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime environment
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built jar from the builder
COPY --from=builder /app/target/*.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
