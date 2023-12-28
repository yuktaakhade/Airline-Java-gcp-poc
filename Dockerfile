# Use Maven image as the builder image
FROM maven:latest AS builder

# Set the working directory inside the container
WORKDIR /build

# Copy the Maven project file (pom.xml) into the container
COPY pom.xml .

# Download the Maven dependencies
RUN mvn -B dependency:go-offline

# Copy the source code into the container
COPY src src

# Build the application using Maven
RUN mvn -B package

# Use an OpenJDK runtime as the base image
FROM adoptopenjdk/openjdk17:alpine-jre

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file of the Spring Boot application from the builder image into the container
COPY --from=builder /build/target/*.jar /app/airline-app.jar

# Expose the port that the Spring Boot application will run on
EXPOSE 9000

# Define the command to run the Spring Boot application when the container starts
CMD ["java", "-jar", "airline-app.jar"]
