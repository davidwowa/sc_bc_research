FROM debian

MAINTAINER David Zakrevskyy "dmcvic@web.de"

RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install erlang
RUN apt-get -y install build-essential

#RUN mkdir app
# && cd /rebar3/_build/default/bin && ./rebar3 local install && chmod a+x /rebar3/_build/default/bin/rebar3
RUN git clone https://github.com/erlang/rebar3 && cd /rebar3 && ./bootstrap

ARG password
RUN git clone https://wowa_:$password@bitbucket.org/wowa_/bc.git

CMD cd bc && /rebar3/_build/default/bin/rebar3 run
#RUN mkdir /app/bc
#ADD . /app/bc

#RUN sed -i -e 's/\r$//' /app/bc/clean_compile_run.sh
#RUN chmod +x /bc/clean_compile_run.sh
#CMD /bc/clean_compile_run.sh

EXPOSE 5555