# Use an appropriate base image
FROM openjdk:11-jre-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven Wrapper and pom.xml
COPY mvnw mvnw.cmd pom.xml ./

# Make the wrapper executable
RUN chmod +x mvnw

# Install dos2unix to handle line endings
RUN apt-get update && apt-get install -y dos2unix

# Convert line endings of mvnw to Unix format
RUN dos2unix mvnw

# Run the Maven build
RUN ./mvnw clean install

# Copy the source code
COPY src ./src

# Build the application
RUN ./mvnw package

# Final image to run the application
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/target/your-app.jar .
ENTRYPOINT ["java", "-jar", "your-app.jar"]
EXPOSE 8080
