# Docker development desktop image

This Docker image extends the
[development image](https://github.com/mbT-Infrastructure/docker-development).
Make sure to also configure environment variables, ports and volumes from that image.
by some applications with graphical user interface.

It allows connection via Meshcentral, ssh with X11Forwarding and VNC.

## Environment variables

- `DISPLAY_RESOLUTION`
    - The resolution of the virtual display, default: `1280x720`.
- `MESHCENTRAL_DOMAIN`
    - Domain of the meshcentral instance to connect to.
- `MESHCENTRAL_GROUP_ID`
    - Group id of the Meshcentral device group.
- `USER_PASSWORD`
    - Password used to authenticate the user via VNC.


## Development

To build and run for development run:
```bash
docker compose --file docker-compose-dev.yaml up --build
```
