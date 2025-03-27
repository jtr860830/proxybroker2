FROM python:3.9-slim AS base

ENV \
    # Keeps Python from generating .pyc files in the container
    PYTHONDONTWRITEBYTECODE=1 \
    # Turns off buffering for easier container logging 
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends gcc libc-dev libffi-dev \
#    && apt-get clean

RUN apt-get update -y &&\
        apt-get upgrade -y &&\
        apt-get autoremove -y --purge &&\
        apt-get clean &&\
        rm -rf /var/lib/lists/*

RUN \
    pip install -U poetry

FROM base AS builder

WORKDIR /app
COPY poetry.lock pyproject.toml ./

RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --no-dev

COPY proxybroker proxybroker
EXPOSE 8888

ENTRYPOINT ["python", "-m", "proxybroker" ]
