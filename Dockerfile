FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /build

COPY . .

RUN ./mvnw clean package -DskipTests -q

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=builder /build/target/manas-training-service-*.jar app.jar

EXPOSE 8089

ENTRYPOINT ["java", "-jar", "app.jar"]