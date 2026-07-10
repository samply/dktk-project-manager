FROM docker.io/samply/project-manager:develop

COPY config/ /app/

WORKDIR /app

RUN mkdir /app/documents && \
    chmod +x /app/entrypoint.sh && \
    chmod +x /app/generate_bridgeheads.sh

ENTRYPOINT ["/app/entrypoint.sh"]