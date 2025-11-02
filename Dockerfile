# Multi-stage Dockerfile
# Stage 1: build with Maven
FROM maven:3.6.3-jdk-8 AS builder
WORKDIR /workspace

# Copy Maven wrapper (mvnw) and project files
COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests package

# Stage 2: runtime image
FROM openjdk:8-jre-slim
WORKDIR /app
ARG JAR_FILE=target/splitExpenseFinal-0.0.1-SNAPSHOT.jar
COPY --from=builder /workspace/${JAR_FILE} app.jar

EXPOSE 8090

ENTRYPOINT ["java","-jar","/app/app.jar"]
