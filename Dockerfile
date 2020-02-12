FROM scratch
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

WORKDIR /

ADD helloworld-web /

ENTRYPOINT ["/helloworld-web"]

EXPOSE 3000
