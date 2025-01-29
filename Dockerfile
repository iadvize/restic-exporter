FROM fedora:latest AS restic-patch
RUN \
    dnf install -y restic

FROM python:3.12-alpine3.20

RUN apk add --no-cache --update openssh tzdata

COPY --from=restic-patch /usr/bin/restic /usr/bin/restic
COPY entrypoint.sh requirements.txt /

RUN pip install -r /requirements.txt \
    # remove temporary files
    && rm -rf /root/.cache

COPY ./restic-exporter.py /restic-exporter.py

EXPOSE 8001

CMD [ "/entrypoint.sh" ]

# Help
#
# Local build
# docker build -t restic-exporter:custom .
#
# Multi-arch build
# docker buildx create --use
# docker buildx build -t restic-exporter:custom --platform linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/s390x .
#
# add --push to publish in DockerHub
