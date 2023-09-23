# Use an official OpenJDK runtime as a parent image
FROM openjdk:8-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file (assuming your Spring Boot JAR is named as "config-server.jar")
COPY target/config-server-0.0.1-SNAPSHOT.jar .

# Expose the port your Spring Boot application listens on (default is 8080)
EXPOSE 8008

# Define environment variables for connecting to the MySQL database
ENV EUREKA_SERVER_URL=http://eureka-server-container:8761/eureka/
ENV SPRING_DATASOURCE_URL=jdbc:mysql://host.docker.internal:3306/middleware
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=root

# Run the Spring Boot application when the container starts
CMD ["java", "-jar", "config-server-0.0.1-SNAPSHOT.jar"]