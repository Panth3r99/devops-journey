FROM ubuntu:latest

RUN apt-get update && apt-get install -y procps coreutils

WORKDIR /app

COPY . .

RUN chmod +x system_monitor.sh

CMD ["./system_monitor.sh"]
