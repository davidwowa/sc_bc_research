FROM debian

RUN apt-get update
RUN apt-get -y install mysql-client mysql-server

ENV MYSQL_ROOT_PASSWORD "root"
ENV MYSQL_DATABASE "test"
ENV MYSQL_USER "test"
ENV MYSQL_PASSWORD "test"

ADD ./startup.sh .
ADD schema.sql .

EXPOSE 3306

CMD ["/bin/bash", "startup.sh"]