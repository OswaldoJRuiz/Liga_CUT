# la construccion principal
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY . .

# el desorden por eso el uso del -f
RUN mvn -q -DskipTests -f demo/pom.xml package

# el runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
# el que se encargo de general el demo 
COPY --from=build /build/demo/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
