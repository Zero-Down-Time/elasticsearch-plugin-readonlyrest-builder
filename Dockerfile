# taken from https://hub.docker.com/_/gradle/
FROM gradle:alpine

USER root
RUN apk add --update make zip git
