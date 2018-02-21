FROM mysql/mysql-server

MAINTAINER Wladimir David Zakrevskyy

ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE blockchain
ENV MYSQL_USER block
ENV MYSQL_PASSWORD blockchain

COPY create_schema.sql /docker-entrypoint-initdb.d/create_schema.sql

EXPOSE 3306