# The image is the backend (samply/project-manager) plus this configuration (production/ -> /app).
#
# Which backend? The same Dockerfile serves both branches:
#   main    (production)  -> a released backend version, e.g. samply/project-manager:1.0.0
#   develop (test system) -> the development state, samply/project-manager:develop
#
# How it works (multi-stage build): every FROM starts a stage, and only the LAST stage becomes the image.
#   1. The two stages "backend-release" and "backend-develop" have no steps: they only give a name to each candidate.
#   2. The last FROM picks one of them by name, through the build argument BACKEND:
#        docker build .                         -> backend-release (default)
#        docker build --build-arg BACKEND=develop .  -> backend-develop
#      The CI (.github/workflows/docker-ci.yml) passes BACKEND=develop for the develop branch. Docker skips the
#      stage that is not picked.
#
# Why not simply "FROM samply/project-manager:${VERSION}"? Dependabot (.github/dependabot.yml) can only update a
# version written literally in a FROM line. When samply/project-manager publishes a new version, it opens a pull
# request into develop that changes the version of "backend-release" below; production gets it with the next
# develop -> main merge.

ARG BACKEND=release

FROM docker.io/samply/project-manager:1.0.0 AS backend-release

FROM docker.io/samply/project-manager:develop AS backend-develop

FROM backend-${BACKEND}

COPY production/ /app/

WORKDIR /app

RUN mkdir /app/documents && \
    chmod +x /app/entrypoint.sh && \
    chmod +x /app/generate_bridgeheads.sh

ENTRYPOINT ["/app/entrypoint.sh"]
