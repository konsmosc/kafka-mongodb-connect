# fluentd/Dockerfile

FROM fluent/fluentd:v1.12.2-debian-1.0
USER root
ENV FLUENT_UID=0
RUN mkdir /buffer
RUN ["gem", "install", "fluent-plugin-kafka", "--no-document", "--version", "0.16.1"]
