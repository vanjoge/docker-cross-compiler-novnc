# docker-ubuntu-lxde-novnc

Docker-based build environment based on [dorowu/ubuntu-desktop-lxde-vnc](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc) with toolchain pre-installed.  
Easy cross-compilation for FriendlyElec's boards.  

---
## Quick Start
### Build
```
git clone https://github.com/friendlyarm/docker-ubuntu-lxde-novnc
cd docker-ubuntu-lxde-novnc
docker build --no-cache -t docker-ubuntu-lxde-novnc .
```
Setup the proxy for Dockerfile building:
```
docker build --no-cache -t docker-ubuntu-lxde-novnc \
    --build-arg https_proxy=http://127.0.0.1:1080 \
    --build-arg http_proxy=http://127.0.0.1:1080 .
```
### Run container as a non-root user
```
docker run -p 8080:80 -p 5900:5900 \
    -e HTTP_PASSWORD=password \
    -e VNC_PASSWORD=password \
    -e USER=ubuntu \
    -e PASSWORD=ubuntu \
    -v /dev/shm:/dev/shm \
    -e RESOLUTION=1280x720 \
    docker-ubuntu-lxde-novnc:latest
```
---
## Environment Variables

### `FASTBOOT`
* `true`  
Faster container initialization by skipping `chown`-ing every files and directories under `$HOME` on container startup. This may be useful when volume is linked on `$HOME` or its subdirectory, and contains lots of files and directories. __Enabling this option might cause files under `$HOME` inaccessible by container.__
* `false`  
`chown` every file under `$HOME` on container startup.
* **DEFAULT** `false`

### `RESOLUTION`
* Set screen resolution in `NNNNxNNNN` form, like `1366x768`.  
* **DEFAULT** _Follows the size of the browser window when first connected._  

### `USERNAME`
* Name of default user.  
* **DEFAULT** `root`

### `PASSWORD`
* Password of the user inside the container. This may required if you want to use SSH with password authentication, or normal user rather than `root`.

### `HTTP_PASSWORD`
* Password for authentication before loading noVNC screen. `USERNAME` is used as username. Password may be sent without any protection - use other authentication method when possible if this container is planned to be run as worldwide-public.

### `VNC_PASSWORD`
* Authentication method provided by noVNC. Password longer than 8 characters will be truncated to 8 characters.

---
## Acknowledgments
- [fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop)
- [hdavid0510/docker-ubuntu-lxde-novnc](https://github.com/hdavid0510/docker-ubuntu-lxde-novnc)
- [dorowu/ubuntu-desktop-lxde-vnc](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc)
