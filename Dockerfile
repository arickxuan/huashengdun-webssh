FROM python:3.9.19-bullseye

LABEL maintainer="<author>"
LABEL version="0.0.0-dev.0-build.0"

ADD . /code
WORKDIR /code

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libc-dev libffi-dev gcc && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt --no-warn-script-location && \
    addgroup --system webssh && \
    adduser --system --no-create-home --shell /bin/false --ingroup webssh webssh && \
    chown -R webssh:webssh /code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8888/tcp
USER webssh
CMD ["python", "run.py", "--xsrf=False", "--xheaders=False", "--origin='*'", "--debug", "--delay=6"]
