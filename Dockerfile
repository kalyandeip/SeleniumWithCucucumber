# Stage 1: Build
FROM maven:3.8.8-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy pom and preload dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and test files
COPY src ./src

# Copy testng.xml if you use it
COPY testng.xml ./src/test/java/

# Build
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the JAR file
COPY --from=builder /app/target/*.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
