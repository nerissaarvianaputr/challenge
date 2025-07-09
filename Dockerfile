# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jdk as builder

WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
ARG JAR_FILE=target/*.jar
COPY --from=builder /app/${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
