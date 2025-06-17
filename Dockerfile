# Use official Tomcat image with Java
FROM tomcat:9.0-jdk17

# Remove default apps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your app into ROOT folder of Tomcat
COPY ./src/main/webapp/ /usr/local/tomcat/webapps/index.html/

EXPOSE 8080

CMD ["catalina.sh", "run"]
