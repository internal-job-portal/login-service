# Build stage
FROM eclipse-temurin:17-jdk-jammy AS build
ENV HOME=/usr/app/login-service
RUN mkdir -p $HOME
WORKDIR $HOME

# Copy gradle wrapper and source code
COPY build.gradle $HOME/
COPY settings.gradle $HOME/
COPY gradlew $HOME/
COPY gradle $HOME/gradle
COPY src $HOME/src

# Build the application with Gradle
RUN ./gradlew clean build -x test --no-daemon

# Package stage
FROM eclipse-temurin:17-jre-jammy
COPY --from=build /usr/app/login-service/build/libs/*.jar /app/login-service.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/login-service.jar"]