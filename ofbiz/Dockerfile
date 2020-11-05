FROM openjdk:8-jdk

ENV JAVA_OPTS -Xmx2G

COPY /apache-ofbiz /ofbiz
WORKDIR /ofbiz

RUN /ofbiz/gradle/init-gradle-wrapper.sh

EXPOSE 8080
EXPOSE 8443

RUN ./gradlew build

# Configure entity engine to use the localpostgres datasource.
RUN sed -i 's/datasource-name="localderby"/datasource-name="localpostgres"/g; s#jdbc:postgresql://127.0.0.1/ofbiz#jdbc:postgresql://db/ofbiz#g' /ofbiz/framework/entity/config/entityengine.xml 
RUN sed -i "/ofbiz runtime libs/ a runtime 'org.postgresql:postgresql:42.2.18'" /ofbiz/build.gradle
RUN cat /ofbiz/build.gradle


ENTRYPOINT [ "/ofbiz/gradlew" ]
CMD ["ofbiz"]