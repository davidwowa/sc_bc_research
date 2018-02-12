FROM debian

MAINTAINER David Zakrevskyy "dmcvic@qweb.de"

RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install erlang
RUN apt-get -y install build-essential

RUN mkdir app
RUN git clone https://github.com/erlang/rebar3 && cd rebar3 && ./bootstrap && cd default/bin && rebar3 local install

ARG password
RUN git clone https://wowa_:$password@bitbucket.org/wowa_/bc.git

#RUN mkdir /app/bc
#ADD . /app/bc

#RUN sed -i -e 's/\r$//' /app/bc/clean_compile_run.sh
RUN chmod +x /bc/clean_compile_run.sh
RUN /bc/clean_compile_run.sh

EXPOSE 5555