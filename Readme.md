# Deep-Live-Cam Docker

This is a dockerized version of [hacksider/Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam)

## Build

```sh
docker build -t deep-live-cam .
```

## Run prerequisite

```sh
xhost +local:docker
```

## Run

```sh
docker run --rm --name deep-live-cam -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/Bilder:/app/pics --device=/dev/video0:/dev/video0 --user 0 --privileged deep-live-cam
```