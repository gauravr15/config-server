FROM eclipse-temurin:17-jdk
WORKDIR /app

# Pull versioned artifact from an artifact repository (only if not present locally)
ARG CONFIG_SERVER_JAR_URL=https://artifactory.example.com/repo/config-server-0.0.1-SNAPSHOT.jar
RUN if [ ! -f config-server-0.0.1-SNAPSHOT.jar ]; then \
        curl -fSL $CONFIG_SERVER_JAR_URL -o config-server-0.0.1-SNAPSHOT.jar; \
    fi

# Optional: run container as non-root user (enterprise best practice)
RUN useradd -m jenkins && chown -R jenkins:jenkins /app
USER jenkins

EXPOSE 8880

# Spring profiles
ENV SPRING_PROFILES_ACTIVE=jdbc,production

# Disable Eureka registration/fetch
ENV EUREKA_CLIENT_REGISTER_WITH_EUREKA=false
ENV EUREKA_CLIENT_FETCH_REGISTRY=false

# Datasource
ENV SPRING_DATASOURCE_URL=jdbc:mariadb://mariadb-db:3306/middleware
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=BR-10h8352

# Disable all metrics to avoid cgroup crash
ENV MANAGEMENT_METRICS_ENABLE_ALL=false
ENV MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE=health,info

# JVM options for low-memory
CMD ["java","-Xms128m","-Xmx256m","-Dspring.main.allow-bean-definition-overriding=true","-jar","config-server-0.0.1-SNAPSHOT.jar"]