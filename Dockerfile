FROM ubuntu:latest

RUN apt-get update && apt-get install -y iputils-ping curl

WORKDIR /app

COPY . .

RUN chmod +x check_server.sh

CMD ["./check_server.sh"]
