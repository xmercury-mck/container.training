###
## ubuntu base with python3
###
FROM ubuntu:jammy-20220531 as base

# use tini for better kernel signal handling
# install latest python and pip
# TODO: pin all versions to create deterministic builds
# You may also need to add development tools here to build native addons
# e.g.: apt-get install gcc g++ make
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    tini \
    python3-minimal python3-pip \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/tini", "--"]

# create python user and group, then create app dir
RUN groupadd --gid 1000 python \
    && useradd --uid 1000 --gid python --shell /bin/bash --create-home python \
    && mkdir /app \
    && chown -R python:python /app

# you'll likely need more stages for dev/test, but here's our basic prod layer with source code
FROM base as prod
EXPOSE 3000
WORKDIR /app
USER python
COPY --chown=python:python requirements.txt ./
RUN pip install --user -qr requirements.txt
COPY --chown=python:python . .
CMD ["python", "something.py"]