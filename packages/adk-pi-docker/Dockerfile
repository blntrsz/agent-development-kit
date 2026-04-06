FROM oven/bun:latest

WORKDIR /adk-pi
COPY ./bin/adk .
RUN mkdir -p /etc/adk/

CMD ["bun", "adk"]
