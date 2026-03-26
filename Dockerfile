FROM maven:3.9.7-eclipse-temurin-17 AS builder

WORKDIR /workspace

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw
RUN ./mvnw -B dependency:go-offline

COPY src ./src
RUN ./mvnw -B package -DskipTests

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

EXPOSE 8080
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

COPY --from=builder /workspace/target/*.jar app.jar

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
