FROM python:3.10 AS stage

LABEL maintainer="wolkenschieber"
LABEL project_page="https://github.com/wolkenschieber/deep-live-cam-docker"

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN \
    apt-get update \
    && apt-get install -qy \
    build-essential \
    curl \
    ffmpeg \
    gcc \
    git \    
    libffi-dev \ 
    locales \ 
    musl-dev \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \    
    && ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime \
    && echo "Europe/Berlin" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=Europe/Berlin

ENV PYTHONDONTWRITEBYTECODE=0  
ENV PYTHONUNBUFFERED=0      

RUN \
    git clone --depth=1 https://github.com/hacksider/Deep-Live-Cam . 

RUN \
    curl -SL -o /app/models/GFPGANv1.4.pth 'https://huggingface.co/hacksider/deep-live-cam/resolve/main/GFPGANv1.4.pth' \
    && curl -SL -o /app/models/inswapper_128_fp16.onnx 'https://huggingface.co/hacksider/deep-live-cam/resolve/main/inswapper_128_fp16.onnx'

RUN pip install --upgrade pip && pip install -r requirements.txt

RUN groupadd -r deepgroup \
    && useradd --no-log-init -r -g deepgroup deepuser \
    && chown -R deepuser:deepgroup /app

USER deepuser

CMD ["python", "run.py"]


