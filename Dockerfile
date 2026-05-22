FROM docker.io/samply/project-manager:develop

COPY email-templates.json /app/
COPY frontend-project-configs.json /app/
COPY action-explanations.json /app/

COPY entrypoint.sh /app/
COPY generate_bridgeheads.sh /app/

COPY form-fields/ /app/form-fields/
COPY templates/ /app/templates/
COPY coder/ /app/coder/

WORKDIR /app

RUN mkdir /app/documents && \
    chmod +x /app/entrypoint.sh && \
    chmod +x /app/generate_bridgeheads.sh

ENTRYPOINT ["/app/entrypoint.sh"]