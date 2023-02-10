FROM openjdk:8-jdk

ENV JAVA_OPTS -Xmx2G

COPY /apache-ofbiz /ofbiz
WORKDIR /ofbiz

RUN /ofbiz/gradle/init-gradle-wrapper.sh

EXPOSE 8080
EXPOSE 8443
EXPOSE 8009

RUN ./gradlew build

# Configure entity engine to use the localpostgres datasource.
RUN sed -i 's/datasource-name="localderby"/datasource-name="localpostgres"/g; s#jdbc:postgresql://127.0.0.1/ofbiz#jdbc:postgresql://db/ofbiz#g' /ofbiz/framework/entity/config/entityengine.xml 
RUN sed -i "/^dependencies {/ a runtime 'org.postgresql:postgresql:42.2.18'" /ofbiz/build.gradle
RUN cat /ofbiz/build.gradle

# Configure tomcat to listen for AJP connections on all interfaces within the container. This will make it possible
# to use a reverse proxy to connect to the container via a published port.
RUN sed -i '/<property name="ajp-connector" value="connector">/ a <property name="address" value="0.0.0.0"/>'  \
        /ofbiz/framework/catalina/ofbiz-component.xml

COPY send_ofbiz_stop_signal.sh /

ENTRYPOINT [ "/ofbiz/gradlew", "--no-daemon" ]
CMD ["ofbiz"]