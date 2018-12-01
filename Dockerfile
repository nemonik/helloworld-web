FROM 192.168.0.11:5000/nemonik/golang:1.11.2
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

RUN mkdir /app
ADD main.go /app/

WORKDIR /app

RUN go build -o helloworld-web .

CMD ["/app/helloworld-web"

EXPOSE 3000
